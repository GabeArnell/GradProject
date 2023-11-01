
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
    console.log("ChatGPT:", completion.choices[0].message)
    return (completion.choices[0].message.content)
}


module.exports.descriptionGen = async (name,info,price)=>{
    let prompt = `Write an amazon description for a product given a name and information. Make people want to buy it. Answer in less than 70 words.\n`
    prompt+=`name: ${name.trim()}\n`
    prompt+=`info: ${info.trim()}\n`
    let answer = await communicate(prompt);
    return answer;
}