var express = require('express');
var router = express.Router();
var controller = require('../controllers/acordao');
var controllerUser = require('../controllers/user');


// GET Acórdãos
router.get('/', function(req, res, next) {
  controller.getAcordaos(req.query.tribunal, parseInt(req.query.index))
    .then((acordaos) => {
      res.jsonp(acordaos);
    })
    .catch((erro) => {
      res.jsonp(erro);
    });
});


// GET Acórdão
router.get('/:id', function(req, res, next) {
  controller.getAcordao(req.query.tribunal, req.params.id)
    .then((acordao) => {
      res.jsonp(acordao);
    })
    .catch((erro) => {
      res.jsonp(erro);
    });
});

// POST Acordão
router.post('/', function(req, res, next) {
  var descritores = req.body.dados.descritores;
  req.body.dados.descritores = descritores.split(",");
  controller.postAcordao(req.body.dados)
    .then((acordao) => {
      res.jsonp(acordao);
    })
    .catch((erro) => {
      res.jsonp(erro);
    });
});


// POST Acordão - Delete
router.post("/deleteAcordao", function(req, res, next) {
  controller.deleteAcordao(req.body.dados.tribunal, req.body.dados._id)
    .then((acordao) => {
      console.dir(acordao)
      res.jsonp(acordao);
    })
    .catch((erro) => {
      res.jsonp(erro);
    });
});

// PUT Acordão - Update com Sugestão
router.put('/:id', function(req, res, next) {
  controller.updateAcordao(req.query.tribunal, req.body)
    .then((acordao) => {
      res.jsonp(acordao);
    })
    .catch((erro) => {
      res.jsonp(erro);
    });
});

// PUT Acordão - Update com Sugestão
router.put('/sugestao/:id', function(req, res, next) {
  var dados = req.body.dados;
  console.dir(dados)
  var newDados = {};
  for(var key in dados) {
    if (key == "Descritores")
      newDados[key] = dados[key].split(",");
    else
      newDados[key.replace("_", " ")] = dados[key]
  }
  console.dir(newDados)
  controller.updateAcordaoCampos(req.query.tribunal, req.params.id ,newDados)
    .then((acordao) => {
      res.jsonp(acordao);
    })
    .catch((erro) => {
      res.jsonp(erro);
    })
});

// POST Acordão - Pesquisa
router.post('/pesquisa', function(req, res, next) {
  var pesquisaExata = {};
  var pesquisaGeral = [];
  var pesquisaAberta = {};
  var campos = req.body.campos;
  for(var key in campos) {
    if(key == "texto"){
      pesquisaGeral = campos[key];
    }else if(campos[key][1])
      pesquisaExata[key] = campos[key][0];
    else
      pesquisaAberta[key] = campos[key][0];
  }
  console.log("Exata:")
  console.log(pesquisaExata);
  console.log("Aberta:")
  console.log(pesquisaAberta);
  console.log("Geral:")
  console.log(pesquisaGeral);

  controller.pesquisaAcordaos(req.body.tribunal, pesquisaExata, pesquisaAberta, pesquisaGeral)
    .then((acordaos) => {
      res.jsonp(acordaos);
    })
    .catch((erro) => {
      res.jsonp(erro);
    })
});


module.exports = router;