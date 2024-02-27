#!/usr/bin/env python
# -*- coding: utf-8 -*
import model 
import tools 

states = []   

def processamentoDeLinguagemNatural(mensagemOriginal, contato):
    nomeAssistente = tools.removerAcentos(model.dictInfEmpresa["nomeBot"].lower()) 
    ultimaMensagem = mensagemOriginal
    ultimaMensagem = ultimaMensagem.replace("?"," ?")   

    mensagemTraduzida = tools.tradutorPalavra(ultimaMensagem)          
    mensagemTraduzida = tools.tradutorHora (mensagemTraduzida)     
    mensagemTraduzida = tools.tradutorExpressao (mensagemTraduzida)     
    
    respBaseConhecimento = tools.buscarBaseConhecimento(mensagemTraduzida,mensagemOriginal,contato,nomeAssistente)
    return [mensagemTraduzida , respBaseConhecimento[1]]

def nucleoNeural(message_info):
    reply_msg = message_info["message"].lower() 
    contato = message_info["user"]  
    clsModel = model.model(message_info["pasta"])
    pnl = processamentoDeLinguagemNatural(reply_msg, contato)
    mensagemTraduzida = pnl[0]
    respBaseConhecimento = []
    respBaseConhecimento.append(pnl[0])   
    respBaseConhecimento.append(pnl[1])   

    msg_model = clsModel.execute(states,message_info,respBaseConhecimento,mensagemTraduzida)

    reply_msg  += " (Orientação da gerencia: Pergunte ou questione a usuária sobre: '[%s]')" % msg_model

    return reply_msg