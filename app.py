import re
import json
import openai
from neural import nucleo_neural
from datetime import datetime 
from flask import Flask, request, jsonify
from flask_cors import CORS
from tools import obter_chave_openai
from tools import log_message
from babel.dates import format_datetime, Locale

locale = Locale('pt_BR')

chave_openai = obter_chave_openai()

client = openai.OpenAI(api_key=chave_openai)

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

app = Flask(__name__)
CORS(app)
 
@app.route("/", methods=['GET'])
def root():
    return f"<h1>Nelltek LLM APIs.All Rights Reserved</h1>"

@app.route("/customer_service", methods=['POST'])
def customer_service():
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
        "mensagem da cliente": user_msg
    }

    message=[
        {"role": "system", "content": detection_rules},
        {"role": "user", "content": json.dumps(prompt, ensure_ascii=False)}
    ]
    
    try:
        chat_completion = client.chat.completions.create(
            messages=message,
            model="gpt-3.5-turbo",
            temperature=0.0,
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

    log_message(f"{data_hora_ansi} user:{user} - user's message:{user_msg} - manager:{nucleo_neural_info} - response:{response} \n")
 
    return jsonify({'answer': response})

if __name__ ==  '__main__':
    app.run(host="0.0.0.0", debug=True, port=8000)    
