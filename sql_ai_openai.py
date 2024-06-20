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
db_host = "raspinellserver.local"
db_name = "BusinessInteligence"
db = SQLDatabase.from_uri(
                          f"mariadb+pymysql://{db_user}:{db_password}@{db_host}/{db_name}"
                          ,view_support = True
                          )

db_config = {'host': db_host,'user': db_user,'password': db_password,'database': db_name}
conn = mysql.connector.connect(host=db_host,user=db_user,password=db_password,database=db_name)

llm = ChatOpenAI(api_key=chave_openai,  model="gpt-3.5-turbo", temperature=0)

rule_file = "/home/nelljr/nell_hair_salon_api/database_guide.txt"
rule = open(rule_file, "r")  
dba_rule = rule.read()

def get_sql_statement_and_execution (query):

    cursor = conn.cursor()
    try: 
        chain = create_sql_query_chain(llm, db)

        query  = chain.invoke({
            "question": f"{query} / data atual {datetime.now().strftime('%A, %d de %B de %Y')}) / regras: {dba_rule}"
        })

        query = query.replace("LIMIT 5;", "")    # palhativo  -- Nell 12 Jun 24

        print(query)

        cursor.execute(query)

        answer = []
        resultados = cursor.fetchall()

        for linha in resultados:
            if linha[0] is not None:
                 answer.append(linha)

        if len(answer) == 0:
             answer = ("Comunique que,infelizmente, a busca da informação desejada resultou em nada."
                       "Sugira ao usuário que refaça a pergunta." )

    except: 
        answer = "Responda da melhor maneira possivel" 

    cursor.close()

    return answer

def ask_to_the_database(query):

    try: 
        execute_query = QuerySQLDataBaseTool(db=db)
        write_query = create_sql_query_chain(llm, db)
        chain = write_query | execute_query
        answer = chain.invoke({
            "question": f"{query} - (data atual {datetime.now().strftime('%A, %d de %B de %Y')}) -({dba_rule})",
        })

    except: 
        answer = "Responda da melhor maneira possivel" 

    return answer

if __name__ ==  '__main__':

    query = "Quais sao os clientes que possuem agendamento marcados para o dia 14 deste mes?" 
    results = get_sql_statement_and_execution(query)

    print (results)
