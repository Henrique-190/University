var express = require('express');
var axios = require('axios');
var router = express.Router();
var authURL = 'http://auth/users/' 
var apiUserURL = 'http://api/user/'
var jwt = require('jsonwebtoken');

function getDateTime(){
  // timezone de portugal
  var tzoffset = (-1)*60*60*1000; //offset in milliseconds
  var localISOTime = (new Date(Date.now() - tzoffset)).toISOString().substring(0, 19)
  return localISOTime.replace('T', ' ')
}
function verificaAcesso(req, res, next){
  // verificar se o token é válido
  if(req.cookies.token == undefined){
    res.redirect('/login')
  }
  else {
    axios.post(authURL + "verificar", {token : req.cookies.token}).
    then(dados => {
      req.mytoken = dados.data
      next()
    }).catch(e => {
      token = jwt.decode(req.cookies.token)
      axios.put(authURL + token.username + "/desativar").
        then(dados => {
          res.clearCookie('token')
          res.redirect('/login')
        }).
        catch(e => {
          res.clearCookie('token')
          res.render('error', {error: e})
        })
    })  
  }
}

/* GET My Sugests page */
router.get('/sugestoes', verificaAcesso, function(req, res, next) {
    var data = getDateTime()
    axios.get(apiUserURL + "sugestoes/" + req.mytoken.username).
      then(dados => {
        console.log(dados.data)
        res.render('mySugestoes', { d: data, sugestoes: dados.data });
      }).
      catch(e => {
        res.render('error', {error: e})
      })
})
  

/* GET favoritos page */
router.get('/favoritos', verificaAcesso, function(req, res, next) {
    var data = getDateTime()
    axios.get(apiUserURL + "favoritos/" + req.mytoken.username).
      then(dados => {
        res.render('favoritos', { d: data, favoritos: dados.data });
      }).
      catch(e => {
        res.render('error', {error: e})
      })
})

/* GET unfav */
router.get("/favoritos/unfav/:id", verificaAcesso, function(req, res, next) {
    axios.post(apiUserURL + "/favoritos/unfav/" + req.params.id, {dados: req.query, username: req.mytoken.username}).
      then(dados => {
        res.redirect('/acordaos/'+req.params.id+ "?tribunal=" + req.query.tribunal)
      }).
      catch(e => {
        res.render('error', {error: e})
      })
  })

/* POST fav */
router.post("/favoritos/fav/:id", verificaAcesso, function(req, res, next) {
    console.log(req.body)
    axios.post(apiUserURL + "favoritos/fav/" + req.params.id, {dados: req.body, username: req.mytoken.username}).
      then(dados => {
        res.redirect('/acordaos/'+req.params.id + "?tribunal=" + req.body.tribunal)
      }).
      catch(e => {
        res.render('error', {error: e})
      })
})

module.exports = router;