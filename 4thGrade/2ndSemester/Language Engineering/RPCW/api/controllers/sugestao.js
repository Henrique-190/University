const { isObjectIdOrHexString } = require('mongoose')
const sugestao = require('../models/sugestao')
var ObjectId = require('mongoose').Types.ObjectId; 

estados = {
    "E": "Em Análise",
    "S": "Aceite",
    "N": "Rejeitada"
}

processaData = (data) => {
    return data == "Não decidido" ? "Não decidido" : 
        data.substring(0,4) + "-" + data.substring(4,6) + "-" + data.substring(6,8) + " " + data.substring(9,11) + ":" + data.substring(11,13) + ":" + data.substring(13,15)
}


// GET Sugestões - Utilizador (Data de Criação)
module.exports.getSugestoesAdmin = () => {
    return sugestao
            .find()
            .sort({dataCriacao: -1})
            .then((sugestoes) => {
                ans = []
                for (var i = 0; i < sugestoes.length; i++) {
                    aux = {}
                    aux['id'] = sugestoes[i]._id
                    aux['id_acordao'] = sugestoes[i].acordao._id
                    aux['dataCriacao'] = processaData(sugestoes[i].dataCriacao)
                    aux['dataDecisao'] = processaData(sugestoes[i].dataDecisao)
                    aux['estado'] = estados[sugestoes[i].estado]
                    ans = ans.concat(aux)
                }
                return ans
            })
            .catch((erro) => {return erro})
}

// GET Sugestões - Utilizador (Data de Criação)
module.exports.getSugestoes = (idUtilizador) => {
    return sugestao
            .find({idUtilizador: idUtilizador})
            .sort({dataCriacao: -1})
            .then((sugestoes) => {
                ans = []
                for (var i = 0; i < sugestoes.length; i++) {
                    aux = {}
                    aux['id'] = sugestoes[i]._id
                    aux['id_acordao'] = sugestoes[i].acordao._id
                    aux['dataCriacao'] = processaData(sugestoes[i].dataCriacao)
                    aux['dataDecisao'] = processaData(sugestoes[i].dataDecisao)
                    aux['estado'] = estados[sugestoes[i].estado]
                    ans = ans.concat(aux)
                }
                return ans
            })
            .catch((erro) => {return erro})
}

// GET Sugestões - Utilizador (Data de Decisão)
module.exports.getNotificacoes = (idUtilizador, index) => {
    return sugestao
            .find({idUtilizador: idUtilizador})
            .sort({dataDecisao: -1})
            .skip(index * 30)
            .limit(30)
            .then((sugestoes) => {
                var ans = []
                for (var i = 0; i < sugestoes.length; i++) {
                    ans = ans.concat(sugestoes[i].acordao._id + " " + sugestoes[i].acordao.processo + " - " + sugestoes[i].estado);
                } //TODO ADICIONAR O ID DA SUGESTAO
                return ans})
            .catch((erro) => {return erro}) //TODO ALTERAR PARA VAZIO
}

// GET Sugestões - Admin
module.exports.getSugestoesPendentes = (index) => {
    return sugestao
            .find({estado: "E"})
            .sort({dataCriacao: -1})
            .skip(index * 30)
            .limit(30)
            .then((sugestoes) => {return sugestoes})
            .catch((erro) => {return erro})
}


// GET Sugestão - Utilizador
module.exports.getSugestao = (id) => {
    return sugestao
            .findById(new ObjectId(id))
            .then((sugestao) => {
                aux = {}
                aux['id'] = sugestao._id
                aux['id_acordao'] = sugestao.acordao._id
                aux['dataCriacao'] = processaData(sugestao.dataCriacao)
                aux['dataDecisao'] = processaData(sugestao.dataDecisao)
                aux['estado'] = estados[sugestao.estado]
                aux['acordao'] = sugestao.acordao
                
                return aux})
            .catch((erro) => {return erro})
}


// POST Sugestão - Utilizador
module.exports.postSugestao = (sugest) => {
    return sugestao.create({
                "acordao": sugest["dados"], 
                "idUtilizador": sugest["username"], 
                "dataCriacao": getCurrentDateTime(),
                "dataDecisao": "Não decidido",
                "estado": "E"})
            .then((resposta) => {return resposta})
            .catch((erro) => {return erro})
}

// PUT Sugestão - Admin (aceitar ou rejeitar)
module.exports.putSugestao = (id, estado) => {
    return sugestao
            .updateOne({_id: id}, {$set: {estado: estado, dataDecisao: getCurrentDateTime()}})
            .then((resposta) => {return resposta})
            .catch((erro) => {return erro})
}

function formatNumber(num) {
    return num.toString().padStart(2, '0');
}
  
function getCurrentDateTime() {
  var tzoffset = (-1)*60*60*1000; //offset in milliseconds
  var now = (new Date(Date.now() - tzoffset))

  const year = now.getFullYear();
  const month = formatNumber(now.getMonth() + 1);
  const day = formatNumber(now.getDate());
  const hours = formatNumber(now.getHours());
  const minutes = formatNumber(now.getMinutes());
  const seconds = formatNumber(now.getSeconds());

  console.log(`${year}${month}${day}_${hours}${minutes}${seconds}`)
  
  return `${year}${month}${day}_${hours}${minutes}${seconds}`;
}