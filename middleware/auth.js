const jwt = require('jsonwebtoken');
const {TOKEN_PRIVATE_KEY} = require("../config.json")

// next is the next route
const auth = async (req, res, callback) => {
    try {
        const token = req.header('x-auth-token');
        if (!token){
            res.status(401).json({msg: 'Invalid authentication token'});
        }
        const valid = jwt.verify(token, TOKEN_PRIVATE_KEY);
        if (!valid){
            res.status(401).json({msg: 'Invalid authentication token'});
        }

        // TODO
        // THIS IS NOT SAFE BECAUSE IT ASSUMES THAT IF TOKEN IS SAFE THEN ID IS MATCHING. ATTACKER CAN PUT RIGHT TOKEN AND WRONG ID
        req.user = verified.id;
        req.token = token;
        
        callback();

    } catch (error){
        res.status(500).json({error: error.message});
    }
}

module.exports = auth;