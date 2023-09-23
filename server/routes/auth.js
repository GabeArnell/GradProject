const express = require("express");
const bcryptjs = require("bcryptjs")

const User = require("../models/user");

const authRouter = express.Router();


authRouter.post('/api/signup', async (req,res)=>{
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
    // Run Authentication

    // check if an email already exists

    // get the data from the client
    // post that data in database
    // return the data to user
});

module.exports = authRouter