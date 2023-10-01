const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");

const User = require("../models/user");

const authRouter = express.Router();
const {TOKEN_PRIVATE_KEY} = require("../config.json")

const authModule = require("../middleware/auth")

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
    console.log("Sign in", req.body)
    const {email, password} = req.body

    try
    {
        const existingUser = await User.findOne({email: email});
        if (!existingUser){
            return res.status(200).json({error: "Invalid Credentials"})
        }
        const matchedPassword = await bcryptjs.compare(password, existingUser.password);
        if (!matchedPassword){
            return res.status(200).json({error: "Invalid Credentials"})
        }

        // User is Authenticated at this point
        // TODO- THE TOKEN SHOULD ONLY BE USED FOR ABOUT 1 DAYS LENGTH
        const token = jwt.sign({id: existingUser._id}, TOKEN_PRIVATE_KEY);
        return res.json({token, ...existingUser._doc});
    }
    catch (error) {
        return res.status(500).json ({error: error.message});
    }
});


authRouter.post('/validateToken', async (req,res)=>{
    try
    {
        const token = req.header('x-auth-token');
        if (!token){
            return req.json(false);
        }

        const valid = jwt.verify(token, TOKEN_PRIVATE_KEY);
        if (!valid){
            return req.json(false);
        }

        const existingUser = await User.findById(valid.id);
        if (!existingUser){
            return req.json(false);
        }

        return req.json(true);
    }
    catch (error) {
        return res.status(500).json ({error: error.message});
    }
})


authRouter.get("/", authModule, async (req,res) => {
    const user = await User.findById(req.user);
    res.json({...user._doc, token: req.token});
});


module.exports = authRouter;