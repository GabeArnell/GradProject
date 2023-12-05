const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");

const User = require("../models/user");

const authRouter = express.Router();
const {TOKEN_PRIVATE_KEY} = require("../config.json")

const authModule = require("../middleware/auth");
const mailModule = require("../controllers/mailer");

function randomPasswordGenerator(length) {
    const list = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = ''
    while (result.length < length) {
      result += list.charAt(Math.floor(Math.random() * list.length));
    }
    return result;
}

authRouter.post('/api/signup', async (req,res)=>{
    console.log(req.body)
    const {name, email, password} = req.body

    const existingUser = await User.findOne({email: email});
    
    if (existingUser){
        return res.status(400).json({msg: 'Email already being used.'});
    }

    // Hash the password
    const hashedPassword = bcryptjs.hashSync(password, 10)


    try
    {
        let user = new User({
            email: email,
            name: name,
            password: hashedPassword
        })


        user = await user.save()
        res.json(user);
    }
    catch (error) {
        res.status(500).json ({error: error.message});
    }
});

authRouter.post('/api/signin', async (req,res)=>{
    console.log("Sign in", req.body.email,req.body.password)
    const {email, password} = req.body

    try
    {
        const existingUser = await User.findOne({email: email});
        if (!existingUser){
            return res.status(400).json({msg: "Invalid Credentials"})
        }
        const matchedPassword = await bcryptjs.compare(password, existingUser.password);
        if (!matchedPassword){
            return res.status(400).json({msg: "Invalid Credentials"})
        }
        if (existingUser.banStatus && existingUser.banStatus == "banned"){
            return res.status(400).json({msg: "User is banned."})
        }

        const token = jwt.sign({id: existingUser._id}, TOKEN_PRIVATE_KEY);
        //console.log("returning",existingUser._doc);
        return res.json({token, ...existingUser._doc});
    }
    catch (error) {
        console.log("Auth error", error.message)
        return res.status(500).json ({error: error.message});
    }
});

authRouter.post('/api/reset-password', async (req,res)=>{
    console.log("Yooo");
    console.log("resetting", req.body)
    const {email} = req.body

    try
    {
        let existingUser = await User.findOne({email: email});
        if (!existingUser){
            return res.status(400).json({msg: "Invalid Credentials"})
        }
        let date = new Date().getTime();
        let monthLong = 1000*60*60*24;
        if (existingUser.lastPasswordReset && existingUser.lastPasswordReset+monthLong > date){
            console.log("Last reset:",new Date(existingUser.lastPasswordReset))
            return res.status(400).json({msg: "Password reset already used this month, contact administrator for assistance."})
        }
        if (existingUser.banStatus && existingUser.banStatus == "banned"){
            return res.status(400).json({msg: "User is banned."})
        }
        let newPassword = randomPasswordGenerator(15);

        const hashedPassword = bcryptjs.hashSync(newPassword, 10);
        existingUser.password = hashedPassword;
        existingUser.lastPasswordReset = date;
        existingUser = await existingUser.save();
        
        mailModule.sendEmail(existingUser.email,"Password Reset - ThriftExchange",
        `A password reset has been requested on your account. Your new temporary password is:\n
        <b>${newPassword}</b>\nUse this one-time use password to log into your account then change your password in Edit Profile.`)
        

        return res.status(200).json(true);
    }
    catch (error) {
        console.log("Auth error", error.message)
        return res.status(500).json ({error: error.message});
    }
});


authRouter.post('/api/validateToken', async (req,res)=>{
    console.log("validate tokening");
    try
    {
        const token = req.header('x-auth-token');
        if (!token){
            return res.json(false);
        }
        console.log("attempting to verify");
        const valid = jwt.verify(token, TOKEN_PRIVATE_KEY);
        if (!valid){
            return res.json(false);
        }
        console.log("Searching for the user")
        const existingUser = await User.findById(valid.id);
        if (!existingUser){
            return res.json(false);
        }
        if (existingUser.banStatus && existingUser.banStatus == "banned"){
            return res.json(false);
        }

        console.log("Found the user")

        return res.json(true);
        
    }
    catch (error) {
        console.log('validation errored out', error.message);
        return res.status(500).json ({error: error.message});
    }
})


authRouter.get("/api/getuserdata", authModule, async (req,res) => {
    const user = await User.findById(req.user);
    res.status(200).json({...user._doc, token: req.token});
});
authRouter.post("/admin/get-user-data", authModule, async (req,res) => {
    console.log("getting admin data req")
    const adminUser = await User.findById(req.user);
    let {userID} = req.body

    if (!adminUser || (adminUser.type != 'Admin' && adminUser.id != userID)){
        //console.log('admin search errored out', "Admin user does not exist");
        return res.status(500).json ({error: "Admin user does not exist"});
    }
    console.log(req.body)
    const user = await User.findById(userID);
    //console.log("Admin searching for", user._doc)
    res.status(200).json(user);
});

module.exports = authRouter;