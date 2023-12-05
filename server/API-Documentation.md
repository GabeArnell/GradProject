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

### Reset Password
HTTP Method: POST
> /api/reset-password

Required Body Values
 - "email" String - The email of the user.

Responses
 - Status 200: Successful reset. The email has been sent to the user.
 - Status 400: "Invalid Credentials". This means that the email does not exist as an account or that the password is wrong.
 - Status 400: The account may not be able to reset password due to password reset being used recently.
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
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Seller Listings
HTTP Method: GET
> /api/my-listings

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Responses
 - Status 200. Returns JSON data of listings posted by the user.
+ - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Filter Listings
HTTP Method: GET
> /api/products/search/:name/:category/:zipcode

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Responses
 - Status 200. Filters listings by the category, searched name, and zipcode
+ - Status 500. There is an internal server error. Contact the backend developer and give them this message.


### Filter Listings By Category
HTTP Method: GET
> /api/products/category/:category

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Responses
 - Status 200. Returns all listings from specified category
+ - Status 500. There is an internal server error. Contact the backend developer and give them this message.





## User API

### Change Name 
HTTP Method: POST
> /api/save-user-name

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Request Body should be the new name in a JSON format.

Responses
 - Status 200: Successfull request. Response body is JSON data of the updated user.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Change Address 
HTTP Method: POST
> /api/save-user-address

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Request Body should be the new address in a JSON format.

Responses
 - Status 200: Successfull request. Response body is JSON data of the updated user.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Change Password 
HTTP Method: POST
> /api/save-user-password

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Request Body should be the new password in a JSON format.

Responses
 - Status 200: Successfull request. Response body is JSON data of the updated user.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Get Profile Information
HTTP Method: POST
> /api/view-profile

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "email" String - The email of the user.

Responses
 - Status 200: Successfull request. Response body is JSON data of the user for normal users to view.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.




### Tax List Calculation
HTTP Method: POST
> /api/tax-list

Body is a JSON list of zipcodes

Responses
 - Status 200: Returns list of sales tax rates parallel to the zipcode list.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.



### Get Seller Reviews
HTTP Method: POST
> /api/get-reviews

Required Body Values
 - "email" String - The email of the user.

Responses
 - Status 200: Returns all of the reviews of a requested seller email.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Ban Status
HTTP Method: POST
> /admin/ban-status

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "email" String - The email of the user.

Responses
 - Status 200: Checks if the user is banned from the app.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Ban User
HTTP Method: POST
> /admin/ban-user

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "email" String - The email of the user.

Responses
 - Status 200: Bans a user from the platform. Must be an admin.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Unban User
HTTP Method: POST
> /admin/unban-user

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "email" String - The email of the user.

Responses
 - Status 200: Unbans a user from the platform. Must be an admin.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### add review
HTTP Method: POST
> /api/add-review

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "email" String - The email of the seller.
 - "content" String - The review content.

Responses
 - Status 200: Adds the review to the designated seller if the user has purchased from them.

### Delete review
HTTP Method: POST
> /admin/delete-review

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "writer" String - The email of the reviewer.
 - "subject" String - The email of the seller.

Responses
 - Status 200: Deletes the review. Requires admin permission.


## Analytics API

### Earnings Analytics
HTTP Method: GET
> /api/analytics/earnings/:timespan

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

"timespan" parameter is "month"/"week"/"day"/"all"

Responses
 - Status 200: Returns JSON object for earnings by category.

### View Analytics
HTTP Method: GET
> /api/analytics/views

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Responses
 - Status 200: Returns JSON object for views by category.

### Increase View on Product
HTTP Method: POST
> /api/analytics/viewed-product

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "itemID" String - The ID of the product.

Responses
 - Status 200: Returns the product's update information.



## Product API

### Add Product
HTTP Method: POST
> /api/add-product

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "item" Product Object - The new product.

Responses
 - Status 200: Successfull addition
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Edit Product
HTTP Method: POST
> /api/edit-product

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "item" Product Object - The product with the edited fields.

Responses
 - Status 200: Edit
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.


### Delete product
HTTP Method: POST
> /delete-product

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "item" Product Object - The product to be deleted.

Responses
 - Status 200: Successfull deletion
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

## Cart API
### Add Product to Cart
HTTP Method: POST
> /api/add-to-cart

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "id" string - The ID of the product to be added to cart.

Responses
 - Status 200: Successfull addition
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Remove Product From Cart
HTTP Method: DELETE
> /api/remove-from-cart/:id

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Required Body Values
 - "id" string - The ID of the product to be removed from cart.

Responses
 - Status 200: Successfull removal
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Get Products In Cart
HTTP Method: GET
> /api/get-cart-products

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Responses
 - Status 200: JSON list of products in user's cart
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

### Checkout Cart
HTTP Method: post
> /api/checkout

Requires an authentication token from SignIn to be put as a header value named `x-auth-token`

Responses
 - Status 200: Successfully processed order of the cart.
 - Status 500. There is an internal server error. Contact the backend developer and give them this message.

