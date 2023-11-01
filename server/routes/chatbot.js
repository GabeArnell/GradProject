const express = require("express");

const chatbotController = require("../controllers/chatbot")
const chatbotRouter = express.Router();

const authModule = require("../middleware/auth");


chatbotRouter.post("/api/chatbot/description-gen", authModule, async (req,res) => {
    try {
        const {name, description, price} = req.body
        let answer = await chatbotController.descriptionGen(name,description,price);
        res.status(200).json(answer);    
    }
    catch (e)
    {
        return res.status(500).json ({error: error.message});
    }
});


module.exports = chatbotRouter;