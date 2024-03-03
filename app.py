import os
import openai
from neural import nucleoNeural
from datetime import datetime 
from flask import Flask, request, jsonify
from flask_cors import CORS
previous_user = "" 

app = Flask(__name__)
CORS(app)
 
@app.route("/", methods=['GET'])
def root():
        return f"<h1>Nelltek LLM APIs. All Rights Reserved</h1>"

if __name__ ==  '__main__':
    app.run(host="0.0.0.0", debug=True, port=8000)    
