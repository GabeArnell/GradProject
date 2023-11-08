const mongoose = require("mongoose")
const { use } = require("../routes/auth")
const {Listing, listingSchema} = require("./listing")
const userSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true,
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
    password: {
        required: true,
        type: String,
        validate: {
            validator: (value) =>{
                return value.length >= 1
            },
            message: 'Please enter a password longer than 6 characters'
        }

    },

    address: {
        type: String,
        default: ''
    },

    image: {
        type: String,
        default: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png'
    },

    type: {
        type: String,
        default: 'user'
    },

    cart: [
        {
            product: listingSchema,
            quantity: {
                type: Number,
                required: true
            }
        }
    ]

});

const User = mongoose.model('User', userSchema);
module.exports = User;