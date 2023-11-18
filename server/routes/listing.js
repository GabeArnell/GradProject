const express = require("express");

const listingController = require("../controllers/listing")
const listingRouter = express.Router();

const authModule = require("../middleware/auth");
const {Listing} = require("../models/listing");
const User = require("../models/user");


listingRouter.get("/api/listings",  async (req,res) => {
    try {
        let array = await listingController.get();
        res.status(200).json(array);    
    }
    catch (e)
    {
        return res.status(500).json ({error: error.message});
    }
});


listingRouter.get("/api/my-listings",  authModule, async (req,res) => {
    try {
        const existingUser = await User.findById(req.user);
        console.log("Searching for listings from ", existingUser.email)
        let results = await Listing.find({ 'email': existingUser.email});
    
        console.log(results)

        res.status(200).json(results);    
    }
    catch (e)
    {
        return res.status(500).json ({error: error.message});
    }
});


listingRouter.get("/api/products/search/:name/:category/:zipcode", async(req,res)=>{
    console.log(req.params)
    try {
        let array = await listingController.searchByFields(req.params);
        res.status(200).json(array);
    }
    catch (e)
    {
        return res.status(500).json ({error: e.message});
    }
});

listingRouter.get("/api/products/category/:category", async(req,res)=>{
    console.log(req.params)
    try {
        let array = await listingController.getByCategory(req.params.category);
        res.status(200).json(array);
    }
    catch (e)
    {
        return res.status(500).json ({error: e.message});
    }
});

module.exports = listingRouter;