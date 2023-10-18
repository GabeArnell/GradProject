const path = require("path")

// Packages
const express = require("express");
const mongoose = require("mongoose");

// Imports from other files
// Authentication API
const authRouter = require('./routes/auth')
// API for getting a specific set of products
const listingRouter = require('./routes/listing')
// API for individual products
const productsRouter = require("./routes/products")
const cors = require("cors")

// Initializations
const {PORT, DATABASE_URI} = require('./config.json')
const app = express();

// Allowing cross origin requests
app.use(cors())

// Middleware Routes
app.use(express.json())
app.use(express.static(path.join(__dirname,'../build/web')));
app.use(authRouter);
app.use(listingRouter);
app.use(productsRouter);

// Database connections
mongoose.connect(DATABASE_URI).then(()=>{
    console.log("Connected to MongoDB");
})


app.listen(PORT, "0.0.0.0", ()=>{
    console.log('Connected to port', PORT);
})

