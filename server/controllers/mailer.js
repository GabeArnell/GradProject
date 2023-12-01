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
