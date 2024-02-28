var express = require('express');
var router = express.Router();
var controllerUser = require('../controllers/user');
var controllerSugestao = require('../controllers/sugestao');

// GET Utilizador - Favoritos
router.get('/favoritos/:id', function(req, res, next) {
  controllerUser.getFavoritos(req.params.id)
    .then((favoritos) => {
      console.dir(favoritos);
      res.jsonp(favoritos);
    })
    .catch((erro) => {
      res.jsonp(erro);
    });
});



router.post('/favoritos/fav/:id', function(req, res, next) {
  var fav = req.body.dados;
  fav['idAcordao'] = req.params.id;
  controllerUser.postFavorito(req.body.username, fav)
    .then((favorito) => {
      res.jsonp(favorito);
    })
    .catch((erro) => {
      res.jsonp(erro);
    })
});

router.post('/favoritos/unfav/:id', function(req, res, next) {
  var fav = req.body.dados;
  fav['idAcordao'] = req.params.id;
  controllerUser.deleteFavorito(req.body.username, fav)
    .then((favorito) => {
      res.jsonp(favorito);
    })
    .catch((erro) => {
      res.jsonp(erro);
    })
});


// GET Utilizador - Notificações
router.get('/notificacoes/:id', function(req, res, next) {
    controllerSugestao.getNotificacoes(req.params.id)
    .then((notificacoes) => {res.jsonp(notificacoes);})
    .catch((erro) => {res.jsonp(erro);});
});

// GET Sugestões - Utilizador
router.get('/sugestoes/:id', function(req, res, next) {
  index = req.index == null ? 0: req.index;
  controllerSugestao.getSugestoes(req.params.id)
  .then((sugestoes) => {
      res.jsonp(sugestoes);
  })
  .catch((erro) => {
      res.jsonp(erro);
  });
});


module.exports = router;