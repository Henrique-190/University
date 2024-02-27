var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    passportLocalMongoose = require('passport-local-mongoose')

var User = new Schema({
    _id: String, // username é unico
    password: String, // password encriptada aparece como "hash" na bd
    idTelegram: String, // id do telegram
    nivel: String, // admin, user
    filiacao: String, // Estudante, Docente, Outro
    ativo: Boolean, // true, false
    dataRegisto: String, // data de registo
    dataUltimoAcesso: String, // data do ultimo acesso
    otp: String, // one time password
    favoritos: [String]
})

User.plugin(passportLocalMongoose) 

module.exports = mongoose.model('user', User)

