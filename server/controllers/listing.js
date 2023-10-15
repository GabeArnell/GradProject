const Listing = require("../models/listing");
const User = require("../models/user");

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
            category: "Technology",
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