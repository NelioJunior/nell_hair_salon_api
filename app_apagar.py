import os 
from langchain_community.utilities import SQLDatabase
from langchain.chains import create_sql_query_chain
from langchain_openai import ChatOpenAI

db = SQLDatabase.from_uri("mysql+pymysql://root:2246@177.143.21.214/SalaoConsultorio")
# print(db.dialect)
# print(db.get_usable_table_names())
# print(db.run("SELECT * FROM cliente LIMIT 10;"))
# os.environ["TOGETHER_API_KEY"] = "22f11c536f8f545095f63d82203910d048705c3876fbe55ac717fcd31774c352"

# TALVEZ SEJA UMA BOA IDEIA TESTAR O TOGETHER - Nell Jr - Fev/24

OPENAI_API_KEY = os.environ["OPENAI_API_KEY"] 

llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0, max_tokens=6000)
chain = create_sql_query_chain(llm, db)
response = chain.invoke({"question": "select 'Hello World' as msg ;"})


print(response)


