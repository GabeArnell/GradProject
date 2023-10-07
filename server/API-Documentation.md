# API File
The server is hosted on http://thriftexchange.net

Body Contents must be provided in a JSON format. Example: 
`
{
 "Key" : Value,
 "SecondKey": SecondValue
}
`

## Authentication API

### Sign Up - Account Creation
HTTP Method: POST
> /api/signup

Required Body Values
 - "email" String - The new user's email. Email must be new to the database.
 - "name" String - The new user's name. 
 - "password" String - The new user's password.
Responses
 - Status 200. The account creation was successful. The response body contains a JSON data of the new user including their email, name, password, type (customer, seller, admin), and address (empty for now).
 - Status 400: "Email already being used." means that an account already has that email in the databasse.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.


### Sign In - Login
HTTP Method: POST
> /api/signin

Required Body Values
 - "email" String - The email of the user.
 - "password" String - The password of the user.
Responses
 - Status 200. A successful login. Response body contains JSON data of the user as well as a **token** value which is used to authenticate the user. The token should be held by the client as other APIs may require it.
 - Status 400: "Invalid Credentials". This means that the email does not exist as an account or that the password is wrong.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Validate Token 
HTTP Method: POST
> /api/validateToken

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`
Responses
 - Status 200. The token was evaluated. If the response JSON in the response body is **true** the token is valid. If it is **false** it is invalid.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Get User Data
HTTP Method: GET
> /api/getuserdata

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`
Responses
 - Status 200: Successfull request. Response body is JSON data of the user and their token.
 - Status 401: "Invalid authentication token". The given token is invalid. It is not linked to a current user.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

## Shopping API

### Get Listings
HTTP Method: GET
> /api/listings

Requirements: None
Responses
 - Status 200. Returns JSON data of **count** and **listings**
 count is how many total listings the server wants to send. 
 Current **PLACEHOLDER** response data: 
 `{
    count: 3
    listings: [
        {
            name: "Wooden Chair",
            image: "https://images.restaurantfurniture.net/image/upload/c_lpad,dpr_1.0,f_auto,q_auto/rfnet/media/catalog/product/5/1/5100-ch-ws__1.jpg",
            price: 5.50,
            category: "Furniture",
            description: "Has a few scratches on the legs.",
            email: "gabe@gmail.com"
        },
        {
            name: "Used Tennis Racket",
            image: "https://www.perfect-tennis.com/wp-content/uploads/2022/06/functional-tennis-saber-review-1024x628.jpg",
            price: 7.00,
            category: "Sports",
            description: "In good condition, used a couple times.",
            email: "gabe@gmail.com"
        },
        {
            name: "Computer Monitor",
            image: "https://i.pcmag.com/imagery/roundups/05ersXu1oMXozYJa66i9GEo-40..v1657319390.jpg",
            price: 30.00,
            category: "Technology",
            description: "Need to get rid of my second monitor when I leave the dormatory. Open to haggle.",
            email: "gabe@gmail.com"
        }

    ]
 }`
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

