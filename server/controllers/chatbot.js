
const { OpenAI } = require("openai"); 
const {CHATGPT_KEY} = require("../config.json")  

const openai = new OpenAI({
  apiKey: CHATGPT_KEY,
});

async function communicate(message){
    console.log('User: ', message)
    const completion = await openai.chat.completions.create({
        model: "gpt-4",
        messages: [{role: "user", content: message}],
    });
    return (completion.choices[0].message)
}
communicate("Write a description for my used Saber tennis racket that will make people want to buy it. Also suggest a price for it. Keep it under 200 words.")
.then(msg =>{
    console.log("ChatGPT:",msg.content)
})