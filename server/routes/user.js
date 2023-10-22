const express = require("express");

const userRouter = express.Router();

const authModule = require("../middleware/auth");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");


// Change Name
userRouter.post('/api/save-user-name', authModule, async (req, res)=>{
    console.log(req.user);
    console.log(req.body);

    try {
        const {newName} = req.body;
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }
        if (!newName){
            return res.status(500).json ({error: "Could not find name in request"});
        }


        existingUser.name =  newName;

        await existingUser.save()
        res.status(200).json(existingUser);

    }
    catch (e){
        console.log('error with username saving error', e.message);
        return res.status(500).json ({error: e.message});
    }
});

// Change Name
userRouter.post('/api/save-user-address', authModule, async (req, res)=>{
    console.log(req.user);
    console.log(req.body);

    try {
        const {newAddress} = req.body;
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }
        if (!newAddress){
            return res.status(500).json ({error: "Could not find address in request"});
        }

        existingUser.address =  newAddress;

        await existingUser.save()
        res.status(200).json(existingUser);

    }
    catch (e){
        console.log('error with name saving', e.message);
        return res.status(500).json ({error: e.message});
    }
})

// Change Password
userRouter.post('/api/save-user-password', authModule, async (req, res)=>{
    console.log(req.user);
    console.log(req.body);

    try {
        const { newPassword } = req.body;
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }
        if (!newPassword){
            return res.status(500).json ({error: "Could not find password in request"});
        }

        const hashedPassword = bcryptjs.hashSync(newPassword, 10)

        existingUser.password =  hashedPassword;

        await existingUser.save()
        res.status(200).json(existingUser);

    }
    catch (e){
        console.log('error with password saving', e.message);
        return res.status(500).json ({error: e.message});
    }
})

module.exports = userRouter;