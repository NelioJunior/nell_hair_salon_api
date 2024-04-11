#!/usr/bin/env python
# -*- coding: utf-8 -*

import json 
import urllib
import random
import tools 
import re
import requests
from datetime import timedelta
from datetime import date
from datetime import datetime

def find_contact(string):
    result = ""
    for reg_item in dictCliente: 
        palavras = tools.removerAcentos(string).split() 
        
        for palavra in palavras:
            item = palavra.strip(",.!?:;")
            if reg_item["contato"].lower() == item.lower():
               result = reg_item["contato"] 
               break

    return result           
                       
def agrupar_horarios(horarios):
    horarios = sorted(set(map(lambda x: x.strip(), horarios.split(','))))
    resultado = []
    inicio_intervalo = None
    fim_intervalo = None

    for horario in horarios:
        horario_atual = datetime.strptime(horario, '%H:%M')

        if inicio_intervalo is None:
            inicio_intervalo = horario_atual
            fim_intervalo = horario_atual
        elif horario_atual - fim_intervalo <= timedelta(minutes=30):
            fim_intervalo = horario_atual
        else:
            resultado.append((inicio_intervalo, fim_intervalo))
            inicio_intervalo = horario_atual
            fim_intervalo = horario_atual

    if inicio_intervalo is not None:
        resultado.append((inicio_intervalo, fim_intervalo))

    resultado_formatado = ', '.join([f'{inicio.strftime("%H:%M")} até {fim.strftime("%H:%M")}' for inicio, fim in resultado])
    
    return resultado_formatado

def loadDicionariosDinamicos(pasta):
    global dictInfEmpresa
    global dictCliente 
    global dictFuncionario 
    global dictEspecialidade
    global dictEspecialidadeGeral 
    global dictFeriado 
    global dictCompromissosDosFuncionarios 

    servico = "%s%s" %(pasta,"model/jsonFiles/configuracao.json")
    dictInfEmpresa = json.loads(urllib.request.urlopen(servico).read())

    servico = "%s%s" %(pasta,"model/buscarcliente.php?apenasAtivos=1")
    dictCliente = json.load(urllib.request.urlopen(servico))

    servico = "%s%s" %(pasta,"model/buscarespecialidadedoprofissional.php?id=0")
    dictEspecialidade = json.load(urllib.request.urlopen(servico))
    # dictEspecialidade = sorted(dictEspecialidade, key=lambda x: len(x['nome'].split()))

    servico = "%s%s" %(pasta,"model/buscarespecialidade.php?apenasAtivos=1")
    dictEspecialidadeGeral = json.load(urllib.request.urlopen(servico))

    servico = "%s%s" %(pasta,"model/buscarferiado.php?apenasAtivos=1")
    dictFeriado = json.load(urllib.request.urlopen(servico))

    servico = "%s%s" %(pasta,"model/buscarcompromissosfuncionarios.php")
    dictCompromissosDosFuncionarios = json.load(urllib.request.urlopen(servico))

    servico = "%s%s" %(pasta,"model/buscarfuncionarioChatBot.php")
    req = urllib.request.Request(servico)     

    with urllib.request.urlopen(req) as response:        
        retorno = json.loads(response.read())

        for item in retorno:
            item["dias"] = json.loads(item["dias"])  
        
    dictFuncionario = retorno

def excluirReserva(idagenda, pasta):
    retorno = False 
    url = pasta+"model/excluiragenda.php"

    headers = {"Content-Type": "application/json"}
    response = requests.post(url, data=idagenda, headers=headers)

    if response.status_code == 200:
        retorno = True 

    return retorno

def buscaReserva(id, pasta):
    servico = "%s%s%s" % (pasta,"model/buscaragendachatbot.php?id=",id)
    colecao = json.load(urllib.request.urlopen(servico))
    return colecao 

def salvarReserva(reserva, idcliente, pasta):

    headers = {"charset" : "utf-8", "Content-Type": "application/json"}

    for idx in range(len(reserva)):
        idprofissional = reserva[idx]["id_funcionario"] 
        data = reserva[idx]["data"]
        inicio = reserva[idx]["inicio"]

        if idprofissional == "" or idcliente == "" or data == "" or inicio == "":
            return 0 

        fim =  "%0.2d:%s" % (int(inicio[0:2]) + 1,inicio[3:5])

        if data == "":
            data = "%0.4d-%0.2d-%0.2d" % (date.today().year, date.today().month, date.today().day)

        dataHoraInicio = "%s %s" % (data, inicio) 
        dataHoraFim = "%s %s" % (data, fim) 
        totalPreco = 0 

        for item in reserva[idx]["especialidades"]:  
            totalPreco += float(item["preco"]) 

        idOperacao = 0 
        
        parametros = {
                    "id_agenda" : idOperacao,
                    "id_agenda_original" : idOperacao,  
                    "id_funcionario" : idprofissional,
                    "id_cliente" : idcliente,
                    "dataHoraInicio" : dataHoraInicio,
                    "dataHoraFim" : dataHoraFim,
                    "sessaoNumero": idx,
                    "totalSessoes":"1",        
                    "totalPreco" : totalPreco,
                    "parcelarPrecoPorSessao":1,
                    "ativo" : "1",
                    "itensSelecionados": reserva[idx]["especialidades"] 
                }
   
        url = pasta+"model/salvaragenda.php"

        dados_json = json.dumps(parametros)
        headers = {"Content-Type": "application/json"}
        response = requests.post(url, data=dados_json, headers=headers)

        if response.status_code == 200:
            idOperacao = remove_non_numeric(response.text)

    return idOperacao

def remove_non_numeric(text):
    pattern = r'\D+' 
    return re.sub(pattern, '', text)

def clearOldInteractions(states):
    dataHoraLimite = datetime.now() + timedelta(minutes = -30) 
    i = 0 
    while i < len(states):
        horaUltimaInteracao = datetime.strptime(states[i]["horaUltimaInteracao"], '%Y-%m-%d %H:%M')  
        if horaUltimaInteracao < dataHoraLimite:
            del states[i] 
        else:
            i += 1   
    return 

def findStatePosition(states,contato):
    for idx, item in enumerate(states):
        if item["contato"] == "":
            item["contato"] = contato      

        if item["contato"] == contato:
            item["horaUltimaInteracao"] == "%0.4d-%0.2d-%0.2d %0.2d:%0.2d" % (datetime.now().year,datetime.now().month,datetime.now().day,datetime.now().hour,datetime.now().minute)
            return idx

    states.append({
        "id_cliente" : "",     
        "contato" : contato,
        "contatoGenero": "",
        "horaUltimaInteracao" : "%0.4d-%0.2d-%0.2d %0.2d:%0.2d" % (datetime.now().year,datetime.now().month,datetime.now().day,datetime.now().hour,datetime.now().minute),  
        "informacaoAoUsuario" : "" , 
        "ultimaMensagemAssistente" : "",  
        "flagUsuarioDemonstrouPreferenciaAoProfissional" : False,   
        "flagEscolherProfissional" : False,  
        "flagAdicionarServicos" : False,  
        "flagUsuarioDesejaFazerCRUD" : False,  
        "flagConfirmarAgendamento" : False,
        "flagCancelarAgendamento" : False,
        "flagAlterarAgendamento" : False,
        "flagPrimeiraInteracao" : True,
        "stateIdAgenda": "",
        "reservas" : [{ 
                        "id_funcionario":"",
                        "funcionario" : "",  
                        "data": "", 
                        "inicio": "", 
                        "especialidades" :  [{
                                               "id_especialidade":"" , 
                                               "especialidade" : "" , 
                                               "preco": 0,
                                               "sessoes":1, 
                                               "tempoNecessarioPorSessao":30 
                                            }]
                     }]
    })    

    return len(states) -1

def buscarFuncionario(msg): 
    retorno = ["","",""]  
    msg = msg.replace("?", "").replace("!","")
    
    for Funcionario in dictFuncionario:
        if tools.buscarPalavra(Funcionario["nome"], msg.lower()) > 0 or (Funcionario["apelido"] != "" and tools.buscarPalavra(Funcionario["nome"], msg.lower()) > 0):
            retorno[0] = Funcionario["id_funcionario"]
            retorno[1] = Funcionario["nome"]
            retorno[2] = Funcionario["genero"]
            break             
        else:
            for item in msg.split(): 
                if tools.buscarPalavra(item.lower(), Funcionario["nome"].lower()) > 0:
                    retorno[0] = Funcionario["id_funcionario"]
                    retorno[1] = Funcionario["nome"]
                    retorno[2] = Funcionario["genero"]
                    break 
        if retorno[0] == "" and Funcionario["apelido"] != "":
            if tools.buscarPalavra(Funcionario["apelido"], msg.lower()) > 0:
                retorno[0] = Funcionario["id_funcionario"]
                retorno[1] = Funcionario["nome"]
                retorno[2] = Funcionario["genero"]
                break             
            else:
                for item in msg.split(): 
                    if tools.buscarPalavra(item.lower(), Funcionario["apelido"].lower()) > 0:
                        retorno[0] = Funcionario["id_funcionario"]
                        retorno[1] = Funcionario["nome"]
                        retorno[2] = Funcionario["genero"]
                        break 

    return retorno     

