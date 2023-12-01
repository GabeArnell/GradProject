const {Listing} = require("../models/listing");
const User = require("../models/user");
const Alert = require("../models/alert");
const { default: test } = require("node:test");
const mailController = require("./mailer");

module.exports.getDemoListings = ()=>{
    return ([
        {
            name: "Wooden Chair",
            images: ["https://images.restaurantfurniture.net/image/upload/c_lpad,dpr_1.0,f_auto,q_auto/rfnet/media/catalog/product/5/1/5100-ch-ws__1.jpg"],
            price: 5.50,
            category: "Furniture",
            description: "Has a few scratches on the legs.",
            email: "gabe@gmail.com",
            zipcode: 12601,
        },
        {
            name: "Used Tennis Racket",
            images: ["https://www.perfect-tennis.com/wp-content/uploads/2022/06/functional-tennis-saber-review-1024x628.jpg"],
            price: 7.00,
            category: "Sports",
            description: "In good condition, used a couple times.",
            email: "gabe@gmail.com",
            zipcode: 12601,
        },
        {
            name: "Computer Monitor",
            images: ["https://i.pcmag.com/imagery/roundups/05ersXu1oMXozYJa66i9GEo-40..v1657319390.jpg"],
            price: 30.00,
            category: "Electronics",
            description: "Need to get rid of my second monitor when I leave the dormatory. Open to haggle.",
            email: "gabe@gmail.com",
            zipcode: 12601,
        }

    ])
}

module.exports.get = async() =>{
    let results = await Listing.find({});

    return results;
}
module.exports.searchByField = async(field,input) =>{
    let results = await Listing.find({ 'name': 
        {$regex: input, $options: 'i'},
    });
    //console.log(results)
    return results;
}
module.exports.searchByFields = async(body) =>{
    let zipcode = null
    let category = null;
    let name = "";

    if (body.zipcode && body.zipcode.length > 0 && body.zipcode != "null"){
        zipcode = parseInt(body.zipcode)
    }
    if (body.category && body.category.length > 0  && body.category != "null" && body.category != "All"){
        category = body.category
    }
    if (body.name && body.name.length > 0  && body.name != "null"){
        name = body.name
    }
    
    if (!zipcode && !category){
        let results = await Listing.find({ 'name': 
            {$regex: name, $options: 'i'}
        });
        //console.log(results)
        return results;
    }
    else if (category && zipcode){
        let results = await Listing.find({ 'name': 
            {$regex: name, $options: 'i'},
            zipcode: zipcode,
            category: category
        },);
        return results;
    }else if (!zipcode){
        let results = await Listing.find({ 'name': 
            {$regex: name, $options: 'i'},
            category: category
        },);
        return results;
    }
    else {
        let results = await Listing.find({ 'name': 
            {$regex: name, $options: 'i'},
            zipcode: zipcode,
        },);
        return results;
    }
}
module.exports.getByCategory = async(input) =>{
    if (input != 'All'){
        let results = await Listing.find({ 'category': input
    });
    //console.log(results)
    return results;
    }
    else{
        let results = await Listing.find({});
    //console.log(results)
    return results;
    }
}


module.exports.checkAlerts = async (newProduct)=>{
    let allAlerts = await Alert.find();
    let prodName = newProduct.name.trim().toLowerCase();
    for (let alert of allAlerts){
        let testname = alert.name.trim().toLowerCase();
        if (newProduct.zipcode != alert.zipcode) continue;
        if (newProduct.category != alert.category) continue;
        if (prodName.includes(testname)){

            let html = `
            <h1>A new product as added to ThriftExchange that matches your alert!</h1>
            <h2> Product: ${newProduct.name}</h2>
            <h2> Sold by ${newProduct.email}</h2>
            <p>${newProduct.description}</p>
            `
            // mail out
            mailController.sendEmail(
                alert.email,
                "ThriftExchange Alert: "+prodName,
                html
            )
        }
    }
}

