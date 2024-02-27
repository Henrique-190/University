var express = require('express');
var axios = require('axios');
var router = express.Router();
var authURL = 'http://auth/users/' 
var apiAcordaoURL = 'http://api/acordaos/'
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

messages = {
  "1": "Perfil atualizado com sucesso!",
  "2": "Sugestão enviada com sucesso!",
  "3": "Acórdão adicionado com sucesso!",
  "4": "Acórdão removido com sucesso!",
  "5": "Acórdão não eliminado porque não é Admin!"
}

router.get('/', verificaAcesso, function(req, res, next) {
  var data = getDateTime()
  var msg = messages[req.query.msg] == undefined ? "" : messages[req.query.msg]

  if (req.query.index == undefined){
    req.query.index = 0
  }
  if (req.query.tribunal == undefined){
    res.render('indexBase', { d: data, 
      user: req.mytoken.username, 
      message: msg,  
      admin: req.mytoken.nivel == "admin" ? true : false });
  }
  else{
    axios.get(apiAcordaoURL + "?index=" + req.query.index + "&tribunal=" + req.query.tribunal).
    then(dados => {
      acordaos = dados.data
      res.render('index', { d: data, 
                              user: req.mytoken.username, 
                              message: msg,  
                              index: req.query.index,
                              acordaos: acordaos,
                              tribunal: req.query.tribunal,
                              admin: req.mytoken.nivel == "admin" ? true : false });
      }).
      catch(e => {
        res.render('error', {error: e})
      })
    }
});

/* GET login page. */
router.get('/login', function(req, res, next) {
  
  // ao entrar na pagina de login faz logout
  axios.put(authURL + req.query.username + "/desativar").
    then(dados => {
        // sempre que entra na página de login, apaga o token
        res.clearCookie('token')

        var data = getDateTime()

        // otp normalmente undefined
        // otp = true se o user tiver feito esqueci password e otp estiver correto
        // otp = false se estiver incorreto

        res.render('login', { d: data, otp: req.query.otp });
    }).
    catch(e => {
      res.clearCookie('token')
      res.render('error', {error: e, message: e.response.data.message})
    })
});

/* GET registo page. */
router.get('/registo', function(req, res, next) {
  var data = getDateTime()
  res.render('registo', { d: data });
});

/* GET editar perfil page */
router.get('/editar', verificaAcesso, function(req, res, next) {
  var data = getDateTime()
  axios.get(authURL + req.mytoken.username + "?token=" + req.cookies.token).
    then(dados => {
      res.render('editarPerfil', { d: data, dados: dados.data });
    }).
    catch(e => {
      res.render('error', {error: e})
    })
});

/* POST login page. */
router.post('/login', function(req, res, next) {
  axios.post(authURL + "login", req.body).
    then(dados => {
      token = dados.data.token
      axios.put(authURL + req.body.username + "/ativar", {token : dados.data.token}).
        then(dados => {
          res.cookie('token', token);
          res.redirect('/')
        }).
        catch(e => {
          var data = getDateTime()
          res.render('login', {error: e.response.data.message, d: data})
        })
    })
    .catch(e => {
      var data = getDateTime()
      if(e.response.data == "Unauthorized"){
        res.render('login', {error: "Credenciais inválidas", d: data})
      }else{
        res.render('login', {error: e.response.data.message, d: data})
      }
    })
});


/* POST registo page. */
router.post('/registo', function(req, res, next) {
  axios.post(authURL + "registar", req.body).
    then(dados => {
      res.redirect('/login')
    })
    .catch(e => {
      var data = getDateTime()
      res.render('registo', {error: e.response.data.message, d: data})
    })

});

/* POST esqueci password. */
router.post('/esqueci', function(req, res, next) {
  axios.post(authURL + "esqueci", req.body).
    then(dados => {
      res.redirect('/login?otp=true')
    })
    .catch(e => {
      res.redirect('/login?otp=false')
    })
});

/* POST otp */
router.post('/otp', function(req, res, next) {  
  axios.get(authURL + "otp/" + req.body.username).
    then(dados => {
      if(dados.status != 200)
        res.redirect('/login?otp=none')
    })
});

/* POST editar perfil */
router.post('/editar', verificaAcesso, function(req, res, next) {
  axios.put(authURL + "editar" + "?token=" + req.cookies.token, {dados : req.body, username: req.mytoken.username}).
    then(dados => {
      res.redirect('/?message=1')
    }).
    catch(e => {
      res.render('error', {error: e})
    })
});
  

module.exports = router;