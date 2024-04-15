#!/usr/bin/env python
# -*- coding: utf-8 -*

import re
import random
import json
import datetime
import time
import traceback
from datetime import date
from datetime import timedelta  
from datetime import datetime
from unicodedata import normalize

def read_config_credentials():
    credentials = {}
    with open("config.txt", "r") as file:
        lines = file.readlines()
        for line in lines:
            key, value = line.split("=")
            credentials[key] = value.strip()
    return credentials

def eliminar_duplicatas(palavras_chave):
    palavras_lista = palavras_chave.split()
    palavras_sem_duplicatas = set(palavras_lista)
    return ' '.join(palavras_sem_duplicatas)

def log_message(message):
    with open("historic.log", "a") as log_file:
        log_file.write(message)

def formalizador_de_linguagem_natural(message_info, nomeAssistente):
    mensagemTraduzida = message_info["message"].lower() 
    mensagemTraduzida = mensagemTraduzida.replace(nomeAssistente,"")   

    mensagemTraduzida = tradutorHora (mensagemTraduzida)
    mensagemTraduzida = buscartradutor (mensagemTraduzida)
    mensagemTraduzida = mensagemTraduzida.strip()

    detected = json.loads(message_info["detected"]) 
  
    if detected["intencao"] == "semrelacao":

        if "listar" not in detected["intencao"]:
            if "reservar" in mensagemTraduzida:
                detected["intencao"] = "incluirReserva"

            elif "alterar" in mensagemTraduzida:
                detected["intencao"] = "alterarReservaJaEfetuada"

            match = re.search(r'\b\d{6}\b', mensagemTraduzida)
            if match:
                detected["intencao"] = "cancelarReservaJaEfetuada"   

    if mensagemTraduzida[0:3] == "sim": 
        match = re.search(r'\b\d{6}\b', mensagemTraduzida)
        if match:
            detected["intencao"] = "cancelarReservaJaEfetuada"   
        else: 
            detected["intencao"] = "concordancia"

    if mensagemTraduzida[0:3] == "nao": 
        detected["intencao"]= "discordancia"

    if "adeus" in mensagemTraduzida: 
        detected["intencao"] = "semrelacao"

    resp = []
    resp.append(mensagemTraduzida)   
    resp.append(json.dumps(detected))     

    return resp

def alterar_data_extenso(texto):
    data = re.search(r'Data: (\d{1,2}/\d{1,2}/\d{4})', texto).group(1)
    data_obj = datetime.strptime(data, '%d/%m/%Y')
    
    dia = data_obj.strftime('%d')
    mes = dictMes[data_obj.month]
    ano = data_obj.strftime('%Y')
    
    data_extenso = f"{dia} de {mes} de {ano}"
    
    texto = re.sub(r'Data: \d{1,2}/\d{1,2}/\d{4}', 'Data: ' + data_extenso, texto)
    
    return texto

def substituir_interrogacoes(texto):
    indices_interrogacao = [i for i, char in enumerate(texto) if char == '?']
    
    if indices_interrogacao:
        primeiro_indice_interrogacao = indices_interrogacao[0]
        texto = texto[:primeiro_indice_interrogacao] + ',' + texto[primeiro_indice_interrogacao+1:]
    
    if len(indices_interrogacao) >= 2:
        penultimo_indice_interrogacao = indices_interrogacao[-2]
        texto = texto[:penultimo_indice_interrogacao] + ' e' + texto[penultimo_indice_interrogacao+1:]

    texto = texto.replace("  "," ")    
    
    return texto

def edits1(word):
    letters    = 'abcdefghijklmnopqrstuvwxyz'
    splits     = [(word[:i], word[i:])    for i in range(len(word) + 1)]
    deletes    = [L + R[1:]               for L, R in splits if R]
    transposes = [L + R[1] + R[0] + R[2:] for L, R in splits if len(R)>1]
    replaces   = [L + c + R[1:]           for L, R in splits if R for c in letters]
    inserts    = [L + c + R               for L, R in splits for c in letters]
    return set(deletes + transposes + replaces + inserts)

def edits2(word): 
    return (e2 for e1 in edits1(word) for e2 in edits1(e1))

