const mongoose = require("mongoose")
const { use } = require("../routes/auth")
const {Listing, listingSchema} = require("./listing")

const orderSchema = mongoose.Schema({

    userId: {
        type: String,
        default: ''
    },

    status: {
        type: Number,
        default: 0
    },

    address: {
        type: String,
        default: 'No Address'
    },

    totalPrice: {
        type: Number,
        default: 0
    },

    orderedAt: {
        type: Number,
        default: 0
    },

    quantity: [Number],

    products: [listingSchema]

});

const Order = mongoose.model('Order', orderSchema);
module.exports = Order;