
var axios = require('axios');

// Function to generate a random OTP
function generate_otp(){
    var otp = ""
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    for (var i = 0; i < 9; i++)
        otp += possible.charAt(Math.floor(Math.random() * possible.length))

    return otp
}

// Function to send OTP to the pre-determined user
function send_otp(user_id){
    var token = "5748571031:AAEWxJpuJEWrFxw8pcopYhSdeHJQXpsVPDI"
    // Telegram Bot API base URL
    var base_url = 'https://api.telegram.org/bot' + token + '/'


    var otp = generate_otp()
    message = text = "OTP: " + otp

    var url = base_url + 'sendMessage'
    var payload = {
        'chat_id': user_id,
        'text': message
    }

    return axios.post(url, payload)
}

module.exports = { send_otp };