def remove_emojis(texto):
    regex = re.compile("[^\w\s,:]")
    return regex.sub("", texto)

def expressoesSemDiscordancia(msg, estimulo):
    retorno = False 
    msgContemNao = True if buscarPalavra("nao",msg) > 0  else False 
    estimuloContemNao = True if buscarPalavra("nao",estimulo) > 0  else False 

    if estimuloContemNao == msgContemNao:
        retorno = True 

    return retorno     

def contar_ocorrencias(palavra, texto):
    palavras = texto.split()  
    contador = 0
    
    for palavra_texto in palavras:
        if palavra_texto == palavra:
            contador += 1
    
    return contador

def buscartradutor(palavra):     
    retorno = removerAcentos(palavra).lower()
    retorno = retorno.strip()
    retorno = re.sub(r'[?!,.-]', ' ', retorno)

    for item in dictTradutor:
        itm = item["texto"]
        if buscarPalavra(itm, retorno) > 0: 
            retorno =  re.sub(rf'\b{itm}\b', item["equivalente"], retorno)

    return retorno

def tradutorHora (msg):
    retorno = removerAcentos(msg).lower()
    if buscarHora (msg) == "":  
        while "  " in retorno : retorno = retorno.replace("  ", " ")  

        for item in lstHora:
            ret = retorno   
            retorno = retorno.replace(item["texto"], item["equivalente"]) 
            if ret != retorno:
                break 

    return retorno.strip()

def tradutorExpressao (msg):
    retorno = msg
    while "  " in retorno : retorno = retorno.replace("  ", " ")  
    
    for item in lstExpressao:
        retorno = retorno.replace(item["texto"], item["equivalente"]) 

    msg = retorno.strip()
    msg = re.sub(r'[?!,.-]', ' ', msg)
    msg = msg.replace("feira", " ")
    msg = msg.strip()
    words = msg.split()

    if words[-1] == "adeus":
        return words[-1] 

    elif words[0] == "sim":
        return words[0]

    return None 

import re

def contextualizador(msg):

    msg = re.sub(r'[?!,.-]', ' ', msg)
    msg = msg.replace("feira", " ")
    msg = msg.strip()
    words = msg.split()

    if words[-1] == "adeus":
        return "naoRelacionado"

    elif words[0] == "sim":
        return 'confirmacao'

    else:
        for item in dictTradutor:
            if len(item["texto"].split()) == 1:
                padrao = r'\b' + re.escape(item["texto"]) + r'\b'
                msg = re.sub(padrao, item["equivalente"], msg)
            else:
                msg = msg.replace(f' {item["texto"]} ', f' {item["equivalente"]} ')

    return msg

def tradutorPalavra (msg):    
    msgx = removerAcentos(msg).lower()
    arrayRetorno = msgx.split()
    retorno = ""

    for itemA in lstPalavra:
        for i, itemB in enumerate(arrayRetorno):
            if itemB == itemA["texto"].lower(): 
                arrayRetorno[i] = itemA["equivalente"].lower()

    retorno = ' '.join(arrayRetorno)  
    while "  " in retorno : retorno = retorno.replace("  ", " ")   
    retorno = retorno.replace(" :", ":")   
    return retorno.strip()


def tradutor (msg):    
    msg = removerAcentos(msg).lower().split(" ")
    retorno = ""

    for idx, item  in enumerate(msg):
        if idx < len(msg)-1:
            msg[idx+1] = msg[idx] + " " + msg[idx+1]

    for palavra in msg:
       
       for item in dictTradutor:
          if item["texto"] == palavra:
             palavra = item["equivalente"]
             
       retorno += palavra + " "

    while "  " in retorno : retorno = retorno.replace("  ", " ")   
    retorno = retorno.replace(" :", ":")   
    

    return retorno.strip()

def buscarDiaSemana(i):
    return dictSemana[i]   

def buscarDiaSemanaExtenso(msg):
    for dia in dictSemana:
        if buscarPalavra(dia,msg):
           return dia 
    return ""       

def buscarMensagemNaoCompreendido():
    i = len(dictResponderNaoCompreendido) -1     
    return dictResponderNaoCompreendido[random.randint(0,i)]

