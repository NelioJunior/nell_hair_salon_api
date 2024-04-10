# nell_hair_salon_api

## buscartratutor.json -  Regras  : ---------------------------------------------------------------------------------------------------

      -  Considerar a ordernação pela ordem de insert (id) 
      -  Usar gramatica "tarzan" todos verbos devem estar no infinitivo.
      -  Preferencia a palavra no femino, Exemplos: Obrigado se torna obrigada, masculino se torna masculina  
      -  todas as palavras no singular com excecao das horas 
      -  Evitar espaco em branco no inicio e no final , por exemplo ' centopeia ' 
      -  Frases com mais de uma palavrava devem prevalecer sobre frases de apenas uma palavra, e por ultimo por ordem alfabetica 
                                                                                               (ex: apenas prevalece sobre somente) 
                                                
----------------------------------------------------------------------------------------------------------------------------------------


USAR PLAYGROUND EM VEZ DO CHATGPT PARA CRIACAO DE PROMPTS, A DIFERENCAS DE RESULTADOS ENTRE O PLAYGROUND E O CHATGTP 
SENDO O PLAYGROUND MAIS DE ACORDO COM AS RESPOSTAS DA API

TO DO ------------------------------------------------------------------------------------------------------------------------

CUIDADO, ISSO E' QUASE UMA PEGADINHA !

SE FOR COLOCADO A OPENAI KEY DIRETAMENTE "HARDCODE" E COMITADO, SIMPLEMENTE E' CANCELADO ESTRA KEY E O SISTEMA PARA DE FUNCIONAR  

---------------------------------------------------------------------------------------------------------------------------------------

Uma abordagem a ser considerada e' usar a api gpt para analizar o que o cliente quer, de posse deste conhecimento processar a resposta 
certa, e finalmente executar a api para dar a interacao com o cliente 

Claro que nesta caso, o rol do system tera obviamente conteudos diferentes...

---------------------------------------------------------------------------------------------------------------------------------------------------
Siga o passo-a-passo:

- Escoha um destes nomes de clintes: Angela, Bernadete, Emmy, Haroldo, Mel, Natasha,Pati, Renato, Ricardo, Silva ou Silvio.
- Crie uma personalidade para o nome de cliente que voce escolheu e seja esta pessoa.
- Simule uma conversa entra voce e uma recepcionista de salao de beleza chamada Angel. O objetivo da conversa e' voce marcar um agendamento no salao.
- Nesta conversa voce entrara com uma fala e esperara pela fala da atendente Angel.
- No incio de cada fala voce ira colocar o nome da pessoa seguido por dois pontos (:)
- Comece saudando a recepcionista Angel e aguarde a fala da Angel.
-------------------------------------------------------------------------------------------------------------------------------------------------


O TRECHO ABAIXO DEVERA SER REMOVIDO PARA A API IA DE BI 

Questoes testes ✓

Qual é o serviço mais demandado pelos clientes?    
Quais são os 5 produtos mais vendidos no salão?   
Qual é a taxa de ocupação média dos funcionários ao longo da semana?  
Quais são os horários de pico para cada tipo de serviço?  
Quais são os serviços menos procurados pelos clientes?   
Qual é a margem de lucro média dos produtos de beleza?   
Qual é a taxa de cancelamento ou não comparecimento dos clientes agendados? 
Quais são os itens de estoque com maior saída? 
Quais são os custos operacionais mais significativos? 
Como está a satisfação dos clientes em relação aos serviços prestados? 

02/Marco/24  Nao sei porque perdi a api key da openai , tive que gerar outra 

Glossário 

LangChain e LlamaIndex são duas bibliotecas valiosas para o desenvolvimento de aplicativos alimentados por modelos de linguagem. Vou explicar as principais diferenças entre elas:

LangChain:
Propósito: O LangChain é mais flexível e oferece uma ampla gama de capacidades e integração de ferramentas. Ele é projetado para interagir com modelos de linguagem grandes (LLMs) e fornece muitas ferramentas prontas para uso.
Componentes Principais:
Chains: Permite a combinação de componentes, como criar um prompt e consultar um LLM.
PromptTemplate: Ajuda a criar prompts personalizados.
LLMChain: Facilita a interação com um LLM.
Personalização: O LangChain permite que os usuários personalizem o comportamento de suas aplicações.
LlamaIndex:
Propósito: O LlamaIndex é otimizado para indexação e recuperação de dados. Ele é especificamente projetado para construir aplicativos de busca e recuperação.
Interface Simples: O LlamaIndex oferece uma interface simples para consultar LLMs e recuperar documentos relevantes.
Eficiência: É eficiente em tarefas de indexação e recuperação.
Em resumo, se você precisa de uma solução mais geral e flexível, o LangChain é uma boa escolha. Por outro lado, se você está focado em indexação e recuperação eficientes, o LlamaIndex é mais relevante. Lembre-se de considerar o contexto e os requisitos específicos do seu projeto ao escolher entre eles

Estudar 

    SQL com  LangChain

    https://python.langchain.com/docs/use_cases/sql/
    https://python.langchain.com/docs/use_cases/sql/quickstart

    Neste abaixo a parte do Leonard de Caprio e' desnecessario, mas vale muito a pena estudar  
    Verificar se rola com o banco de dados mencionado

    https://blog.futuresmart.ai/langchain-sql-agents-openai-llms-query-database-using-natural-language    



## Exemplo de uso do comando curtl para testes local com endpoint customer_service

nelljr@raspberrypi:~ $ curl -X POST -H "Content-Type: application/json" -d '{"question": "Eu quero saber se tem uma cabelereira ai na quinta feira", "requester":"Angela"}' http://localhost:5000/customer_service
