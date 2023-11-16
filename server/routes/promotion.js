const {Promotion, promotionSchema} = require("../models/promotion")
const express = require("express");

const promoRouter = express.Router();

const authModule = require("../middleware/auth");
const User = require("../models/user");

promoRouter.get("/api/get-promotion/:code", authModule, async(req,res)=>{
    try {
        let code = req.params.code
        console.log("Promo query:", code)
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        const myPromotion = await Promotion.findOne({ code:code.trim().toLowerCase() });

        if (!myPromotion){
            console.log("Could not find promotion");
            return res.status(200).json ({valid: false});
        }
        if (existingUser.usedPromotions){
            let uses = 0;
            for (let code of existingUser.usedPromotions){
                if (code == myPromotion.code){
                    uses++;
                }
            }
            if (uses >= myPromotion.uses){
                console.log("Left over promotions.")
                return res.status(200).json ({valid: false, reason: "You have used this promotion a maximum number of times."});
            }
        }
        console.log("found: ",myPromotion)
        const valid = true;
        let serverResponse = {valid,...myPromotion._doc}
        console.log("Responding with", serverResponse)
        res.status(200).json(serverResponse);

    }
    catch (e)
    {
        return res.status(500).json ({error: e.message});
    }
});

module.exports = promoRouter;