def verificaSeHaEspecialidadeNaMensagem(msg):
    flag = False 
    retorno = list(filter(lambda item: tools.removerAcentos(item["nome"].lower()) in msg.lower(),dictEspecialidadeGeral))
    if retorno != "":
        flag = True 
    return flag 

def buscarEspecialidadeIndisponivel(msg, genero):
    resposta = ""

    retorno = list(filter(lambda item: tools.removerAcentos(item["nome"].lower()) in msg.lower() and item["ativo"] == "0",dictEspecialidadeGeral))
    if retorno != []:  
        resposta = buscarListaEspecialidades("")   
        resposta += " Lamento,mas a atividade %s esta fora de nosso catálogo," % retorno[0]['nome']
        resposta += "mas talvez você se interesse por uma destas atividades que eu listei acima. "
        resposta += "Caso você queira encerrar nossa conversa é so se despedir." 

    return resposta

def buscarEspecialidade(detected, genero, inexistente=[]):

    retorno_final=[]  
    servicos = detected["servicos"]

    for servico in servicos:
        if type(servico) != str:
            break 

        servico_traduzido = tools.tradutorPalavra(servico)
        retorno = []
        avaliacao = 0 
        flag_inexistente = True  

        for especialidade in dictEspecialidade:
            lstPalavrasChaves = tools.tradutorPalavra(especialidade["palavrasChaves"])
            lstPalavrasChaves = tools.eliminar_duplicatas(lstPalavrasChaves)
            lstPalavrasChaves = lstPalavrasChaves.split()

            if "feminina" in lstPalavrasChaves and "masculina" in lstPalavrasChaves:
                lstPalavrasChaves = lstPalavrasChaves.replace("feminina", "")
                lstPalavrasChaves = lstPalavrasChaves.replace("masculina", "")
                
            num = 0
            for palavra in lstPalavrasChaves:    

                if tools.buscarPalavra(palavra,servico_traduzido) > 0:
                    flag_inexistente = False  
                    num += 1

                    if "infantil" in especialidade["nome"].lower():
                        if "infantil" not in servico_traduzido.lower():  
                            num -= 1                    
                    if genero == "m":
                        if "feminino" in especialidade["nome"].lower():
                            num -= 1
                    elif genero == "f":  
                        if "masculino" in especialidade["nome"].lower():
                            num -= 1

                if num > avaliacao:                    
                    avaliacao = num  
                    retorno = especialidade

        if flag_inexistente == True:
            inexistente.append(servico)

        if len(retorno): 
            retorno_final.append(retorno)

    return retorno_final       

def buscarEspecialidadePorFuncionario(msg): 
    retorno = ""
    for funcionario in dictFuncionario:
        if funcionario["especialidade"].lower() in msg:
            retorno = funcionario["especialidade"]
            break 
    return retorno       

def buscarListaFuncionarios(msg, states):
    if states["reservas"][0]["funcionario"] != "":
        funcionarioMencionado = buscarFuncionario(states["reservas"][0]["funcionario"])
    else:
        funcionarioMencionado = buscarFuncionario(msg)

    msgResp = ""
    nome = "" 

    for funcionario in dictFuncionario:
        if nome != funcionario["nome"]:
            nome = funcionario["nome"]

            dias = str(funcionario["dias"]).replace("[","").replace("]","").replace("'","")  
            entrada = ""
            saida = ""
            if funcionario["entradaManha"] is not None and funcionario["entradaManha"] != "":
                entrada = funcionario["entradaManha"]
            elif  funcionario["entradaTarde"] is not None and funcionario["entradaTarde"] != "":
                entrada = funcionario["entradaTarde"]
            else: 
                entrada = funcionario["entradaNoite"]

            if funcionario["entradaNoite"] is not None and funcionario["entradaNoite"] != "":
                saida = funcionario["saidaNoite"]
            elif funcionario["entradaTarde"] is not None and funcionario["entradaTarde"] != "":
                saida = funcionario["saidaTarde"]
            else:
                saida = funcionario["saidaNoite"]   

            if funcionarioMencionado[0] != "":  
                if funcionarioMencionado[1] == funcionario["nome"]:       
                    msgResp += "%s - %s, presente nos dias de %s das %s ás %s." % (funcionario["nome"],funcionario["cargo"],dias, entrada, saida)
                    break 
            else:    
                msgResp += "%s - %s, presente nos dias de %s das %s ás %s ." % (funcionario["nome"],funcionario["cargo"],dias, entrada, saida)   

    if funcionarioMencionado[0] != "": 
        tratamento = "ela" if funcionario["genero"] == "f" else "ele"
        msgResp += " Caso você queira agendar com %s, é uma boa ideia você me dizer o horário,dia e o serviço que %s deve fazer." % (funcionarioMencionado[1], tratamento) 
        states["reservas"][0]["id_funcionario"] = funcionarioMencionado[0] 
        states["reservas"][0]["funcionario"] = funcionarioMencionado[1] 

    else:  
        msgResp += " Você gostaria de agendar um horário com um de nossos especialistas ? "         

    return msgResp    

def buscarListaEspecialidades(msg): 
    msgResp = ""
    
    if buscarEspecialidadePorFuncionario(msg) == "":
        for especialidade in dictEspecialidade: 
            msgResp += f"• {especialidade['nome']} - R$ {especialidade['preco']},00 \n" 

    return msgResp

def buscarFuncionarioPorEspecialidades(lstEspecialidades):

    retorno = []

    if isinstance(lstEspecialidades, dict): 
        lstEspecialidades = [lstEspecialidades]

    numeroEspecialidade = len(lstEspecialidades) 

    if numeroEspecialidade > 0: 
        lstFunc = []        
        id_func_anterior = '0'
        cont = 0  

        for funcionario in dictFuncionario:
            if id_func_anterior != funcionario["id_funcionario"]:
                id_func_anterior = funcionario["id_funcionario"]  
                cont = 0 

            for item in lstEspecialidades:
                if item['id_especialidade'] == funcionario['id_especialidade']:
                    cont += 1  
                    
            if cont == numeroEspecialidade:
                lstFunc.append(funcionario)
                cont = 0

        ocorrencias = 0
        idsAptos = []
        idAntes = ""

        for item in lstFunc:
            if item["id_funcionario"] != idAntes:
                idAntes = item["id_funcionario"] 
                occurs = len(list(filter(lambda i: i["id_funcionario"] == item["id_funcionario"] , lstFunc))) 
                if occurs == numeroEspecialidade:
                    if ocorrencias < occurs:
                        ocorrencias = occurs
                        idsAptos = []                                  
                    
                    idsAptos += item["id_funcionario"]
                elif occurs >= ocorrencias:  
                    ocorrencias = occurs
                    idsAptos += item["id_funcionario"]

        lstFuncionariosAptos = []

        for id in idsAptos:    
            lstFuncionariosAptos.append(list(filter(lambda i: i["id_funcionario"] == id , lstFunc))[0])    

        if len(lstFuncionariosAptos) > 0 : 
            for funcionario in lstFuncionariosAptos:   
                diasSemana = ""
                for dia in funcionario["dias"]:
                    diasSemana += "%s," % dia     
                
                diasSemana = diasSemana[:len(diasSemana)-1]
            
                retorno += [{"id_funcionario" : funcionario["id_funcionario"] ,
                            "nome" : funcionario["nome"], 
                            "genero" : funcionario["genero"] , 
                            "entradaManha" :  funcionario["entradaManha"] , 
                            "saidaManha" :  funcionario["saidaManha"] , 
                            "entradaTarde" :  funcionario["entradaTarde"] , 
                            "saidaTarde" :  funcionario["saidaTarde"] , 
                            "entradaNoite" :  funcionario["entradaNoite"] , 
                            "saidaNoite" :  funcionario["saidaNoite"] , 
                            "diasSemana" : diasSemana }]

    return sorted(retorno, key=lambda k: k["nome"])         

