import os
import openai
from neural import nucleoNeural
import locale
from datetime import datetime 
from flask import Flask, request, jsonify
from flask_cors import CORS

message_info = {
                "requester": "",
                "message" : "",
                "lastMessageTime": datetime.now().strftime("%H:%M"),  
                "pasta": "https://nelltek.ddns.net/nellSite/ClientesParceirosNell/gestorPai_SalaoConsultorioMVC/" 
}

client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY")) 

rule_file = "./angel_guide.txt"
rule = open(rule_file, "r")  
system_msg = rule.read()
system_msg = system_msg.replace('\t', ' ')     
system_msg = system_msg.replace('\n', ' ')     

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
    data = request.get_json()
    message_info["message"] = data.get('question') 
    message_info["requester"] = data.get('requester') 

    response = nucleoNeural(message_info) 
    response = f"{message_info['requester']}: {response}"

    message=[
        {"role": "system", "content": system_msg},
        {"role": "user", "content": response}
    ]

    chat_completion = client.chat.completions.create(
       messages=message,
       model="gpt-3.5-turbo",
       temperature=0.7
    )
    response = chat_completion.choices[0].message.content

    return jsonify({'answer': response})

if __name__ ==  '__main__':
    app.run(host="0.0.0.0", debug=True, port=5000)    
