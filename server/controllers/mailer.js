const nodemailer = require('nodemailer');
const {EMAIL_USERNAME,EMAIL_PASSWORD}  = require("../config.json")
const html = `
<h1>Hello World</h1>
<p>This is our first *successful* email</p>
`

async function sendEmail(){
    const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
            user: EMAIL_USERNAME,
            pass: EMAIL_PASSWORD
        }
    })
    const info = await transporter.sendMail({
        from: EMAIL_USERNAME,
        to: "gabearnell@gmail.com",
        subject: "Test Email",
        html: html
    })
}

sendEmail()
.catch(error=>{
    console.log(error)
})


// let mailTransporter = nodemailer.createTransport({
//     service: "gmail",
//     auth: {
//         user: EMAIL_USERNAME,
//         pass: EMAIL_PASSWORD
//     }
// })

// let details = {
//     from: EMAIL_USERNAME,
//     to: "gabearnell@gmail.com",
//     subject: "Nodemail Test",
//     text: "This is a test for the nodemailer, this is the first message"
// }

// mailTransporter.sendMail( details, (error)=>{
//     if (error){
//         console.log("Mail error", error);
//     }else{
//         console.log("send mail")
//     }
// })