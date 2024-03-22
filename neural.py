#!/usr/bin/env python
# -*- coding: utf-8 -*
import model 
import tools 

states = []   

def processamentoDeLinguagemNatural(mensagemOriginal):
   nomeAssistente = tools.removerAcentos(model.dictInfEmpresa["nomeBot"].lower()) 
   mensagemTraduzida = mensagemOriginal
   mensagemTraduzida = mensagemTraduzida.replace(nomeAssistente,"")   

   mensagemTraduzida = tools.tradutorHora (mensagemTraduzida)
   mensagemTraduzida = tools.tradutorExpressao (mensagemTraduzida)     
   
   respBaseConhecimento = tools.buscarBaseConhecimento(tools.contextualizador(mensagemTraduzida))

   return [mensagemTraduzida , respBaseConhecimento[1]]

def nucleoNeural(message_info):
   reply_msg = message_info["message"].lower() 
   clsModel = model.model(message_info["pasta"])
   
   pnl = processamentoDeLinguagemNatural(reply_msg)
   mensagemTraduzida = pnl[0]
   
   respBaseConhecimento = []
   respBaseConhecimento.append(pnl[0])   
   
   if pnl[1] == 'confirmacao': 
      respBaseConhecimento.append(pnl[1])  
   elif pnl[1] == 'encerrar': 
      respBaseConhecimento.append('naoRelacionado')  
   else:
      respBaseConhecimento.append(message_info["detected"])   

   if 'naoRelacionado' in respBaseConhecimento[1]:
      reply_msg  = "responda a mensagem da(o) cliente da maneira mais adequada possivel."   
   else:   
      return_msg = clsModel.execute(states,message_info,respBaseConhecimento,mensagemTraduzida)
      reply_msg  = f'Diga exatamente com as mesmas palavras ... {return_msg}'  

   return reply_msg