#!/usr/bin/env python
# -*- coding: utf-8 -*
import model 
import tools 

states = []   

def nucleo_neural(message_info):
   clsModel = model.model(message_info["pasta"])
   respBaseConhecimento = tools.formalizador_de_linguagem_natural(message_info)
  
   if 'semrelacao' in respBaseConhecimento[1]:
      reply_msg  = "responda a mensagem da(o) cliente da maneira mais adequada possivel."   
   else:   
      return_msg = clsModel.execute(states,message_info,respBaseConhecimento,respBaseConhecimento[0])
      reply_msg  = f'ignore a mensagem do cliente e diga o texto a seguir com suas palavras sem perder o sentido original: {return_msg}'  

   return reply_msg