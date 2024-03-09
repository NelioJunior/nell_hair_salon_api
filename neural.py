#!/usr/bin/env python
# -*- coding: utf-8 -*
import model 
import tools 

states = []   

def processamentoDeLinguagemNatural(mensagemOriginal, contato):
    nomeAssistente = tools.removerAcentos(model.dictInfEmpresa["nomeBot"].lower()) 
    ultimaMensagem = mensagemOriginal
    ultimaMensagem = ultimaMensagem.replace(nomeAssistente,"")   
    ultimaMensagem = ultimaMensagem.replace("?"," ?")   

    mensagemTraduzida = tools.contextualizador(ultimaMensagem)          
    mensagemTraduzida = tools.tradutorHora (mensagemTraduzida)     
    mensagemTraduzida = tools.tradutorExpressao (mensagemTraduzida)     
    
    respBaseConhecimento = tools.buscarBaseConhecimento(mensagemTraduzida)

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
 
    return_msg  = ("responda a mensagem do cliente cujo 'numero de ordem' é a maior,"
                   "ou seja a ultima mensagem recebida"
                   "na forma mais adequada.Utilize no máximo 100 caracteres")

    if respBaseConhecimento[1] != "": 
        return_msg = clsModel.execute(states,message_info,respBaseConhecimento,mensagemTraduzida)

    reply_msg  = '{"retorno": "%s"}' % return_msg

    return reply_msg