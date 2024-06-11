import mysql.connector
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
db = SQLDatabase.from_uri(
                          f"mariadb+pymysql://{db_user}:{db_password}@{db_host}/{db_name}"
                          ,view_support = True
                          )

db_config = {'host': db_host,'user': db_user,'password': db_password,'database': db_name}
conn = mysql.connector.connect(host=db_host,user=db_user,password=db_password,database="BusinessInteligence")

llm = ChatOpenAI(api_key=chave_openai,  model="gpt-3.5-turbo", temperature=0)

dba_content = ("Nas consultas, usar like para os campos 'nome', 'nome_cliente' , 'nome_funcionario' "
                "e com coringa(%) no FINAL da string a ser buscada."
                "Exemplo: Select * from aluno where nome_aluno like 'johnny%'"
            )     

def get_sql_statement(query):
    chain = create_sql_query_chain(llm, db)
    query  = chain.invoke({
        "question": f"{query} - (data atual {datetime.now().strftime('%A, %d de %B de %Y')}) -({dba_content})",
    })

    print(query)

    cursor = conn.cursor()
    cursor.execute(query , multi=True)

    answer = []
    resultados = cursor.fetchall()

    for linha in resultados:
        answer.append(linha)

    cursor.close()
    conn.close()      

    return answer

def ask_to_the_database(query):

    try: 
        execute_query = QuerySQLDataBaseTool(db=db)
        write_query = create_sql_query_chain(llm, db)
        chain = write_query | execute_query
        answer = chain.invoke({
            "question": f"{query} - (data atual {datetime.now().strftime('%A, %d de %B de %Y')}) -({dba_content})",
        })

    except: 
        answer = "Responda da melhor maneira possivel" 

    return answer

if __name__ ==  '__main__':

    query = "Liste todos os profissionais do estabelecimento"  
    results = get_sql_statement(query)

    print (results)