def buscarCalculosMatematicos(msg):
    msg = msg.lower()
    retorno = ""
    if "?" in msg: 
        if "qual" in msg or "quanto" in msg:
            for char in msg:
                if char.isalpha():
                   msg = msg.replace(char, "")                   
        
            msg = msg.replace("?", "")
            msg = msg.replace("!", "")
            msg = msg.replace(",", "")            
            msg = msg.replace(";", "")            

            for item in dictOperadores:
                if item in msg: 
                    retorno = msg
                    break 
                
    return retorno.strip()

def buscarMes(msg):
    retorno = []
    for idx in range(len(dictMes)):
        if dictMes[idx] in msg: 
           retorno = [idx,dictMes[idx]] 
              
    return retorno  

def buscarMesPorIndice(i):
    return dictMes[i-1]   

def buscarAno(msg, intMes = 0):
    hoje = date.today()   
    ano = hoje.year
    mes = ""
    
    if intMes == 0: 
        mes = buscarMes(msg)

    if len(mes) == 0: 
        intMes = hoje.month
    
    else: 
        intMes = mes[0]
        var = buscarNumero(msg[buscarPalavra(mes[1],msg):])
        if len(var) > 0:  
            ano = var[0]
    
    if len(str(ano)) == 2: 
        ano = ano + 2000  

    if ano < hoje.year:
        ano = hoje.year
          
    return ano    

def confirmar(msg):
    retorno = False 
    if buscarPalavra("sim", msg) + buscarPalavra("quero", msg) > 0:
        retorno = True  
        if buscarPalavra("nao", msg) > 1:
            retorno = False 
    else:
        retorno = False 

    return retorno     

def buscarNumero(msg): 
    return [int(s) for s in msg.split() if s.isdigit()]
    
def buscarPalavra(palavra,msg):
    palavra = removerAcentos(palavra).lower()
    palavra = palavra.replace("(", "")
    palavra = palavra.replace(")", "")
    palavra = palavra.replace("?", "QUESTION")     

    msg = removerAcentos(msg).lower()   
    msg = msg.replace("?", "QUESTION")      
    msg = " " + msg 
    retorno = 0
    
    try:
        x1 = findWholeWord(palavra)(msg)
        if x1 is not None: 
            retorno = x1.span()[0]
    except:  
        retorno = 0      
        
    return retorno 

def findWholeWord(w):
    return re.compile(r'\b({0})\b'.format(w), flags=re.IGNORECASE).search    
    
def convertDataExtensaParaPadrao(msg):   
    hoje = date.today()   
    dia = hoje.day
    mes = hoje.month
    ano = buscarAno(msg)  
    correnteDt =  "%0.4d-%0.2d-%0.2d" % (ano , mes , dia)    

    if "hoje" in msg:
       return correnteDt

    elif "ontem" in msg:
       yesterday = hoje + timedelta(days = -1)
       return "%0.4d-%0.2d-%0.2d" % (yesterday.year , yesterday.month , yesterday.day)

    elif "amanha" in msg:
       tomorrow = hoje + timedelta(days = 1)
       return "%0.4d-%0.2d-%0.2d" % (tomorrow.year , tomorrow.month , tomorrow.day)

    varDia = buscarPalavra("dia", msg)
    varMes = buscarMes(msg)

    try:
        if varDia == 0:
            if len(varMes) > 0:
                dia = buscarNumero(msg[:msg.find(varMes[1])])[0]
            else: 
                return "nao localizado"        
        else:
            dia = buscarNumero(msg[varDia:])[0]       
    except:
      return "nao localizado"  

    if len(varMes) > 0:
        mes = varMes[0] 

    try:
        datetime(year=ano,month=mes,day=dia)
    except:
        return ""

    dt = "%0.4d-%0.2d-%0.2d" % (ano , mes , dia)

    if dt < correnteDt:
        if mes == 12: 
            mes = 1 
            ano += 1 
        else:                
            mes += 1

        if validaData(ano,mes,dia):
            dt = "%0.4d-%0.2d-%0.2d" % (ano , mes , dia)

    return dt

