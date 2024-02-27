var mongoose = require('mongoose')
var ObjectId = require('mongoose').Types.ObjectId; 


var atcoSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Volume dos Acordãos do T.C.":{
        type: String,
        alias: "volume"
    },
    "Indicações Eventuais":{
        type: String,
        alias: "indicacoes"
    },
    "Jurisprudência Internacional":{
        type: String,
        alias: "jurisprudenciaINT"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Requerido" :{
        type: String,
        alias: "requerido"
    },
    "Área Temática 1":{
        type: String,
        alias: "area1"
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    },
    "Nº do Documento":{
        type: String,
        alias: "nDocumento"
    },
    "Voto Vencido":{
        type: String,
        alias: "voto"
    },
    "Área Temática 2":{
        type: String,
        alias: "area2"
    },
    "tribunal": String,
    "Referências Internacionais":{
        type: String,
        alias: "referenciasINT"
    },
    "Página do Boletim do M.J.":{
        type: String,
        alias: "paginaBoletim"
    },
    "Outras Publicações":{
        type: String,
        alias: "outrasPub"
    },
    "Normas Suscitadas":{
        type: String,
        alias: "normas"
    },
    "Acordão":{
        type: String,
        alias: "acordao"
    },
    "url": String,
    "Normas Declaradas Inconst.":{
        type: String,
        alias: "normasDeclInconst"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Nº do Boletim do M.J.":{
        type: String,
        alias: "boletim"
    },
    "Página do Diário da República":{
        type: String,
        alias: "paginaDR"
    },
    "Declaração de Voto":{
        type: String,
        alias: "declVoto"
    },
    "Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "Página do Volume":{
        type: String,
        alias: "paginaVol"
    },
    "Descritores":{
        type: Array,
        alias: "descritores"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Normas Apreciadas":{
        type: String,
        alias: "normasApreciadas"
    },
    "Data do Diário da República":{
        type: String,
        alias: "dataDR"
    },
    "Outra Jurisprudência":{
        type: String,
        alias: "outraJurisprudencia"
    },
    "Requerente":{
        type: String,
        alias: "requerente"
    },
    "Nº do Diário da República":{
        type: String,
        alias: "nDR"
    },
    "Série do Diário da República":{
        type: String,
        alias: "serieDR"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Legislação Estrangeira":{
        type: String,
        alias: "legislacaoESTR"
    },
    "Nº Convencional":{
        type: String,
        alias: "nConvencional"
    },
    "Constituição":{
        type: String,
        alias: "constituicao"
    },
    "Legislação Nacional":{
        type: String,
        alias: "legislacaoNAC"
    },
    "Espécie":{
        type: String,
        alias: "especie"
    },
    "Normas Julgadas Inconst.":{
        type: String,
        alias: "normasJulInconst"
    },
    "Jurisprudência Constitucional":{
        type: String,
        alias: "jurisprudenciaNAC"
    },
    "Jurisprudência Estrangeira":{
        type: String,
        alias: "jurisprudenciaESTR"
    },
    "Privacidade":{
        type: String,
        alias: "privacidade"
    },
    "Legislação Comunitária":{
        type: String,
        alias: "legislacaoCOM"
    },
    "Referência a Pareceres":{
        type: String,
        alias: "referenciaPareceres"
    }
},{ versionKey : false})

var jtcampcaSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Nº Processo/TAF":{
        type: String,
        alias: "nProcesso"
    },
    "Sub-Secção":{
        type: String,
        alias: "subseccao"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Data":{
        type: String,
        alias: "dataAcordao"
    },
    "url": String,
    "Disponível na JTCA":{
        type: String,
        alias: "disponivelJTCA"
    },
    "Magistrado":{
        type: String,
        alias: "magistrado"
    },
    "Observações":{
        type: String,
        alias: "observacoes"
    },
    "tribunal": String,
    "Contencioso":{
        type: String,
        alias: "contencioso"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Área Temática":{
        type: String,
        alias: "area1"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    }
},{ versionKey : false})

var jdgpjSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Tipo de Contrato":{
        type: String,
        alias: "tipoContrato"
    },
    "Tribunal 1ª instância":{
        type: String,
        alias: "tribunal1Instancia"
    },
    "Réu":{
        type: String,
        alias: "reu"
    },
    "Recursos":{
        type: String,
        alias: "recursos"
    },
    "Data da Decisão":{
        type: String,
        alias: "dataAcordao"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Autor":{
        type: String,
        alias: "autor"
    },
    "Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Tipo de Ação":{
        type: String,
        alias: "tipoAcao"
    },
    "Juízo ou Secção":{
        type: String,
        alias: "juizoSeccao"
    },
    "url": String,
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Texto das Cláusulas Abusivas":{
        type: String,
        alias: "textoClausulasAbusivas"
    },
    "tribunal": String,
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Área Temática":{
        type: String,
        alias: "area1"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    }
},{ versionKey : false})

var jtrpSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Indicações Eventuais":{
        type: String,
        alias: "indicacoes"
    },
    "Jurisprudência Internacional":{
        type: String,
        alias: "jurisprudenciaINT"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    },
    "Nº do Documento":{
        type: String,
        alias: "nDocumento"
    },
    "tribunal": String,
    "Recurso":{
        type: String,
        alias: "recurso"
    },
    "Nº Único do Processo":{
        type: String,
        alias: "nProcesso"
    },
    "Data Dec. Recorrida":{
        type: String,
        alias: "dataDecisaoRecorrida"
    },
    "Referências Internacionais":{
        type: String,
        alias: "referenciasINT"
    },
    "Apenso":{
        type: String,
        alias: "apenso"
    },
    "Decisão Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "url": String,
    "Meio Processual":{
        type: String,
        alias: "meioProcessual"
    },
    "Referência Processo":{
        type: String,
        alias: "referenciaProcesso"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Área Temática":{
        type: String,
        alias: "area1"
    },
    "Processo no Tribunal Recorrido":{
        type: String,
        alias: "processoTribunalRecorrido"
    },
    "Referência de Publicação":{
        type: String,
        alias: "referenciaPublicacao1"
    },
    
    "Jurisprudência Nacional":{
        type: String,
        alias: "jurisprudenciaNAC"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Legislação Estrangeira":{
        type: String,
        alias: "legislacaoESTR"
    },
    "Nº Convencional":{
        type: String,
        alias: "nConvencional"
    },
    "Legislação Nacional":{
        type: String,
        alias: "legislacaoNAC"
    },
    "Tribunal Recorrido":{
        type: String,
        alias: "tribunalRecorrido"
    },
    "Jurisprudência Estrangeira":{
        type: String,
        alias: "jurisprudenciaESTR"
    },
    "Reclamações":{
        type: String,
        alias: "reclamacoes"
    },
    "Privacidade":{
        type: String,
        alias: "privacidade"
    },
    "Legislação Comunitária":{
        type: String,
        alias: "legislacaoCOM"
    }
},{ versionKey : false})

var jtrgSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Indicações Eventuais":{
        type: String,
        alias: "indicacoes"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    },
    "Nº do Documento":{
        type: String,
        alias: "nDocumento"
    },
    "tribunal": String,
    "Decisão Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "url": String,
    "Meio Processual":{
        type: String,
        alias: "meioProcessual"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Área Temática":{
        type: String,
        alias: "area1"
    },
    
    "Jurisprudência Nacional":{
        type: String,
        alias: "jurisprudenciaNAC"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Legislação Estrangeira":{
        type: String,
        alias: "legislacaoESTR"
    },
    "Nº Convencional":{
        type: String,
        alias: "nConvencional"
    },
    "Legislação Nacional":{
        type: String,
        alias: "legislacaoNAC"
    },
    "Privacidade":{
        type: String,
        alias: "privacidade"
    }
},{ versionKey : false})

var jtcampctSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Tema":{
        type: String,
        alias: "area1"
    },
    "Nº Processo/TAF":{
        type: String,
        alias: "nProcesso"
    },
    "Sub-Secção":{
        type: String,
        alias: "subseccao"
    },
    "Peça Processual":{
        type: String,
        alias: "pecaProcessual"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "url": String,
    "Disponível na JTCA":{
        type: String,
        alias: "disponivelJTCA"
    },
    "Magistrado":{
        type: String,
        alias: "magistrado"
    },
    "Observações":{
        type: String,
        alias: "observacoes"
    },
    "Data":{
        type: String,
        alias: "data"
    },
    "tribunal": String,
    "Contencioso":{
        type: String,
        alias: "contencioso"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    }
},{ versionKey : false})

var jtreSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Jurisprudência Internacional":{
        type: String,
        alias: "jurisprudenciaINT"
    },
    "Indicações Eventuais":{
        type: String,
        alias: "indicacoes"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    },
    "Nº do Documento":{
        type: String,
        alias: "nDocumento"
    },
    "tribunal": String,
    "Referências Internacionais":{
        type: String,
        alias: "referenciasINT"
    },
    "Decisão Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "url": String,
    "Meio Processual":{
        type: String,
        alias: "meioProcessual"
    },
    "Referência Processo":{
        type: String,
        alias: "referenciaProcesso"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Área Temática":{
        type: String,
        alias: "area1"
    },
    "Processo no Tribunal Recorrido":{
        type: String,
        alias: "processoTribunalRecorrido"
    },
    
    "Jurisprudência Nacional":{
        type: String,
        alias: "jurisprudenciaNAC"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Legislação Estrangeira":{
        type: String,
        alias: "legislacaoESTR"
    },
    "Legislação Nacional":{
        type: String,
        alias: "legislacaoNAC"
    },
    "Tribunal Recorrido":{
        type: String,
        alias: "tribunalRecorrido"
    },
    "Legislação Comunitária":{
        type: String,
        alias: "legislacaoCOM"
    }
},{ versionKey : false})

var jconSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Indicações Eventuais":{
        type: String,
        alias: "indicacoes"
    },
    "Jurisprudência Internacional":{
        type: String,
        alias: "jurisprudenciaINT"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Recusa Aplicação":{
        type: String,
        alias: "recusaAplicacao"
    },
    "Área Temática 1":{
        type: String,
        alias: "area1"
    },
    "Ano da Publicação":{
        type: String,
        alias: "anoPublicacao"
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Nº do Documento":{
        type: String,
        alias: "nDocumento"
    },
    "Objecto":{
        type: String,
        alias: "objeto"
    },
    "Área Temática 2":{
        type: String,
        alias: "area2"
    },
    "tribunal": String,
    "Referência a Doutrina":{
        type: String,
        alias: "referenciaDoutrina"
    },
    "Referência Publicação 1":{
        type: String,
        alias: "referenciaPublicacao1"
    },
    "Tribunal":{
        type: String,
        alias: "tribunalRecorrido"
    },
    "Recorrido 2":{
        type: String,
        alias: "recorrido2"
    },
    "Referências Internacionais":{
        type: String,
        alias: "referenciasINT"
    },
    "Recorrido 1":{
        type: String,
        alias: "recorrido1"
    },
    "url": String,
    "Nº do Volume":{
        type: String,
        alias: "nVolume"
    },
    "Meio Processual":{
        type: String,
        alias: "meioProcessual"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Data do Apêndice":{
        type: String,
        alias: "dataApendice"
    },
    "Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "Jurisprudência Nacional":{
        type: String,
        alias: "jurisprudenciaNAC"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Recorrente":{
        type: String,
        alias: "recorrente"
    },
    "Data de Entrada":{
        type: String,
        alias: "dataEntrada"
    },
    "Apêndice":{
        type: String,
        alias: "apendice"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Nº Convencional":{
        type: String,
        alias: "nConvencional"
    },
    "Legislação Nacional":{
        type: String,
        alias: "legislacaoNAC"
    },
    "1ª Pág. de Publicação do Acordão":{
        type: String,
        alias: "primeiraPagPublicacaoAcordao"
    },
    "Privacidade":{
        type: String,
        alias: "privacidade"
    },
    "Legislação Comunitária":{
        type: String,
        alias: "legislacaoCOM"
    },
    "Referência a Pareceres":{
        type: String,
        alias: "referenciaPareceres"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    }
},{ versionKey : false})

var jtrcSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Processo no Tribunal Recurso":{
        type: String,
        alias: "processoTribunalRecorrido"
    },
    "Indicações Eventuais":{
        type: String,
        alias: "indicacoes"
    },
    "Jurisprudência Internacional":{
        type: String,
        alias: "jurisprudenciaINT"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    },
    "Nº do Documento":{
        type: String,
        alias: "nDocumento"
    },
    "tribunal": String,
    "Nº Único do Processo":{
        type: String,
        alias: "nProcesso"
    },
    "Decisão Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "url": String,
    "Meio Processual":{
        type: String,
        alias: "meioProcessual"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Data":{
        type: String,
        alias: "data"
    },
    "Área Temática":{
        type: String,
        alias: "area1"
    },
    "Referência de Publicação":{
        type: String,
        alias: "referenciaPublicacao1"
    },
    "Tribunal Recurso":{
        type: String,
        alias: "tribunalRecorrido"
    },
    "Jurisprudência Nacional":{
        type: String,
        alias: "jurisprudenciaNAC"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Legislação Estrangeira":{
        type: String,
        alias: "legislacaoESTR"
    },
    "Nº Convencional":{
        type: String,
        alias: "nConvencional"
    },
    "Legislação Nacional":{
        type: String,
        alias: "legislacaoNAC"
    },
    "Privacidade":{
        type: String,
        alias: "privacidade"
    },
    "Legislação Comunitária":{
        type: String,
        alias: "legislacaoCOM"
    }
},{ versionKey : false})

var jstaSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Tribunal":{
        type: String,
        alias: "tribunalRecorrido"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Nº Convencional":{
        type: String,
        alias: "nConvencional"
    },
    "Nº do Documento":{
        type: String,
        alias: "nDocumento"
    },
    "Data de Entrada":{
        type: String,
        alias: "dataEntrada"
    },
    "Recorrente":{
        type: String,
        alias: "recorrente"
    },
    "Recorrido 1":{
        type: String,
        alias: "recorrido1"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "url": String,
    "tribunal": String,
    "Legislação Nacional":{
        type: String,
        alias: "legislacaoNAC"
    },
    "Legislação Comunitária":{
        type: String,
        alias: "legislacaoCOM"
    },
    "Área Temática 1":{
        type: String,
        alias: "area1"
    },
    "Referências Internacionais":{
        type: String,
        alias: "referenciasINT"
    },
    "Jurisprudência Nacional":{
        type: String,
        alias: "jurisprudenciaNAC"
    },
    "Recorrido 2":{
        type: String,
        alias: "recorrido2"
    },
    "Nº do Volume":{
        type: String,
        alias: "nVolume"
    },
    "Meio Processual":{
        type: String,
        alias: "meioProcessual"
    },
    "Objecto":{
        type: String,
        alias: "objeto"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Área Temática 2":{
        type: String,
        alias: "area2"
    },
    "Legislação Estrangeira":{
        type: String,
        alias: "legislacaoESTR"
    },
    "Referência a Doutrina":{
        type: String,
        alias: "referenciaDoutrina"
    },
    "Indicações Eventuais":{
        type: String,
        alias: "indicacoes"
    },
    "Jurisprudência Internacional":{
        type: String,
        alias: "jurisprudenciaINT"
    },
    "Referência a Pareceres":{
        type: String,
        alias: "referenciaPareceres"
    },
    "Recusa Aplicação":{
        type: String,
        alias: "recusaAplicacao"
    },
    "Jurisprudência Estrangeira":{
        type: String,
        alias: "jurisprudenciaESTR"
    },
    "1ª Pág. de Publicação do Acordão":{
        type: String,
        alias: "primeiraPagPublicacaoAcordao"
    },
    "Referência Publicação 1":{
        type: String,
        alias: "referenciaPublicacao1"
    },
    "Ano da Publicação":{
        type: String,
        alias: "anoPublicacao"
    },
    "Privacidade":{
        type: String,
        alias: "privacidade"
    },
    "Apêndice":{
        type: String,
        alias: "apendice"
    },
    "Data do Apêndice":{
        type: String,
        alias: "dataApendice"
    },
    "Página":{
        type: String,
        alias: "paginaVol"
    },
    "Referência Publicação 2":{
        type: String,
        alias: "referenciaPublicacao2"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    }
},{ versionKey : false})

var jtcaSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Secção":{
        type: String,
        alias: "area1"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Decisão Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "url": String,
    "tribunal": String,
    "Referências Internacionais":{
        type: String,
        alias: "referenciasINT"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Nº do Volume":{
        type: String,
        alias: "nVolume"
    },
    "Nº Convencional":{
        type: String,
        alias: "nConvencional"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    },
    "Recorrente":{
        type: String,
        alias: "recorrente"
    },
    "Meio Processual":{
        type: String,
        alias: "meioProcessual"
    },
    "Referência Publicação 2":{
        type: String,
        alias: "referenciaPublicacao2"
    },
    "Tribunal":{
        type: String,
        alias: "tribunalRecorrido"
    },
    "Referência a Doutrina":{
        type: String,
        alias: "referenciaDoutrina"
    },
    "Área Temática 2":{
        type: String,
        alias: "area2"
    },
    "Referência Publicação 1":{
        type: String,
        alias: "referenciaPublicacao1"
    }
},{ versionKey : false})

var jtrlSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Nº do Documento":{
        type: String,
        alias: "nDocumento"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Meio Processual":{
        type: String,
        alias: "meioProcessual"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    },
    "Decisão Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "url": String,
    "tribunal": String,
    "Processo no Tribunal Recurso":{
        type: String,
        alias: "processoTribunalRecorrido"
    },
    "Área Temática":{
        type: String,
        alias: "area1"
    },
    "Jurisprudência Estrangeira":{
        type: String,
        alias: "jurisprudenciaESTR"
    },
    "Legislação Comunitária":{
        type: String,
        alias: "legislacaoCOM"
    },
    "Nº Convencional":{
        type: String,
        alias: "nConvencional"
    },
    "Legislação Nacional":{
        type: String,
        alias: "legislacaoNAC"
    },
    "Referência de Publicação":{
        type: String,
        alias: "referenciaPublicacao1"
    },
    "Privacidade":{
        type: String,
        alias: "privacidade"
    },
    "Jurisprudência Nacional":{
        type: String,
        alias: "jurisprudenciaNAC"
    },
    "Indicações Eventuais":{
        type: String,
        alias: "indicacoes"
    },
    "Jurisprudência Internacional":{
        type: String,
        alias: "jurisprudenciaINT"
    },
    "Legislação Estrangeira":{
        type: String,
        alias: "legislacaoESTR"
    },
    "Referências Internacionais":{
        type: String,
        alias: "referenciasINT"
    },
    "Tribunal Recurso":{
        type: String,
        alias: "tribunalRecorrido"
    },
    "Apenso":{
        type: String,
        alias: "apenso"
    },
    "Data":{
        type: String,
        alias: "data"
    },
    "Recurso":{
        type: String,
        alias: "recurso"
    },
    "Nº Único do Processo":{
        type: String,
        alias: "nProcesso"
    },
    "Referência Processo":{
        type: String,
        alias: "referenciaProcesso"
    }
},{ versionKey : false})

var jtcnSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Secção":{
        type: String,
        alias: "area1"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Tribunal":{
        type: String,
        alias: "tribunalRecorrido"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    },
    "Decisão Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "url": String,
    "tribunal": String,
    "Recorrente":{
        type: String,
        alias: "recorrente"
    },
    "Recorrido 1":{
        type: String,
        alias: "recorrido1"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Meio Processual":{
        type: String,
        alias: "meioProcessual"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Parecer Ministério Publico":{
        type: String,
        alias: "parecerMP"
    },
    "Objecto":{
        type: String,
        alias: "objeto"
    },
    "Recorrido 2":{
        type: String,
        alias: "recorrido2"
    },
    "Data de Entrada":{
        type: String,
        alias: "dataEntrada"
    }
},{ versionKey : false})

