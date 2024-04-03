import re
import json
import openai
from neural import nucleo_neural
from datetime import datetime 
from flask import Flask, request, jsonify
from flask_cors import CORS
from tools import obter_chave_openai
from babel.dates import format_datetime, Locale

chave_openai = obter_chave_openai()

client = openai.OpenAI(api_key=chave_openai)

previous_user = "" 
response = ""
question_number = 0

message_info = {
                "user": "",
                "message" : "",
                "detected" : "",
                "lastMessageTime": datetime.now().strftime("%H:%M"),  
                "pasta": "https://nelltek.ddns.net/nellSite/ClientesParceirosNell/gestorPai_SalaoConsultorioMVC/" 
}

rule_file = "/home/nelljr/nell_hair_salon_api/intent_analysis.txt"
rule = open(rule_file, "r")  

detection_rules = rule.read()                        

rule_file = "/home/nelljr/nell_hair_salon_api/angel_guide.txt"
rule = open(rule_file, "r")  

agent_rule = rule.read()

question_history = []

app = Flask(__name__)
CORS(app)

def log_message(message):
    with open("historic.log", "a") as log_file:
        log_file.write(message)
 
@app.route("/", methods=['GET'])
def root():
    return f"<h1>Nelltek LLM APIs.All Rights Reserved</h1>"

@app.route("/customer_service", methods=['POST'])
def customer_service():
    global previous_user
    global question_number 
    global response

    locale = Locale('pt_BR')
    data_hora_atual = datetime.now()
    data_hora_formatada = format_datetime(data_hora_atual, format='full', locale=locale)
    data_hora_formatada = data_hora_formatada[0:len(data_hora_formatada)-29]    

    data_hora_ansi = data_hora_atual.strftime('%Y-%m-%d %H:%M:%S')

    data = request.get_json()

    user = data.get('user')
    user_msg = data.get('question') 
    user_msg = re.sub(r'\bnao\b', 'não', user_msg, flags=re.IGNORECASE)

    prompt = {
        "cliente": user, 
        "mensagem da cliente": user_msg,
        "data hora corrente": data_hora_formatada
    }

    message=[
        {"role": "system", "content": detection_rules},
        {"role": "user", "content": json.dumps(prompt, ensure_ascii=False)}
    ]
    
    try:
        chat_completion = client.chat.completions.create(
            messages=message,
            model="gpt-3.5-turbo",
            temperature=0.1,
            max_tokens=100
        )

        message_info["detected"]  = chat_completion.choices[0].message.content
        message_info["message"] = user_msg
        message_info["user"] = user

    except:
        return jsonify({'answer': 'estou com problemas para acessar o sistema do estabelecimento, entre em contato mais tarde'})

    nucleo_neural_info = nucleo_neural(message_info) 

    if nucleo_neural_info[1]:
    
        prompt = {
            "cliente": user, 
            "orientacao da gerente": nucleo_neural_info[0] , 
            "mensagem da cliente": user_msg,
            "data hora corrente": data_hora_formatada
        }
    
        message=[
            {"role": "system", "content": agent_rule},
            {"role": "user", "content": json.dumps(prompt, ensure_ascii=False)}
        ]
        
        chat_completion = client.chat.completions.create(
            messages=message,
            model="gpt-3.5-turbo",
            temperature=0.1,
            max_tokens=200
        )

        response = chat_completion.choices[0].message.content

    else:
        response = nucleo_neural_info[0]

    if question_number > 1:
        position = response.find('!')
        if position != -1 and position <= 30:
            response = response[position + 1:]

    log_message(f"{data_hora_ansi} user:{user} - user's message:{user_msg} - manager:{nucleo_neural_info} - response:{response} \n")
 
    return jsonify({'answer': response})

if __name__ ==  '__main__':
    app.run(host="0.0.0.0", debug=True, port=8000)    
