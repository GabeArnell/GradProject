const express = require("express");

const productsRouter = express.Router();

const authModule = require("../middleware/auth");
const {Listing} = require("../models/listing");
const User = require("../models/user");
const Rating = require("../models/rating");
const mailer = require("../controllers/mailer")
const Order = require("../models/orders")
const {Promotion, promotionSchema} = require("../models/promotion")
const taxModule = require("../controllers/tax");
const { stat } = require("fs");
const Alert = require("../models/alert");
const listingController = require("../controllers/listing")

productsRouter.post('/api/add-product', authModule, async (req, res)=>{
    console.log(req.user);
    console.log(req.body);
    let item = req.body;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        if (parseInt(item.quantity) == null){
            return res.status(400).json ({msg: "Quantity must be a whole number"});
        }
        item.quantity = parseInt(item.quantity);
        if (parseFloat(item.price) == null){
            return res.status(400).json ({msg: "Price must be a number"});
        }
        item.price = parseFloat(item.price);
        
        // validation
        if (item.quantity < 1){
            return res.status(400).json ({error: "Quantity can not be below 1"});
        }

        // validation
        if (item.price < 0){
            return res.status(400).json ({msg: "Price can not be below 0."});
        }

        if (parseInt(item.zipcode) == null){
            return res.status(400).json ({msg: "Zipcode must be a whole number"});
        }

        let myzipcode = item.zipcode;
        let taxrate = await taxModule.getSalesTax(myzipcode);

        if (taxrate == 0){
            return res.status(400).json ({msg: "Enter a valid US zipcode."});
        }

        let listing = new Listing({
            name: item.name,
            description: item.description,
            email: existingUser.email,
            quantity: item.quantity,
            images: item.images.length > 0 ? item.images : ['https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png'],
            category: item.category,
            price: item.price,
            zipcode: item.zipcode
        })


        listing = await listing.save();
        listingController.checkAlerts(listing);
        res.json(listing);

    }
    catch (e){
        console.log('prod error', e.message);
        return res.status(500).json ({error: e.message});
    }
})


productsRouter.post('/api/edit-product', authModule, async (req, res)=>{
    console.log("EDITING PRODUCT")
    console.log(req.user);
    console.log(req.body);
    let item = req.body;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }
        let existingListing = await Listing.findById(item.id);
        if (!existingListing){
            return res.status(500).json ({error: "Could not find product"});
        }
        if (item.name != null && item.name != "null" && item.name.length > 0){
            existingListing.name = item.name;
        }
        if (item.description != null && item.description != "null" && item.description.length > 0){
            existingListing.description = item.description;
        }
        if (item.category != null && item.category != "null" && item.category.length > 0){
            existingListing.category = item.category;
        }
        if (parseInt(item.quantity) != null  && parseFloat(item.quantity) >= 0){
            if (parseInt(item.quantity) < 1){
                return res.status(400).json ({msg: "Quantity can not be less than 1."});
            }
            existingListing.quantity = parseInt(item.quantity);
        }

        if (parseFloat(item.price) != null   && parseFloat(item.price) >= 0){
            if (parseFloat(item.price) < 0){
                return res.status(400).json ({msg: "Price can not be lower than 0."});
            }

            existingListing.price = parseFloat(item.price);
        }
        
        if (parseInt(item.zipcode) != null  && item.zipcode != "null"){
            let myzipcode = item.zipcode;
            let taxrate = await taxModule.getSalesTax(myzipcode);
            if (taxrate == 0){
                return res.status(400).json ({msg: "Enter a valid US zipcode."});
            }
    
            existingListing.zipcode = item.zipcode;
        }

        if (item.images.length > 0){
            existingListing.images = item.images;
        }
        

        existingListing = await existingListing.save()
        res.json(existingListing);

    }
    catch (e){
        console.log('prod error', e.message);
        return res.status(500).json ({error: e.message});
    }
})
productsRouter.post('/delete-product', authModule, async (req, res)=>{
    console.log(req.user);
    let item = req.body;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        const existingListing = await Listing.findById(item.id);
        if (!existingListing){
            return res.status(400).json ({msg: "Could not find product to delete."});
        }       
        
        if (existingListing.email != existingUser.email && existingUser.type.toLowerCase() != 'admin'){
            return res.status(401).json ({error: "User is not authorized to delete the product."});
        } 

        await Listing.deleteOne({ _id: existingListing._id });

        res.status(200).json(existingListing);
        

    }
    catch (e){
        return res.status(500).json ({error: error.message});
    }
})
productsRouter.post('/edit-product-price/:newprice', authModule, async (req, res)=>{
    console.log(req.user);
    let item = req.body;
    let newPrice = req.params.newprice;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let existingListing = await Listing.findById(item.id);
        if (!existingListing){
            return res.status(400).json ({msg: "Could not find product to delete."});
        }       
        if (existingListing.email != existingUser.email && existingUser.type != 'admin'){
            return res.status(401).json ({error: "User is not authorized to delete the product."});
        } 

        existingListing.price = parseInt(newPrice);
        existingListing = await existingListing.save();

        res.status(200).json(existingListing);
    }
    catch (e){
        return res.status(500).json ({error: error.message});
    }
})

