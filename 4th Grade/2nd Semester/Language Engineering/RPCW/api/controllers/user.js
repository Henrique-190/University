var ObjectId = require('mongoose').Types.ObjectId;
const user = require('../models/user')

// GET Utilizador - Perfil
module.exports.getUser = (id) => {
    return user.findById(new ObjectId(id)).exec()
        .then((user) => {return user})
        .catch((erro) => {return erro})
}

// GET Utilizador - Favoritos
module.exports.getFavoritos = (id, index) => {
    return user.findOne({_id:id})
            .skip(index * 30)
            .limit(30)
            .then((user) => {return user.favoritos})
            .catch((erro) => {return erro})
}

// POST Utilizador - Novo Favorito
module.exports.postFavorito = (id, favorito) => {
    return user
            .updateOne({_id: id}, {$push: {favoritos: favorito}})
            .then((resposta) => {return resposta})
            .catch((erro) => {return erro})
}

// DELETE Utilizador - Favorito
module.exports.deleteFavorito = (id, favorito) => {
    return user
            .updateOne({_id: id}, {$pull: {favoritos: {idAcordao: favorito.idAcordao}}})
            .then((resposta) => {return resposta})
            .catch((erro) => {return erro})
}