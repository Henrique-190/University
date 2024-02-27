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

function getCamposPesquisa(procura){
    var exata = /\s*<([^:]+)>:\"([^\"]+)\"/g;
    var geral = /\s*<([^:]+)>:([^\"\s]+)/g;
    var texto = /\s*([^\"\'\s<>:]+)/g;
    var m;
    var pesquisaDic = { "texto" : [] }
  
    do {
        m = exata.exec(procura);
        if (m) {
            console.log(m[1], m[2]);
            procura.replace(m[1], "")
            procura.replace(m[2], "")
            pesquisaDic[m[1]] = [m[2], true]
        }
    } while (m);
  
    do {
      m = geral.exec(procura);
      if (m) {
          console.log(m[1], m[2]);
          procura.replace(m[1], "")
          procura.replace(m[2], "")
          pesquisaDic[m[1]] = [m[2], false]
      }
    } while (m);
  
    do {
      m = texto.exec(procura);
      if (m) {
          console.log(m[1], m[2]);
          procura.replace(m[1], "")
          procura.replace(m[2], "")
          pesquisaDic["texto"].push(m[1])
      }
    } while (m);
  
    console.dir(pesquisaDic)
    return pesquisaDic
}

function trataAcordao(dados){
  acordao = {}
  
  for(var key in dados){
    console.log(key)
    if(key != "Descritores")
      acordao[key] = String(dados[key]).replaceAll("\n"," ")
    else 
      acordao[key] = dados[key]
    console.log(acordao[key])
  }
  return acordao
}

/* GET add Acordao page */
router.get('/add', verificaAcesso, function(req, res, next) {
  var data = getDateTime()
  console.log("boas")
  if(req.mytoken.nivel != "admin"){
    res.redirect('/')
  }
  else{
    res.render('addAcordao', { d: data });
  }
});

/* GET Acordao page */
router.get('/:id', verificaAcesso, function(req, res, next) {
  var data = getDateTime()
  axios.get(apiAcordaoURL + req.params.id + "?token=" + req.cookies.token + "&tribunal=" + req.query.tribunal).
    then(dados => {
      acordao = trataAcordao(dados.data)
      console.dir(acordao)
      //acordao = dados.data
      // IR BUSCAR SE É FAVORITO OU NÃO
      var fab = false
      
      axios.get(apiUserURL + "favoritos/" + req.mytoken.username).
        then(dados => {
          for(var i = 0; i < dados.data.length; i++){
            if(dados.data[i].idAcordao == req.params.id){
              fab = true
              break
            }
          }
          res.render('acordao', { d: data, acordao: acordao, fav: fab });
        }).
        catch(e => {
          res.render('error', {error: e})
        })
    }).
    catch(e => {
      res.render('error', {error: e})
    })
})


/* POST add Acordao page */
router.post("/add", verificaAcesso, function(req, res, next) {
  axios.post(apiAcordaoURL, {dados: req.body}).
    then(dados => {
      res.redirect('/?message=3')
    }).
    catch(e => {
      res.render('error', {error: e})
    })
})
  
/* POST delete Acordao page */
router.post("/deleteAcordao", verificaAcesso, function(req, res, next) {
  if (req.mytoken.nivel != "admin") {
    res.redirect('/?message=5')
  }
  axios.post(apiAcordaoURL + "deleteAcordao", {dados: req.body}).
    then(dados => {
      res.redirect('/?message=4')
    }).
    catch(e => {
      res.render('error', {error: e})
    })
})
  
/* POST procura */
router.post("/procura", verificaAcesso, function(req, res, next) {
  var pesquisaDic = getCamposPesquisa(req.body.procura)
  var data = getDateTime()
  axios.post(apiAcordaoURL + "pesquisa", {campos: pesquisaDic, tribunal: req.body.tribunal}).
    then(dados => {
      acordaos = dados.data
      res.render('index', { d: data, 
                            user: req.mytoken.username,  
                            notif: undefined, 
                            acordaos: acordaos,
                            tribunal: req.body.tribunal,
                            admin: req.mytoken.nivel == "admin" ? true : false });
 
    }).
    catch(e => {
      res.render('error', {error: e})
    })
})

module.exports = router;