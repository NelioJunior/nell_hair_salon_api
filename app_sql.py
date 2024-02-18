from langchain_community.utilities import SQLDatabase
from langchain.chains import create_sql_query_chain
from langchain_openai import ChatOpenAI

db_user = "root"
db_password = "2246"
db_host = "177.143.21.214"
db_name = "salon_and_office"
db = SQLDatabase.from_uri(f"mysql+pymysql://{db_user}:{db_password}@{db_host}/{db_name}")


llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0)
chain = create_sql_query_chain(llm, db)
response = chain.invoke({"question": "Quantas pessoas tem cadastado na tabela cliente?"})

print(response) 