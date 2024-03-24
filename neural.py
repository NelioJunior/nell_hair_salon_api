#!/usr/bin/env python
# -*- coding: utf-8 -*
import model 
import tools 

states = []   

def formalizador_de_linguagem_natural(mensagemOriginal):
   nomeAssistente = tools.removerAcentos(model.dictInfEmpresa["nomeBot"].lower()) 
   mensagemTraduzida = mensagemOriginal
   mensagemTraduzida = mensagemTraduzida.replace(nomeAssistente,"")   
   mensagemTraduzida = tools.tradutorHora (mensagemTraduzida)
   mensagemTraduzida = tools.tradutorExpressao (mensagemTraduzida)       

   return mensagemTraduzida

def nucleo_neural(message_info):
   reply_msg = message_info["message"].lower() 
   clsModel = model.model(message_info["pasta"])
   
   mensagemTraduzida = formalizador_de_linguagem_natural(reply_msg)
   
   respBaseConhecimento = []
   respBaseConhecimento.append(mensagemTraduzida)   
   respBaseConhecimento.append(message_info["detected"])  

   if 'naoRelacionado' in respBaseConhecimento[1]:
      reply_msg  = "responda a mensagem da(o) cliente da maneira mais adequada possivel."   
   else:   
      return_msg = clsModel.execute(states,message_info,respBaseConhecimento,mensagemTraduzida)
      reply_msg  = f'Diga exatamente as mesmas palavras: {return_msg}'  

   return reply_msg