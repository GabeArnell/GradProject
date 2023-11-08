const nodemailer = require('nodemailer');
const {EMAIL_USERNAME,EMAIL_PASSWORD}  = require("../config.json")


module.exports.sendEmail = async (address,subject, htmlContent)=>{
    const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
            user: EMAIL_USERNAME,
            pass: EMAIL_PASSWORD
        }
    })
    const info = await transporter.sendMail({
        from: EMAIL_USERNAME,
        to: address,
        subject: subject,
        html: htmlContent
    })
}

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