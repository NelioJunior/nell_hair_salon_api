from tools import obter_chave_openai
from datetime import datetime 
from langchain_community.tools.sql_database.tool import QuerySQLDataBaseTool
from langchain_community.utilities import SQLDatabase
from langchain.chains import create_sql_query_chain
from langchain_openai import ChatOpenAI

chave_openai = obter_chave_openai()

db_user = "root"
db_password = "2246"
db_host = "192.168.0.131"
db_name = "BusinessInteligence"
db = SQLDatabase.from_uri(f"mariadb+pymysql://{db_user}:{db_password}@{db_host}/{db_name}")

llm = ChatOpenAI(api_key=chave_openai,  model="gpt-3.5-turbo", temperature=0)

def get_sql_statement(query):
    chain = create_sql_query_chain(llm, db)
    answer = chain.invoke({"question":  f"{query} - (data atual {datetime.now().strftime('%A, %d de %B de %Y')}"})

    return answer

def ask_to_the_database(query):

    execute_query = QuerySQLDataBaseTool(db=db)
    write_query = create_sql_query_chain(llm, db)
    chain = write_query | execute_query
    answer = chain.invoke({"question":  f"{query} - (data atual {datetime.now().strftime('%A, %d de %B de %Y')}"})

    return answer

if __name__ ==  '__main__':

    # Eu acho que o database_guide.txt esta muito grande - Nell Jr 28/Maio.
    # Sera que e' possivel quebra-lo em setores   (Se e' que esta servindo pra alguma coisa)

    query = "Me de o nome dos clientes que tiveram agendamentos realizados no mes de maio desta ano de 2024?"   

    results = get_sql_statement(query)
    print (results)
