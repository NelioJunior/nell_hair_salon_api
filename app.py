import json
import openai
from neural import nucleoNeural
from datetime import datetime 
from flask import Flask, request, jsonify
from flask_cors import CORS
from tools import obter_chave_openai
import locale

chave_openai = obter_chave_openai()

client = openai.OpenAI(api_key=chave_openai)

previous_user = "" 

message_info = {
                "user": "",
                "message" : "",
                "lastMessageTime": datetime.now().strftime("%H:%M"),  
                "pasta": "https://nelltek.ddns.net/nellSite/ClientesParceirosNell/gestorPai_SalaoConsultorioMVC/" 
}

rule_file = "/home/nelljr/nell_hair_salon_api/angel_guide.txt"
rule = open(rule_file, "r")  

agent_rule = rule.read()
agent_rule = agent_rule.replace('\t', ' ')     
agent_rule = agent_rule.replace('\n', ' ')     

conversation_history = []

app = Flask(__name__)
CORS(app)
 
@app.route("/", methods=['GET'])
def root():
    return f"<h1>Nelltek LLM APIs.All Rights Reserved</h1>"

@app.route("/customer_service", methods=['POST'])
def customer_service():
    global previous_user 

    data = request.get_json()

    user = data.get('user')
    user_msg = data.get('question') 

    message_info["message"] = user_msg
    message_info["user"] = user

    company_api_message = nucleoNeural(message_info) 
   
    prompt = "" 
    if previous_user != user: 
        previous_user = user
        conversation_history.clear()

    conversation_history.append(f"'{user_msg}',")   

    locale.setlocale(locale.LC_TIME, 'pt_BR.utf8')

    data_hora_atual = datetime.now()
    data_hora_formatada = data_hora_atual.strftime('%A, %d de %B de %Y')
    
    prompt = {"usuario": user, 
        "mensagem": company_api_message , 
        "conversas anteriores": json.dumps(conversation_history),
        "data hora atual": data_hora_formatada
    }
    
    message=[
        {"role": "system", "content": agent_rule},
        {"role": "user", "content": json.dumps(prompt, ensure_ascii=False)}
    ]
    
    chat_completion = client.chat.completions.create(
       messages=message,
       model="gpt-3.5-turbo",
       temperature=0.7,
       max_tokens=150
    )

    response = chat_completion.choices[0].message.content

    return jsonify({'answer': response})

if __name__ ==  '__main__':
    app.run(host="0.0.0.0", debug=True, port=8000)    