def separarEspecialidadesPorFuncionarios(states, lstFuncionariosAptos, lstEspecialiadades):  

    data = states["reservas"][0]["data"]
    inicio = states["reservas"][0]["inicio"]        
    statesReservas = [] 
    flagApenasUmProfissionalAptoParaCadaServico = True  
    idFuncionario = ""

    for itemEsp in lstEspecialiadades:
        idx = 0 
        for itemFunc in lstFuncionariosAptos:                
            profissionalApto = True if len(list(filter(lambda item: item["id_especialidade"] == itemEsp["id_especialidade"] and item["id_funcionario"] == itemFunc["id_funcionario"], dictFuncionario))) > 0 else False  

            if profissionalApto:
                if idx > 0:
                    flagApenasUmProfissionalAptoParaCadaServico = False   

                idx += 1   

                flagApenasUmProfissionalAptoParaCadaServico = True if len(lstEspecialiadades) > 1  else False 

                if len(statesReservas) == 0 or len(list(filter(lambda item: item["id_especialidade"] == itemEsp["id_especialidade"], statesReservas[0]["especialidades"]))) == 0:  

                    if idFuncionario != itemFunc["id_funcionario"]: 
                            idFuncionario = itemFunc["id_funcionario"]
                            statesReservas.append({
                                                    "id_funcionario": itemFunc["id_funcionario"] , 
                                                    "funcionario": itemFunc["nome"], 
                                                    "data": data, 
                                                    "inicio": inicio,
                                                    "especialidades": [{"id_especialidade": itemEsp["id_especialidade"] , 
                                                                        "especialidade": itemEsp["especialidade"], 
                                                                        "preco": itemEsp["preco"],
                                                                        "sessoes": itemEsp["sessoes"],
                                                                        "tempoNecessarioPorSessao": itemEsp["tempoNecessarioPorSessao"]}]
                                                    })
                    else:  
                        statesReservas[0]["especialidades"].append({"id_especialidade": itemEsp["id_especialidade"] , 
                                                                "especialidade": itemEsp["especialidade"], 
                                                                "preco": itemEsp["preco"],
                                                                "sessoes": itemEsp["sessoes"],
                                                                "tempoNecessarioPorSessao": itemEsp["tempoNecessarioPorSessao"]})
            else:
                idx = 0                             

    if flagApenasUmProfissionalAptoParaCadaServico: 
        lstAux = lstFuncionariosAptos.copy()
        for itemFunc in lstAux:
            flagRemover = True 
            if len(list(filter(lambda item: item["id_funcionario"] == itemFunc["id_funcionario"], statesReservas))) > 0:
               flagRemover = False 

            if flagRemover:
                lstFuncionariosAptos.remove(itemFunc)      

        states["reservas"] = statesReservas

    for especialidade in lstEspecialiadades:
        flag = False  
        for reserva in states["reservas"]: 
            for item in reserva["especialidades"]:
                if especialidade["id_especialidade"] == item["id_especialidade"]:
                    flag = True  
        if flag == False: 
            states["informacaoAoUsuario"] += especialidade["especialidade"]+","

    if states["reservas"][0]["data"] != "" and states["reservas"][0]["inicio"] != "":  
        if states["reservas"][0]["id_funcionario"] != "" and states["reservas"][0]["especialidades"][0]["id_especialidade"] != "":
            if states["informacaoAoUsuario"] != "":
                states["informacaoAoUsuario"] = states["informacaoAoUsuario"][0:len(states["informacaoAoUsuario"])-1]     
                states["informacaoAoUsuario"] = "Lamento,mas não foi possivel fazer reserva para %s porque não existe profissionais livres no horário e dia escolhido." % states["informacaoAoUsuario"]

    return lstFuncionariosAptos

def listarDisponibilidadeFuncionario(funcionario,diaReserva):
    horariosLivres = ""
    entradaManha = None
    entradaTarde = None
    entradaNoite = None
    saidaManha = None
    saidaTarde = None
    saidaNoite = None

    if funcionario["entradaManha"] != None and funcionario["entradaManha"]  != "" :
        entradaManha = funcionario["entradaManha"]
        entradaManha = "%0.2d:00" % (int(entradaManha[0:2])+1) if entradaManha[3:] != "00" and entradaManha[3:] > "30" else entradaManha
        entradaManha = "%0.2d:30" % (int(entradaManha[0:2])) if entradaManha[3:] != "00" and entradaManha[3:] < "30" else entradaManha
    if  funcionario["entradaTarde"] != None and funcionario["entradaTarde"]  != "" :   
        entradaTarde = funcionario["entradaTarde"]
        entradaTarde = "%0.2d:00" % (int(entradaTarde[0:2])+1) if entradaTarde[3:] != "00" and entradaTarde[3:] > "30" else entradaTarde
        entradaTarde = "%0.2d:30" % (int(entradaTarde[0:2])) if entradaTarde[3:] != "00" and entradaTarde[3:] < "30" else entradaTarde
    if  funcionario["entradaNoite"] != None and funcionario["entradaNoite"]  != "" :   
        entradaNoite = funcionario["entradaNoite"]
        entradaNoite = "%0.2d:00" % (int(entradaNoite[0:2])+1) if entradaNoite[3:] != "00" and entradaNoite[3:] > "30" else entradaNoite
        entradaNoite = "%0.2d:30" % (int(entradaNoite[0:2])) if entradaNoite[3:] != "00" and entradaNoite[3:] < "30" else entradaNoite

    if funcionario["saidaManha"] != None and funcionario["saidaManha"]  != "" :
        saidaManha = funcionario["saidaManha"]
        saidaManha = "%0.2d:00" % (int(saidaManha[0:2])) if saidaManha[3:] != "00" and saidaManha[3:] < "30" else saidaManha
        saidaManha = "%0.2d:30" % (int(saidaManha[0:2])) if saidaManha[3:] != "00" and saidaManha[3:] > "30" else saidaManha
    if  funcionario["saidaTarde"] != None and funcionario["saidaTarde"]  != "" :   
        saidaTarde = funcionario["saidaTarde"]
        saidaTarde = "%0.2d:00" % (int(saidaTarde[0:2])) if saidaTarde[3:] != "00" and saidaTarde[3:] < "30" else saidaTarde
        saidaTarde = "%0.2d:30" % (int(saidaTarde[0:2])) if saidaTarde[3:] != "00" and saidaTarde[3:] > "30" else saidaTarde
    if  funcionario["saidaNoite"] != None and funcionario["saidaNoite"]  != "" :   
        saidaNoite = funcionario["saidaNoite"]
        saidaNoite = "%0.2d:00" % (int(saidaNoite[0:2])) if saidaNoite[3:] != "00" and saidaNoite[3:] < "30" else saidaNoite
        saidaNoite = "%0.2d:30" % (int(saidaNoite[0:2])) if saidaNoite[3:] != "00" and saidaNoite[3:] > "30" else saidaNoite

    entradasSaidas = [{"entrada": entradaManha , "saida" : saidaManha},
                      {"entrada": entradaTarde , "saida" : saidaTarde},
                      {"entrada": entradaNoite , "saida" : saidaNoite}]

    for expediente  in entradasSaidas: 
        dispo = expediente["entrada"] 
        saida = expediente["saida"] 
        if dispo is not None:
            while dispo < saida:
                hrmin = "%s:00" % dispo   
                dthrmin = "%s %s" % (diaReserva,hrmin) 
                livre = False if len(list(filter(lambda i: funcionario["id_funcionario"] == i["id_funcionario"] and dthrmin >= i["dataHoraInicio"] and dthrmin < i["dataHoraFim"],dictCompromissosDosFuncionarios))) > 0 else True 
                if livre:    
                    horariosLivres += dispo + ", " 

                dispo = "%0.2d:30" % (int(dispo[0:2])) if dispo[3:] == "00" else "%0.2d:00" % (int(dispo[0:2])+1) 

    return horariosLivres[:len(horariosLivres)-2] 


