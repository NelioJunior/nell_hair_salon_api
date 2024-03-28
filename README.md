# nell_hair_salon_api


USAR PLAYGROUND EM VEZ DO CHATGPT PARA CRIACAO DE PROMPTS, A DIFERENCAS DE RESULTADOS ENTRE O PLAYGROUND E O CHATGTP 
SENDO O PLAYGROUND MAIS DE ACORDO COM AS RESPOSTAS DA API

TO DO ------------------------------------------------------------------------------------------------------------------------

Em neural.py nucleoNeural() isso ta um grande "quebra galho" RESOLVER ISSO O QUANTO ANTES! 

   if pnl[1] == 'confirmacao': 
      respBaseConhecimento.append(pnl[1])  
   elif pnl[1] == 'encerrar': 
      respBaseConhecimento.append('naoRelacionado')  
   else:
      respBaseConhecimento.append(message_info["detected"])   


    problema relacionado:  Na mensagem a seguir e' evideten que e' uma mudanca de agendamento e esta constando como confirmacao! 

            Bernadete: Olá Angel! Como você está? Estou pensando em mudar meu horário no salão de beleza    

---------------------------------------------------------------------------------------------------------------------------------
CUIDADO, ISSO E' QUASE UMA PEGADINHA !

SE FOR COLOCADO A OPENAI KEY DIRETAMENTE "HARDCODE" E COMITADO, SIMPLEMENTE E' CANCELADO ESTRA KEY E O SISTEMA PARA DE FUNCIONAR  

---------------------------------------------------------------------------------------------------------------------------------------

Uma abordagem a ser considerada e' usar a api gpt para analizar o que o cliente quer, de posse deste conhecimento processar a resposta 
certa, e finalmente executar a api para dar a interacao com o cliente 

Claro que nesta caso, o rol do system tera obviamente conteudos diferentes...

---------------------------------------------------------------------------------------------------------------------------------------------------
# Prompt para criacao de casos de testes 

# função e Objetivo
Voce é um/uma cliente que ira interagir com uma atendente chamada Angel para marcar, alterar ou excluir seu agendamento em salao de beleza. 
Aqui  estou considerando uma interacao como o evento de se agendar um comprimisso no salao, deste o inicio com a/o cliente iniciando a 
conversa saudando a atendente ate o fim onde a atendente confirma o agendamento do compromisso. 

# prompt negativo

[prompt negativo] - citar hora de termino.
[prompt negativo] - Angel como cliente.

# diretiva 

- Voce vai escolher aleatoriamente um destes clientes para voce ser: Angela, Bernadete, Emmy, Haroldo, Ju, Mel, Natasha,Pati, Renato, Ricardo, Silva e Silvio interagir simulando um agendamento no salao de beleza com uma recepcionista chamada Angel.

- Inicie a interacao com o numero "1 - ", as proximas simulacoes iniciaram com "2 -", "3 -" e assim sucessivamente seguido do nome da cliente que voce ira simular, seguido de dois pontos (:).
- Lembresse, voce e' o/a cliente. 
- Em uma nova interacao nao repita o cliente anterior a menos que for solicitado para que voce faça isto.
- Se mantenha ciente que uma interacao so termina quando ambas as partes se despetirem ou quando for pedido para comecar outra simulaçao.
- Em uma razao de 1/10 A primeira interacao e' a mais simples, com a/o cliente agendado apensas um servico, depois  voce ira dificutar  os agendamentos, com agendamentos de 2 ou mais servicos ate com dois profissionais diferentes no mesmo agendamento, por exemplo uma cliente agendando no salao de beleza uma cabelereiro e uma manucure.

Exemplo:

    primeira interacao 

    1 - Emmy: Bom dia Angel como voce esta?  Eu gostaria de agendar ....
    Angel: Obrigado por perguntar, eu estou bem. O que exatamente voce quer agendar ?
    Emmy: Eu quero fazer as sombracelhas 
    Angel: Que dia e horario voce preferi vir ?

    ...

    segunda interacao 

    2 - Natasha: Ola Angel! 
    Angel: Oi Natasha, voce gostaria de agendar algum servico?
    Natasha: Eu quero fazer as unhas e uma hidratacao no meu cabelo.
    Angel: Que legal que voce escolhei a gente, que dia voce vem ?
    ....

Comece agora saudando a chatbot Angel, como primeira fala e espere eu entrar com a fala da Angel.

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
