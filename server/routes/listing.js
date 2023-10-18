const express = require("express");

const listingController = require("../controllers/listing")
const listingRouter = express.Router();

const authModule = require("../middleware/auth");
const Listing = require("../models/listing");
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

listingRouter.get("/api/products/search/:input", async(req,res)=>{
    try {
        let array = await listingController.searchByField('name',req.params.input);
        res.status(200).json(array);
    }
    catch (e)
    {
        return res.status(500).json ({error: e.message});
    }
});

module.exports = listingRouter;