def listarFuncionariosDisponiveis(states,respBaseConhecimento,msgRetorno):
    horariosLivres = ""

    if states["reservas"][0]["data"] != "" and states["reservas"][0]["especialidades"][0]["id_especialidade"] != "":
        flagNenhumConflitoDiaSemanaHoraInicio = False
        lstFuncionariosAptos = buscarFuncionarioPorEspecialidades(states["reservas"][0]["especialidades"]) 
        diaSemana = tools.buscarDiaSemana(datetime.strptime(states["reservas"][0]["data"], "%Y-%m-%d").weekday())
        diaSem = diaSemana[0:3] 
        horariosLivres = ""
        i = 0 
        while i < len(lstFuncionariosAptos):
            lstDiasSemana = lstFuncionariosAptos[i]['diasSemana'].split(",")
            flagNenhumConflitoDiaSemanaHoraInicio = False 
            for dia in lstDiasSemana :
                if dia == diaSem: 
                    flagNenhumConflitoDiaSemanaHoraInicio = True 
                    break 

            if flagNenhumConflitoDiaSemanaHoraInicio:              
                if states["reservas"][0]["data"] != "": 
                    diaReserva = states["reservas"][0]["data"]
                    horariosLivres = listarDisponibilidadeFuncionario(lstFuncionariosAptos[i],diaReserva)
                    if horariosLivres == "":
                        flagNenhumConflitoDiaSemanaHoraInicio = False 

            if flagNenhumConflitoDiaSemanaHoraInicio:              
                if states["reservas"][0]["inicio"] != "":
                    inicio = states["reservas"][0]["inicio"]
                    if tools.buscarPalavra(inicio, horariosLivres) == 0: 
                        flagNenhumConflitoDiaSemanaHoraInicio = False 

            if flagNenhumConflitoDiaSemanaHoraInicio:              
                i += 1       
            else:
                del lstFuncionariosAptos[i] 

        if len(lstFuncionariosAptos) == 0:  
            if horariosLivres == "": 
                if len(states["reservas"][0]["especialidades"]) > 1:
                    msgRetorno = "Infelizmente %s não há profissionais para os serviços quê você quer." % diaSemana
                    msgRetorno += "Pode ser uma boa ideia voce separar estes serviços em outros dias.\n"
                    msgRetorno += "Para que isso nao seja confuso, vamos aos poucos."
                    msgRetorno += "Entre com um serviço por vez.Ok?"
                    msgRetorno += "Ao confirmar o agendadamento de um dia,você começa outro.Vamos lá!"
                else:
                    msgRetorno = "Desculpe, mas %s não há um especialista disponivel pra o quê você quer. Por favor, escolha um outro dia da semana." % diaSemana

                limparStateContatoAtivo(states, False)
            else:
                msgRetorno = "Na %s neste horário posso agendar pra você em um destes horários: %s"  % (diaSemana, horariosLivres)   
                states["reservas"][0]["inicio"] = "" 

        elif len(lstFuncionariosAptos) == 1: 
            states["reservas"][0]["funcionario"] = lstFuncionariosAptos[0]["nome"]
            states["reservas"][0]["id_funcionario"] = lstFuncionariosAptos[0]["id_funcionario"]
            lstFuncionariosAptos = separarEspecialidadesPorFuncionarios(states, lstFuncionariosAptos, states["reservas"][0]["especialidades"]) 

        elif len(lstFuncionariosAptos) > 1 and states["reservas"][0]["id_funcionario"] == "":

            if states["flagEscolherProfissional"]:
                states["flagEscolherProfissional"] = False 
                msgRetorno = ""
                
                if respBaseConhecimento[1] != "concordancia" and states["reservas"][0]["id_funcionario"] == "": 
                    rdn = int(random.random() * len(lstFuncionariosAptos))
                    states["reservas"][0]["funcionario"] = lstFuncionariosAptos[rdn]["nome"]
                    states["reservas"][0]["id_funcionario"] = lstFuncionariosAptos[rdn]["id_funcionario"]  
                    lstFuncionariosAptos = [] 
            else:

                lstFuncionariosAptos = separarEspecialidadesPorFuncionarios(states, lstFuncionariosAptos, states["reservas"][0]["especialidades"]) 

                if len(states["reservas"]) < len(lstFuncionariosAptos): 
                    diaReserva = states["reservas"][0]["data"]
                    ano, mes, dia = diaReserva.split('-')
                    data_dia_mes_ano = f"{dia}/{mes}/{ano}"

                    for item in lstFuncionariosAptos: 
                        horariosLivres = agrupar_horarios(listarDisponibilidadeFuncionario(item,diaReserva))
                        msgRetorno += "  %s disponivel nos seguintes horários: %s " %  (item["nome"], horariosLivres) 

                    msgRetorno = (f"Para esta atividade,neste dia {data_dia_mes_ano}, temos estes profissionais: {msgRetorno}. "  
                                  f"Você tem alguma preferência por algum profissional?")
                    states["flagEscolherProfissional"] = True  

    return msgRetorno                

def trueSeDataHoraJaPassou (diaReserva, horario):
    hj = date.today() 
    hora = datetime.now()

    agora = "%0.4d-%0.2d-%0.2d %0.2d:%0.2d" % (hj.year, hj.month, hj.day, hora.hour, hora.minute) 
    diaHrSel = "%s %s" % (diaReserva, horario)  

    if diaHrSel <= agora: 
        return True 

    return False  

def validarFuncionarioVsEspecialidade(stt):
    retorno = ""
    if stt["reservas"][0]["id_funcionario"] != "":
        lst1 = buscarFuncionarioPorEspecialidades(stt["reservas"][0]['especialidades'][0])
        lst2 = list(filter(lambda item: item['id_funcionario'] == stt["reservas"][0]["id_funcionario"],lst1))

        if len(lst2) == 0:            
            retorno = "Desculpe, mas %s não é qualificada para este tarefa, escolha outra profissional, por favor." % stt["reservas"][0]["funcionario"] 
            stt["reservas"][0]["id_funcionario"] = ""
            stt["reservas"][0]["funcionario"] = ""

    return retorno

def verificaItensFaltantes(state, respBaseConhecimento, mensagemTraduzida):
    retorno = ""
    msgResposta = ""

    if state["ultimaMensagemAssistente"][:19] == "Para esta atividade":
        state["flagAdicionarServicos"] = False 

    if respBaseConhecimento[1] == "concordancia":
        if "anotei aqui que você quer fazer" in state["ultimaMensagemAssistente"]:
            if "sim" in mensagemTraduzida:
                retorno = "Você gostaria de incluir mais serviços ao seu agendamento? Se sim, me diga qual?"
                state["flagAdicionarServicos"] = True 
                return retorno
            else:
                state["flagAdicionarServicos"] = False 

        elif "Você gostaria de incluir mais serviços ao seu agendamento" in state["ultimaMensagemAssistente"]:
            if len(state["reservas"][0]['especialidades']) == 1: 
                retorno = "Quais são os outros serviço que você quer?"
                return retorno
    if respBaseConhecimento[1] == "discordancia":  
        state["flagAdicionarServicos"] = False   
    

    if state["flagAdicionarServicos"]:
        especialidaesEscolhidas = ""
        
        for idx,item in enumerate(state["reservas"][0]["especialidades"]): 
            separador = "," if idx < len(state["reservas"][0]["especialidades"])-2 else " e "
            especialidaesEscolhidas = especialidaesEscolhidas + item["especialidade"].lower() + separador

        especialidaesEscolhidas = especialidaesEscolhidas[:len(especialidaesEscolhidas)-3]   

        retorno = ""

    if state["reservas"][0]['especialidades'][0]["id_especialidade"] == "":
        retorno += "quais serviços você quer? "

    if state["reservas"][0]["data"] == "":
        retorno += "qual é a data que você quer marcar?"

    elif state["reservas"][0]["inicio"] == "":
        retorno += "qual hora você quer vir?" 

    elif state["reservas"][0]["id_funcionario"] == "": 
        retorno += "se você tem preferência, qual profissional?" 

    if retorno != "" :
        msgResposta = "Informe %s " % retorno

        if state["reservas"][0]["data"] == "" and state["reservas"][0]["id_funcionario"] == "" and state["reservas"][0]['especialidades'][0]["id_especialidade"] != "":
            msgResposta = "Me diga o dia em que você quer vir ou o profissional se já tem um em mente."

        elif state["reservas"][0]["inicio"] == "" and state["reservas"][0]["data"] == "" and state["reservas"][0]["id_funcionario"] == "" and state["reservas"][0]['especialidades'][0]["id_especialidade"] == "":
            msgResposta = "Entendi.Então me informe detalhes tipo,os serviços que você quer sejam feitos,dia e hora do agendamento"
     
    elif trueSeDataHoraJaPassou (state["reservas"][0]["data"], state["reservas"][0]["inicio"]): 
        msgResposta = "Olha, só tem um pequeno problema,mas nada que seja grave\nO horário que você escolheu já passou...Escolha outro horário e dia, por favor"
        state["reservas"][0]["data"] = ""
        state["reservas"][0]["inicio"] = ""

    else: 
        msgResposta = "" 

    if state["reservas"][0]['especialidades'][0]["id_especialidade"] == "" and state["reservas"][0]["data"] == "" and state["reservas"][0]["id_funcionario"] == "" and state["reservas"][0]["inicio"] == "":
        state["flagUsuarioDesejaFazerCRUD"]  = False   

    if state["reservas"][0]["id_funcionario"] != "":
        if state["reservas"][0]['especialidades'][0]["id_especialidade"] == "" and state["reservas"][0]["data"] == "" and state["reservas"][0]["inicio"] == "":
            state["flagUsuarioDemonstrouPreferenciaAoProfissional"] = True    

    msgResposta = tools.substituir_interrogacoes(msgResposta)
    msgResposta = msgResposta.strip().rstrip(',')

    return msgResposta

