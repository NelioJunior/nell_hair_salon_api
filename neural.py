#!/usr/bin/env python
# -*- coding: utf-8 -*
import model 
import tools 

states = []   

def processamentoDeLinguagemNatural(mensagemOriginal):
   nomeAssistente = tools.removerAcentos(model.dictInfEmpresa["nomeBot"].lower()) 
   ultimaMensagem = mensagemOriginal
   ultimaMensagem = ultimaMensagem.replace(nomeAssistente,"")   

   mensagemTraduzida = tools.contextualizador(ultimaMensagem)          
   mensagemTraduzida = tools.tradutorHora (mensagemTraduzida)
   mensagemTraduzida = tools.tradutorExpressao (mensagemTraduzida)     
   
   respBaseConhecimento = tools.buscarBaseConhecimento(mensagemTraduzida)

   return [mensagemTraduzida , respBaseConhecimento[1]]

def nucleoNeural(message_info):
   reply_msg = message_info["message"].lower() 
   contato = message_info["user"]  
   clsModel = model.model(message_info["pasta"])
   pnl = processamentoDeLinguagemNatural(reply_msg)
   mensagemTraduzida = pnl[0]
   respBaseConhecimento = []
   
   respBaseConhecimento.append(pnl[0])   
   if pnl[1] == 'confirmacao': 
      respBaseConhecimento.append(pnl[1])   
   else:
      respBaseConhecimento.append(message_info["detected"])   

   return_msg = clsModel.execute(states,message_info,respBaseConhecimento,mensagemTraduzida)

   if not return_msg or 'naoRelacionado' in respBaseConhecimento[1]:
      reply_msg  = "responda a mensagem da(o) cliente da maneira mais adequada possivel."   
   elif 'json:' in return_msg:  
      reply_msg  = 'Verifique na lista (json) se temos o que a/o cliente quer ... %s' % return_msg
   else:   
      reply_msg  = f'Diga exatamente as mesmas palavras ... {return_msg}'  

   return reply_msg