var jstjSchema = new mongoose.Schema({
    _id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        auto: true,
    },
    "Processo":{
        type: String,
        alias: "processo"
    },
    "Nº Convencional":{
        type: String,
        alias: "nConvencional"
    },
    "Relator":{
        type: String,
        alias: "relator"
    },
    "Descritores":{
        type: [String],
        alias: "descritores"
    },
    "Data do Acordão":{
        type: String,
        alias: "dataAcordao"
    },
    "Votação":{
        type: String,
        alias: "votacao"
    },
    "Privacidade":{
        type: String,
        alias: "privacidade"
    },
    "Meio Processual":{
        type: String,
        alias: "meioProcessual"
    },
    "Decisão":{
        type: String,
        alias: "decisao"
    },
    "Sumário":{
        type: String,
        alias: "sumario"
    },
    "Decisão Texto Integral":{
        type: String,
        alias: "decisaoTextoIntegral"
    },
    "url": String,
    "tribunal": String,
    "Nº do Documento":{
        type: String,
        alias: "nDocumento"
    },
    "Apenso":{
        type: String,
        alias: "apenso"
    },
    "Referência de Publicação":{
        type: String,
        alias: "referenciaPublicacao1"
    },
    "Indicações Eventuais":{
        type: String,
        alias: "indicacoes"
    },
    "Data da Decisão Sumária":{
        type: String,
        alias: "dataDecisaoSumaria"
    },
    "Nº Único do Processo":{
        type: String,
        alias: "nProcesso"
    },
    "Tribunal Recurso":{
        type: String,
        alias: "tribunalRecorrido"
    },
    "Legislação Comunitária":{
        type: String,
        alias: "legislacaoCOM"
    },
    "Legislação Nacional":{
        type: String,
        alias: "legislacaoNAC"
    },
    "Doutrina":{
        type: String,
        alias: "referenciaDoutrina"
    },
    "Jurisprudência Nacional":{
        type: String,
        alias: "jurisprudenciaNAC"
    },
    "Área Temática":{
        type: String,
        alias: "area1"
    },
    "Referências Internacionais":{
        type: String,
        alias: "referenciasINT"
    },
    "Jurisprudência Internacional":{
        type: String,
        alias: "jurisprudenciaINT"
    },
    "Legislação Estrangeira":{
        type: String,
        alias: "legislacaoESTR"
    },
    "Data da Decisão Singular":{
        type: String,
        alias: "dataDecisao"
    },
    "Data da Reclamação":{
        type: String,
        alias: "dataReclamacao"
    },
    "Jurisprudência Estrangeira":{
        type: String,
        alias: "jurisprudenciaESTR"
    },
    "Referência Processo":{
        type: String,
        alias: "referenciaProcesso"
    },
    "Processo no Tribunal Recurso":{
        type: String,
        alias: "processoTribunalRecorrido"
    },
    "Data":{
        type: String,
        alias: "data"
    },
    "Recurso":{
        type: String,
        alias: "recurso"
    }
},{ versionKey : false})

atcoSchema.index({'$**': 'text'});
jtcampcaSchema.index({'$**': 'text'});
jdgpjSchema.index({'$**': 'text'});
jtrpSchema.index({'$**': 'text'});
jtrgSchema.index({'$**': 'text'});
jtcampctSchema.index({'$**': 'text'});
jtreSchema.index({'$**': 'text'});
jconSchema.index({'$**': 'text'});
jtrcSchema.index({'$**': 'text'});
jstaSchema.index({'$**': 'text'});
jtcaSchema.index({'$**': 'text'});
jtrlSchema.index({'$**': 'text'});
jtcnSchema.index({'$**': 'text'});
jstjSchema.index({'$**': 'text'});

module.exports = {  
    atco1: mongoose.model("atco1Model", atcoSchema, "atco1"),
    jtcampca: mongoose.model("jtcampcaModel", jtcampcaSchema, "jtcampca"),
    jdgpj: mongoose.model("jdgpjModel", jdgpjSchema, "jdgpj"),
    jtrp: mongoose.model("jtrpModel", jtrpSchema, "jtrp"),
    jtrg: mongoose.model("jtrgModel", jtrgSchema, "jtrg"),
    jtcampct: mongoose.model("jtcampctModel", jtcampctSchema, "jtcampct"),
    jtre: mongoose.model("jtreModel", jtreSchema, "jtre"),
    jcon: mongoose.model("jconModel", jconSchema, "jcon"),
    jtrc: mongoose.model("jtrcModel", jtrcSchema, "jtrc"),
    jsta: mongoose.model("jstaModel", jstaSchema, "jsta"),
    jtca: mongoose.model("jtcaModel", jtcaSchema, "jtca"),
    jtrl: mongoose.model("jtrlModel", jtrlSchema, "jtrl"),
    jtcn: mongoose.model("jtcnModel", jtcnSchema, "jtcn"),
    jstj: mongoose.model("jstjModel", jstjSchema, "jstj")
}
