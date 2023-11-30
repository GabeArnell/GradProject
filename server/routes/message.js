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

messageRouter.get("/api/get-conversation-headers", authModule, async (req,res) => {
    try {
        const user = await User.findById(req.user);
        let list = [

        ]
        let convoMap = {

        }
        let recipientResults = await Message.find({ 'recipient': user.email });
        let senderResults = await Message.find({ 'sender': user.email });

        for (let msg of recipientResults){
            const sender = await User.find({'email': msg.sender});
            if (!sender){
                console.log("Cant find sender");
                continue;
            }
            msg.convoemail = sender[0].email
            msg.convoname = sender[0].name
            msg.convoimage = sender[0].image || null;

            if (!convoMap[sender[0].email]){

                convoMap[sender[0].email] = msg;
            }
            else if (convoMap[sender[0].email].timestamp < msg.timestamp){

                convoMap[sender[0].email] = msg;
            }
        }
        for (let msg of senderResults){
            const recipient = await User.find({'email': msg.recipient});
            if (!recipient){
                console.log("Cant find recipient");
                continue;
            }
            msg.convoemail = recipient[0].email
            msg.convoname = recipient[0].name
            msg.convoimage = recipient[0].image || null;

            if (!convoMap[recipient[0].email]){
                convoMap[recipient[0].email] = msg;
            }
            else if (convoMap[recipient[0].email].timestamp < msg.timestamp){
                msg.email = recipient[0].email
                convoMap[recipient[0].email] = msg;
            }
        }
        let results = []
        for (let k in convoMap){
            results.push(convoMap[k]);
        }


        for (let msg of results){
            let date = new Date(msg.timestamp);
            let stringDate = date.toDateString();
            list.push({
                name: msg.convoname,
                email: msg.convoemail,
                messageText: msg.content,
                imageURL: msg.convoimage || "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png",
                time: stringDate
            })
        }
        console.log("Sending", list)
        res.status(200).json(list);
    }
    catch (e)
    {
        console.log("error", e.message)
        return res.status(500).json ({error: e.message});
    }
});

messageRouter.post("/api/get-conversation-history", authModule, async (req,res) => {
    console.log("Convo history");
    console.log(req.body);
    try {
        const user = await User.findById(req.user);
        let otherEmail = req.body.email;
        let otherUser = await User.find({email: otherEmail})
        otherUser = otherUser[0];
        let recipientResults = await Message.find({ 'sender':otherUser.email,'recipient': user.email });
        let senderResults = await Message.find({ 'sender': user.email, recipient:otherUser.email });
        let results = [];
        for (let msg of recipientResults){
            results.push({
                messageContent: msg.content,
                messageType: 'receiver',
                timestamp: msg.timestamp
            })
        }
        for (let msg of senderResults){
            results.push({
                messageContent: msg.content,
                messageType: 'sender',
                timestamp: msg.timestamp
            })
        }
        console.log('history results', results)
        let history = results.sort((a,b)=>{
            return a.timestamp - b.timestamp
        })
        
        console.log("Sending history", history)
        res.status(200).json(history);
    }
    catch (e)
    {
        console.log("error", e.message)
        return res.status(500).json ({error: e.message});
    }
});
messageRouter.post("/api/send-message", authModule, async (req,res) => {
    console.log("Got send message api", req.body)

    try {
        const user = await User.findById(req.user);
        const recipient = req.body.recipient.trim();
        console.log("searchin");

        let destinationUser = await User.find({email: recipient});
        
        if (!destinationUser){
            return res.status(400).json ({msg: 'The email you are trying to message does not have an account.'});
        }
        console.log("has user", destinationUser);

        const content = req.body.content.trim();
        if (content.length < 1){
            console.log("Length not long enough")
            return res.status(500).json({error: 'Message must have a body.'});
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
        console.warn(e.message)
        return res.status(500).json ({error: e.message});
    }
});

module.exports = messageRouter;