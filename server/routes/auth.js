const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");

const User = require("../models/user");

const authRouter = express.Router();
const {TOKEN_PRIVATE_KEY} = require("../config.json")

const authModule = require("../middleware/auth")

// TODO: FORCE ALL EMAIL INPUTS TO LOWERCASE

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
            return res.status(400).json({error: "Invalid Credentials"})
        }
        const matchedPassword = await bcryptjs.compare(password, existingUser.password);
        if (!matchedPassword){
            return res.status(400).json({error: "Invalid Credentials"})
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


module.exports = authRouter;