function showEsqueci() {
    if ($('#user').val().trim() !== '') {
        // NO SERVIDOR DE AUTH ENVIAR UM OTP PARA O TELEGRAM DO USER E GUARDA-LO NA BD
        // DEPOIS DE GUARDADO, ENVIAR O OTP PARA O TELEGRAM DO USER
        // 
        var val = $('#user').val().trim()
        var content = $(
            '<div class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:400px">' +
                '<form class="w3-container" action="/otp" method="post">' +
                  '<input type="hidden" name="username" value="' + val + '">' +
                  '<button class="w3-button w3-block w3-green w3-section w3-padding" type="submit">Enviar OTP</button>' +
                '</form>' +
                '<form class="w3-container" action="/esqueci" onsubmit="matchPassword(event)" method="post">' +
                      '<div class="w3-section">' +
                            '<input type="hidden" name="username" value="' + val + '">' +
                            '<label><b>OTP</b></label>' +
                            '<input class="w3-input w3-border" type="text" placeholder="Introduza o OTP enviado para o seu telegram" name="otp" required>' +
                            '<label><b>Password</b></label>' +
                            '<input class="w3-input w3-border" type="password" placeholder="Introduza a nova password" name="password" id="pwd1" required>' +
                            '<label><b>Password</b></label>' +
                            '<input class="w3-input w3-border" type="password" placeholder="Repita a nova password" id="pwd2" required>' +
                            '<button class="w3-button w3-block w3-green w3-section w3-padding" type="submit">Alterar Password</button>' +
                      '</div>' +
                '</form>' +
            '</div>') 
        
        $('#esqueci').empty()
        $('#esqueci').append(content)
        $('#esqueci').modal({ showClose: true, keyboard: true, clickClose: true})              
    } else {
      // Field is empty
      alert('Preencha o campo de utilizador');
    }
}

function loadTabela(acordao){
  $('#list').empty()
  var content = '<ul class="w3-ul w3-card-4">'
  for(var key in acordao){
    content += '<li><b>' + key + ':</b> ' + acordao[key] + '</li>'
  }

  $('#list').append($(content))
}

function alteraCampo(val,key){
  console.log(val)
  console.log(key)
  console.log($("input").parents("[id='"+key+"']").length)
  
  if($("input").parents("[id='"+key+"']").length == 0 && $("textarea").parents("[id='"+key+"']").length == 0){
    console.log("#"+key)
    if(key == "Descritores")
      $("[id='"+key+"']").replaceWith('<li id="'+key+'">(Campos separados por vírgulas)<br><input style="width: 80%" type="text" name="'+key+'" value="'+val+'"></li>')
    else if (val.length > 50)
      $("[id='"+key+"']").replaceWith('<li id="'+key+'"><textarea style="width: 80%; min-width: 80%; max-width:80% ; height: 150px" name="'+key+'">'+val+'</textarea></li>')
    else 
      $("[id='"+key+"']").replaceWith('<li id="'+key+'"><input style="width: 80%" type="text" name="'+key+'" value="'+val+'"></li>')

    $("[id='"+key+"E']").removeClass("w3-teal")
    $("[id='"+key+"E']").addClass("w3-red")
    $("[id='"+key+"E']").text("Reverter")
  }
  else{
    if(key == "Descritores"){
      var desc = val.split(",")
      var html = "<li id='"+key+"'><ul class='w3-ul'>"
      for(var i = 0; i < desc.length; i++){
        html += "<li>"+desc[i]+"</li>"
      }
      html += "</ul></li>"
      $("[id='"+key+"']").replaceWith(html)
      $("[id='"+key+"E']").removeClass("w3-red")
      $("[id='"+key+"E']").addClass("w3-teal")
      $("[id='"+key+"E']").text("Editar")
    }
    else{
      $("[id='"+key+"']").replaceWith('<li id="'+key+'">'+val+'</li>')
      $("[id='"+key+"E']").removeClass("w3-red")
      $("[id='"+key+"E']").addClass("w3-teal")
      $("[id='"+key+"E']").text("Editar")
    }
  }

  var inputs = $("#sugestao").find($("input")).length + $("#sugestao").find($("textarea")).length;
  console.log("Nr: "+inputs)
  if(inputs == 2){
    $("#submit").addClass("w3-disabled")
    $("#submit").attr("disabled", true)
  }else{
    $("#submit").removeClass("w3-disabled")
    $("#submit").attr("disabled", false)
  }
}

function showNotif(user, msg) {
  msg = msg.split(",")

  var content = [$('<div class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:400px; overflow-y: scroll;">')]
  $('#notif').empty()

  for (var i = 0; i < msg.length; i++) {
    var item = msg[i].split(" - ")
    var subItem = item[0].split(" ")
    var id = subItem[0]
    var processo = ""
    for (var j = 1; j < subItem.length; j++) {
      processo += subItem[j] + " "
    }
    var html = "<a href='/sugestoes/" + id + "'>"
    html += '<div class="w3-container w3-center">' + '<p style="border-bottom: 2px dotted black;">' + item[0]

    if (item[1] === "S") {
      html += '<i style="color: green;">\t-\tSugestão Aceite</i></p>'
    }
    else if (item[1] === "N") {
      html += '<i style="color: red;">\t-\tSugestão Negada</i></p>' 
    }
    else{
      html += '<i style="color: gray;">\t-\tSugestão em análise</i></p>'
    }
    html += '</div></a>'
    content.push($(html))
  }

  if (msg.length == 0) {
    content.push($('<p style="text-align: center;">Não tem notificações</p>'))
  }

  content.push($('</div>'))
  
  
  for(var i = 0; i < content.length; i++) {
    $('#notif').append(content[i])
  }
  $('#notif').modal({ showClose: true, keyboard: true, clickClose: true})              
}


function matchPassword(event) {
    event.preventDefault();

    var pw1 = $("#pwd1").val();
    var pw2 = $("#pwd2").val();

    console.log("pwd1: ",pw1)
    console.log("pwd2: ",pw2)

    // Check if passwords are empty
    if (pw1 === "" || pw2 === "") {
      alert("Passwords cannot be empty");
      return false; // Prevent form submission
    }
    
    // Check if passwords match
    if (pw1 !== pw2) {
      alert("Passwords não coincidem");
      console.log("Passwords não coincidem")
      return false; // Prevent form submission
    }
    
    // If reached here submit form
    event.currentTarget.submit();
    return true;
  }

function showFav(id,tribunal){
  $('#fav').empty()
  var content = $(
    '<div class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:400px">' +
        '<form class="w3-container" action="/user/favoritos/fav/'+ id +'" method="post">' +
              '<input type="hidden" name="tribunal" value="' + tribunal + '">' +
              '<div class="w3-section">' +
                    '<label><b>Descrição</b></label>' +
                    '<input class="w3-input w3-border" type="text" placeholder="Introduza uma observação (opcional)" name="descricao">' +
             '</div>' +
             '<button class="w3-button w3-block w3-green w3-section w3-padding" type="submit">Adicionar aos favoritos</button>' +
        '</form>' +
    '</div>') 

  $('#fav').append($(content))
  $('#fav').append(content)
  $('#fav').modal({ showClose: true, keyboard: true, clickClose: true})   
}