def validarHorarioEscolhido(states, horario):
    msg = ""
    tratamento = "querida" if states["contatoGenero"] == "f" else "querido"
    nomeEmpresa = dictInfEmpresa["nomeEmpresa"]
    abreEmpresa = dictInfEmpresa["horario"]["abre"]
    fechaEmpresa = dictInfEmpresa["horario"]["fecha"]
    horario = "%s:00" % horario[0:2]  if horario[3:5] > "00" and horario[3:5] < "30" else horario 
    horario = "%0.2d:00" % (int(horario[0:2]) + 1) if horario[3:5] > "30" else horario  

    if horario != "":    
        if horario < abreEmpresa or horario >= fechaEmpresa:
            msg  = "Me desculpe, %s, mas neste horário não estamos funcionando." % tratamento
            msg += "O horário do %s é das %s às %s Escolha outro horário, por favor." % (nomeEmpresa, abreEmpresa,fechaEmpresa)  
            states["reservas"][0]["inicio"] = ""

        else:

            diaReserva = states["reservas"][0]["data"]
            prefixo = "a"

            if states['reservas'][0]['id_funcionario'] != "":
                flagNenhumConflitoHorario = False         
                horariosLivres = ""
                funcionario = list(filter(lambda f:states['reservas'][0]['id_funcionario'] == f['id_funcionario'],dictFuncionario))

                if diaReserva != "":
                    if  trueSeDataHoraJaPassou (diaReserva, horario): 
                        msg = "Acho que você se enganou, esse horário já passou. Entre com outro horário."
                        if states["reservas"][0]["id_funcionario"] != "" and states["flagUsuarioDemonstrouPreferenciaAoProfissional"]:
                            msg += "Tambem vamos ter que ver que rever a disponibilidade da profissional"

                        states["reservas"][0]["id_funcionario"] = ""
                        states["reservas"][0]["funcionario"] = ""
                        states["reservas"][0]["data"] = ""
                        states["reservas"][0]["inicio"] = ""
                        return msg 

                    horariosLivres = listarDisponibilidadeFuncionario(funcionario[0],diaReserva) 
                    horariosLivres = horariosLivres.replace(" ","") 
                    arrayHorariosLivres = horariosLivres.split(",")  

                    livre = True if len(list(filter(lambda horaLivre: horario == horaLivre,arrayHorariosLivres))) > 0 else False  
                    if livre :
                        flagNenhumConflitoHorario = True 

                else:
                    for funcionario in dictFuncionario:
                        if states['reservas'][0]['id_funcionario'] == funcionario['id_funcionario']:
                            prefixo = "a" if states["contatoGenero"] == "f" else "o"

                            if funcionario['entradaManha'] != None and horario >= funcionario['entradaManha']  and horario < funcionario['saidaManha']:  
                                flagNenhumConflitoHorario = True                                     
                            elif funcionario['entradaTarde'] != None and  horario >= funcionario['entradaTarde']  and horario < funcionario['saidaTarde']:  
                                flagNenhumConflitoHorario = True                                     
                            elif funcionario['entradaNoite'] != None and horario >= funcionario['entradaNoite']  and horario < funcionario['saidaNoite']:  
                                flagNenhumConflitoHorario = True   

                            break 

                if flagNenhumConflitoHorario == False:

                    if states["flagUsuarioDemonstrouPreferenciaAoProfissional"]:
                        msg = "Sinto, mas as %s, neste dia %s %s não esta disponivel." % (states["reservas"][0]["inicio"], prefixo, states["reservas"][0]["funcionario"]) 

                    elif states["reservas"][0]["data"] == "":
                        msg = "{person frow} Hummm,aparentemente nesta hora não tem ninguem livre pra te atender... Me diga que dia quer vir,para me ajudar a achar um horário pra você."
                    else:  
                        msg = "Ops! Neste horário nenhuma especialista no que você quer esta disponivel. "
                       
                    states["reservas"][0]["inicio"] = ""
                
                    if horariosLivres != "":
                        if not trueSeDataHoraJaPassou(states["reservas"][0]["data"],arrayHorariosLivres[len(arrayHorariosLivres)-1]):
                            msg += "Escolha um destes horários: %s" % agrupar_horarios(horariosLivres) 
                            if states["flagUsuarioDemonstrouPreferenciaAoProfissional"]:
                                msg += ".Ou mude de profissional" 

    return msg        

def addEspecialidadesInState(stts, especialidades):                       

    if stts["reservas"][0]["especialidades"][0]["id_especialidade"] == "" and len(especialidades) > 0: 
        stts["reservas"][0]["especialidades"] = []

    for especialidade in especialidades:
        lst = list(filter(lambda item: (item['id_especialidade'] == especialidade["id_especialidade"]), stts["reservas"][0]["especialidades"]))
        if len(lst) == 0:   
            stts["reservas"][0]["especialidades"].append({ 
                "id_especialidade":especialidade["id_especialidade"]  , 
                "especialidade" :  especialidade["nome"] ,                  
                "preco": especialidade["preco"], 
                "sessoes":especialidade["sessoes"], 
                "tempoNecessarioPorSessao":especialidade["tempoNecessarioPorSessao"]  
            }) 

    return 


def buscarEspecialidadeNaoCadastrada(msg):

    retorno = "" 
    expressoesChaves = [
        "serviço",
        "serviços",
        "aplicacao",
        "aplicar",
        "aplicam",
        "trabalham",
        "sessão",
        "sessões",
        "fazem ", 
        "fazer ",
        "mexem ",
        "tratamento",
        "tratam",
        "sobre",
        "reserva",
        "procedimento"
    ] 
    
    msg = msg.replace(" um ", " ").replace(" uma ", " ").replace(" com ", " ").replace(" de "," ").replace(" no ", " ").replace(" na ", " ").replace(" nos ", " ").replace(" nas ", " ").replace(" para ", " ")
    supostaEspecialidade = "" 

    for exp in expressoesChaves: 
        pos = tools.buscarPalavra(exp, msg) -2 
        if pos > 0 and (pos + len(exp) <= len(msg)): 
            supostaEspecialidade = msg[pos:].split()[0] 
            if supostaEspecialidade in str(expressoesChaves):
                supostaEspecialidade = "" 
            elif len(list(filter(lambda i: tools.buscarPalavra(supostaEspecialidade, i['palavrasChaves'] ) > 0,dictEspecialidade))) > 0:
                supostaEspecialidade = "" 

    if supostaEspecialidade != "":        
        retorno = "Eu não sei o que é %s, que tipo de serviço é essa?" % supostaEspecialidade

    return retorno 

def TrueParaInteracaoExpirada(respBaseConhecimento,mensagem,stts,mensagemTraduzida,hrMsgAssistente):

    if respBaseConhecimento[1] == "": 
        flg = False   
        if len(buscarEspecialidade(mensagem,stts["contatoGenero"])) > 0: 
            flg = True 
        elif tools.buscarHora(mensagemTraduzida) != "":
            flg = True 
        elif tools.buscarData(mensagem) != "":
            flg = True 
        else:    
            funcionario = buscarFuncionario(mensagem)
            if funcionario[1] != "": 
                flg = True 

        if flg:      
            if hrMsgAssistente != "":  
                horaLimite = datetime.now() + timedelta(minutes = -30) 
                horaLimite = "%0.2d:%0.2d" % (horaLimite.hour, horaLimite.minute)  
                if hrMsgAssistente < horaLimite:
                    respBaseConhecimento[0] = "O tempo que você levou para fazer o agendameno expirou.Sinto, você ira ter de começar de novo.Qual serviço você quer agendar?"
                    respBaseConhecimento[1] = "cancelarOperacaoEmAndamento" 
                    return True 

    elif respBaseConhecimento[1] == "concordancia": 
        if hrMsgAssistente != "":  
            horaLimite = datetime.now() + timedelta(minutes = -30) 
            horaLimite = "%0.2d:%0.2d" % (horaLimite.hour, horaLimite.minute)  
            if hrMsgAssistente < horaLimite:
                respBaseConhecimento[0] = "Desculpe.Eu me atralhei.Qual serviço você quer agendar mesmo?"
                respBaseConhecimento[1] = "cancelarOperacaoEmAndamento" 
                return True 

    return False  


def limparStateContatoAtivo(stts, manterDataHora): 

    for i in range(0, len(stts["reservas"])):
        stts["reservas"][i]["id_funcionario"] = ""
        stts["reservas"][i]["funcionario"] = ""
        stts["reservas"][i]["especialidades"] = []

        if manterDataHora == False:
            stts["reservas"][i]["data"] = ""
            stts["reservas"][i]["inicio"] = ""    

    stts["flagConfirmarAgendamento"] = False 
    stts["flagEscolherProfissional"] = True   
    stts["flagAdicionarServicos"] = False   
    stts["flagCancelarAgendamento"] = False   
    stts["flagUsuarioDesejaFazerCRUD"] = False                          
    stts["informacaoAoUsuario"] = ""
    stts["ultimaMensagemAssistente"] = ""
    stts["stateIdAgenda" ] = ""
    stts["reservas"] = [{ 
                        "id_funcionario":"",
                        "funcionario" : "",  
                        "data": "", 
                        "inicio": "", 
                        "especialidades" :  [{
                                               "id_especialidade":"" , 
                                               "especialidade" : "" , 
                                               "preco": 0,
                                               "sessoes":1, 
                                               "tempoNecessarioPorSessao":30 
                                            }]
                     }]

