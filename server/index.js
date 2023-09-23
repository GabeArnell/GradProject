// Packages
const express = require("express");
const mongoose = require("mongoose");

// Imports from other files
const authRouter = require('./routes/auth')


// Initializations
const {PORT, DATABASE_URI} = require('./config.json')
const app = express();

// Middleware Routes
app.use(express.json())
app.use(authRouter);


// Database connections
mongoose.connect(DATABASE_URI).then(()=>{
    console.log("Connected to MongoDB");
})


app.listen(PORT, "0.0.0.0", ()=>{
    console.log('Connected to port', PORT);
})


