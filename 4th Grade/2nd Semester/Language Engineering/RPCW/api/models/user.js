var mongoose = require('mongoose')


var favoritosSchema = new mongoose.Schema({
    idAcordao: String,
    descricao: String,
    tribunal: String,
    dataAcordao: Date,
}, { versionKey: false, _id: false })

var User = new mongoose.Schema({
    _id: String,
    favoritos: [favoritosSchema],
})

module.exports = mongoose.model('userModel', User, "users")

