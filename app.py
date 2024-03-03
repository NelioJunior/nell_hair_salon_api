import os
import openai
from neural import nucleoNeural
from datetime import datetime 
from flask import Flask, request, jsonify
from flask_cors import CORS
previous_user = "" 

message_info = {
                "user": "",
                "message" : "",
                "lastMessageTime": datetime.now().strftime("%H:%M"),  
                "pasta": "https://nelltek.ddns.net/nellSite/ClientesParceirosNell/gestorPai_SalaoConsultorioMVC/" 
}

# client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY")) 
client = openai.OpenAI(api_key='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') 

rule_file = "./angel_guide.txt"
rule = open(rule_file, "r")  

agent_rule = rule.read()
agent_rule = agent_rule.replace('\t', ' ')     
agent_rule = agent_rule.replace('\n', ' ')     
agent_rule += f"Anote  a data e hora atual em caso de voce precisar: {datetime.now().strftime('%A, %d de %B de %Y')}."

conversation_history = []

dba_content = (
    "You are a MySQL database administrator, and your task is to create SQL statements that help answer user questions."
    "First of all, look for the most appropriate SQL statement for user queries by searching for the '#user_request_or_question' hashtag."
    "The SQL statement will be just below, indicated by the #SQL hashtag."
    "However, if not found, you should create the SQL instructions yourself based on the data modeling described in the documentation."
    "Pay close attention to ALL association tables in the relationship between tables, as well as table attributes."
    f"In case of questions related to date, month and year, consider that the current date is {datetime.now().strftime('%A, %d de %B de %Y')}."
)

app = Flask(__name__)
CORS(app)
 
@app.route("/", methods=['GET'])
def root():
        return f"<h1>Nelltek LLM APIs. All Rights Reserved</h1>"

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