productsRouter.post('/api/add-to-cart', authModule, async (req, res)=>{
    console.log(req.user);
    let {id} = req.body;
    try {
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let existingListing = await Listing.findById(id);
        if (!existingListing){
            return res.status(400).json ({msg: "Could not find product to delete."});
        }   
        if (existingListing.quantity < 1){
            return res.status(400).json ({msg: "Product is out of stock."});
        }
        
        if (existingUser.cart.length == 0){
            existingUser.cart.push({id: existingListing._id, quantity: 1});
        }
        else {
            let foundProduct = false;
            for (let duple of existingUser.cart){
                if (duple._id.equals(existingListing._id)){
                    foundProduct = true;
                    duple.quantity +=1
                    if (duple.quantity > existingListing.quantity){
                        return res.status(400).json ({msg: "Product does not have more stock."});
                    }
            
                    
                }
            }
            if (!foundProduct){
                console.log("Adding to cart", existingListing)
                existingUser.cart.push({_id: existingListing._id, quantity: 1});
            }     
            
        }
        

        existingUser = await existingUser.save();
        res.status(200).json(existingUser);

        
    }
    catch (e){
        return res.status(500).json ({error: e.message});
    }
})

productsRouter.delete('/api/remove-from-cart/:id', authModule, async(req,res)=>{
    try{
        const id = req.params.id;
        const existingListing = await Listing.findById(id);
        let existingUser = await User.findById(req.user);

        function filterOut(dupple){
            if (dupple._id.equals(existingListing.id)){
                dupple.quantity-=1;
                if (dupple.quantity <= 0){
                    return false;
                }
            }
            return true;
        }   
        existingUser.cart = existingUser.cart.filter(filterOut);     
        existingUser = await existingUser.save();

        res.status(200).json(existingUser)
    }
    catch (e){
        console.log('prod cart error', e.message);
        return res.status(500).json ({error: e.message});
    }
})


productsRouter.get("/api/get-cart-products", authModule,async (req,res)=>{
    console.log(req.user);
    
    try {
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let loadedCart = [];
        for (let dupple of existingUser.cart || []){
            console.log("Searching", dupple._id.toString())
            let existingListing = await Listing.findById(dupple._id.toString());
            if (existingListing){
                console.log("Loading ", existingListing.name);
                existingListing.quantity = dupple.quantity;

                loadedCart.push(existingListing)
            }else{
                console.log("Can not find item", dupple)
            }
        }
        //console.log("Returning cart", loadedCart)
        res.status(200).json(loadedCart);

    }
    catch (e){
        return res.status(500).json ({error: error.message});
    }
})


