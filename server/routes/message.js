const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");

const User = require("../models/user");
const Message = require("../models/message");

const messageRouter = express.Router();
const {TOKEN_PRIVATE_KEY} = require("../config.json")

const authModule = require("../middleware/auth")

messageRouter.get("/api/get-messages", authModule, async (req,res) => {
    try {
        const user = await User.findById(req.user);

        let results = await Message.find({ 'recipient': user.email });
        console.log(results)
    
        res.status(200).json({...user._doc, token: req.token});
    }
    catch (e)
    {
        return res.status(500).json ({error: e.message});
    }
});
messageRouter.get("/api/send-message", authModule, async (req,res) => {
    try {
        const user = await User.findById(req.user);
        const recipient = req.body.recipient.trim();
        let destinationUser = await User.findById(recipient);
        if (!destinationUser){
            return res.status(400).json ({error: 'The email you are trying to message does not have an account.'});
        }

        const content = req.body.content.trim();
        if (content.length < 1){
            return res.status(400).json ({error: 'Message must have a body.'});
        }
        const timeStamp = new Date().getTime();

        let newMsg = new Message({
            sender: user.email,
            recipient: recipient,
            content: content,
            timestamp: timeStamp
        })


        newMsg = await newMsg.save()

        res.status(200).json(newMsg);
    }
    catch (e)
    {
        return res.status(500).json ({error: e.message});
    }
});


module.exports = messageRouter;