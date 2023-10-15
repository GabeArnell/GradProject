const mongoose = require("mongoose")
const { use } = require("../routes/auth")

const listingSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true,
    },

    price: {
        required: true,
        type: Number,
        trim: true,
    },

    images: {
        type: Array,
        default: ['https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png']
    },


    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
            validator: (value) =>{
                // RegEx Taken from here
                // https://stackoverflow.com/questions/201323/how-can-i-validate-an-email-address-using-a-regular-expression
                const regex = /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/
                value.match(regex)
            },
            message: 'Invalid Email'
        }
    },

    category: {
        type: String,
        default: 'Furniture'
    },

    description: {
        type: String,
        default: 'Used wooden chair, some dents on side but structurally sound.'
    },
    zipcode: {
        type: Number,
        default: 12601,
    },
    quantity: {
        type: Number,
        default: 99,
    },
});

const Listing = mongoose.model('Listing', listingSchema);
module.exports = Listing;