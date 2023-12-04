
const {API_NINJA_KEY} = require("../config.json")

let taxCache = new Map();

module.exports.getSalesTax = async (zipcode)=>{
    if (taxCache.get(zipcode)){
        return taxCache.get(zipcode);
    }

    const url = 'https://api.api-ninjas.com/v1/salestax?zip_code='+zipcode;
    let response = await fetch(url, {
        headers: {
            "X-Api-Key": API_NINJA_KEY,
        },
    })
    if (response.status == 200){
        try{
            let data = await response.json();
            console.log(data[0]['total_rate']);
            taxCache.set(zipcode,data[0]['total_rate'])
            return data[0]['total_rate']
        }
        catch(e){
            console.log("Tax parse error", e);
            return 0;
        }
    }
    return 0
}

module.exports.getSalesTax(2453).then(res =>{
    console.log(res);
})