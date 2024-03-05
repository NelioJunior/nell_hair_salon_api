import os
import openai
from neural import nucleoNeural
from datetime import datetime 
from flask import Flask, request, jsonify
from flask_cors import CORS
from pathlib import Path
from tools import obter_chave_openai


config_path = str(Path.home() / '.bashrc')
chave_openai = obter_chave_openai()

client = openai.OpenAI(api_key=os.getenv(chave_openai))

previous_user = "" 

message_info = {
                "user": "",
                "message" : "",
                "lastMessageTime": datetime.now().strftime("%H:%M"),  
                "pasta": "https://nelltek.ddns.net/nellSite/ClientesParceirosNell/gestorPai_SalaoConsultorioMVC/" 
}

client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY")) 

rule_file = "/home/nelljr/nell_hair_salon_api/angel_guide.txt"
rule = open(rule_file, "r")  

agent_rule = rule.read()
agent_rule = agent_rule.replace('\t', ' ')     
agent_rule = agent_rule.replace('\n', ' ')     
agent_rule += f"Anote  a data e hora atual em caso de voce precisar: {datetime.now().strftime('%A, %d de %B de %Y')}."

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
    msg = data.get('question') 

    message_info["message"] = msg
    message_info["user"] = user

    msg = nucleoNeural(message_info) 
   
    prompt = "" 
    if previous_user == user: 
        conversation_history.append(f"'{msg}',")   
    else: 
        previous_user = user
        conversation_history.clear()

    prompt = "{'usuario': '%s', 'ultima_mensagem': '%s' , 'conversas_anteriores': '%s'}" % (user,msg,''.join(conversation_history))

    message=[
        {"role": "system", "content": agent_rule},
        {"role": "user", "content": prompt}
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
