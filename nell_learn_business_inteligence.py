
from llama_index import VectorStoreIndex, SimpleDirectoryReader           # Em caso de erro, tentar resolver executando  sudo apt-get install libopenblas-dev  
                                                                          # Lla usa openai por baixo dos panos definido pela variavel de ambiente OPENAI_API_KEY

documents = SimpleDirectoryReader("./business_inteligence_data").load_data()
index = VectorStoreIndex.from_documents(documents)
index.storage_context.persist(persist_dir="./business_inteligence_storage")
print ("Completed indexing")
