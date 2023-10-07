const path = require("path")

// Packages
const express = require("express");
const mongoose = require("mongoose");

// Imports from other files
const authRouter = require('./routes/auth')
const listingRouter = require('./routes/listing')


// Initializations
const {PORT, DATABASE_URI} = require('./config.json')
const app = express();

// Middleware Routes
app.use(express.json())
app.use(express.static(path.join(__dirname,'../build/web')));
app.use(authRouter);
app.use(listingRouter);

// Database connections
mongoose.connect(DATABASE_URI).then(()=>{
    console.log("Connected to MongoDB");
})


app.listen(PORT, "0.0.0.0", ()=>{
    console.log('Connected to port', PORT);
})

