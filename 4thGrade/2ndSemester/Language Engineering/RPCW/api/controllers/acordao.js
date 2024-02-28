const tribunais = require('../models/acordao')
var ObjectId = require('mongoose').Types.ObjectId; 

// GET Acórdãos de um tribunal
module.exports.getAcordaos = (tribunal, index) => { 
    var sort = tribunal == "jtcampca" ? {"Data" : 1}: {"Data do Acordão" : 1}
    return tribunais[tribunal]
            .find({},{ _id: 1, processo: 1, dataAcordao: 1, descritores: 1, data:1 }, { translateAliases: true })
            .sort(sort)
            .skip(index * 30)
            .limit(30)
            .then((acordaos) => {return acordaos})
            .catch((erro) => {return erro})
}

// GET Acórdão de um tribunal
module.exports.getAcordao = (tribunal, id) => {
    console.log("IDcontr: " + id)
    console.log("tribunal: " + tribunal)
    return tribunais[tribunal].findById(new ObjectId(id)).exec()
            .then((acordao) => {
                console.log("acordao")
                return acordao})
            .catch((erro) => {
                console.log("eorroo")
                return erro})
}

// POST Acórdão de um tribunal
module.exports.postAcordao = (acordao) => {
   var tribunal = tribunais[acordao.tribunal]
   var newAcordao = tribunal.translateAliases(acordao)
   return tribunal
           .create(newAcordao)
           .then((resposta) => {
               return resposta
           })
           .catch((erro) => {
               return erro
           })
}

module.exports.deleteAcordao = (tribunal, idAcordao) => {

    return tribunais[tribunal]
            .deleteOne({_id: idAcordao})
            .then((resposta) => {
                return resposta})
            .catch((erro) => {
                return erro})
}

// UPDATE Acórdão de um tribunal
module.exports.updateAcordao = (tribunal, acordao) => {
    return tribunais[tribunal]
            .updateOne({_id: acordao._id}, acordao)
            .then((resposta) => {
                return resposta
            })
            .catch((erro) => {
                return erro
            })
}

// UPDATE Acórdão campos de acordao
module.exports.updateAcordaoCampos = (tribunal, idAcordao, campos) => {
    return tribunais[tribunal]
            .updateOne({_id: idAcordao}, {$set: campos})
            .then((resposta) => {
                return resposta
            })
            .catch((erro) => {
                return erro
            })
}

// GET Pesquisa de um tribunal
module.exports.pesquisaAcordaos = (tribunal, pesquisaExata, pesquisaAberta, pesquisaGeral) => {
    var pesquisa = {}
    for (var key in pesquisaExata) {
        pesquisa[key] = pesquisaExata[key]
    }

    for (var key in pesquisaAberta) {
        pesquisa[key] = {"$regex": pesquisaAberta[key], "$options": "i"}
    }

    if (pesquisaGeral.length > 0)
        pesquisa["$text"] = {"$search": pesquisaGeral.join(" ")}
    console.log(pesquisaGeral)
    var sort = tribunal == "jtcampca" ? "Data": "Data do Acordão"
    console.dir(pesquisa)
    return tribunais[tribunal]
            .find(pesquisa)
            .sort({sort: 1})
            //.skip(index * 30)
            .limit(30)
            .then((acordaos) => {
                return acordaos
            })
            .catch((erro) => {
                return erro
            })

}