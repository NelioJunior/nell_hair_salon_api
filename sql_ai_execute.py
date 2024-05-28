from tools import obter_chave_openai
from datetime import datetime 
from langchain_community.tools.sql_database.tool import QuerySQLDataBaseTool
from langchain_community.utilities import SQLDatabase
from langchain.chains import create_sql_query_chain
from langchain_openai import ChatOpenAI

chave_openai = obter_chave_openai()

db_user = "root"
db_password = "2246"
db_host = "177.143.21.214"
db_name = "SalaoConsultorio"
db = SQLDatabase.from_uri(f"mariadb+pymysql://{db_user}:{db_password}@{db_host}/{db_name}")

llm = ChatOpenAI(api_key=chave_openai,  model="gpt-3.5-turbo", temperature=0)
chain = create_sql_query_chain(llm, db)

def ask_to_the_database(query):
    execute_query = QuerySQLDataBaseTool(db=db)
    write_query = create_sql_query_chain(llm, db)
    chain = write_query | execute_query
    answer = chain.invoke({"question":  f"{query} - (data atual {datetime.now().strftime('%A, %d de %B de %Y')})"})

    return answer

if __name__ ==  '__main__':
    results = ask_to_the_database("me de o nome completo dos produtos com o nome que inicial em esmalte ")
    print (results)
