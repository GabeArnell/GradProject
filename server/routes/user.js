const express = require("express");

const userRouter = express.Router();

const authModule = require("../middleware/auth");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");


// Change Details
userRouter.post('/api/profile/update-details', authModule, async (req, res)=>{
    console.log(req.user);
    console.log(req.body);

   switch(req.type){
    case('username'):
    case('address'):
    case('password'):
        changeName(req,res,req.body.detail.trim())
        break;
   }
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
        res.status(200).json(existingUser);

    }
    catch (e){
        console.log('error with address saving', e.message);
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