productsRouter.post('/api/checkout', authModule, async (req, res)=>{
    console.log(req.user);
    try {
        let promocode = req.body.code;
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }
        if (existingUser.cart.length < 1){
            return res.status(500).json({error: "No items in cart"});
        }
        let myPromotion = null;
        if (promocode != ""){
            myPromotion = await Promotion.findOne({code: promocode});
            if (existingUser.usedPromotions.includes(promocode)){
                console.log("Negating promotion, user already has used it");
                myPromotion = null;
            }
            else{
                existingUser.usedPromotions.push(promocode);
            }
        }

        function formatMoney(m){
            let expand = m*100;
            let cut = expand.toString().split(".")[0];
            let parsed = parseInt(cut);
            let s = (parsed/100).toFixed(2);
            return s
        }


       let totalPrice = 0;
       let totalItems = 0;
       
       let html = `
       <h1>Your ThriftExchange order is in the works!</h1>
       <h2> Your order </h2>
       <ul>
       `
       let order = new Order({
            userId: existingUser._id,

            products: [],
            quantity: [],

            address: existingUser.address,
            
            orderedAt: new Date().getTime(),
            status: 0,
            totalPrice: 0,
        })

        let tax = 0;
        while(existingUser.cart.length > 0){
            let dupple = existingUser.cart.shift();
            totalItems += dupple.quantity;
            let existingListing = await Listing.findById(dupple._id.toString());
            existingListing.quantity -= dupple.quantity;
            await existingListing.save();
            let basePrice = existingListing.price;
            totalPrice += dupple.quantity * basePrice;
            let taxPercent = await taxModule.getSalesTax(existingListing.zipcode);
            tax = dupple.quantity * basePrice * parseFloat(taxPercent);
            let textTax = (parseFloat(taxPercent)*100).toFixed(1);
            html+=`<li>x${dupple.quantity} ${existingListing.name} | $${basePrice * dupple.quantity} | Tax ${textTax}%</li>`;
            order.products.push(existingListing);
            order.quantity.push(dupple.quantity);
        }


        let promoPrice = totalPrice;
        if (myPromotion){
            console.log("Applying promotion", totalPrice)
            if (myPromotion.flatdiscount > 0){
                promoPrice -= myPromotion.flatdiscount;
            }
            if (myPromotion.percentdiscount > 0){
                promoPrice = promoPrice * ((100-myPromotion.percentdiscount)/100);
            }
        }


        html += `</ul>`
        html+=`<br><hr>Sub Total: $${formatMoney(totalPrice)}`
        if (promoPrice < totalPrice){
            html+=`<br><hr>Discounted Total: $${formatMoney(promoPrice)}`
            totalPrice = promoPrice;
        }

        html+=`<br>Sales Tax: $${formatMoney(tax)}<br>Total Price: $${formatMoney(totalPrice + tax)}`;

        order.totalPrice = totalPrice + tax;
        order = await order.save()
        console.log("Making order", order)
        existingUser = await existingUser.save();

        mailer.sendEmail(existingUser.email,"ThriftExchange Receipt", html);

        res.status(200).json(existingUser);
    }
    catch (e){
        console.log("Checkout error", e.message);
        return res.status(500).json ({error: e.message});
    }
})

productsRouter.get("/api/orders/listings", authModule,async (req,res)=>{
    console.log(req.user);
    
    try {
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let myOrders = null;
        
        // Admins can see all orders
        if (existingUser.type.toLowerCase() != "admin"){
            myOrders= await Order.find({ userId: req.user });
        }
        else{
            myOrders= await Order.find({ });
        }

        if (!myOrders){
            return res.status(500).json ({error: "Could not find orders"});
        }

        //console.log(myOrders);

        res.status(200).json(myOrders);


    }
    catch (e){
        return res.status(500).json ({error: e.message});
    }
})

productsRouter.post("/admin/update-order-status", authModule,async (req,res)=>{
    console.log(req.user);
    
    try {
        const {orderID, status} = req.body;
        let existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        
        // Admins can see all orders
        if (existingUser.type.toLowerCase() != "admin"){
            return res.status(500).json ({error: "Must be admin to edit order status"});
        }
        let myOrder= await Order.findById(orderID);
        
        if (!myOrder){
            return res.status(500).json ({error: "Could not find orders"});
        }

        myOrder.status = status;

        myOrder = await myOrder.save();

        res.status(200).json(myOrder);


    }
    catch (e){
        return res.status(500).json ({error: e.message});
    }
})

