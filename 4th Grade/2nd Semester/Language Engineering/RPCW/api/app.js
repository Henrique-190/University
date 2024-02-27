var createError = require('http-errors');
var express = require('express');
var path = require('path');
var logger = require('morgan');
var mongoose = require('mongoose');

var indexRouter = require('./routes/acordao');
var userRouter = require('./routes/user');
var sugestaoRouter = require('./routes/sugestao');

var mongoDB = (process.env.MONGODB_URL || "mongodb://localhost:11001/Acordaos")
mongoose.connect(mongoDB, {useNewUrlParser: true, useUnifiedTopology: true})
var db = mongoose.connection;
db.on('open', function(){console.log("Conexão do Servidor de Autenticação ao MongoDB realizada com sucesso...")});
db.on('error', function(){console.log("Erro de conexão ao MongoDB...")});

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));

app.use('/acordaos', indexRouter);
app.use('/sugestoes', sugestaoRouter);
app.use('/user', userRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
