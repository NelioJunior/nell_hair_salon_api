 /* 
    Script de criação de estrutura do banco de dados mysql BusinessInteligence
    
                                    	                     Nell Jr.

*/

set auto_increment_increment = 1;
use BusinessInteligence;

drop view if exists funcionario_servico;
drop view if exists agenda_servico;
drop view if exists agenda;
drop view if exists cliente;
drop view if exists servico;
drop view if exists fluxo_de_caixa_item; 
drop view if exists fluxo_de_caixa; 
drop view if exists funcionario;
drop view if exists cargo;
drop view if exists produto;                 
drop view if exists fornecedor;
drop view if exists mes; 
drop view if exists feriado;
drop view if exists empresa; 
drop view if exists compromissos_clientes_funcionarios;

/*
use SalaoConsultorio;
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'empresa';
use BusinessInteligence; 
*/

create view funcionario_servico as 
  select * from SalaoConsultorio.funcionarioEspecialidade;

create view agenda_servico as 
  select * from SalaoConsultorio.agendaEspecialidade;

create view agenda as 
  select 
    id_agenda,
    id_agenda_original,
    id_funcionario,
    id_cliente,
    NULLIF(dataHoraInicio, '') as data_hora_inicio,
    NULLIF(dataHoraFim, '') as data_hora_fim,
    sessaoNumero as sessao_numero,
    totalSessoes as total_sessao,
    totalPreco as total_preco,
    parcelarPrecoPorSessao as preco_da_parcela_por_sessao,
    enviado, 
    ativo        
  from SalaoConsultorio.agenda;

create view cliente as 
  select  
    id_cliente,
    nome,
    contato,
    telefone,
    aniversario,
    genero,
    observacaoCli as observacao_sobre_o_cliente,
    avatar,
    email,
    enviarEmail as enviar_email,
    divulgacao,
    roboPodeAtender as habilitado_atendimento_pelo_robo,
    roboPodeAgendar as habilitado_agendamento_pelo_robo, 
    ativo
  from SalaoConsultorio.cliente;

create view servico as 
  select 
    id_especialidade,
    nome,
    palavrasChaves as palavras_chave,
    descricao,
    avatar,
    emoji,
    preco,
    sessoes,
    tempoNecessarioPorSessao as tempo_necessario_por_sessao,
    ativo
  from SalaoConsultorio.especialidade;

create view fluxo_de_caixa_item as 
  select 
    id_fluxoCaixaItem as id_fluxo_caixa_item,    
    id_fluxoCaixa as id_fluxo_caixa,   
    id_agenda,
    id_cliente,
    id_funcionario,
    descricao,
    id_produto,
    quantidade,
    valor    
  from SalaoConsultorio.fluxoCaixaItem;

create view fluxo_de_caixa as  
  select 
    id_fluxoCaixa,
    id_principal,
    id_funcionario,
    NULLIF(horaDataAbertura, '') as hora_data_abertura,
    NULLIF(horaDataFechamento, '') as hora_data_fechamento,
    valorAbertura as valor_abertura,
    valorFechamento as valor_fechamento,
    NULLIF(dataHora, '') as data_hora,
    valor,
    tipo,
    situacao,
    meioPgto as meio_de_pagamento,
    diaPgtoCartao as dia_de_pagamento_cartao,
    id_parcela,
    parcelas,
    observacao,
    ativo        
  from SalaoConsultorio.fluxoCaixa;

create view funcionario as 
  select  
    id_funcionario,
    nome,  
    apelido,
    id_cargo,
    NULLIF(telefone, '') as telefone,
    NULLIF(cpfCnpj, '') as cpf_cnpj,  
    genero, 
    id_banco,
    NULLIF(entradaManha, '') as entrada_manha,
    NULLIF(saidaManha, '') as saida_manha,
    NULLIF(entradaTarde, '') as entrada_tarde,
    NULLIF(saidaTarde, '') as saida_tarde,
    NULLIF(entradaNoite, '') as entrada_noite,
    NULLIF(saidaNoite, '') as saida_noite,
    NULLIF(contaCorrente, '') as conta_corrente,
    modalidade,
    diaRemuneracao1 as dia_remuneracao_1,
    percentagemRemuneracao1 as percentagem_remuneracao1,
    diaRemuneracao2 as dia_remuneracao_2,
    percentagemRemuneracao2 as percentagem_remuneracao2,
    percentagemRemuneracaoGeral as percentagem_remuneracao_geral,
    remuneracaoFixa as remuneracao_fixa,
    domingo,
    segunda,
    terca,
    quarta,
    quinta,
    sexta,
    sabado,
    mes,
    cor,
    avatar,
    ativo        
  from SalaoConsultorio.funcionario;

create view cargo as 
  select * from SalaoConsultorio.cargo;

create view produto as 
  select 
    id_produto,
    nome,
    codigobarras as codigo_barra,
    marca,
    linha,
    categoria,
    descricao,
    precoCompra as preco_compra,
    precoVenda as preco_venda,
    id_fornecedor,  
    prazoentrega as prazo_entrega,
    tipovenda as tipo_venda,
    tipoconsumo as tipo_consumo,
    evitarsaidanegativa as evitar_saida_negativa,
    estoqueatual as estoque_atual,
    estoqueminimo as estoque_minimo, 
    medida,
    observacao,
    avatar,
    ativo  
  from SalaoConsultorio.produto;

create view fornecedor as 
  select 
    id_fornecedor,
    nome,
    razaoSocial as razao_fornecedor, 
    cnpjcpf as cnpj_cpf, 
    responsabel, 
    email,
    telefone,
    celular,
    site,
    cep,
    endereco,
    bairro,
    cidade,
    estado,
    observacao,
    avatar,
    ativo     
  from SalaoConsultorio.fornecedor;

create view mes as 
  select 
    id_mes, 
    nome     
  from SalaoConsultorio.mes;

create view feriado as 
  select 
    id_feriado,
    NULLIF(dataFeriado, '') as data_feriado,
    nome,
    ativo       
  from SalaoConsultorio.feriado;

create view empresa as 
  select 
    id_empresa,
    nomeEmpresa as nome_empresa,
    telefone,
    responsavel,
    adesao,
    nomeUsuario as nome_usuario,
    endereco,
    cep,
    email,
    cnpj,
    instagram,
    nomeBot as nome_bot,
    avatar,
    horario,
    atenderNaoCadastrados as atender_nao_cadastrados,
    modalidade, 
    diaRemuneracao1 as dia_remuneracao_1,
    percentagemRemuneracao1 as percentagem_remuneracao_1,
    diaRemuneracao2 as dia_remuneracao_2,
    percentagemRemuneracao2 as percentagem_remuneracao_2,
    percentagemRemuneracaoGeral as percentagem_remuneracao_geral,
    semana,
    ativo
  from SalaoConsultorio.empresa;

create view compromissos_clientes_funcionarios as     
  select 
    a.id_agenda,
    NULLIF(a.data_hora_inicio, '') as data_hora_inicio,
    NULLIF(a.data_hora_fim, '') as data_hora_fim,
    a.id_funcionario,
    c.nome as nome_cliente,
    f.nome as nome_funcionario
  from 
    agenda a  
  inner join 
    funcionario f on a.id_funcionario = f.id_funcionario
  left join 
    cliente c on a.id_cliente = c.id_cliente
  where 
    a.data_hora_inicio > curdate() - interval 30 day
    and f.ativo = true
  order by 
    a.data_hora_inicio, f.id_funcionario;

create view pesquisa_satisfacao as 
   select * from SalaoConsultorio.pesquisaSatisfacao ;
