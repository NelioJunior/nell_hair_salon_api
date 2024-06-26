#!/usr/bin/env python
# -*- coding: utf-8 -*
import model 
import tools 

states = []   

def nucleo_neural(message_info):
   clsModel = model.model(message_info["pasta"])
   usarGPT = True 
   nomeAssistente = tools.removerAcentos(model.dictInfEmpresa["nomeBot"].lower()) 

   respBaseConhecimento = tools.formalizador_de_linguagem_natural(message_info, nomeAssistente)
  
   if 'semrelacao' in respBaseConhecimento[1] or 'gratidao' in respBaseConhecimento[1]:
      reply_msg  = "responda de maneira mais adequada possivel."   
   else:   
      return_msg = clsModel.execute(states,message_info,respBaseConhecimento)
      reply_msg  = return_msg  
      usarGPT = False 

   return [reply_msg , usarGPT]