def validarDiaFuncionamento(stts):
    retorno = ""
    if stts["reservas"][0]["data"] != "":

        feriado = list(filter(lambda i:stts["reservas"][0]["data"] == i["dataFeriado"][:10],dictFeriado))  

        if len(feriado) > 0:
            msgResposta = "neste o dia de %s, então o estabelecimento não estará aberto" % feriado[0]["nome"]
            msgResposta += " Peça para ela escolher outro dia"
            retorno = msgResposta  

        diaSemana = tools.buscarDiaSemana(datetime.strptime(stts["reservas"][0]["data"], "%Y-%m-%d").weekday()) 

        if dictInfEmpresa["semana"][diaSemana] == False:
            msgResposta  = "neste dia da semana, %s o %s esta fechado " % (diaSemana,dictInfEmpresa["nomeEmpresa"])   
            msgResposta += " você tem que escolher um outro dia..."
            retorno = msgResposta

        elif trueSeDataHoraJaPassou (stts["reservas"][0]["data"], dictInfEmpresa["horario"]["fecha"]): 
            msgResposta  = "Hoje o estabelecimento já fechou."
            msgResposta += "Para qual dia você quer agendar?"
            retorno = msgResposta

        if  retorno !=  "" :  
            stts["reservas"][0]["data"] = ""
            stts["reservas"][0]["inicio"] = ""    

    return retorno   

def listarFunionariosPorEspecialidade(especialidade, stts, respBaseConhecimento):
    msgResposta = ""
    if especialidade != []: 
        if stts["reservas"][0]['especialidades'][0]["id_especialidade"] == "":
            stts["reservas"][0]['especialidades'][0]["id_especialidade"] = especialidade[0]["id_especialidade"] 
            stts["reservas"][0]['especialidades'][0]["especialidade"] = especialidade[0]["nome"] 
            stts["reservas"][0]['especialidades'][0]["preco"] = especialidade[0]["preco"] 
            stts["reservas"][0]['especialidades'][0]["sessoes"] = especialidade[0]["sessoes"] 
            stts["reservas"][0]['especialidades'][0]["tempoNecessarioPorSessao"] = especialidade[0]["tempoNecessarioPorSessao"] 

        lstFunc = buscarFuncionarioPorEspecialidades(especialidade[0]) 
        if len(lstFunc) > 0: 
            for funcionario in lstFunc:
                entrada = ""
                saida = ""
                if funcionario["entradaManha"] is not None and funcionario["entradaManha"] != "":
                    entrada = funcionario["entradaManha"]
                elif  funcionario["entradaTarde"] is not None and funcionario["entradaTarde"] != "":
                    entrada = funcionario["entradaTarde"]
                else: 
                    entrada = funcionario["entradaNoite"]

                if funcionario["entradaNoite"] is not None and funcionario["entradaNoite"] != "":
                    saida = funcionario["saidaNoite"]
                elif funcionario["entradaTarde"] is not None and funcionario["entradaTarde"] != "":
                    saida = funcionario["saidaTarde"]
                else:
                    saida = funcionario["saidaNoite"]   

                msgResposta +=  "%s diponivel nos dias de %s das %s às %s / "  % (funcionario["nome"], funcionario["diasSemana"],entrada,saida)  

            msgResposta = msgResposta[:len(msgResposta)-2] 
            if msgResposta != "" : msgResposta += "."

            if len(lstFunc) > 1 : msgResposta += f"Em caso de você ter alguma preferência,entre com o nome da funcionária." 

            if len(lstFunc) == 1:
                stts["reservas"][0]["id_funcionario"] = funcionario["id_funcionario"]
                stts["reservas"][0]["funcionario"] = funcionario["nome"] 

            respValidacao = verificaItensFaltantes(stts, respBaseConhecimento, "")  
            if respValidacao != "":                    
                stts["flagUsuarioDesejaFazerCRUD"] = True 
                if len(lstFunc) > 1 : msgResposta += "Alem disso,"
                msgResposta += "%s " % respValidacao.lower()
        else:
            msgResposta = "infelizmente, não temos um profissional especializado em %s " % especialidade[0]["nome"]      
            stts["reservas"][0]['especialidades'][0]["id_especialidade"] = ""
            stts["reservas"][0]['especialidades'][0]["especialidade"] = ""
            stts["reservas"][0]['especialidades'][0]["preco"] = ""
            stts["reservas"][0]['especialidades'][0]["sessoes"] = ""
            stts["reservas"][0]['especialidades'][0]["tempoNecessarioPorSessao"] = ""

    return  msgResposta       


