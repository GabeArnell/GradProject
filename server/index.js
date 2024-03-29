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
// API for user settings changes
const userRouter = require("./routes/user")
// API for sending and receiving messages
const messageRouter = require("./routes/message")
// API for chat GPT interfacing
const chatbotRouter = require("./routes/chatbot")
// API for PromoCode interfacing
const promoRouter = require("./routes/promotion")
// API for Sales Analytics
const analyticsRouter = require("./routes/analytics")

const cors = require("cors")

// Initializations
const {PORT, SHARED_DATABASE_URI,DATABASE_URI} = require('./config.json')
const app = express();

// Allowing cross origin requests
const corsOptions ={
    origin:'*', 
    credentials:true,            //access-control-allow-credentials:true
    optionSuccessStatus:200
}
app.use(cors(corsOptions));
// Middleware Routes
app.use(express.json())
app.use(express.static(path.join(__dirname,'../build/web')));
app.use(authRouter);
app.use(listingRouter);
app.use(productsRouter);
app.use(userRouter);
app.use(messageRouter);
app.use(chatbotRouter);
app.use(promoRouter);
app.use(analyticsRouter);

// Database connections
mongoose.connect(SHARED_DATABASE_URI).then(()=>{
    console.log("Connected to MongoDB");
})


app.listen(PORT, "0.0.0.0", ()=>{
    console.log('Connected to port', PORT);
})

