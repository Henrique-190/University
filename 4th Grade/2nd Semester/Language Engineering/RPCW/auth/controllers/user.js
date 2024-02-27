// User API controller
//
var User = require('../models/user')

module.exports.list = () => {
    return User
            .find()
            .then(resposta => {
                return resposta
            })
            .catch(erro => {
                return erro
            })
}

module.exports.getUser = id => {
    return User.findOne({_id:id})
            .then(resposta => {
                return resposta
            })
            .catch(erro => {
                return erro
            })
}

module.exports.updateUser = (id, info) => {
    return User.updateOne({_id:id}, info)
            .then(resposta => {
                return resposta
            })
            .catch(erro => {
                return erro
            })
}


module.exports.updateUserStatus = (id, status, data) => {
    return User.updateOne({_id:id}, {ativo: status, dataUltimoAcesso: data})
            .then(resposta => {
                return resposta
            })
            .catch(erro => {
                return erro
            })
}

module.exports.updateUserOTP = (id, otp) => {
    return User.updateOne({_id:id}, { "$set": {"otp": otp}})
            .then(resposta => {
                return resposta
            })
            .catch(erro => {
                return erro
            })
}

// altera a password e elimina o OTP
module.exports.updateUserPassword = (id, password) => {
    return User.findOne({ _id: id }).
            then(user => {
                user.setPassword(password).
                    then(users => {
                        User.updateOne({ _id: id },{ hash: users.hash, salt: users.salt, otp: "" }).
                            then(resposta => {
                                return resposta
                            }).
                            catch(erro => {
                                return erro
                            })
                    }).
                    catch(err => {
                        return err
                    })

            }).
            catch(err => {
                return err
            })
}

module.exports.deleteUser = id => {
    return User.deleteOne({_id:id})
            .then(resposta => {
                return resposta
            })
            .catch(erro => {
                return erro
            })
}