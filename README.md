# nell_hair_salon_api   (teste de conceito)

# Marketing -------------------------------------------------------------------------------------------------------------------------

  Que tal vender o nosso Modelo como um SLM - Small Languagem Model? 

## buscartratutor.json -  Regras  : ---------------------------------------------------------------------------------------------------

      -  Considerar a ordernação pela ordem de insert (id) 
      -  Usar gramatica "tarzan" todos verbos devem estar no infinitivo.
      -  Preferencia a palavra no femino, Exemplos: Obrigado se torna obrigada, masculino se torna masculina  
      -  todas as palavras no singular com excecao das horas 
      -  Evitar espaco em branco no inicio e no final , por exemplo ' centopeia ' 
      -  Frases com mais de uma palavrava devem prevalecer sobre frases de apenas uma palavra, e por ultimo por ordem alfabetica 
                                                                                               (ex: apenas prevalece sobre somente) 
                                                - sexo masculino

## TO DO ------------------------------------------------------------------------------------------------------------------------

  20/Abril/24 E' preciso uma mensagem adequanda para quando se cancela um agendamento e o cliente desiste de cancelar √.

  19/Abril/24 
    Verificar erro de resposta na mensagem do usuario "Eu quero mudar a cor do meu cabelo"

  17/Abril/24

    Imprementar consistencia para quando o usuario entrar com "Depois (depois) de amanha"  

    Fazer uma copia do celular virtual como uma rota do nell_hair_salon_api para testes.  √
    Quando a Angela escreveu "quero cancelar"  nao foi comprendido corretamente. √
    Testar, quando 2 ou mais usuarios interagem com a Angel.  √  (E' Bom fazer mais testes)  

  16/Abril/24

    Houve um caso em que foi solicitados alguns servicos, sendo que alguns destes nao eram feitos pelo mesmo funcionario, 
    a Angel pediu para separar o agendamentos em mais de um. Apos concordado e o cliente feito o primeiro, ela simplesmente
    encerrou sendo que seria melhor ela perguntar sobre outros servicos. apos o cliente aprovar o primero agendamento.

    Pode ser uma boa ideia você separar estes serviços em outros dias  (seria mais adequado outras sessoes?)

    Sera que da pra dar uma unica solucao ara estas duas questoes ?

      Tratar localizar datas para quando o usuario escreve "depois (e Ns depois) de amanha" 
      Tratar para para especificar melhor "agendar para depois do almoco, depois da academina, depois da novela" 


  14/Abril/24 
    Se o cliente entra com a data numerica, por exemplo "dia 17" a funcao buscarData() nao localiza.  √ 

  13/Abril/24 
    Preciso fazer uma bateria de testes de alteracao e cancelamento de reservas!!! √

  Em 12/Abril/24  removi da  linha 1157 de model.py a linha return msgResposta √

  Em 11/Abr/24 Na linha 1312 do model.py eu avancei um tab na linha abaixo, atencao nos testes para que isso nao tenha √
  resultado em problemas ...    
      
      msgResposta = listarFuncionariosDisponiveis(stts,respBaseConhecimento, msgResposta)

## SUGESTOES --------------------------------------------------------------------------------------------------------------------
USAR PLAYGROUND EM VEZ DO CHATGPT PARA CRIACAO DE PROMPTS, A DIFERENCAS DE RESULTADOS ENTRE O PLAYGROUND E O CHATGTP 
SENDO O PLAYGROUND MAIS DE ACORDO COM AS RESPOSTAS DA API

CUIDADO, ISSO E' QUASE UMA PEGADINHA !

  SE FOR COLOCADO A OPENAI KEY DIRETAMENTE "HARDCODE" E COMITADO, SIMPLEMENTE E' 
  CANCELADO ESTRA KEY E O SISTEMA PARA DE FUNCIONAR  

## Testes do modelo ------------------------------------------------------------------------------------------------------------------
Exemplo de teste utilizando terminal linux:

  curl -X POST -H "Content-Type: application/json" -d '{"question": "Quero marcar para a proxima terca ", "user":"Nell"}' localhost:8000/customer_service

### Execucao no ambiente de testes  

  E' necessario executar no terminal linux para execucao junto com o flask:

    ngrok http http://localhost:8080

    Apos executar o grok copiar e colar no local adequando em chat.js 

  Acesso ao ambiente de testes:

  #####

    https://nelltek.ddns.net/desenvolvimento/view/listaagenda.php      

---------------------------------------------------------------------------------------------------------------------------------------

Uma abordagem a ser considerada é usar a api gpt para analizar o que o cliente quer, de posse deste conhecimento processar a resposta 
certa, e finalmente executar a api para dar a interacao com o cliente 

Claro que nesta caso, o rol do system tera obviamente conteudos diferentes...

Testes ---------------------------------------------------------------------------------------------------------------------------------------

  Fazer 4 testes de inclusao de agendamento 
  Fazer 2 testes de exclusao de agendamento 
  Fazer 2 testes de alteracao de agendamento 
  Fazer 2 testes de lista de servicos
  Fazer 2 testes sem ser sinteticos, ou seja sem a ajuda do GPT.

Siga o passo-a-passo:

- Escoha um destes nomes de clientes: 
    -  Angela - sexo feminino   
    -  Bernadete - sexo feminino 
    -  Emmy - sexo feminino 
    -  Haroldo - sexo masculino 
    -  Mel - sexo feminino 
    -  Natasha - sexo feminino
    -  Pati - sexo feminino 
    -  Renato - sexo masculino 
    -  Ricardo - sexo masculino 
    -  Silva - sexo masculino
    -  Silvio - sexo masculino

- Crie uma personalidade para o cliente que você escolheu o nome e seja esta pessoa.
- Simule uma conversa entra você e uma recepcionista de salao de beleza chamada Angel. 
- O objetivo da conversa é você marcar, alterar ou cancelar um agendamento no salao .
- Nesta conversa você entrara com uma fala e esperara pela fala da atendente Angel.
- No incio de cada fala você ira colocar o nome da pessoa seguido por dois pontos (:)

- Comece saudando a recepcionista Angel e aguarde a fala dela.

Prompts auxilires ------------------------------------------------------------------------------------------------------------------

crie uma nova interacao escolhendo um cliente qualquer que voce escolher da lista e crie uma personalidade diferente da anterior. 
Inicie ja.

crie uma nova interacao para excluir algum dos agendamentos criados anteriormente. Inicie ja.

crie uma nova interacao para alterar algum dos agendamentos criados anteriormente. Inicie ja.

SQL auxiliar -------------------------------------------------------------------------------------------------------------------------

  select c.nome, a.* from agenda a inner JOIN cliente c on a.id_cliente = c.id_cliente where a.dataHoraInicio > '2024-04-21';

--------------------------------------------------------------------------------------------------------------------------------------

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

    Neste abaixo a parte do Leonard de Caprio é desnecessario, mas vale muito a pena estudar  
    Verificar se rola com o banco de dados mencionado

    https://blog.futuresmart.ai/langchain-sql-agents-openai-llms-query-database-using-natural-language    

## Exemplo de uso do comando curtl para testes local com endpoint customer_service

nelljr@raspberrypi:~ $ curl -X POST -H "Content-Type: application/json" -d '{"question": "Eu quero saber se tem uma cabelereira ai na quinta feira", "requester":"Angela"}' http://localhost:5000/customer_service
