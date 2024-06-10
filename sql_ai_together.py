from tools import obter_chave_together
from datetime import datetime 

from langchain_community.tools.sql_database.tool import QuerySQLDataBaseTool
from langchain_community.utilities import SQLDatabase
from langchain.chains import create_sql_query_chain
from langchain_together import ChatTogether

chave_together = obter_chave_together()

db_user = "root"
db_password = "2246"
db_host = "192.168.0.131"
db_name = "BusinessInteligence"
db = SQLDatabase.from_uri(f"mariadb+pymysql://{db_user}:{db_password}@{db_host}/{db_name}",view_support = True)                          

llm = ChatTogether(api_key=chave_together,  model="meta-llama/Llama-3-70b-chat-hf", temperature=0)

def get_sql_statement(query):
    chain = create_sql_query_chain(llm, db)
    answer = chain.invoke({"question":  f"{query} - (data atual {datetime.now().strftime('%A, %d de %B de %Y')}"})

    return answer

def ask_to_the_database(query):

    try: 
        execute_query = QuerySQLDataBaseTool(db=db)
        write_query = create_sql_query_chain(llm, db)
        chain = write_query | execute_query
        answer = chain.invoke({"question":  f"{query} - (data atual {datetime.now().strftime('%A, %d de %B de %Y')}"})
    except: 
        answer = "Responda da melhor maneira possivel" 

    return answer

if __name__ ==  '__main__':

    query = "Liste os profissionais que nao tabalham a tarde e nem a noite"  

    results = get_sql_statement(query)

    print (results)
