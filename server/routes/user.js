const express = require("express");

const userRouter = express.Router();

const authModule = require("../middleware/auth");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");

const taxModule = require("../controllers/tax");
const Review = require("../models/review");
const Order = require("../models/orders")
const {Listing} = require("../models/listing")
const Rating = require("../models/rating");
const auth = require("../middleware/auth");


userRouter.post('/api/add-review', authModule, async (req, res)=>{
    try {

        const {email,content} = req.body;
        //console.log(req.body);
        let myUser = await User.findById(req.user);

        let existingUser = await User.findOne({email: email});
        if (!existingUser ){
            return res.status(500).json ({error: "Could not find subject user"});
        }
        if (!myUser){
            return res.status(500).json ({error: "Could not find writer user"});
        }

        // Go through orders, they must have an order that contains product sold by user to review
        let orders = await Order.find({userId:req.user });
        let hasPurchasedFromSeller = false;

        for (let order of orders){
            for (let prod of order.products){
                if (prod.email == email){
                    hasPurchasedFromSeller = true;
                }
            }
        }

        if (!hasPurchasedFromSeller){
            return res.status(500).json ({error: "You can not review a seller without buying from them."});
        }


        let existingReview = await Review.findOne({subject: email, writer: myUser.email});
        if (existingReview){
            existingReview.content = content;
            existingReview.timestamp = new Date().getTime();
            existingReview = await existingReview.save();
            console.log("Updated review", existingReview);
            res.status(200).json(existingReview);

        }
        else{
            let review = new Review({
                writer: myUser.email,
                subject: existingUser.email,
                content: content,
                timestamp: new Date().getTime(),
            })
            review = await review.save();
            console.log("saved review", review);
            res.status(200).json(review);

        }


    }
    catch (e){
        console.log('error with username saving error', e.message);
        return res.status(500).json ({error: e.message});
    }
});
userRouter.post('/admin/delete-review', authModule, async (req, res)=>{
    try {

        const {writer,subject} = req.body;
        //console.log(req.body);
        let myUser = await User.findById(req.user);
        if (!myUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        if (myUser.type != "Admin"){
            return res.status(500).json ({error: "Must be admin to delete reviews"});
        }

        let existingReview = await Review.findOne({subject: subject, writer: writer});
        if (existingReview){
            await Review.findOneAndRemove({subject: subject, writer: writer});
            console.log("Removed review", existingReview);
            res.status(200).json(existingReview);
        }


    }
    catch (e){
        console.log('error with username saving error', e.message);
        return res.status(500).json ({error: e.message});
    }
});

userRouter.post('/admin/ban-user', authModule, async (req, res)=>{
    try {
        const {email} = req.body;

        let myUser = await User.findById(req.user);
        if (!myUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        if (myUser.type != "Admin"){
            return res.status(500).json ({error: "Must be admin to ban a user."});
        }
        //console.log(req.body);
        let targetUser = await User.findOne({email: email});
        if (!targetUser){
            return res.status(500).json ({error: "Could not find target user"});
        }
        targetUser.banStatus = "banned"
        targetUser = await targetUser.save();
        res.status(200).json (true);

    }
    catch(error){
        console.log("error banning player", error)
    }
})
userRouter.post('/admin/unban-user', authModule, async (req, res)=>{
    try {
        const {email} = req.body;

        let myUser = await User.findById(req.user);
        if (!myUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        if (myUser.type != "Admin"){
            return res.status(500).json ({error: "Must be admin to unban a user."});
        }
        //console.log(req.body);
        let targetUser = await User.findOne({email: email});
        if (!targetUser){
            return res.status(500).json ({error: "Could not find target user"});
        }
        targetUser.banStatus = ""
        targetUser = await targetUser.save();
        res.status(200).json (true);

    }
    catch(error){
        console.log("error unbanning player", error)
    }
})
userRouter.post('/admin/ban-status', authModule, async (req, res)=>{
    try {
        const {email} = req.body;

        let myUser = await User.findById(req.user);
        if (!myUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let targetUser = await User.findOne({email: email});
        if (!targetUser){
            return res.status(500).json ({error: "Could not find target user"});
        }
        if (targetUser.banStatus && targetUser.banStatus == "banned"){
            return res.status(200).json (true);
        }
        return res.status(200).json (false);


    }
    catch(error){
        console.log("error banning player", error)
    }
})

userRouter.post('/api/get-reviews', authModule, async (req, res)=>{
    try {

        const {email} = req.body;
        let myUser = await User.findById(req.user);

        let existingUser = await User.findOne({email: email});
        if (!existingUser || !myUser){
            return res.status(500).json ({error: "Could not find user(s)"});
        }
        
        const reviews = await Review.find({subject: email});
        //console.log("retrieved review", reviews);
        res.status(200).json(reviews);
    }
    catch (e){
        console.log('error with username saving error', e.message);
        return res.status(500).json ({error: e.message});
    }
});

// Change Details
userRouter.post('/api/profile/update-details', authModule, async (req, res)=>{
    console.log(req.user);
    console.log(req.body);

   switch(req.body.type){
    case("image"):
        changeImage(req,res,req.body.detail.trim())
        break;
    case('username'):
        changeName(req,res,req.body.detail.trim())
        break;
    case('address'):
        changeAddress(req,res,req.body.detail.trim());
        break;
    case('password'):
        changePassword(req,res,req.body.detail.trim())
        break;
   }
});

userRouter.post('/api/view-profile', authModule, async (req, res)=>{
    try {

        const {email} = req.body;
        let existingUser = await User.findOne({email: email});
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        // calculate average stars
        let listings = await Listing.find({email: email});
        let totalRatings = 0;
        let totalStars = 0;
        let avgStars = -1;
        for (let prod of listings){
            let ratings = await Rating.find({productid: prod._id});
            for (let r of ratings){
                totalRatings++;
                totalStars+= r.rating
            }
        }
        if (totalRatings > 0){
            avgStars = totalStars / totalRatings
        }

        let profile = {
            name: existingUser.name,
            email: existingUser.email,
            image: existingUser.image,
            // forcing to double
            averagestars: avgStars+0.0000001,
        }
        console.log("profile", profile);
        res.status(200).json(profile);
    }
    catch (e){
        console.log('error with username saving error', e.message);
        return res.status(500).json ({error: e.message});
    }
});

// Get Tax Ammount
userRouter.post('/api/tax-list', async (req, res)=>{
    let zipcodes = req.body
    let taxes = [];
    for (let zipcode of zipcodes){
        let string = await taxModule.getSalesTax(zipcode);
        let f = parseFloat(string);
        taxes.push(f);
    }
    res.status(200).json(taxes);
});


// Change Name
async function changeName(req,res,value){
    console.log(req.user);
    console.log(req.body);

    try {
        const newName = value;
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }
        if (!newName){
            return res.status(500).json ({error: "Could not find name in request"});
        }


        existingUser.name =  newName;

        await existingUser.save()
        res.status(200).json(existingUser);

    }
    catch (e){
        console.log('error with username saving error', e.message);
        return res.status(500).json ({error: e.message});
    }
};

// Change Address
async function changeAddress(req,res,value){
    console.log(req.user);
    console.log(req.body);

    try {
        const newAddress = value;
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }
        if (!newAddress){
            return res.status(500).json ({error: "Could not find address in request"});
        }

        existingUser.address =  newAddress;

        await existingUser.save()
        console.log("Changed address to", existingUser.address);
        res.status(200).json(existingUser);

    }
    catch (e){
        console.log('error with address saving', e.message);
        return res.status(500).json ({error: e.message});
    }
}

// Change Image
async function changeImage(req,res,value){
    console.log(req.user);
    console.log(req.body);

    try {
        const newImage = value;
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            console.log('no user')
            return res.status(500).json ({error: "Could not find user"});
        }
        if (!newImage){
            console.log('no image')

            return res.status(500).json ({error: "Could not find image in request"});
        }

        existingUser.image =  newImage;

        await existingUser.save()
        console.log('saved')

        res.status(200).json(newImage);

    }
    catch (e){
        console.log('error with image saving', e.message);
        return res.status(500).json ({error: e.message});
    }
}


// Change Password
async function changePassword(req,res,value){
    console.log(req.user);
    console.log(req.body);

    try {
        const newPassword = value;
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }
        if (!newPassword){
            return res.status(500).json ({error: "Could not find password in request"});
        }

        const hashedPassword = bcryptjs.hashSync(newPassword, 10)

        existingUser.password =  hashedPassword;

        await existingUser.save()
        res.status(200).json(existingUser);

    }
    catch (e){
        console.log('error with password saving', e.message);
        return res.status(500).json ({error: e.message});
    }
}

module.exports = userRouter;