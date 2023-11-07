const express = require("express");

const productsRouter = express.Router();

const authModule = require("../middleware/auth");
const Listing = require("../models/listing");
const User = require("../models/user");
const Rating = require("../models/rating");
const Cart = require("../models/cart");


productsRouter.post('/admin/add-product', authModule, async (req, res)=>{
    console.log(req.user);
    console.log(req.body);
    let item = req.body;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        if (parseInt(item.quantity) == null){
            return res.status(400).json ({error: "Quantity must be a whole number"});
        }
        item.quantity = parseInt(item.quantity);
        if (parseFloat(item.price) == null){
            return res.status(400).json ({error: "Price must be a number"});
        }
        item.price = parseFloat(item.price);
        
        // validation
        if (item.quantity < 1){
            return res.status(400).json ({error: "Quantity can not be below 1"});
        }

        // validation
        if (item.price < 0){
            return res.status(400).json ({error: "Price can not be below 0."});
        }

        if (parseInt(item.zipcode) == null){
            return res.status(400).json ({error: "Zipcode must be a whole number"});
        }

        let listing = new Listing({
            name: item.name,
            description: item.description,
            email: existingUser.email,
            quantity: item.quantity,
            images: item.images.length > 0 ? item.images : ['https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png'],
            category: item.category,
            price: item.price,
            zipcode: item.zipcode
        })


        listing = await listing.save()
        res.json(listing);

    }
    catch (e){
        console.log('prod error', e.message);
        return res.status(500).json ({error: e.message});
    }
})
productsRouter.post('/delete-product', authModule, async (req, res)=>{
    console.log(req.user);
    let item = req.body;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        const existingListing = await Listing.findById(item.id);
        if (!existingListing){
            return res.status(400).json ({error: "Could not find product to delete."});
        }       
        if (existingListing.email != existingUser.email && existingUser.type != 'admin'){
            return res.status(401).json ({error: "User is not authorized to delete the product."});
        } 

        await Listing.deleteOne({ _id: existingListing._id });

        res.status(200).json(existingListing);
        

    }
    catch (e){
        return res.status(500).json ({error: error.message});
    }
})
productsRouter.post('/edit-product-price/:newprice', authModule, async (req, res)=>{
    console.log(req.user);
    let item = req.body;
    let newPrice = req.params.newprice;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let existingListing = await Listing.findById(item.id);
        if (!existingListing){
            return res.status(400).json ({error: "Could not find product to delete."});
        }       
        if (existingListing.email != existingUser.email && existingUser.type != 'admin'){
            return res.status(401).json ({error: "User is not authorized to delete the product."});
        } 

        existingListing.price = parseInt(newPrice);
        existingListing = await existingListing.save();

        res.status(200).json(existingListing);
    }
    catch (e){
        return res.status(500).json ({error: error.message});
    }
})

productsRouter.post('/add-to-cart', authModule, async (req, res)=>{
    console.log(req.user);
    let {itemID} = req.body;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let existingListing = await Listing.findById(item.id);
        if (!existingListing){
            return res.status(400).json ({error: "Could not find product to delete."});
        }       

        let existingCart = await Cart.find({email: existingUser.email});
        if (!existingListing){
            existingCart = new Cart({
                email: existingUser.email,
                items: []
            })
            existingCart = await existingCart.save();
        }

        existingCart.items.push(itemID);
        existingCart = await existingCart.save();
        
        res.status(200).json(existingCart);
    }
    catch (e){
        return res.status(500).json ({error: error.message});
    }
})
productsRouter.get("/get-cart", authModule, async(req,res)=>{
    console.log(req.user);
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let existingCart = await Cart.find({email: existingUser.email});
        if (!existingListing){
            existingCart = new Cart({
                email: existingUser.email,
                items: []
            })
            existingCart = await existingCart.save();
        }
        
        res.status(200).json(existingCart);
    }
    catch (e){
        return res.status(500).json ({error: error.message});
    }
})


productsRouter.post('/checkout', authModule, async (req, res)=>{
    console.log(req.user);
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let existingListing = await Listing.findById(item.id);
        if (!existingListing){
            return res.status(400).json ({error: "Could not find product to delete."});
        }       

        let existingCart = await Cart.find({email: existingUser.email});
        if (!existingListing || existingCart.items.length < 1){
            return res.status(400).json ({error: "Empty Carts can not checkout"});
        }
        
        res.status(200).json(existingCart);
    }
    catch (e){
        return res.status(500).json ({error: error.message});
    }
})
module.exports = productsRouter;