def validaData(ano,mes,dia):
    import datetime
    correctDate = None
    try:
        newDate = datetime.datetime(ano,mes,dia)
        correctDate = True
    except ValueError:
        correctDate = False
    return (str(correctDate))


def convertDiaSemanaParaExtensa(msg):
    retorno = ""
    if "hoje" not in msg: 
        for idx in range(len(dictSemana)):
            if dictSemana[idx] in msg:       
                vlr = idx - date.today().weekday()
                if vlr <= 0: vlr += 7             
                dtAg = date.today()+timedelta(days=vlr)     
                retorno = "%s, %s de %s" % (dictSemana[idx], dtAg.day,dictMes[dtAg.month-1])             
                break
   
    return retorno

def buscarDataPadraoAnoMesDia(msg):
    retorno = convertDataExtensaParaPadrao(msg)
    
    if retorno == "nao localizado": 
        retorno = convertDataExtensaPadraoAnoMesDia(convertDiaSemanaParaExtensa(msg))
       
    return retorno     

def convertDataExtensaPadraoAnoMesDia(msg):
    hoje = date.today()   
    dia = hoje.day
    mes = hoje.month  
    
    varDia = buscarPalavra("dia", msg)
    varMes = buscarMes(msg)
    
    if varDia == 0:
        if len(varMes) > 0:
            dia = buscarNumero(msg[:msg.find(varMes[1])])[0]
        else: 
            return "nao localizado"        
    else:
        dia = buscarNumero(msg[varDia:])[0] 
    
    if len(varMes) > 0:
        mes = varMes[0] 
        
    ano = buscarAno(msg)  
    
    return "%0.4d-%0.2d-%0.2d" % (ano , mes , dia)       


def isTimeFormat(input):
    try:
        time.strptime(input.strip(), '%H:%M')
        return True
    except ValueError:
        return False    

def buscarHora(msg):
    retorno = ""
    if msg == None:
        return ""  

    msg = " %s " % msg.strip()
    if ":" in msg:
        msg += "/"  
        hora = msg[msg.find(":")-2:(len(msg) - 3 - msg.find(":")) * -1] 
        if isTimeFormat(hora):
            hora = hora.strip()   
            if len(hora[:hora.find(":")]) == 1: hora = "0" + hora
            if len(hora) == 4: hora += "0"                
            
            retorno = hora   
       
    return retorno 
        
def isDateFormat(input):
    try:
        datetime.strptime(input.strip(), '%d/%m/%Y')
        return True
    except ValueError:
        return False    

def buscarDataDiaMesAno(msg):
    msg = msg.replace("-", "/") 
    retorno = ""
    if "/" in msg:     
        data = msg[msg.find("/")-2:msg.find("/")+4]
        
        dt = data.split("/") 
       
        if str(dt[1]).isdigit() == False:
            for idx in range(len(dictMes)):
                if dt[1].lower() == dictMes[idx][:3].lower():
                   dt[1] = idx + 1   
                   break 
        
        if str(dt[1]).isdigit() == False:   
            dt[1] == date.today().month

        dt[0] = re.sub('[^A-Za-z0-9]+', '', str(dt[0]))  
        dt[1] = re.sub('[^A-Za-z0-9]+', '', str(dt[1]))   

        if dt[0].isdigit() and dt[1].isdigit():
            data = "%0.2d/%0.2d" % (int(dt[0]) , int(dt[1])) 
                   
        if len(data) == 5:
            data = "%s/%s" % (data, date.today().year) 
        
        if isDateFormat(data):
            retorno = data.strip()   
       
    return retorno 


def buscarDiaMes(msg):
    match = re.search(r'dia\s*(\d{1,2})\b', msg)
    if match:
        dia = int(match.group(1))
    else:
        return ""

    data_atual = datetime.now()

    try:
        if dia < data_atual.day:
            proximo_mes = data_atual.replace(day=dia) + timedelta(days=30)
        else:
            proximo_mes = data_atual.replace(day=dia)

        data_formatada = proximo_mes.strftime('%Y-%m-%d')
        return data_formatada
    except ValueError:
        return ""


