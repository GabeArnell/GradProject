const express = require("express");

const analyticsRouter = express.Router();

const authModule = require("../middleware/auth");
const {Listing} = require("../models/listing");
const User = require("../models/user");
const Rating = require("../models/rating");
const mailer = require("../controllers/mailer")
const Order = require("../models/orders")
const {Promotion, promotionSchema} = require("../models/promotion")

analyticsRouter.get("/api/analytics/earnings", authModule, async (req,res) => {
    try{
        const user = await User.findById(req.user);

        let allOrders = await Order.find();

        let data = {
            totalEarnings: 0,
            electronicsEarnings: 0,
            appliancesEarnings: 0,
            apparelEarnings: 0,
            furnitureEarnings: 0,
            otherEarnings: 0
        }

        for (let order of allOrders){
            data.totalEarnings += order.totalPrice;
            for (let i = 0; i < order.products.length; i++){
                let prod = order.products[i];
                let quantity = order.quantity[i];

                switch(prod.category.toLowerCase()){
                    case("electronics"):
                        data.electronicsEarnings += prod.price * quantity;break;
                    case("appliances"):
                        data.appliancesEarnings += prod.price * quantity;break;
                    case("apparel"):
                        data.apparelEarnings += prod.price * quantity;break;
                    case("furniture"):
                        data.furnitureEarnings += prod.price * quantity;break;
                    case("other"):
                        data.otherEarnings += prod.price * quantity; break;
                    
                }
            }
        }
        //console.log(data);
        res.status(200).json(data);
    
    }
    catch(e){
        console.log("Analytics error", e);
        req.status(500).json({message: e})
    }
});
analyticsRouter.get("/api/analytics/views", authModule, async (req,res) => {
    try{
        const user = await User.findById(req.user);

        let allProducts = await Listing.find();

        let data = {
            total: 0,
            electronics: 0,
            appliances: 0,
            apparel: 0,
            furniture: 0,
            other: 0
        }

        for (let prod of allProducts){
            data.total += prod.views;
            switch(prod.category.toLowerCase()){
                case("electronics"):
                    data.electronics += prod.views;break;
                case("appliances"):
                    data.appliances += prod.views;break;
                case("apparel"):
                    data.apparel += prod.views;break;
                case("furniture"):
                    data.furniture += prod.views;break;
                case("other"):
                    data.other += prod.views;break;
                
            }
            
        }
        console.log(data);
        res.status(200).json(data);
    
    }
    catch(e){
        console.log("Analytics error", e);
        req.status(500).json({message: e})
    }
});
analyticsRouter.post('/api/analytics/viewed-product', authModule, async (req, res)=>{
    console.log("viewing PRODUCT")
    let {itemID} = req.body;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }
        let existingListing = await Listing.findById(itemID);
        if (!existingListing){
            return res.status(500).json ({error: "Could not find product"});
        }

        if (!existingListing.views){
            existingListing.views = 0;
        }

        // Sellers do not increase view count of their own stuff, neither do admins
        if (existingUser.type != 'Admin' && existingListing.email != existingUser.email){
            existingListing.views = existingListing.views + 1;
        }

        console.log(existingListing);
        existingListing = await existingListing.save()
        res.json(existingListing);

    }
    catch (e){
        console.log('prod error', e.message);
        return res.status(500).json ({error: e.message});
    }
})

module.exports = analyticsRouter;