productsRouter.post('/api/calculate-product-rating', async (req, res)=>{
    console.log("Calcing Rating")
    console.log(req.body);
    let {itemID} = req.body;
    try {
        let existingListing = await Listing.findById(itemID);
        if (!existingListing){
            return res.status(500).json ({error: "Could not find product"});
        }

        let ratings = await Rating.find({productid: itemID});
        let total = 0;
        let sum = 0;
        for (let r of ratings ){
            total++;
            sum = sum + r.rating;
        }

        if (total == 0){
            return res.status(200).json(0);
        }
        
        // forcing it to be a double so that the ratings are accepted by frontend (which will round it anyway)
        res.status(200).json(sum/total + 0.001);
    }
    catch (e){
        console.log('prod error', e.message);
        return res.status(500).json ({error: e.message});
    }
})

productsRouter.post('/api/rate-product', authModule, async (req, res)=>{
    let {itemID, rating} = req.body;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }
        let existingListing = await Listing.findById(itemID);
        if (!existingListing){
            return res.status(500).json ({error: "Could not find product"});
        }

        let purchasedProduct = false;
        let orders = await Order.find({userId: req.user});

        for (let i = 0; i < orders.length && purchasedProduct == false; i++){
            let order = orders[i];
            for (let product of order.products){
                if (product._id == itemID){
                    console.log("Owns product");
                    purchasedProduct = true;
                }
            }
        }

        if (!purchasedProduct){
            return res.status(500).json ({error: "Must purchase the item to rate it."});
        }

        let myRating = await Rating.findOne({user: existingUser.email, productid: itemID});
        console.log(myRating)
        if (!myRating){
            console.log("New rating");
            myRating = new Rating({
                user: existingUser.email,
                productid: itemID,
                rating: rating
            })
        }else{
            console.log("edited rating");
            myRating.rating = rating;
        }

        myRating = await myRating.save();
        
        res.json(true);
    }
    catch (e){
        console.log('prod error', e.message);
        return res.status(500).json ({error: e.message});
    }
})

productsRouter.post('/api/set-alert', authModule, async (req, res)=>{
    console.log("Setting alert")
    console.log(req.user);
    console.log(req.body);
    let {name,zipcode,category} = req.body;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let myAlert = new Alert({
            name: name,
            zipcode: zipcode,
            category: category,
            email: existingUser.email
        })

        myAlert = await myAlert.save();
        
        res.json(true);
    }
    catch (e){
        console.log('prod error', e.message);
        return res.status(500).json ({error: e.message});
    }
})

productsRouter.get('/api/get-alerts', authModule, async (req, res)=>{
    console.log("Getting alerts");
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let myAlerts = await Alert.find({email: existingUser.email});
        res.status(200).json(myAlerts);
    }
    catch (e){
        console.log('prod error', e.message);
        return res.status(500).json ({error: e.message});
    }
})


productsRouter.post('/api/delete-alert', authModule, async (req, res)=>{
    console.log("deleting alert")
    console.log(req.user);
    console.log(req.body);
    let {alertID} = req.body;
    try {
        const existingUser = await User.findById(req.user);
        if (!existingUser){
            return res.status(500).json ({error: "Could not find user"});
        }

        let myAlert = await Alert.findById(alertID);
        if (!myAlert){
            return res.status(500).json ({error: "Could not find alert."});
        }
        if (myAlert.email != existingUser.email){
            return res.status(400).json ({msg: "User does not own that alert."});
        }

        await Alert.deleteOne({ _id: myAlert._id });

        res.status(200).json(true);
    }
    catch (e){
        console.log('prod error', e.message);
        return res.status(500).json ({error: e.message});
    }
})


module.exports = productsRouter;