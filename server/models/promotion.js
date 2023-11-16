const mongoose = require("mongoose")
const { use } = require("../routes/auth")

const promotionSchema = mongoose.Schema({

    flatdiscount: {
        required: true,
        type: Number,
        trim: true,
        default: 0,

    },
    percentdiscount: {
        required: true,
        type: Number,
        trim: true,
        default: 0,

    },
    minprice: {
        required: true,
        type: Number,
        trim: true,
        default: 0,

    },
    code: {
        type: String,
        default: "",
    },
    description: {
        type: String,
        default: 'What is the code used for?'
    },
    uses: {
        type: Number,
        default: 1,
    },
});

const Promotion = mongoose.model('Promotion', promotionSchema);
module.exports = {Promotion, promotionSchema};