def processCrud (stts,contato,mensagemOriginal,detected,respBaseConhecimento,pasta):
    msgResposta = ""
    hrPesquisa = "" 
    mensagemTraduzida = respBaseConhecimento[0]

    intencao = json.loads(respBaseConhecimento[1])["intencao"] 

    if stts["flagEscolherProfissional"]:
        funcionario = buscarFuncionario(mensagemOriginal)
        if funcionario[1] != "": 
            stts["flagUsuarioDemonstrouPreferenciaAoProfissional"] = True
        else: 
            stts["flagUsuarioDemonstrouPreferenciaAoProfissional"] = False     

    if intencao == "alterarReserva":
        stts["flagAlterarAgendamento"] = True 
        possivelArrayIdReserva = [int(s) for s in mensagemTraduzida.split() if s.isdigit() and int(s) >= 100000 and int(s) <= 999999]
        if len(possivelArrayIdReserva) == 0:   
            msgResposta = "é necessário o código de identificação da reserva para que a alteração seja feita."
            stts["ultimaMensagemAssistente"] = msgResposta                                       
            return msgResposta

    if stts["flagCancelarAgendamento"]:
        if intencao == "concordancia":                      
            if excluirReserva(stts["stateIdAgenda"], pasta):
                if stts["flagAlterarAgendamento"]:
                   msgResposta  = f"{stts['contato']}, que serviços voce quer e tambem qual o novo dia e horário de agendamento" 
                else:   
                    msgResposta  = "Sua reserva ja foi cancelada"
                    stts["flagCancelarAgendamento"] = False 
            else:
                msgResposta = "Algo deu errado! Você pode esperar alguns minutos e tente novamente ou entre em contato diretor com a gente.O que você achar melhor.Até mais" 
        else: 
            msgResposta = "Ta bom,sua reserva esta mantida. Esperamos você em breve!"

        del stts 
        return msgResposta    

    if msgResposta == "":     
        possivelArrayIdReserva = [int(s) for s in mensagemTraduzida.split() if s.isdigit() and int(s) >= 100000 and int(s) <= 999999]

        if intencao == "cancelarReservaJaEfetuada" or len(possivelArrayIdReserva) > 0: 
            if stts["reservas"][0]["data"] == "" and  stts["reservas"][0]["inicio"] == "" and stts["reservas"][0]["id_funcionario"] == "":  
                colecaoReserva = []
                if len(possivelArrayIdReserva) > 0:   
                    colecaoReserva = buscaReserva(possivelArrayIdReserva[0],pasta)

                if len(colecaoReserva) > 0: 
                    if stts["id_cliente"] == colecaoReserva[0]["id_cliente"]:  
                        if colecaoReserva[0]["situacao"] == "fechada":
                            msgResposta  = f"Consta aqui que voce. {stts['contato']}, já pagou antecipadamente o agendamento."
                            del stts 
                            stts["ultimaMensagemAssistente"] = msgResposta     
                            return respBaseConhecimento[0] 

                        else: 
                            dthora = datetime.strptime(colecaoReserva[0]["dataHoraInicio"], '%Y-%m-%d %H:%M:%S')
                            funcionario = colecaoReserva[0]["funcionario"]
                            if stts["flagAlterarAgendamento"]:
                                msgResposta = f"Para prosseguir com a alteração,{stts['contato']}, voce terá de cancelar a reserva anterior que seria com %s no dia %s/%s as %0.2d:%0.2d para fazer uma reserva nova.Você acorda com isso?" % (funcionario, dthora.day , dthora.month, dthora.hour,dthora.minute) 
                                stts["flagCancelarAgendamento"] = True 
                                stts["stateIdAgenda" ] = colecaoReserva[0]["id_agenda"] 

                            else:
                                msgResposta = f"{stts['contato']}, voce quer mesmo cancelar o seu agendamento com %s que seria dia %s/%s as %0.2d:%0.2d?" % (funcionario, dthora.day , dthora.month, dthora.hour,dthora.minute) 
                                stts["flagCancelarAgendamento"] = True 
                                stts["stateIdAgenda" ] = colecaoReserva[0]["id_agenda"] 

                    else:      
                        msgResposta  = f"{stts['contato']} algo e deu algo de errado com este número. Verifique se o numero de agendameto certo."
                else: 
                    if "Entre com um número válido" in  stts["ultimaMensagemAssistente"]:
                        msgResposta = "Lamento,mas não consigo encontrar o agendamento,talvez seja melhor entrar em contato com o estabelecimento"    
                    elif "me passe o número" in  stts["ultimaMensagemAssistente"]:
                        msgResposta = f"{stts['contato']} Entre com o número da reserva "    
                    else:            
                        msgResposta  = f"{stts['contato']} Por favor, me passa o número de identificação da reserva para que eu possa prosseguir com o cancelamento.Deve ter ficado gravado no whats quando efetivou a reserva"  

            stts["ultimaMensagemAssistente"] = msgResposta           
            return msgResposta


    if msgResposta == "":  
        if intencao == "listarEspecialidades" and not stts["flagConfirmarAgendamento"]:  
            msgResposta = buscarListaEspecialidades(mensagemTraduzida)  
            stts["flagUsuarioDesejaFazerCRUD"] = False 

    if msgResposta == "":  
        
        if intencao == "listarFuncionarios" and stts["reservas"][0]["data"] == "" and stts["reservas"][0]["inicio"] == "" and  stts["reservas"][0]["especialidades"][0]["id_especialidade"] == "":
            if not stts["flagConfirmarAgendamento"]:
                if len(buscarEspecialidade(detected,stts["contatoGenero"])) == 0:
                    msgResposta  = buscarListaFuncionarios(mensagemOriginal, stts)

        elif intencao == "listarFuncionarios" and stts["reservas"][0]['especialidades'][0]["id_especialidade"] != "":
            if not stts["flagConfirmarAgendamento"]:
                especialidade = stts["reservas"][0]['especialidades'][0]["especialidade"] 
                detected["servicos"] = especialidade                    
                especialidade = buscarEspecialidade(detected,stts["contatoGenero"])                     
                msgResposta = listarFunionariosPorEspecialidade(especialidade,stts,respBaseConhecimento) 

        elif intencao == "listarFuncionarios" and stts['flagEscolherProfissional']:
            if not stts["flagConfirmarAgendamento"]:
                if  stts["reservas"][0]["id_funcionario"] != "":
                    stts['flagEscolherProfissional'] = False  

    if msgResposta == "":
        if intencao == "listarHorariosLivres":
            especialidade = buscarEspecialidade(detected,stts["contatoGenero"])                     
            msgResposta = listarFunionariosPorEspecialidade(especialidade,stts,respBaseConhecimento) 

    if msgResposta == "":
        if stts["reservas"][0]["data"] == "":
            dtPesquisa = tools.buscarData(mensagemTraduzida)
            if dtPesquisa != "":
                stts["reservas"][0]["data"] = dtPesquisa   
                msgResposta = validarDiaFuncionamento(stts) 

    if msgResposta == "":

        if stts["reservas"][0]["inicio"] == "":
            msgOrgnl = tools.removerAcentos(tools.removerAcentos(mensagemOriginal)) 
            periodo = " manha" if " manha" in  msgOrgnl else " tarde"  if "tarde" in msgOrgnl else " noite" if "noite" in msgOrgnl else ""
            hrPesquisa = tools.converterHoraExtensaParaPadrao(mensagemTraduzida+periodo)
            if hrPesquisa == "":
                hrPesquisa = tools.converterHoraExtensaParaPadrao("%s manha" % mensagemTraduzida)

        if hrPesquisa != "":
            stts["reservas"][0]["inicio"] = hrPesquisa
            id_funcionario = ""
            funcionario = ""

            if not stts["flagUsuarioDemonstrouPreferenciaAoProfissional"]:
                id_funcionario = stts['reservas'][0]['id_funcionario']
                funcionario = stts['reservas'][0]['funcionario']
                stts['reservas'][0]['id_funcionario'] = ""
                stts['reservas'][0]['funcionario'] = ""

            msgResposta = validarHorarioEscolhido(stts, hrPesquisa)

            if msgResposta == "":
                if stts['reservas'][0]['id_funcionario'] == "" and id_funcionario != "" :
                    stts['reservas'][0]['id_funcionario'] = id_funcionario
                    stts['reservas'][0]['funcionario'] = funcionario  
            else:
                stts["reservas"][0]["inicio"] = ""

    if msgResposta == "":
        if stts["flagConfirmarAgendamento"]:           
            if intencao == "concordancia" or intencao == "incluirReserva"  : 
                identificador = salvarReserva(stts["reservas"], stts["id_cliente"], pasta)   
                stts["flagUsuarioDesejaFazerCRUD"] = False   

                if identificador != 0:
                    msgResposta =  " reserva confirmada! Seu número de reserva é %s" % identificador 
                    msgResposta += " Guarde este o número, pois pode ser util em caso de você querer cancelar"
                    msgResposta += " Nosso endereço é %s - %s.Estaremos lhe aguardando" % (dictInfEmpresa["nomeEmpresa"],dictInfEmpresa["endereco"])                        
                    msgResposta += " Obrigada"
                else:
                    msgResposta =  " Ops! Não sei o que aconteceu, não foi possivel consegui agendar..." 
                    msgResposta += " Mas não se preocupe, espere alguns minutos. E vamos tentar novamente"
                    msgResposta += " Eu vou ficar aqui te esperando"     
                    msgResposta += " Obrigada"
    
            else:                    
                msgResposta = "Sinto que eu tenha anotado algo errado, melhor voltar do inicio,né?!" 
                msgResposta += "Voce pode desistir a qualquer hora, sem tem problemas."
                msgResposta += "Então me diga, pra qual dia você quer agendar ?"     

                intencao = "incluirReserva"

            limparStateContatoAtivo(stts, False)

    if msgResposta == "":
        msgResposta = buscarEspecialidadeIndisponivel(mensagemOriginal,stts["contatoGenero"]) 

    if msgResposta == "":
        especialidade = []
        if stts["flagAdicionarServicos"]: 
            especialidade = buscarEspecialidade(detected,stts["contatoGenero"])

        elif stts["reservas"][0]['especialidades'][0]["id_especialidade"] == "":
            inexistente = []
            especialidade = buscarEspecialidade(detected,stts["contatoGenero"],inexistente)
            stts["flagAdicionarServicos"] = len(especialidade) == 1      
        
            flagServicoInexistente  = False 
            if len(especialidade) != 0:
                if len(list(filter(lambda i: especialidade[0]["id_especialidade"] == i["id_especialidade"],dictFuncionario))) == 0:
                    flagServicoInexistente = True 
                if len(inexistente) != 0:
                    flagServicoInexistente = True 

            elif len(especialidade) == 0 and len(detected["servicos"]) : 
                flagServicoInexistente = True 

            if flagServicoInexistente:
                if "procurando" in stts["ultimaMensagemAssistente"]:
                    msgResposta  = f"Lamento muito {contato},mas por enquanto, não temos especialistas para o serviço que você procura."   
                    limparStateContatoAtivo(stts, True)
                elif len(inexistente) != 0:
                    msgResposta = f"Ainda não trabalhamos com {', '.join(inexistente)} mas podemos agendar os outros itens.Tudo bem?"
                    if len(especialidade) > 0 :
                        addEspecialidadesInState(stts, especialidade)

                else:    
                    msgResposta = "Qual serviço você esta procurando mesmo?"   
                    stts["ultimaMensagemAssistente"] = msgResposta

    if msgResposta == "":
        if len(especialidade) > 0 :
            addEspecialidadesInState(stts, especialidade)

        funcionario = buscarFuncionario(mensagemOriginal)
        if funcionario[1] != "": 
            stts["flagUsuarioDemonstrouPreferenciaAoProfissional"] = True  
            stts["reservas"][0]["funcionario"] = funcionario[1] 
            stts["reservas"][0]["id_funcionario"] = funcionario[0] 

            if stts["reservas"][0]['especialidades'][0]["id_especialidade"] != ""  and  stts["reservas"][0]["id_funcionario"] != "":
                msgResposta = validarFuncionarioVsEspecialidade(stts) 

    if msgResposta == "": 
        if stts["reservas"][0]["data"] == "" and stts["reservas"][0]["inicio"] == "" and  stts["reservas"][0]["especialidades"][0]["id_especialidade"] == "":
            if intencao == "listarFuncionarios":
                msgResposta = buscarListaFuncionarios("",stts)
        else:
            if hrPesquisa == "" and stts["reservas"][0]["inicio"] != "":
                hrPesquisa = stts["reservas"][0]["inicio"] 

            msgResposta = validarHorarioEscolhido(stts, hrPesquisa)
            if msgResposta == "": 
                if "sobre" in mensagemOriginal: 
                    msgResposta = buscarListaFuncionarios("",stts)

    msgResposta = listarFuncionariosDisponiveis(stts,respBaseConhecimento, msgResposta)   

    if msgResposta == "": 
        if intencao == "incluirReserva" and len(detected["servicos"]) > 0:
            if stts["reservas"][0]["data"] == "" and stts["reservas"][0]["inicio"] == "":
                if stts["reservas"][0]['especialidades'][0]["id_especialidade"] == "" and stts["reservas"][0]["id_funcionario"] == "":
                    msgResposta = buscarEspecialidadeNaoCadastrada(mensagemTraduzida)

    if msgResposta == "": 
        if stts["reservas"][0]['especialidades'][0]["id_especialidade"] != ""  and  stts["reservas"][0]["id_funcionario"] != "":
            msgResposta = validarFuncionarioVsEspecialidade(stts) 

    if msgResposta == "": 
        if stts["flagUsuarioDemonstrouPreferenciaAoProfissional"]:
            if stts["reservas"][0]["data"] != "":
                if stts["reservas"][0]["inicio"] != "":
                    itemFunc = list(filter(lambda i: stts["reservas"][0]["id_funcionario"] == i["id_funcionario"],dictFuncionario))
                    itemFunc = itemFunc[0]
                    prefixo = "a" if itemFunc["genero"] == "f" else "o"
                    horariosLivres = listarDisponibilidadeFuncionario(itemFunc,stts["reservas"][0]["data"])
                    arrayLivres = horariosLivres.split(",")

                    if len(list(filter(lambda hora: hora.strip() == stts["reservas"][0]["inicio"],arrayLivres))) == 0:
                        msgResposta = "Às %s,neste dia %s %s não esta disponivel.Escolha um entre estes horários: %s" % (stts["reservas"][0]["inicio"], prefixo, stts["reservas"][0]["funcionario"], horariosLivres) 

    if msgResposta == "": 
        if stts["reservas"][0]["data"] != "" and stts["reservas"][0]["inicio"] != "":
            msgResposta = validarHorarioEscolhido(stts, stts["reservas"][0]["inicio"]) 

    if msgResposta == "": 
        msgResposta = verificaItensFaltantes(stts, respBaseConhecimento, mensagemTraduzida)    

    if msgResposta == "":   
        intencao = "incluirReserva"
        dt = datetime.strptime(stts["reservas"][0]["data"], "%Y-%m-%d")
        dtReserva = "%s/%s/%s" % (dt.day, dt.month, dt.year)    

        if stts["informacaoAoUsuario"]:
            msgResposta = stts["informacaoAoUsuario"] 
        else:
            msgResposta = " valide se as informações estão certas:"
            msgResposta += "  cliente: %s" % contato     
            atividades = ""
            funcionarios = ""  
            vlrTotal = 0 
            for idx, item in enumerate(stts["reservas"]):
                separador = "," if idx < len(stts["reservas"])-2 else " e "
                funcionarios += "%s%s" % (item["funcionario"],separador) 

            for itemReservas in stts["reservas"]:       
                for idx, item in enumerate(itemReservas["especialidades"]):
                    separador = "," if idx < len(stts["reservas"])-2 else " e "
                    atividades += "%s%s" % (item["especialidade"],separador) 
                    vlrTotal += float(item["preco"]) 

            funcionarios = funcionarios[0:len(funcionarios)-3]      
            atividades = atividades[0:len(atividades)-3]     

            msgResposta += " atividades: %s " % atividades  
            msgResposta += " Data: %s  Início: %s " % (dtReserva,stts["reservas"][0]["inicio"]) 
            msgResposta += " profissionais %s" % funcionarios
            msgResposta += " O valor será de %.2f reais" % vlrTotal    
            msgResposta += " Tudo bem ? Podemos confirmar esta dados? Sim ou não?"

            msgResposta = tools.alterar_data_extenso(msgResposta)

            stts["ultimaMensagemAssistente"] = msgResposta   
            stts["flagConfirmarAgendamento"] = True 

    return msgResposta

