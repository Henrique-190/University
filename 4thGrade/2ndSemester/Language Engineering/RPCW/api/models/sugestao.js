var mongoose = require('mongoose')

var sugestaoSchema = new mongoose.Schema({
    _id: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    acordao: Object,
    idUtilizador: String,
    dataCriacao: String,
    dataDecisao: String,
    estado: String // S | E | N
})

module.exports = mongoose.model('sugestaoModel', sugestaoSchema, "sugestoes")