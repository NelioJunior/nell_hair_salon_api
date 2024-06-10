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

create view funcionario_servico
  as 
  select * from SalaoConsultorio.funcionarioEspecialidade; 

create view agenda_servico 
  as 
  select * from SalaoConsultorio.agendaEspecialidade; 

create view agenda
   as 
   select 
		id_agenda,
		id_agenda_original,
		id_funcionario,
		id_cliente,
		dataHoraInicio data_hora_inicio,
		dataHoraFim  data_hora_fim,
		sessaoNumero sessao_numero,
		totalSessoes total_sessao,
		totalPreco total_preco,
		parcelarPrecoPorSessao preco_da_parcela_por_sessao, 
		enviado, 
		ativo        
       from SalaoConsultorio.agenda;

create view cliente
   as 
    select  
		id_cliente,
		nome,
		contato,
		telefone,
		aniversario,
		genero,
		observacaoCli observacao_sobre_o_cliente, 
		avatar,
		email,
		enviarEmail  enviar_email,  
		divulgacao,
		roboPodeAtender habilitado_atendimento_pelo_robo,
		roboPodeAgendar habilitado_agendamento_pelo_robo, 
		ativo
    from SalaoConsultorio.cliente; 
    
create view servico 
 as 
 select 
	id_especialidade,
	nome,
	palavrasChaves palavras_chave,
	descricao,
	avatar,
	emoji,
	preco,
	sessoes,
	tempoNecessarioPorSessao tempo_necessario_por_sessao,
	ativo
    from SalaoConsultorio.especialidade;

create view fluxo_de_caixa_item 
	as 
    select 
		id_fluxoCaixaItem id_fluxo_caixa_item,    
		id_fluxoCaixa id_fluxo_caixa,   
		id_agenda,
		id_cliente,
		id_funcionario,
		descricao,
		id_produto,
		quantidade,
		valor    
    from SalaoConsultorio.fluxoCaixaItem;    
    
create view fluxo_de_caixa
    as  
    select 
		id_fluxoCaixa,
		id_principal,
		id_funcionario,
		horaDataAbertura hora_data_abertura, 
		horaDataFechamento hora_data_fechamento,
		valorAbertura valor_abertura,
		valorFechamento valor_fechamento,
		dataHora data_hora, 
		valor,
		tipo,
		situacao,
		meioPgto meio_de_pagamento,
		diaPgtoCartao dia_de_pagamento_cartao,
		id_parcela,
		parcelas,
		observacao,
		ativo        
    from SalaoConsultorio.fluxoCaixa;
     
create view funcionario
    as 
    select  
        id_funcionario,
        nome,  
        apelido,
        id_cargo,
        telefone,
        cpfCnpj cpf_cnpj,  
        genero, 
        id_banco,
        entradaManha entrada_manha,
        saidaManha saida_manha,
        entradaTarde entrada_tarde,
        saidaTarde saida_tarde,
        entradaNoite entrada_noite,
        saidaNoite saida_noite,
        contaCorrente conta_corrente,
        modalidade,
        diaRemuneracao1 dia_remuneracao_1 ,
        percentagemRemuneracao1 percentagem_remuneracao1,
        diaRemuneracao2 dia_remuneracao_2,
        percentagemRemuneracao2 percentagem_remuneracao2,
        percentagemRemuneracaoGeral percentagem_remuneracao_geral ,
        remuneracaoFixa remuneracao_fixa,
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
    from SalaoConsultorio.funcionario ;

create view cargo 
    as 
    select * from SalaoConsultorio.cargo;
    
create view produto
    as 
    select 
		id_produto,
		nome,
		codigobarras codigo_barra,
		marca,
		linha,
		categoria,
		descricao,
		precoCompra preco_compra,
		precoVenda preco_venda,
		id_fornecedor,  
		prazoentrega prazo_entrega,
		tipovenda tipo_venda,
		tipoconsumo tipo_consumo,
		evitarsaidanegativa evitar_saida_negativa,
		estoqueatual estoque_atual,
		estoqueminimo estoque_minimo, 
		medida,
		observacao,
		avatar,
		ativo  
    from SalaoConsultorio.produto;    

create view fornecedor 
     as 
     select 
		id_fornecedor,
		nome,
		razaoSocial razao_fornecedor, 
		cnpjcpf cnpj_cpf, 
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

create view mes 
    as 
       select 
         id_mes, 
         nome     
    from SalaoConsultorio.mes;

create view feriado 
    as 
       select 
			id_feriado,
			dataFeriado data_feriado,
			nome ,
			ativo       
    from SalaoConsultorio.feriado; 

create view empresa 
     as 
       select 
			id_empresa,
			nomeEmpresa mome_empresa,
			telefone,
			responsavel,
			adesao,
			nomeUsuario nome_usuario,
			endereco,
			cep,
			email,
			cnpj,
			instagram,
			nomeBot,
			avatar,
			horario,
			atenderNaoCadastrados atender_nao_cadastrados,
			modalidade, 
			diaRemuneracao1 dia_remuneracao_1,
			percentagemRemuneracao1 percentagem_remuneracao_1,
			diaRemuneracao2 dia_remuneracao_2,
			percentagemRemuneracao2 percentagem_remuneracao_2,
			percentagemRemuneracaoGeral percentagem_remuneracao_geral,
			semana,
			ativo
           from SalaoConsultorio.empresa;
    
    create view compromissos_clientes_funcionarios 
         as     
			select a.id_agenda 
			 , a.data_hora_inicio
			 , a.data_hora_fim 
			 , a.id_funcionario
             , c.nome nome_cliente 
             , f.nome nome_funcionario  			 
			 from agenda a  
				 inner join funcionario f 
						 on a.id_funcionario = f.id_funcionario
				 left join cliente c 
						 on a.id_cliente = c.id_cliente                       
			 where a.data_hora_inicio > curdate() - interval 30 day   
			   and f.ativo = true
			order by a.data_hora_inicio,f.id_funcionario;     
    
    