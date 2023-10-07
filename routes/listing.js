const express = require("express");

const listingController = require("../controllers/listing")
const listingRouter = express.Router();

const authModule = require("../middleware/auth")


// TODO, ADD TOKENIZATION TO IT
// listingRouter.get("/api/listings", authModule, async (req,res) => {
//     let array = listingController.getDemoListings();

//     res.json({
//         count: array.length,
//         listings: array
//     });
// });
// PLACEHOLDER
listingRouter.get("/api/listings",  (req,res) => {
    let array = listingController.getDemoListings();

    res.json({
        count: array.length,
        listings: array
    });
});



module.exports = listingRouter;