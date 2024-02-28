var express = require('express');
var router = express.Router();
var controllerSugestao = require('../controllers/sugestao');


// GET Sugestões - Admin
router.get('/', function(req, res, next) {
  controllerSugestao.getSugestoesAdmin()
  .then((sugestoes) => {
    res.jsonp(sugestoes);
  })
  .catch((erro) => {
    res.jsonp(erro);
  });
});

// GET Sugestão
router.get('/:id', function(req, res, next) {
  controllerSugestao.getSugestao(req.params.id)
  .then((sugestao) => {
    res.jsonp(sugestao);
  })
  .catch((erro) => {
    res.jsonp(erro);
  });
});


// POST Sugestão - Utilizador
router.post('/', function(req, res, next) {
  controllerSugestao.postSugestao(req.body)
  .then((sugestao) => {
    res.jsonp(sugestao);
  })
  .catch((erro) => {
    res.jsonp(erro);
  });
});


// PUT Sugestão - Estado de Sugestão (aceite ou rejeitada)
router.put('/:id', function(req, res, next) {

  controllerSugestao.putSugestao(req.params.id, req.body.estado)
  .then((sugestao) => {
    res.jsonp(sugestao);
  })
  .catch((erro) => {
    console.dir(erro)
    res.jsonp(erro);
  });
});

module.exports = router;