def horarioFuncionamento(): 
    diasFuncionamento = ""

    for diaDaSemana in dictInfEmpresa["semana"]:
        if dictInfEmpresa["semana"][diaDaSemana] == True:
            diasFuncionamento += "%s, " % diaDaSemana

    msgResposta = "O estabelecimento funciona nos dias de %s  no horário das %s até %s." % (diasFuncionamento,  
                                                                               dictInfEmpresa["horario"]["abre"], 
                                                                               dictInfEmpresa["horario"]["fecha"])     
    return msgResposta


class model:

    def __init__(self, pasta):
        self.pasta = pasta 
        loadDicionariosDinamicos(pasta)
        tools.loadDicionariosDinamicos(pasta) 

    def execute(self, states, infUltimaMensagem, respBaseConhecimento):

        contato = infUltimaMensagem["user"]  
        mensagemOriginal = infUltimaMensagem["message"]        
        msgResposta = ""
        detected = json.loads(infUltimaMensagem["detected"]) 
        intencao = json.loads(respBaseConhecimento[1])["intencao"] 

        clearOldInteractions(states)

        idx = findStatePosition(states, contato) 

        states[idx]["flagPrimeiraInteracao"] = False     

        if states[idx]["id_cliente"] == "":
            roboNaoDeveAtender = f"desculpa {contato},mas  você não pode ser atendido por mim, por favor por favor entre em contato na recepção."
            for item in dictCliente:                
                if item["contato"].lower() == contato.lower() and item["roboPodeAtender"] == "1":
                    states[idx]["contatoGenero"] = item["genero"]
                    states[idx]["id_cliente"] = item["id_cliente"]
                    break
                elif item["contato"].lower() == contato.lower() and item["roboPodeAtender"] == "0":
                    return roboNaoDeveAtender

            if dictInfEmpresa["atenderNaoCadastrados"] == False and states[idx]["id_cliente"] == "":
                return roboNaoDeveAtender

        if intencao == "discordancia":
            if "Ainda não trabalhamos" in states[idx]["ultimaMensagemAssistente"]:                
                limparStateContatoAtivo(states[idx], False)
                return "Compreendo,sem problemas. Entre em contato se precisar de algo da gente."

        msgResposta = processCrud (states[idx],contato,mensagemOriginal,detected,respBaseConhecimento,self.pasta) 

        if intencao == "infoEmpresa":
            if tools.buscarPalavra("responsavel", respBaseConhecimento[0]):
                msgResposta = "Você pode falar com %s. " % dictInfEmpresa["responsavel"] 
            elif tools.buscarPalavra("telefone", respBaseConhecimento[0]):
                msgResposta = "Você pode nos ligar pelo %s. " % dictInfEmpresa["telefone"] 
            elif tools.buscarPalavra("endereco", respBaseConhecimento[0]):
                msgResposta = "Nosso endereço é em %s.Venha nos ver!" % dictInfEmpresa["endereco"] 
            elif tools.buscarPalavra("onde", respBaseConhecimento[0]):
                msgResposta = "Nosso endereço é em %s.Venha tomar um cafézinho!" % dictInfEmpresa["endereco"] 
            elif tools.buscarPalavra("local", respBaseConhecimento[0]):
                msgResposta = "Nosso endereço é em %s.Venha nos visitar!" % dictInfEmpresa["endereco"] 
            elif tools.buscarPalavra("hora", respBaseConhecimento[0]) or tools.buscarPalavra("horas", respBaseConhecimento[0]):
                 msgResposta = horarioFuncionamento()  
            elif tools.buscarPalavra("horario", respBaseConhecimento[0]):
                 msgResposta = horarioFuncionamento()  
            elif tools.buscarPalavra("fica", respBaseConhecimento[0]) or tools.buscarPalavra("ficam", respBaseConhecimento[0]) :
                msgResposta = "Nosso endereço é em %s.Visite-nos!" % dictInfEmpresa["endereco"] 
            elif tools.buscarPalavra("estabelecimento", respBaseConhecimento[0]):
                msgResposta = dictInfEmpresa["nomeEmpresa"]
            elif tools.buscarPalavra("nome", respBaseConhecimento[0]):
                msgResposta = dictInfEmpresa["nomeEmpresa"]
            else: 
                msgResposta = horarioFuncionamento()      

        if msgResposta == "":
            if intencao == "listarFuncionarios" or intencao == "listarHorariosLivres": 
                msgResposta =  horarioFuncionamento()  

        states[idx]["ultimaMensagemAssistente"] = msgResposta    

        return msgResposta