def buscarData(msg):    
    if "depois amanha" in msg:
        depoisDeamanha = adicionarDias(2)
        retorno = depoisDeamanha
    else:     
        retorno = convertDataExtensaParaPadrao(msg)
    
    if retorno == "nao localizado": 
        retorno = convertDataExtensaParaPadrao(convertDiaSemanaParaExtensa(msg))
    if retorno == "nao localizado":
        retorno = buscarDataDiaMesAno(msg)
        if retorno != "":
           dt = datetime.strptime(retorno, '%d/%m/%Y')
           retorno =  "%0.2d-%0.2d-%0.2d" % (dt.year, dt.month, dt.day)
    if retorno == "":
        retorno = buscarDiaMes(msg)

    return retorno     

def converterHoraExtensaParaPadrao(msg):  
    hora = buscarHora(msg)
    
    if hora == "": 
        hora =  buscarHora(tradutorExpressao(tradutor(msg))) 

    if hora != "":
        if (hora < "08:00" and not " manha" in msg)  or (hora >= "08:00" and " noite" in msg):
           hrs = str(int(hora[:2]) + 12)
           min = hora [2:]
           hora = hrs+min
        
        hrs = hora[:2]
        min = hora [3:]
        if min >= "45": 
            min = "00" if hrs < "24" else "30"
            hrs = int(hora[:2])+1 if hrs < "24" else hrs
            hrs = "%0.2d" % hrs 

        min = "00" if min < "30" else "30"  
        hora = hrs+":"+min

        return hora      
    else:
        msg = " " + msg + " "                         
    
    if  msg.find(" as ") == -1:   
        xhr = buscarNumero(msg)    

        if len(xhr) > 0:
            if len(xhr) == 1:
                if buscarPalavra("dia",msg) == 0 and buscarDiaSemanaExtenso(msg) == "":
                    yHr = str(xhr[0])    
                    if " de " not in  msg[msg.find(yHr):7]:
                        msg = msg.replace(yHr, yHr + ":00")           

            else:        
                yHr = str(xhr[len(xhr) -1])                            
                msg = msg.replace(yHr, yHr + ":00")           
            
    else:
        
        x = msg[msg.find(" as ")+3:msg.find(" as ")+6].strip()  
        if x.isdigit():
            y = x 
            if int(x) < 8: y = str(int(x) + 12)                  
            msg = msg.replace (x, "%s:00" % y)
         
        # intB = msg[msg.find(" as ") - 2:msg.find(" as ")].strip() 

        # if intB.isdigit(): 
        #     intB = str(60 - int(intB))  
            
        #     hora = buscarHora(msg)
        #     if hora != "":                
        #         intA = str(int(hora[:2]) -1)                   
        #         if len(intB) == 1:intB = "0" + intB
        #         if len(intA) == 1:intA = "0" + intA
        #         intC = "%s:%s" % (intA, intB)  
        #         msg = intC + msg
                
    # Acho que dá pra racionalizar, - ver isso quando possivel - Nelio Jr. Set/18 
    # Ainda dá para criar uma consistencia em que "arendondar as unidades em pelo menos 
    # de cinco em cinco, Exemplo: 10:23 vira 10:25  / 10:21 vira 10:20 
    
    if " e 10" in msg:   
        msg = msg.replace(":00", ":10")                
    elif " e 15" in msg:   
        msg = msg.replace(":00", ":15")                
    elif " e 20 e 5" in msg:   
        msg = msg.replace(":00", ":25") 
    elif " e 25" in msg:   
        msg = msg.replace(":00", ":25")                        
    elif " e 20" in msg:   
        msg = msg.replace(":00", ":20")                
    elif " e 30 e 5" in msg:   
        msg = msg.replace(":00", ":35") 
    elif " e 35" in msg:   
        msg = msg.replace(":00", ":45")    
    elif " e 30" in msg:   
        msg = msg.replace(":00", ":30") 
    elif " e 40 e 5" in msg:   
        msg = msg.replace(":00", ":45")        
    elif " e 45" in msg:   
        msg = msg.replace(":00", ":45")    
    elif " e 40" in msg:   
        msg = msg.replace(":00", ":40")            
    elif " e 50 e 5" in msg:   
        msg = msg.replace(":00", ":55")        
    elif " e 55" in msg:   
        msg = msg.replace(":00", ":55")
    elif " e 50" in msg:   
        msg = msg.replace(":00", ":50") 
    elif " e 5 " in msg:   
        msg = msg.replace(":00", ":05")
  
    hora = buscarHora(msg)
    
    if hora != "":    
        if hora < "08:00" or (hora >= "08:00" and " da noite" in msg):
            hrs = str(int(hora[:2]) + 12)
            min = hora [2:]
            hora = hrs+min

        hrs = hora[:3]
        min = hora [3:]
        min = "00" if min > "30" else "00"  
        hora = hrs+min

    return hora      
            
