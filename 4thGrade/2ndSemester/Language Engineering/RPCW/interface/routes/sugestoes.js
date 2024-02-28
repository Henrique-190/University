var express = require('express');
var axios = require('axios');
var router = express.Router();
var authURL = 'http://auth/users/' 
var apiSugestaoURL = 'http://api/sugestoes/'
var apiAcordaoURL = 'http://api/acordaos/'
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

/* GET sugestoes page */
router.get('/', verificaAcesso, function(req, res, next) {
    var data = getDateTime()
    if(req.mytoken.nivel == "admin"){
      axios.get(apiSugestaoURL).
      then(dados => {
        console.log(dados.data)
        res.render('mySugestoes', { d: data, sugestoes: dados.data });
      }).
      catch(e => {
        res.render('error', {error: e})
      })
    }
    else
      res.redirect('/')
});

/* GET a sugestao page */
router.get('/:id', verificaAcesso, function(req, res, next) {
  var data = getDateTime()
  axios.get(apiSugestaoURL + req.params.id).
    then(dados => {
      axios.get(apiAcordaoURL + dados.data.acordao._id + "?tribunal=" + dados.data.acordao.tribunal).
      then(acordao => {
        res.render('paginaSugestao', { d: data, sugestao: dados.data, acordao: acordao.data, admin: req.mytoken.nivel == "admin" });
      }).
      catch(e => {
        res.render('error', {error: e})
      })
    }).
    catch(e => {
      res.render('error', {error: e})
    })
})

/* POST add Sugestoes  */
router.post('/add', verificaAcesso, function(req, res, next) {
    console.log(req.body)
    axios.post(apiSugestaoURL, {dados : req.body, username: req.mytoken.username}).
      then(dados => {
        res.redirect('/?message=2')
      }).
      catch(e => {
        res.render('error', {error: e})
      })
})


/* POST aceita Sugestoes  */
router.post('/aceita/:id', verificaAcesso, function(req, res, next) {
  if(req.mytoken.nivel == "admin"){
    var id_acordao = req.body.id_acordao
    var tribunal = req.body.tribunal
    delete req.body.id_acordao
    delete req.body.tribunal
    axios.put(apiAcordaoURL + "sugestao/" + id_acordao + "?tribunal=" + tribunal, {dados : req.body}).
      then(dados => {
        axios.put(apiSugestaoURL + req.params.id, {estado: "S"}).
          then(dados => {
            res.redirect('/?message=1')
          }).
          catch(e => {
            res.render('error', {error: e})
          })
      }).
      catch(e => {
        res.render('error', {error: e})
      })
  }
  else{
    res.redirect('/')
  }
})

/* POST recusa Sugestoes  */
router.post('/recusa/:id', verificaAcesso, function(req, res, next) {
  if(req.mytoken.nivel == "admin"){
    axios.put(apiSugestaoURL + req.params.id, {estado: "N"}).
      then(dados => {
        res.redirect('/?message=1')
      }).
      catch(e => {
        res.render('error', {error: e})
      })
  }
  else{
    res.redirect('/')
  }
})

  
module.exports = router;