def removerAcentos(txt):
    txt = txt.replace(".", "")
    txt = txt.replace("!", "")
    return normalize("NFKD", txt).encode("ASCII", "ignore").decode("ASCII")


def adicionarDias(dias):
    from datetime import datetime, date, timedelta
    data = datetime.now() + timedelta(days = dias) 
    return str(data)[0:10]


def adicionarMes(strData):
    from datetime import date, timedelta
    import calendar

    strData = datetime.strptime(strData, '%Y-%m-%d')    
    start_date = date(strData.year,strData.month,strData.day)
    days_in_month = calendar.monthrange(start_date.year, start_date.month)[1]
    Data = start_date + timedelta(days=days_in_month)

    return "%0.2d-%0.2d-%0.2d" % (Data.year, Data.month, Data.day)

def loadDicionariosDinamicos(urlServidor):
    global dictTradutor
    global dicBaseConhecimento
    global dictResponderNaoCompreendido
    global lstHora 
    global lstExpressao
    global lstPalavra

    dictTradutor = json.load(open("./tradutor.json", "r"))

    lstHora = list(filter(lambda x: ":" in x["equivalente"],dictTradutor))
    lstExpressao = list(filter(lambda x: len(x["texto"].split()) > 1 and ":" not in x["equivalente"] ,dictTradutor))
    lstPalavra = list(filter(lambda x: len(x["texto"].split()) == 1 and ":" not in x["equivalente"],dictTradutor))

def anotarErro(cnt):
    erro = traceback.format_exc()
    momentoErro = time.strftime("%Y-%m-%d %H:%M:%S")
    cnt += 1 
    msgErro = "%s - %s - %s\n" % (cnt,momentoErro,str(erro))
    print (msgErro ,flush=True)  
    errosAnteriores = open("erro.log", 'r').read() 
    msgErro += errosAnteriores          
    with open("erro.log", 'w') as f: f.write(msgErro)             
    time.sleep(10)
    return cnt
    
#dicionarios estáticos -----------------------------------------------------------------------------------

dictOperadores = [
    "+",
    "-",
    "*",
    "/"
]

dictSemana = [
    "segunda", 
    "terca", 
    "quarta", 
    "quinta", 
    "sexta", 
    "sabado",
    "domingo"
]    

dictMes = [
    "",
    "janeiro", 
    "fevereiro", 
    "marco", 
    "abril", 
    "maio", 
    "junho", 
    "julho", 
    "agosto", 
    "setembro", 
    "outubro", 
    "novembro", 
    "dezembro"
]    

dictDespresarPalavra = [
    "gostoso",
    "gostosa",
    "qual vai",
    "que vai",
    "que tem",
    "de",
    "deliciosa",
    "delicioso",
    "suculento",
    "da hora",
    "bom",
    "boa"
    "com"
    "maravilhosa",
    "maravilhoso",
    "estupendo",
]

def obter_chave_openai():
    caminho_bashrc = '/home/nelljr/.bashrc'

    try:
        with open(caminho_bashrc, 'r') as arquivo:
            linhas = arquivo.readlines()

            for linha in linhas:
                if 'export OPENAI_API_KEY=' in linha:
                    chave = linha.split('=')[1].strip().strip('"')
                    return chave

    except FileNotFoundError:
        print(f"O arquivo {caminho_bashrc} não foi encontrado.")
    except Exception as e:
        print(f"Erro ao ler o arquivo {caminho_bashrc}: {str(e)}")

    return None
