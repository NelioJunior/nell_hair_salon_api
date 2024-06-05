/* 
    Script de criação de estrutura do banco de dados mysql salao_consultorio
    
						            	                             Nell Jr.


*/

set auto_increment_increment = 1;
use SalaoConsultorio;

drop table if exists funcionarioEspecialidade;
drop table if exists agendaEspecialidade;
drop table if exists agenda;
drop table if exists cliente;
drop table if exists grupo;
drop table if exists grupoCliente;
drop table if exists especialidade;
drop table if exists fluxoCaixaItem; 
drop table if exists fluxoCaixa; 
drop table if exists funcionario;
drop table if exists cargo;
drop table if exists produto;                         
drop table if exists fornecedor;
drop table if exists mes; 
drop table if exists feriado;
drop table if exists campanhaGrupo; 
drop table if exists campanha; 
drop table if exists empresa; 

drop trigger if exists after_insert_agenda;
drop trigger if exists after_update_agenda;
drop trigger if exists after_delete_agenda;
drop trigger if exists after_insert_cliente;
drop trigger if exists after_update_cliente;
drop trigger if exists after_delete_cliente;

create table if not exists empresa (id_empresa int auto_increment primary key,
                                    nomeEmpresa varchar(100) not null,
                                    telefone varchar(20) not null,
                                    responsavel varchar(200) not null,
                                    adesao varchar(20) not null,
                                    nomeUsuario varchar(50) null, 
                                    endereco varchar(255) not null,
                                    cep varchar(10) not null,
                                    email varchar(100) not null,
                                    cnpj varchar(18) null,
                                    instagram varchar(200) null, 
                                    nomeBot  varchar(100) null, 
                                    avatar varchar(100) null, 
                                    horario json not null, 
                                    atenderNaoCadastrados int not null default true,
                                    modalidade varchar(20) not null,
                                    diaRemuneracao1 varchar(2) not null default "01",
                                    percentagemRemuneracao1 int not null default 0,
                                    diaRemuneracao2 varchar(2) default "00",
                                    percentagemRemuneracao2 int not null default 0,
                                    percentagemRemuneracaoGeral int not null default 0,
                                    semana json not null, 
                                    ativo integer default 1 );

create table if not exists campanha ( id_campanha  integer primary key auto_increment
                                     ,imagem varchar(45) null 
                                     ,imagemPropriedade  varchar(80)  default '' 
                                     ,nome varchar(100) 
                                     ,nomeArquivoTransmitido varchar(100) 
                                     ,dataHoraUltimoDisparo datetime 
                                     ,texto text
                                     ,ativo integer default 1);
                                     
create table if not exists campanhaGrupo( id_campanha  integer 
                                         ,id_grupo  integer
                                         ,foreign key(id_campanha) references campanha(id_campanha) on delete cascade) ;

create table if not exists  mes ( id_mes integer primary key auto_increment 
                                  ,nome varchar(20));  

insert into mes (nome) values ('Janeiro') 
                             ,('Fevereiro') 
                             ,('Março') 
                             ,('Abril') 
                             ,('Maio') 
                             ,('Junho') 
                             ,('Julho') 
                             ,('Agosto') 
                             ,('Setembro') 
                             ,('Outrubro') 
                             ,('Novembro') 
                             ,('Dezembro');  

create table if not exists feriado (id_feriado integer primary key auto_increment
                                   ,dataFeriado datetime 
                                   ,nome varchar(100) not null 
                                   ,ativo integer default 1);
                                   
	insert into feriado (dataFeriado, nome, ativo) 
                values ('2020-01-01' , 'Confraternização Universal', 1) 
						,('2020-02-24', 'carnaval' ,0)
						,('2020-02-25', 'carnaval' ,0)                      
						,('2020-02-26', 'Quarta-feira de Cinzas' ,0)
						,('2020-04-10', 'Sexta-Feira Santa' ,  1) 
						,('2020-04-21', 'Tiradentes ' ,  1) 
						,('2020-05-01', 'Dia do trabalho', 1) 
						,('2020-06-11', 'Corpus Christi', 1) 
						,('2020-09-07', 'Independência do Brasil', 1) 
						,('2020-10-12', 'Nossa Senhora Aparecida', 1) 
						,('2020-11-02', 'Finados', 1)  
						,('2020-11-15', 'Programação da República', 1)  
						,('2020-12-24', 'Vespera de natal', 0)  
						,('2020-12-25', 'natal', 1)
						,('2020-12-31', 'Vespera de ano novo', 1)
						,('2021-01-01' , 'Confraternização Universal', 0) 
						,('2021-02-15', 'carnaval' ,0)
						,('2021-02-16', 'carnaval' ,0)                      
						,('2021-02-17', 'Quarta-feira de Cinzas' ,0)
						,('2021-04-02', 'Sexta-Feira Santa' ,  1) 
						,('2021-04-21', 'Tiradentes ' ,  0) 
						,('2021-05-01', 'Dia do trabalho', 1) 
						,('2021-06-03', 'Corpus Christi', 1) 
						,('2021-09-07', 'Independência do Brasil', 1) 
						,('2021-10-12', 'Nossa Senhora Aparecida', 1) 
						,('2021-10-31', 'haloween - Dia das bruxas', 0)
						,('2021-11-02', 'Finados', 1)  
						,('2021-11-15', 'Programação da República', 1)  
						,('2021-12-24', 'Vespera de natal', 0)  
						,('2021-12-25', 'natal', 1)
						,('2021-12-31', 'Vespera de ano novo', 0)
						,('2022-01-01', 'Confraternização Universal', 1)
						, ('2022-02-25', 'Carnaval', 0)
						, ('2022-04-15', 'Sexta-feira Santa', 0)
						, ('2022-04-21', 'Tiradentes', 0)
						, ('2022-05-01', 'Dia do Trabalho', 1)
						, ('2022-06-15', 'Corpus Christi', 0)
						, ('2022-09-07', 'Independência do Brasil', 0)
						, ('2022-10-12', 'Nossa Senhora Aparecida', 0)
						, ('2022-11-02', 'Finados', 0)
						, ('2022-11-15', 'Proclamação da República', 0)
						, ('2022-12-25', 'Natal', 1)
						, ('2023-01-01', 'Confraternização Universal', 1)
						, ('2023-02-14', 'Carnaval', 0)
						, ('2023-04-07', 'Sexta-feira Santa', 0)
						, ('2023-04-21', 'Tiradentes', 0)
						, ('2023-05-01', 'Dia do Trabalho', 1)
						, ('2023-06-06', 'Corpus Christi', 0)
						, ('2023-09-07', 'Independência do Brasil', 0)
						, ('2023-10-12', 'Nossa Senhora Aparecida', 0)
						, ('2023-11-02', 'Finados', 0)
						, ('2023-11-15', 'Proclamação da República', 0)
						, ('2023-12-25', 'Natal', 1)
						, ('2024-01-01', 'Confraternização Universal', 1)
						, ('2024-02-25', 'Carnaval', 0)
						, ('2024-03-29', 'Sexta-feira Santa', 0)
						, ('2024-04-21', 'Tiradentes', 0)
						, ('2024-05-01', 'Dia do Trabalho', 1)
						, ('2024-05-30', 'Corpus Christi', 0)
						, ('2024-09-07', 'Independência do Brasil', 0)
						, ('2024-10-12', 'Nossa Senhora Aparecida', 0)
						, ('2024-11-02', 'Finados', 0)
						, ('2024-11-15', 'Proclamação da República', 0)
						, ('2024-12-25', 'Natal', 1);                      

create table if not exists fornecedor (id_fornecedor integer primary key auto_increment
									   ,nome varchar(50) not null
									   ,razaoSocial  varchar(100) null
									   ,cnpjcpf varchar(20) null 
									   ,responsabel varchar(50) null 
									   ,email varchar(40) null 
									   ,telefone varchar(30) null 
									   ,celular varchar(30) null 
									   ,site varchar(40) null 
									   ,cep varchar(10) 
									   ,endereco varchar(100) null 
									   ,bairro varchar(40) null 
									   ,cidade varchar(40) null 
									   ,estado varchar(20) null 
									   ,observacao varchar(200) null                                                    
									   ,avatar varchar(45) null
									   ,ativo integer default 1);

create table if not exists produto ( id_produto integer primary key auto_increment 
									,nome  varchar(40) not null 
									,codigobarras  varchar(40) null 
									,marca varchar(40) null 
									,linha varchar(10) null 
									,categoria varchar(10) null 
									,descricao varchar(100) null 
									,precoCompra float default 0  
                                    ,precoVenda float default 0  
									,id_fornecedor integer 
									,prazoentrega integer default 0 
									,tipovenda integer default 1 
									,tipoconsumo integer default 1
									,evitarsaidanegativa integer default 0  
									,estoqueatual float default 0 
									,estoqueminimo  float default 0 
									,medida varchar(10) null 
									,observacao varchar(200) null       
									,avatar varchar(45) null
									,ativo integer default 1
									,constraint foreign key(id_fornecedor) references fornecedor(id_fornecedor));

create table if not exists cliente(id_cliente integer primary key auto_increment
								  ,nome varchar(50) not null
                                  ,contato varchar(50) unique not null
								  ,telefone varchar(30) not null
                                  ,aniversario datetime null
                                  ,genero varchar (1) default "f"
                                  ,observacaoCli text  
								  ,avatar varchar(45) null
								  ,email varchar(40) 
								  ,enviarEmail boolean default 0
								  ,divulgacao boolean default 1
                                  ,roboPodeAtender boolean default 0
                                  ,roboPodeAgendar boolean default 0
								  ,ativo integer default 1);

create table if not exists grupoCliente (id_grupo integer
                                        ,id_cliente integer );  

create table if not exists grupo (id_grupo integer primary key auto_increment 
                                 ,nome varchar (100) 
                                 ,ativo  boolean default 1); 

create table if not exists especialidade(id_especialidade integer primary key auto_increment 
										,nome varchar(50) not null
                                        ,palavrasChaves varchar (200) not null 
										,descricao varchar(100) null
										,avatar varchar(45) null 
                                        ,emoji varchar(20) null 
										,preco double not null default 0 
                                        ,sessoes integer not null default 1
                                        ,tempoNecessarioPorSessao  integer default 30
										,ativo boolean default 0);

create table if not exists cargo (id_cargo integer primary key auto_increment 
								 ,nome varchar(50) not null
								 ,ativo integer default 1); 

create table if not exists funcionario(id_funcionario integer primary key auto_increment 
									   ,nome varchar(50) not null
									   ,apelido varchar(30) default ''
									   ,id_cargo integer 
									   ,telefone varchar(30) null
									   ,cpfCnpj varchar(14) null
									   ,genero varchar(1) default 'f'  
									   ,id_banco  integer null
									   ,entradaManha varchar(5) 
									   ,saidaManha varchar(5)                                                    
									   ,entradaTarde varchar(5) 
									   ,saidaTarde varchar(5) 
									   ,entradaNoite varchar(5) 
									   ,saidaNoite varchar(5)                                                    
									   ,contaCorrente varchar(14) null
                                       ,modalidade varchar(10) default ''  
                                       ,diaRemuneracao1 varchar(10) default ''  
                                       ,percentagemRemuneracao1 integer default 0 
                                       ,diaRemuneracao2 varchar(10) default ''  
                                       ,percentagemRemuneracao2 integer default 0                                           
                                       ,percentagemRemuneracaoGeral integer default 0
                                       ,remuneracaoFixa float default 0
									   ,domingo tinyint(1)                                                    
									   ,segunda tinyint(1) 
									   ,terca tinyint(1) 
									   ,quarta tinyint(1) 
									   ,quinta tinyint(1) 
									   ,sexta tinyint(1) 
									   ,sabado tinyint(1) 
									   ,mes tinyint(1)  default true
									   ,cor varchar(7) default 'white'
									   ,avatar varchar(45) null
									   ,ativo tinyint(1)  default true 
									   ,constraint foreign key(id_cargo) references cargo(id_cargo));

create table if not exists agenda(id_agenda integer primary key auto_increment 
                                 ,id_agenda_original integer not null default 0 
								 ,id_funcionario integer not null
								 ,id_cliente integer null
								 ,dataHoraInicio datetime not null
								 ,dataHoraFim datetime not null
                                 ,sessaoNumero integer not null default 1 
                                 ,totalSessoes integer not null default 1																
								 ,totalPreco double not null default 0
                                 ,parcelarPrecoPorSessao tinyint(1) default true  
								 ,enviado boolean default 0
								 ,ativo tinyint(1)  default true                
								 ,constraint foreign key(id_cliente) references cliente(id_cliente)
								 ,constraint foreign key(id_funcionario) references funcionario(id_funcionario));

alter table agenda auto_increment = 100000;

create table if not exists agendaEspecialidade(id_agenda integer not null
										,id_especialidade integer not null
										,foreign key(id_agenda) references agenda(id_agenda)
										,foreign key(id_especialidade) references especialidade(id_especialidade));
										
CREATE TABLE IF NOT EXISTS funcionarioEspecialidade (
		id_especialidade INTEGER NOT NULL,
		id_funcionario INTEGER NOT NULL,
		CONSTRAINT idxfuncionarioEspecialidade 
			FOREIGN KEY (id_especialidade)
				REFERENCES especialidade (id_especialidade),
			FOREIGN KEY (id_funcionario)
				REFERENCES funcionario (id_funcionario));

create table if not exists fluxoCaixa( id_fluxoCaixa integer primary key auto_increment
                                      ,id_principal integer                 /* Para o caso de parcelamento e consequentemente novos registros vinculados  */
                                      ,id_funcionario integer
                                      ,horaDataAbertura datetime null    
                                      ,horaDataFechamento datetime null  
                                      ,valorAbertura  float default 0
                                      ,valorFechamento float default 0                                                                            
                                      ,dataHora datetime not null  
                                      ,valor float default 0  
                                      ,tipo  varchar(1) default 'E'        /*  Valores possiveis  'E' = Entrada de valor e  'S' Saida de valor   */
                                      ,situacao varchar(10) default 'aberta' 
                                      ,meioPgto varchar(2) default 'DI'    /* Valores possiveis: 'DI': Dinheiro, 'DE': Cartão de Débito , 'CR': Cartão de Crédito, 'CH': Cheque */   
                                      ,diaPgtoCartao integer default 1
                                      ,id_parcela integer default 0 
                                      ,parcelas integer default 1  
                                      ,observacao varchar(200) null 
                                      ,ativo integer default true
                                      ,foreign key(id_funcionario) references funcionario(id_funcionario)); 

create table if not exists fluxoCaixaItem (id_fluxoCaixaItem integer auto_increment
                                          ,id_fluxoCaixa integer  
                                          ,id_agenda integer default 0 
                                          ,id_cliente integer default 0  
                                          ,id_funcionario integer default 0  
                                          ,descricao  varchar(200) not null
                                          ,id_produto integer default 0 
                                          ,quantidade integer default 1  
                                          ,valor float default 0 
                                          ,foreign key(id_fluxoCaixa) references fluxoCaixa(id_fluxoCaixa) on delete cascade  
                                          ,primary key (id_fluxoCaixaItem,id_fluxoCaixa ));



DELIMITER ;

-- Criação das procedures -----------------------------------------------------------------------------------------------------------------

drop procedure if exists sync_agenda;

DELIMITER //

CREATE PROCEDURE sync_agenda(
    IN p_action VARCHAR(10),
    IN p_id_agenda INTEGER,
    IN p_id_agenda_original INTEGER,
    IN p_id_funcionario INTEGER,
    IN p_id_cliente INTEGER,
    IN p_dataHoraInicio DATETIME,
    IN p_dataHoraFim DATETIME,
    IN p_sessaoNumero INTEGER,
    IN p_totalSessoes INTEGER,
    IN p_totalPreco DOUBLE,
    IN p_parcelarPrecoPorSessao TINYINT(1),
    IN p_enviado BOOLEAN,
    IN p_ativo TINYINT(1)
)
BEGIN
    IF p_action = 'INSERT' THEN
        INSERT INTO BusinessInteligence.agenda (
            id_agenda_original, id_funcionario, id_cliente, 
            data_hora_inicio, data_hora_fim, sessao_numero, 
            total_sessoes, total_preco, parcelar_preco_por_sessao, 
            enviado, ativo
        ) VALUES (
            p_id_agenda_original, p_id_funcionario, p_id_cliente, 
            p_dataHoraInicio, p_dataHoraFim, p_sessaoNumero, 
            p_totalSessoes, p_totalPreco, p_parcelarPrecoPorSessao, 
            p_enviado, p_ativo
        );
    ELSEIF p_action = 'UPDATE' THEN
        UPDATE BusinessInteligence.agenda
        SET 
            id_agenda_original = p_id_agenda_original,
            id_funcionario = p_id_funcionario,
            id_cliente = p_id_cliente,
            data_hora_inicio = p_dataHoraInicio,
            data_hora_fim = p_dataHoraFim,
            sessao_numero = p_sessaoNumero,
            total_sessoes = p_totalSessoes,
            total_preco = p_totalPreco,
            parcelar_preco_por_sessao = p_parcelarPrecoPorSessao,
            enviado = p_enviado,
            ativo = p_ativo
        WHERE id_agenda = p_id_agenda;
    ELSEIF p_action = 'DELETE' THEN
        DELETE FROM BusinessInteligence.agenda
        WHERE id_agenda = p_id_agenda;
    END IF;
END //

DELIMITER ;

drop procedure if exists prc_buscar_empresa;

create procedure prc_buscar_empresa(in apenasativos tinyint)
     select id_empresa,
			nomeEmpresa,
			telefone,
			responsavel,
			adesao,
			nomeUsuario, 
			endereco,
			cep,
			email,
			cnpj,
			instagram, 
			nomeBot, 
			avatar, 
			horario, 
			atenderNaoCadastrados,
			modalidade,
			diaRemuneracao1,
			percentagemRemuneracao1,
			diaRemuneracao2,
			percentagemRemuneracao2,
			percentagemRemuneracaoGeral,
			semana, 
			ativo
    from empresa
		where ativo = if(apenasativos = 0, ativo, 1)
		order by nomeEmpresa;

drop procedure if exists prc_atualizar_empresa;

create procedure prc_atualizar_empresa(
    in $id_empresa int,
    in $nomeEmpresa varchar(100),
    in $telefone varchar(20),
    in $responsavel varchar(200),
    in $adesao varchar(20),
    in $nomeUsuario varchar(50),
    in $endereco varchar(255),
    in $cep varchar(10),
    in $email varchar(100),
    in $cnpj varchar(18),
    in $instagram varchar(200),
    in $nomeBot varchar(100),
    in $avatar varchar(100),
    in $horario json,
    in $atenderNaoCadastrados int,
    in $modalidade varchar(20),
    in $diaRemuneracao1 varchar(2),
    in $percentagemRemuneracao1 int,
    in $diaRemuneracao2 varchar(2),
    in $percentagemRemuneracao2 int,
    in $percentagemRemuneracaoGeral int,
    in $semana json,
    in $ativo int
)
    insert into empresa (
        id_empresa,
        nomeEmpresa,
        telefone,
        responsavel,
        adesao,
        nomeUsuario,
        endereco,
        cep,
        email,
        cnpj,
        instagram,
        nomeBot,
        avatar,
        horario,
        atenderNaoCadastrados,
        modalidade,
        diaRemuneracao1,
        percentagemRemuneracao1,
        diaRemuneracao2,
        percentagemRemuneracao2,
        percentagemRemuneracaoGeral,
        semana,
        ativo
    ) values (
        $id_empresa,
        $nomeEmpresa,
        $telefone,
        $responsavel,
        $adesao,
        $nomeUsuario,
        $endereco,
        $cep,
        $email,
        $cnpj,
        $instagram,
        $nomeBot,
        $avatar,
        $horario,
        $atenderNaoCadastrados,
        $modalidade,
        $diaRemuneracao1,
        $percentagemRemuneracao1,
        $diaRemuneracao2,
        $percentagemRemuneracao2,
        $percentagemRemuneracaoGeral,
        $semana,
        $ativo
    ) on duplicate key update
        id_Empresa = $id_empresa,
        nomeEmpresa =  $nomeEmpresa,
        telefone =  $telefone,
        responsavel =  $responsavel,
        adesao =  $adesao,
        nomeUsuario =  $nomeUsuario,
        endereco =  $endereco,
        cep =  $cep,
        email =  $email,
        cnpj =  $cnpj,
        instagram =  $instagram,
        nomeBot =  $nomeBot,
        avatar =  $avatar,
        horario =  $horario,
        atenderNaoCadastrados =  $atenderNaoCadastrados,
        modalidade =  $modalidade,
        diaRemuneracao1 =  $diaRemuneracao1,
        percentagemRemuneracao1 =  $percentagemRemuneracao1,
        diaRemuneracao2 =  $diaRemuneracao2,
        percentagemRemuneracao2 =  $percentagemRemuneracao2,
        percentagemRemuneracaoGeral =  $percentagemRemuneracaoGeral,
        semana =  $semana,
        ativo =  $ativo;

drop procedure if exists prc_deletar_empresa;

create procedure prc_deletar_empresa(in id_empresa int)
    delete from empresa where id_empresa = id_empresa;


drop procedure if exists prc_buscar_fluxoCaixaItem ;

create procedure prc_buscar_fluxoCaixaItem (in $id_fluxoCaixa integer)  
    select id_fluxoCaixaItem
          ,id_fluxoCaixa
          ,id_agenda 
          ,id_cliente
	      ,id_funcionario
		  ,descricao
		  ,id_produto 
		  ,quantidade
		  ,valor 
          from fluxoCaixaItem 
          where id_fluxoCaixa = $id_fluxoCaixa; 

drop procedure if exists prc_atualizar_fluxoCaixaItem ;

delimiter $$

create procedure prc_atualizar_fluxoCaixaItem(in $id_fluxoCaixaItem integer 
                                             ,in $id_fluxoCaixa integer
                                             ,in $id_agenda integer 
                                             ,in $id_cliente integer 
                                             ,in $id_funcionario integer
                                             ,in $descricao  varchar(200) 
                                             ,in $id_produto integer 
                                             ,in $quantidade integer 
                                             ,in $valor float)

    begin
	   insert into fluxoCaixaItem( id_fluxoCaixaItem
								   ,id_fluxoCaixa
                                   ,id_agenda 
                                   ,id_cliente
                                   ,id_funcionario
								   ,descricao
								   ,id_produto 
								   ,quantidade
								   ,valor)
					values  ($id_fluxoCaixaItem
							,$id_fluxoCaixa
                            ,$id_agenda 
                            ,$id_cliente
                            ,$id_funcionario
							,$descricao
							,$id_produto 
							,$quantidade
							,$valor)
					on duplicate
					key update id_fluxoCaixaItem = $id_fluxoCaixaItem
							  ,id_fluxoCaixa = $id_fluxoCaixa
                              ,id_agenda  = $id_agenda 
                              ,id_cliente = $id_cliente
                              ,id_funcionario = $id_funcionario
							  ,descricao = $descricao
							  ,id_produto = $id_produto 
							  ,quantidade = $quantidade
							  ,valor = $valor;
                              
		if (select tipo from fluxoCaixa where id_fluxoCaixa = $id_fluxoCaixa) = "E" then
		    update produto p 
				inner join fluxoCaixaItem i 
						on  p.id_produto = i.id_produto 
				set p.estoqueatual = p.estoqueatual - i.quantidade 
				where i.id_fluxoCaixa = $id_fluxoCaixa ;        
		else 
			update produto p 
			     inner join fluxoCaixaItem i 
				         on  p.id_produto = i.id_produto 
				 set p.estoqueatual = p.estoqueatual + i.quantidade 
				 where i.id_fluxoCaixa = $id_fluxoCaixa ;        
	   end if;  
       
       if $id_agenda != 0 then 
          set @dataHora := (select dataHoraInicio from agenda where id_agenda = $id_agenda);      
          call prc_pagar_funcionario($id_funcionario, @dataHora);       
       end if; 
       
   end $$

delimiter ;

drop procedure if exists prc_pagar_funcionario ;

delimiter $$

create procedure prc_pagar_funcionario(in $id_funcionario integer, $dataHoraInicio datetime)  
     begin 
         set @id_funcionario := $id_funcionario
            ,@dataHoraInicio := $dataHoraInicio 
            ,@diaRemuneracao1 := 0
            ,@percRemuneracao1 := 0 
            ,@diaRemuneracao2 := 0 
            ,@percRemuneracao2 := 0 
            ,@percentagemRemuneracaoGeral := 0 
            ,@nomeFuncionario = '' 
            ,@modalidade := '';
            
         select diaRemuneracao1
               ,percentagemRemuneracao1
               ,diaRemuneracao2
               ,percentagemRemuneracao2
               ,percentagemRemuneracaoGeral
               ,nome 
               ,modalidade 
                into 
                @diaRemuneracao1
               ,@percRemuneracao1 
               ,@diaRemuneracao2 
               ,@percRemuneracao2  
               ,@percentagemRemuneracaoGeral 
               ,@nomeFuncionario 
               ,@modalidade 
               from funcionario  
                    where id_funcionario = $id_funcionario;

         set @somaTotalPreco := (select ifnull(sum(i.valor),0) from fluxoCaixaItem i 
													   inner join fluxoCaixa x 
															   on i.id_fluxoCaixa = x.id_fluxoCaixa 
									  where x.situacao = 'fechada' 
										and i.id_funcionario = @id_funcionario
                                        and x.tipo = 'E' 
                                        and x.id_parcela = 0 
										and month(x.dataHora) = month(@dataHoraInicio)
										and year(x.dataHora) = year(@dataHoraInicio));        

         set @valorGeral := @somaTotalPreco / 100 * @percentagemRemuneracaoGeral;  
         set @valor1 := @valorGeral;
         set @valor2 := 0;
         set @dataRemuneracao1 := (select CONCAT(DATE_FORMAT( DATE_ADD(@dataHoraInicio, INTERVAL 1 MONTH), '%Y-%m-'), @diaRemuneracao1));
         set @dataRemuneracao2 := (select CONCAT(DATE_FORMAT( DATE_ADD(@dataHoraInicio, INTERVAL 1 MONTH), '%Y-%m-'), @diaRemuneracao2));
        
         while exists (select 1 from feriado where dataFeriado = @dataRemuneracao1) do
             set @dataRemuneracao1 := date_sub(@dataRemuneracao1, interval 1 day);
         end while ;      
                         
         if @modalidade = 'quinzenal' then 
			 set @valor1 :=  @valorGeral  / 100 * @percRemuneracao1;
			 set @valor2 :=  @valorGeral - @valor1; 

			 while exists (select 1 from feriado where dataFeriado = @dataRemuneracao2) do
				   set @dataRemuneracao2 := date_sub(@dataRemuneracao2, interval 1 day);
			 end while ;      
         end if;                  

         delete x from fluxoCaixa x 
                      inner join fluxoCaixaItem i 
                              on x.id_fluxoCaixa = i.id_fluxoCaixa 
                  where i.id_funcionario =  @id_funcionario 
                    and month(dataHora) = month(@dataRemuneracao1)
                    and year(dataHora) = year(@dataRemuneracao1)
                    and id_agenda = 0; 

        if @valor1 != 0 then  
			insert into fluxoCaixa( dataHora   
									,valor 
									,tipo   
									,situacao
                                    ,observacao)  
						  values (  @dataRemuneracao1
                                  , @valor1  
                                  , 'S' 
                                  ,'fechada'
                                  ,'remuneração salarial');  
                                  
           set @id_fluxoCaixa = last_insert_id(); 
           
           insert into fluxoCaixaItem ( id_fluxoCaixa
                                       ,id_funcionario
                                       ,descricao
                                       ,valor )
						       values ( @id_fluxoCaixa 
                                       ,@id_funcionario
                                       ,concat('Remuneração de ' , @nomeFuncionario)
                                       ,@valor1);  
        end if; 
        
        if @valor2 != 0 then  
			insert into fluxoCaixa( dataHora   
									,valor 
									,tipo   
									,situacao
                                    ,observacao)  
						  values (  @dataRemuneracao2
                                  , @valor2  
                                  , 'S' 
                                  ,'fechada'
                                  ,'remuneração salarial');  
                                  
           set @id_fluxoCaixa = last_insert_id(); 
           
           insert into fluxoCaixaItem ( id_fluxoCaixa
                                       ,id_funcionario
                                       ,descricao
                                       ,valor )
						       values ( @id_fluxoCaixa 
                                       ,@id_funcionario
                                       ,concat('Remuneração de ' , @nomeFuncionario)
                                       ,@valor2);  
        end if; 

   end $$     
         
delimiter ;

drop procedure if exists prc_atualizar_agenda ;

delimiter $$

create procedure prc_atualizar_agenda(in $id_agenda int
                                     ,in $id_agenda_original int  
                                     ,in $id_funcionario int 
                                     ,in $id_cliente int 
                                     ,in $dataHoraInicio datetime 
                                     ,in $dataHoraFim datetime
                                     ,in $sessaoNumero int 
                                     ,in $totalSessoes int 
                                     ,in $totalPreco double
                                     ,in $parcelarPrecoPorSessao int 
                                     ,in $ativo int)
    begin 
        delete from agendaEspecialidade where id_agenda = $id_agenda; 

		set @id_agenda := case when $id_agenda = 0 then null else $id_agenda end; 
        set @id_cliente := case when $id_cliente = 0 then null else $id_cliente end; 
			
        insert into agenda(  id_agenda 
                            ,id_agenda_original 
                            ,id_funcionario
                            ,id_cliente  
                            ,dataHoraInicio 
                            ,dataHoraFim
                            ,sessaoNumero
                            ,totalSessoes													
                            ,totalPreco
                            ,parcelarPrecoPorSessao
                            ,ativo )
                    values(  @id_agenda
                            ,$id_agenda_original 
                            ,$id_funcionario
                            ,@id_cliente 
                            ,$dataHoraInicio 
                            ,$dataHoraFim 
                            ,$sessaoNumero
                            ,$totalSessoes	                            
                            ,$totalPreco
                            ,$parcelarPrecoPorSessao
                            ,$ativo)
                    on duplicate 
                    key update id_agenda = @id_agenda
                              ,id_agenda_original = $id_agenda_original
                              ,id_funcionario = $id_funcionario
                              ,id_cliente = @id_cliente  
                              ,dataHoraInicio = $dataHoraInicio 
                              ,dataHoraFim = $dataHoraFim                              
                              ,sessaoNumero = $sessaoNumero
                              ,totalSessoes = $totalSessoes                                                          
                              ,totalPreco = $totalPreco
                              ,parcelarPrecoPorSessao = $parcelarPrecoPorSessao
                              ,ativo = $ativo;        
                              
        set @id_agenda := case when ifnull($id_agenda,0) = 0 then last_insert_id() else $id_agenda end;                      
        
        if @id_cliente is not null then 
			set @diaPgtoCartao := ifnull((select diaPgtoCartao from fluxoCaixa order by dataHora desc limit 1),1);  
			 
			set @id_fluxoCaixa := ifnull((select id_fluxoCaixa from fluxoCaixaItem where id_agenda = @id_agenda limit 1),'0'); 
			delete from fluxoCaixaItem where id_fluxoCaixa = @id_fluxoCaixa and id_funcionario = $id_funcionario;

			set @id_fluxoCaixa := ifnull((select ifnull(x.id_fluxoCaixa,0) 
											   from fluxoCaixaItem i 
													inner join fluxoCaixa x   
															on i.id_fluxoCaixa = x.id_fluxoCaixa 
											   where x.situacao = 'aberta' 
												 and day(x.dataHora) = day($dataHoraInicio)
												 and month(x.dataHora) = month($dataHoraInicio)
												 and year(x.dataHora) = year($dataHoraInicio)  
												 and i.id_cliente = $id_cliente
											   limit 1),null) ;
			
			insert into fluxoCaixa( id_fluxoCaixa  
									,id_principal
									,dataHora 
									,valor 
									,tipo 
									,situacao 
									,meioPgto 
									,diaPgtoCartao
									,id_parcela                                       
									,parcelas
									,observacao 
									,ativo)
						   values (@id_fluxoCaixa
									,'0'
									,$dataHoraInicio 
									,$totalPreco
									,'E'
									,'aberta' 
									,'DE'
									, @diaPgtoCartao
									,'0'
									,'1'
									,''
									,'1')                        
				on duplicate
				key update id_fluxoCaixa = @id_fluxoCaixa
						  ,id_principal = '0'
						  ,dataHora = $dataHoraInicio 
						  ,valor = $totalPreco
						  ,tipo = 'E'
						  ,situacao = 'aberta' 
						  ,meioPgto = 'DE'
						  ,diaPgtoCartao = '12' 
						  ,id_parcela = '0'                                                    
						  ,parcelas = '1'  
						  ,observacao = ''
						  ,ativo = '1'; 
						  
			 set @id_fluxoCaixa := case when ifnull(@id_fluxoCaixa,0) = 0 then last_insert_id() else @id_fluxoCaixa end;
			 set @nomeFuncionario := (select nome from funcionario where id_funcionario = $id_funcionario); 
			 set @nomeCliente := (select nome from cliente c where id_cliente = $id_cliente); 
			 set @descricao = concat('Serviços de estética prestados à ', @nomeCliente , ' pela profissional ', @nomeFuncionario);    
			 
			 insert into fluxoCaixaItem ( id_fluxoCaixa
										 ,id_agenda 
										 ,id_cliente 
										 ,id_funcionario 
										 ,descricao
										 ,valor)
								 values ( @id_fluxoCaixa
										 ,@id_agenda
										 ,$id_cliente 
										 ,$id_funcionario
										 ,@descricao
										 ,$totalPreco);

			 update fluxoCaixa set valor = (select sum(valor * quantidade)  from fluxoCaixaItem  where  id_fluxoCaixa = @id_fluxoCaixa)
					where  id_fluxoCaixa = @id_fluxoCaixa; 
       end if;                 
       select  @id_agenda id; 
       
   end $$   
   
delimiter ;    

drop procedure if exists prc_atualizar_agenda_especialidade;

create procedure prc_atualizar_agenda_especialidade(in $id_agenda int ,in $id_especialidade int)

    insert into agendaEspecialidade( id_agenda 
                                    ,id_especialidade) 
                            values ( $id_agenda
                                    ,$id_especialidade) 
                       on duplicate 
                          key update id_agenda = $id_agenda 
                                    ,id_especialidade = $id_especialidade; 


drop procedure if exists prc_buscar_funcionario_com_especialidade ;

/*
    exemplo de uso:
    
        call prc_buscar_funcionario(0); 

*/

create procedure prc_buscar_funcionario_com_especialidade(in $apenasativos tinyint)

    select  f.id_funcionario
           ,f.nome 
           ,o.nomeOuApelido
           ,f.apelido  
           ,c.id_cargo
           ,f.genero 
           ,c.nome cargo   
           ,f.telefone
           ,f.cpfCnpj
           ,f.id_banco
           ,f.contaCorrente
           ,f.modalidade 
           ,f.diaRemuneracao1 
		   ,f.percentagemRemuneracao1 
           ,f.diaRemuneracao2 
		   ,f.percentagemRemuneracao2 
           ,f.percentagemRemuneracaoGeral
           ,f.remuneracaoFixa
           ,f.domingo
           ,f.segunda 
           ,f.terca
           ,f.quarta
           ,f.quinta 
           ,f.sexta
           ,f.sabado
           ,f.ativo 
           ,f.cor
           ,f.entradaManha
           ,f.saidaManha
           ,f.entradaTarde
           ,f.saidaTarde 
           ,f.entradaNoite
           ,f.saidaNoite 
           ,ifnull(f.avatar, './img/semavatar.png') avatar
       from funcionario f 
            inner join (select id_funcionario, case when apelido = '' then nome else apelido end nomeOuApelido  from funcionario) o 
                    on f.id_funcionario = o.id_funcionario
            inner join (select distinct id_funcionario from funcionarioEspecialidade) fe 
                    on f.id_funcionario = fe.id_funcionario  
            inner join cargo c 
                    on f.id_cargo = c.id_cargo
       where f.ativo = if ($apenasativos = false , f.ativo  , true)
             order by o.nomeOuApelido; 

drop procedure if exists prc_buscar_funcionario ;

/*
    exemplo de uso:
    
        call prc_buscar_funcionario(0); 

*/

create procedure prc_buscar_funcionario(in $apenasativos tinyint)

    select  f.id_funcionario
           ,f.nome 
           ,o.nomeOuApelido
           ,f.apelido  
           ,c.id_cargo
           ,f.genero 
           ,c.nome cargo   
           ,f.telefone
           ,f.cpfCnpj
           ,f.id_banco
           ,f.contaCorrente
           ,f.modalidade 
           ,f.diaRemuneracao1 
		   ,f.percentagemRemuneracao1 
           ,f.diaRemuneracao2 
		   ,f.percentagemRemuneracao2 
           ,f.percentagemRemuneracaoGeral
           ,f.remuneracaoFixa
           ,f.domingo
           ,f.segunda 
           ,f.terca
           ,f.quarta
           ,f.quinta 
           ,f.sexta
           ,f.sabado
           ,f.ativo 
           ,f.cor
           ,f.entradaManha
           ,f.saidaManha
           ,f.entradaTarde
           ,f.saidaTarde 
           ,f.entradaNoite
           ,f.saidaNoite 
           ,ifnull(f.avatar, './img/semavatar.png') avatar
       from funcionario f 
            inner join (select id_funcionario, case when apelido = '' then nome else apelido end nomeOuApelido  from funcionario) o 
                    on f.id_funcionario = o.id_funcionario
            inner join cargo c 
                    on f.id_cargo = c.id_cargo
       where f.ativo = if ($apenasativos = false , f.ativo  , true)
       order by o.nomeOuApelido; 

drop procedure if exists prc_buscar_agenda ;

/*

    exemplo de uso: 
    
            call prc_buscar_agenda("2021-03-27");
*/

create procedure prc_buscar_agenda(in $dataHoraInicio datetime)
    select a.id_agenda 
         , a.id_agenda_original  
         , a.dataHoraInicio
         , a.dataHoraFim
         , a.sessaoNumero
         , a.totalSessoes         
         , a.id_funcionario                 
         , f.nome funcionario
         , f.apelido 
         , case when a.id_cliente is not null then f.cor else '#a6a6a6' end cor             
         , a.id_cliente 
         , ifnull(c.nome,'periodo bloqueado') cliente 
         , c.observacaoCli  
         , ifnull(f.avatar, './img/semavatar.png') avatar    
         , a.totalPreco 
         , a.parcelarPrecoPorSessao
         , a.ativo 
           from agenda a   
                inner join funcionario f 
                        on a.id_funcionario = f.id_funcionario
                left join cliente c 
                        on a.id_cliente = c.id_cliente 
          where date_format(a.dataHoraInicio,"%y-%m-%d") = $dataHoraInicio
            and f.ativo = 1    
			and ifnull(c.ativo, 1) = 1 
          order by f.nome, a.dataHoraInicio;

drop procedure if exists prc_buscar_compromissos_funcionarios;

create procedure prc_buscar_compromissos_funcionarios()  
	select a.id_agenda 
         , a.dataHoraInicio
		 , a.dataHoraFim
		 , a.id_funcionario
         , c.nome nomeCliente 
		 from agenda a  
			 inner join funcionario f 
					 on a.id_funcionario = f.id_funcionario
             left join cliente c 
                     on a.id_cliente = c.id_cliente                       
		 where a.dataHoraInicio > curdate() - interval 30 day   
		   and f.ativo = true
		order by a.dataHoraInicio,f.id_funcionario;     

drop procedure if exists prc_buscar_agenda_chatbot ;

/*

    exemplo de uso: 
    
            call prc_buscar_agenda_chatbot("100018");
*/

create procedure prc_buscar_agenda_chatbot (in $id_agenda int)
	select a.id_agenda 
		 , a.dataHoraInicio
		 , a.dataHoraFim
		 , a.id_funcionario                 
		 , f.nome funcionario
		 , f.apelido 
		 , f.cor 
		 , a.id_cliente 
		 , c.nome cliente
		 , c.observacaoCli  
		 , ifnull(f.avatar, './img/semavatar.png') avatar    
		 , a.totalPreco 
		 , x.situacao
		 , a.ativo 
		   from agenda a   
				inner join funcionario f 
						on a.id_funcionario = f.id_funcionario
				inner join cliente c 
						on a.id_cliente = c.id_cliente 
				left join fluxoCaixaItem i  
						on a.id_agenda = i.id_agenda 
				left join fluxoCaixa x         
						on i.id_fluxoCaixa = x.id_fluxoCaixa 
		  where a.id_agenda = $id_agenda
			and a.dataHoraInicio > now() 
			and f.ativo = 1    
			and c.ativo = 1 
		  order by f.nome, a.dataHoraInicio;
          
drop procedure if exists prc_buscar_especialidade_do_funcionario;

/*

    exemplo de uso: 
    
            call prc_buscar_especialidade_do_funcionario(4);
*/

create procedure prc_buscar_especialidade_do_funcionario(in $id_funcionario int)
	
    select distinct  
          f.id_especialidade id
          ,f.id_especialidade  
          ,e.nome 
          ,e.palavrasChaves
          ,e.descricao 
          ,e.sessoes          
          ,e.tempoNecessarioPorSessao
          ,e.preco 
          ,e.avatar 
          ,e.emoji
          ,e.ativo
          from funcionarioEspecialidade f 
               inner join especialidade e 
                       on f.id_especialidade = e.id_especialidade                     
          where f.id_funcionario = case when $id_funcionario = 0 then f.id_funcionario else $id_funcionario end   
            and e.ativo = 1
          order by e.nome ;   

drop procedure if exists prc_buscar_agenda_especialidade;

/*

    exemplo de uso: 
    
        use SalaoConsultorio;
        call prc_buscar_agenda_especialidade();
*/

create procedure prc_buscar_agenda_especialidade(in $id_agenda int)

    select a.id_especialidade id 
          ,a.id_especialidade 
          ,e.nome  
          ,e.preco
          ,e.sessoes  
          ,e.tempoNecessarioPorSessao
          ,e.avatar
          from agendaEspecialidade a 
               inner join especialidade e 
                       on a.id_especialidade = e.id_especialidade
          where a.id_agenda = $id_agenda 
          order by e.nome ;   

drop procedure if exists prc_atualizar_funcionario;

delimiter $$

create procedure prc_atualizar_funcionario( in $id_funcionario int  
                                          , in $nome varchar(50)
                                          , in $apelido varchar(30)   
                                          , in $id_cargo varchar(30)
                                          , in $genero varchar(1) 
                                          , in $telefone varchar(15)
                                          , in $cpfCnpj varchar(14)
                                          , in $id_banco int 
                                          , in $contaCorrente  varchar(14) 
                                          , in $modalidade varchar(10)
                                          , in $diaRemuneracao1 varchar(10)  
			                              , in $percentagemRemuneracao1 integer
                                          , in $diaRemuneracao2 varchar(10)  
			                              , in $percentagemRemuneracao2 integer	
                                          , in $percentagemRemuneracaoGeral integer 
                                          , in $remuneracaoFixa integer 
                                          , in $domingo tinyint(1)                                           
                                          , in $segunda tinyint(1) 
                                          , in $terca tinyint(1) 
                                          , in $quarta tinyint(1) 
                                          , in $quinta tinyint(1) 
                                          , in $sexta tinyint(1) 
                                          , in $sabado tinyint(1)
                                          , in $ativo tinyint(1)
                                          , in $cor varchar(7)
                                          , in $entradaManha varchar(5) 
                                          , in $saidaManha varchar(5) 
                                          , in $entradaTarde varchar(5) 
                                          , in $saidaTarde varchar(5) 
                                          , in $entradaNoite varchar(5) 
                                          , in $saidaNoite varchar(5)  
                                          , in $avatar varchar(45))
										  
	begin     
		insert into funcionario( id_funcionario
							   , nome
							   , apelido 
							   , id_cargo 
							   , genero
							   , telefone
							   , cpfCnpj
							   , id_banco
							   , contaCorrente
							   , modalidade 
							   , diaRemuneracao1
							   , percentagemRemuneracao1
							   , diaRemuneracao2
							   , percentagemRemuneracao2
							   , percentagemRemuneracaoGeral
							   , remuneracaoFixa
							   , domingo 
							   , segunda 
							   , terca 
							   , quarta 
							   , quinta 
							   , sexta 
							   , sabado
							   , ativo 
							   , cor 
							   , entradaManha  
							   , saidaManha  
							   , entradaTarde  
							   , saidaTarde                   
							   , entradaNoite  
							   , saidaNoite  
							   , avatar )
					 values ( $id_funcionario
							, $nome
							, $apelido 
							, $id_cargo
							, $genero
							, $telefone
							, $cpfCnpj
							, $id_banco
							, $contaCorrente
							, $modalidade 
							, $diaRemuneracao1
							, $percentagemRemuneracao1
							, $diaRemuneracao2
							, $percentagemRemuneracao2 
							, $percentagemRemuneracaoGeral
							, $remuneracaoFixa 
							, $domingo 
							, $segunda 
							, $terca 
							, $quarta 
							, $quinta 
							, $sexta 
							, $sabado
							, $ativo 
							, $cor 
							, $entradaManha  
							, $saidaManha  
							, $entradaTarde  
							, $saidaTarde                   
							, $entradaNoite  
							, $saidaNoite 
							, $avatar) 
					on duplicate 
					key update id_funcionario = $id_funcionario
							   , nome = $nome
							   , apelido = $apelido 
							   , id_cargo = $id_cargo
							   , genero = $genero
							   , telefone = $telefone
							   , cpfCnpj = $cpfCnpj
							   , id_banco = $id_banco
							   , contaCorrente = $contaCorrente
							   , modalidade = $modalidade 
							   , diaRemuneracao1 = $diaRemuneracao1
							   , percentagemRemuneracao1 = $percentagemRemuneracao1
							   , diaRemuneracao2 = $diaRemuneracao2
							   , percentagemRemuneracao2 = $percentagemRemuneracao2 
							   , percentagemRemuneracaoGeral = $percentagemRemuneracaoGeral 
							   , remuneracaoFixa = $remuneracaoFixa
							   , domingo = $domingo 
							   , segunda = $segunda 
							   , terca = $terca 
							   , quarta = $quarta 
							   , quinta = $quinta 
							   , sexta = $sexta 
							   , sabado = $sabado
							   , ativo = $ativo 
							   , cor = $cor 
							   , entradaManha = $entradaManha
							   , saidaManha  = $saidaManha 
							   , entradaTarde = $entradaTarde 
							   , saidaTarde = $saidaTarde 
							   , entradaNoite = $entradaNoite 
							   , saidaNoite = $saidaNoite
							   , avatar = $avatar;
                               
        call prc_pagar_funcionario($id_funcionario, curdate());     
        select case when $id_funcionario = 0 then last_insert_id() else $id_funcionario end id; 
		
	end $$

delimiter ;                           

drop procedure if exists prc_deletar_especialidade_do_funcionario ;

create procedure prc_deletar_especialidade_do_funcionario(in $id_funcionario int)  
    delete from funcionarioEspecialidade where id_funcionario = $id_funcionario ;
                           
drop procedure if exists prc_atualizar_especialidade_do_funcionario ;

/*

    exemplo de uso: 
    
            call prc_atualizar_especialidade_do_funcionario(2, 4);
*/

create procedure prc_atualizar_especialidade_do_funcionario(in $id_funcionario int ,in $id_especialidade int)         
    insert into funcionarioEspecialidade (id_funcionario , id_especialidade) values ($id_funcionario , $id_especialidade) ;

drop procedure if exists prc_deletar_funcionario_especialidade ;

create procedure prc_deletar_funcionario_especialidade (in $id_funcionario int)

    delete from funcionarioEspecialidade 
          where id_funcionario = $id_funcionario 
            and (select count(1) from agenda where id_funcionario = $id_funcionario) = 0;  

drop procedure if exists prc_deletar_funcionario ;

delimiter $$
create procedure prc_deletar_funcionario (in $id_funcionario int)
    begin 
       if exists (select 1 from agenda where id_funcionario = $id_funcionario and dataHoraInicio >= curdate()) then 
           signal sqlstate '10000' set message_text = 'Existem agendamentos marcados para este funcionario\nremaneje estes agendamento antes de excluir o funcionario' ;
       else 
           delete from funcionario  where id_funcionario = $id_funcionario;
       end if;
    end $$     
       
delimiter ;              

drop procedure if exists prc_buscar_cliente ;

create procedure prc_buscar_cliente (in $apenasativos tinyint)

    select  id_cliente
           , nome
           , contato 
           , telefone
           , aniversario
           , genero 
           , ifnull(avatar, './img/semavatar.png') avatar 
           , email
           , enviarEmail
           , divulgacao
           , observacaoCli 
           , roboPodeAtender
           , roboPodeAgendar
           , ativo      
       from cliente
       where ativo = if ($apenasativos = false , ativo  , true)
       order by nome;

drop procedure if exists prc_buscar_grupos_do_cliente ;

create procedure prc_buscar_grupos_do_cliente (in $id_cliente int)
	select * from grupoCliente where id_cliente = $id_cliente; 

drop procedure if exists prc_deletar_grupoCliente ;

create procedure prc_deletar_grupoCliente (in $id_cliente int)
	delete from grupoCliente where id_cliente = $id_cliente; 

drop procedure if exists prc_deletar_cliente ;

create procedure prc_deletar_cliente (in $id_cliente int)

    delete from  cliente  where id_cliente = $id_cliente;


drop procedure if exists prc_atualizar_cliente ;

delimiter $$

create procedure prc_atualizar_cliente(in $id_cliente INT
                                      ,in $nome varchar(30)
                                      ,in $contato varchar(30)
                                      ,in $telefone varchar(15)
                                      ,in $aniversario varchar(15)
                                      ,in $genero varchar(1)
                                      ,in $observacaoCli text 
                                      ,in $avatar varchar(45)
                                      ,in $roboPodeAtender boolean 
                                      ,in $roboPodeAgendar boolean 
                                      ,in $ativo tinyint(1))

	begin 
    
        if $aniversario = '' then  
            set $aniversario = null;
        end if;
    
    	insert into cliente( id_cliente
							,nome
							,contato
							,telefone
							,aniversario
							,genero
							,observacaoCli
							,avatar 
							,roboPodeAtender
							,roboPodeAgendar
							,ativo)
					values  ($id_cliente
							,$nome
							,$contato
							,$telefone
							,$aniversario
							,$genero 
							,$observacaoCli
							,$avatar 
							,$roboPodeAtender
							,$roboPodeAgendar
							,$ativo)
					on duplicate
					key update id_cliente = $id_cliente
							  ,nome = $nome
							  ,contato = $contato 
							  ,telefone = $telefone
							  ,aniversario = $aniversario
							  ,genero = $genero 
							  ,observacaoCli = $observacaoCli 
							  ,avatar = $avatar 
							  ,roboPodeAtender = $roboPodeAtender
							  ,roboPodeAgendar = $roboPodeAgendar
							  ,ativo = $ativo; 

        select case when $id_cliente = 0 then last_insert_id() else $id_cliente end id; 
		
	end $$ 
    
delimiter ;     

drop procedure if exists prc_atualizar_grupoCliente ;

create procedure prc_atualizar_grupoCliente(in $id_grupo int 
                                           ,in $id_cliente int)
    
	insert into grupoCliente( id_grupo
							 ,id_cliente)
					values  ($id_grupo
							,$id_cliente)
				on duplicate
				key update id_grupo = $id_grupo 
						  ,id_cliente = $id_cliente; 

drop procedure if exists prc_buscar_funcionario_chatbot ;

create procedure prc_buscar_funcionario_chatbot()

    select distinct f.id_funcionario 
           ,o.nome
           ,o.apelido 
           ,f.genero 
           ,c.nome cargo   
           ,e.id_especialidade 
           ,lower(e.nome) especialidade 
           ,f.entradaManha   
           ,f.saidaManha 
           ,f.entradaTarde 
           ,f.saidaTarde
           ,f.entradaNoite  
           ,f.saidaNoite
           ,concat("[", substring(o.dias, 1, length(o.dias) -1), "]") dias
           ,f.avatar 
       from funcionario f        
            inner join (select id_funcionario
                             , nome 
                             , apelido 
                             ,concat(if (domingo = true, '"dom",' , '')
                                   , if (segunda = true, '"seg",' , '')
                                   , if (terca = true, '"ter",' , '')
                                   , if (quarta = true, '"qua",' , '')
                                   , if (quinta = true, '"qui",' , '')
                                   , if (sexta = true, '"sex",' , '')
                                   , if (sabado = true, '"sab",' ,'')) dias     
            from funcionario) o 
                    on f.id_funcionario = o.id_funcionario
            inner join funcionarioEspecialidade fe 
                    on f.id_funcionario = fe.id_funcionario 
            inner join especialidade e 
                    on fe.id_especialidade = e.id_especialidade 
            inner join cargo c 
                    on f.id_cargo = c.id_cargo

       where f.ativo = true
       order by o.nome; 

drop procedure if exists prc_deletar_agenda ;

delimiter $$    

create procedure prc_deletar_agenda(in $id_agenda INT) 
   begin 
      set @id_agenda := ifnull((select id_agenda from agenda where id_agenda = $id_agenda and id_agenda_original != 0),0); 
      set @id_cliente := (select id_cliente from agenda where id_agenda = $id_agenda);
      
      set @id_agenda_original := (select id_agenda_original from agenda where id_agenda = $id_agenda and id_agenda_original != 0);
      set @id_agenda_original := case when ifnull(@id_agenda_original,0) = 0 then $id_agenda else @id_agenda_original end;    
      
      if @id_cliente is not null then   
   		  set @id_fluxoCaixa := (select x.id_fluxoCaixa from fluxoCaixa x inner join fluxoCaixaItem i 
													on x.id_fluxoCaixa = i.id_fluxoCaixa 
													where i.id_agenda = $id_agenda and x.situacao = 'aberta'); 
		  if @id_fluxoCaixa is not null then 
			  if not exists (select 1 from fluxoCaixaItem where id_fluxoCaixa = @id_fluxoCaixa and id_produto != 0) then 
				  delete from agendaEspecialidade where id_agenda = $id_agenda; 
				  delete from agenda where id_agenda = $id_agenda;
				  call prc_deletar_fluxoCaixa ( @id_fluxoCaixa) ;
			  end if;
		  else 
			 signal sqlstate '10000' set message_text = 'Nao foi possivel excluir a reserva.A possivel causa e'' que a comanda ja'' foi paga ou existem produtos adicionados a comanda' ;
		  end if;
     else      
         delete from agenda where id_agenda = $id_agenda; 
     end if;
        
     if @id_agenda != 0 then 
         delete from agenda where id_agenda = @id_agenda; 
     else 
	     delete from agenda where id_agenda = @id_agenda_original or id_agenda_original = @id_agenda_original ;     
     end if;     
   end $$   
 
 delimiter ;   
 
 /*
 drop trigger if exists del_agenda_especialidade_on_del ;   
 
 create trigger del_agenda_especialidade_on_del before delete on agenda 
    for each row 
        delete from agendaEspecialidade where id_agenda = old.id_agenda; 
 */ 
 
drop procedure if exists prc_buscar_fornecedor ;   
    
create procedure prc_buscar_fornecedor(in $apenasativos tinyint)    
 
   select * from fornecedor     
     where ativo = if ($apenasativos = false , ativo  , true)
     order by nome;


drop procedure if exists prc_atualizar_fornecedor ;

delimiter $$ 

create procedure prc_atualizar_fornecedor(in $id_fornecedor INT
                                         ,in $nome varchar(50)  
                                         ,in $razaoSocial varchar(100)  
                                         ,in $cnpjcpf varchar(20)    
                                         ,in $responsabel varchar(50) 
                                         ,in $email varchar(40)  
                                         ,in $telefone varchar(30) 
                                         ,in $celular varchar(30)  
                                         ,in $site varchar(40)  
                                         ,in $cep varchar(10) 
                                         ,in $endereco varchar(100)  
                                         ,in $bairro varchar(40)  
                                         ,in $cidade varchar(40)  
                                         ,in $estado varchar(20)  
                                         ,in $observacao varchar(200) 
                                         ,in $avatar varchar(45)
                                         ,in $ativo tinyint(1))
	begin 
		insert into fornecedor( id_fornecedor 
							   ,nome 
							   ,razaoSocial 
							   ,cnpjcpf 
							   ,responsabel 
							   ,email 
							   ,telefone 
							   ,celular 
							   ,site
							   ,cep 
							   ,endereco 
							   ,bairro 
							   ,cidade 
							   ,estado 
							   ,observacao 
							   ,avatar 
							   ,ativo)
					 values ( $id_fornecedor
							 ,$nome 
							 ,$razaoSocial 
							 ,$cnpjcpf 
							 ,$responsabel 
							 ,$email 
							 ,$telefone 
							 ,$celular 
							 ,$site
							 ,$cep 
							 ,$endereco 
							 ,$bairro 
							 ,$cidade 
							 ,$estado 
							 ,$observacao 
							 ,$avatar 
							 ,$ativo)
					on duplicate
					key update id_fornecedor = $id_fornecedor
							 ,nome = $nome
							 ,razaoSocial = $razaoSocial
							 ,cnpjcpf = $cnpjcpf
							 ,responsabel = $responsabel
							 ,email = $email
							 ,telefone = $telefone
							 ,celular = $celular
							 ,site = $site
							 ,cep = $cep
							 ,endereco = $endereco
							 ,bairro = $bairro 
							 ,cidade = $cidade
							 ,estado = $estado
							 ,observacao = $observacao
							 ,avatar = $avatar
							 ,ativo = $ativo; 

        select case when $id_fornecedor = 0 then last_insert_id() else $id_fornecedor end id; 
	end $$ 
  
  delimiter ; 
    
drop procedure if exists prc_deletar_fornecedor ;

create procedure prc_deletar_fornecedor (in $id_fornecedor int)

    delete from  fornecedor  where id_fornecedor = $id_fornecedor;


drop procedure if exists prc_buscar_produto ;

create procedure prc_buscar_produto (in $apenasativos tinyint)

     select  p.id_produto 
            ,p.nome
            ,p.codigobarras
            ,p.marca
            ,p.linha
            ,p.categoria
            ,p.descricao
			,precoCompra 
            ,precoVenda 
            ,p.id_fornecedor
            ,f.nome fornecedor             
            ,p.prazoentrega
            ,p.tipovenda 
            ,p.tipoconsumo
            ,p.evitarsaidanegativa
            ,p.estoqueatual
            ,p.estoqueminimo
            ,p.medida            
            ,p.observacao
            ,ifnull(p.avatar, './img/packages.png') avatar 
            ,p.ativo           
       from produto p inner join fornecedor f on p.id_fornecedor = f.id_fornecedor  
       where p.ativo = if ($apenasativos = false , p.ativo  , true)
       order by p.nome;

drop procedure if exists prc_atualizar_produto ;

delimiter $$ 

create procedure prc_atualizar_produto(in $id_produto int 
                                      ,in $nome  varchar(40)  
                                      ,in $codigobarras  varchar(40)  
                                      ,in $marca  varchar(40)  
                                      ,in $linha  varchar(10)  
                                      ,in $categoria  varchar(10)  
                                      ,in $descricao  varchar(40)  
									  ,in $precoCompra float 
                                      ,in $precoVenda float 
                                      ,in $id_fornecedor integer 
                                      ,in $prazoentrega integer
                                      ,in $tipovenda boolean 
                                      ,in $tipoconsumo boolean 
                                      ,in $evitarsaidanegativa integer   
                                      ,in $estoqueatual float  
                                      ,in $estoqueminimo  float  
                                      ,in $medida varchar(10)  
                                      ,in $observacao varchar(200)        
                                      ,in $avatar varchar(45) 
                                      ,in $ativo integer) 
	begin 
		insert into produto( id_produto 
							,nome  
							,codigobarras 
							,marca   
							,linha   
							,categoria    
							,descricao    
							,precoCompra 
							,precoVenda
							,id_fornecedor  
							,prazoentrega 
							,tipovenda
							,tipoconsumo  
							,evitarsaidanegativa 
							,estoqueatual 
							,estoqueminimo    
							,medida   
							,observacao         
							,avatar  
							,ativo )
					values ( $id_produto          
							,$nome  
							,$codigobarras 
							,$marca   
							,$linha   
							,$categoria    
							,$descricao    
							,$precoCompra
							,$precoVenda 
							,$id_fornecedor  
							,$prazoentrega  
							,$tipovenda
							,$tipoconsumo  
							,$evitarsaidanegativa 
							,$estoqueatual 
							,$estoqueminimo    
							,$medida   
							,$observacao         
							,$avatar  
							,$ativo )
	on duplicate
	  key update id_produto = $id_produto
				,nome = $nome  
				,codigobarras = $codigobarras 
				,marca = $marca   
				,linha = $linha    
				,categoria = $categoria 
				,descricao = $descricao 
				,precoCompra = $precoCompra
				,precoVenda = $precoVenda
				,id_fornecedor = $id_fornecedor 
				,prazoentrega = $prazoentrega
				,tipovenda = $tipovenda
				,tipoconsumo = $tipoconsumo
				,evitarsaidanegativa = $evitarsaidanegativa
				,estoqueatual = $estoqueatual
				,estoqueminimo = $estoqueminimo  
				,medida = $medida  
				,observacao = $observacao      
				,avatar = $avatar
				,ativo = $ativo;

       select case when $id_produto = 0 then last_insert_id() else $id_produto end id; 
	end $$ 
	
delimiter ;	
                         
drop procedure if exists prc_deletar_produto ;

create procedure prc_deletar_produto (in $id_produto int)
	delete from  produto  where id_produto = $id_produto;        

drop procedure if exists prc_buscar_especialidade ;

/*
    exemplo de uso:

        use SalaoConsultorio;
    
        call prc_buscar_especialidade(0); 

*/

create procedure prc_buscar_especialidade(in $apenasativos tinyint)

    select id_especialidade id
          ,id_especialidade
          ,nome
          ,palavrasChaves
          ,descricao
          ,avatar   
          ,emoji  
          ,preco
          ,sessoes
          ,tempoNecessarioPorSessao
          ,ativo  
    from especialidade 
       where ativo = if ($apenasativos = false , ativo  , true)
       order by nome;

drop procedure if exists prc_atualizar_especialidade ;

create procedure prc_atualizar_especialidade(in $id_especialidade int
                                            ,in $nome  varchar(40)  
                                            ,in $descricao  varchar(100)  
                                            ,in $palavrasChaves varchar(200)
                                            ,in $preco float
                                            ,in $sessoes int 
                                            ,in $tempoNecessarioPorSessao int)                                   
		 update especialidade set id_especialidade = $id_especialidade
								  ,nome = $nome  
								  ,descricao = $descricao 
								  ,palavrasChaves = $palavrasChaves 
								  ,preco = $preco 
                                  ,sessoes = $sessoes 
                                  ,tempoNecessarioPorSessao = $tempoNecessarioPorSessao
								  ,ativo = true
				where id_especialidade = $id_especialidade;

drop procedure if exists prc_duplicar_especialidade ;

create procedure prc_duplicar_especialidade (in $id_especialidade int)
	insert into especialidade (nome, descricao, tempoNecessarioPorSessao, avatar, preco, palavrasChaves, ativo ) 
		  select nome, descricao, tempoNecessarioPorSessao, avatar, preco, palavrasChaves, ativo from especialidade where id_especialidade = $id_especialidade;

drop procedure if exists prc_deletar_especialidade ;

create procedure prc_deletar_especialidade (in $id_especialidade int)
    update especialidade set ativo = false  
          where id_especialidade = $id_especialidade;

drop procedure if exists prc_buscar_cargo ;

create procedure prc_buscar_cargo (in $apenasativos tinyint)
	select id_cargo
			  ,nome
			  ,ativo  
		from cargo 
		   where ativo = if ($apenasativos = false , ativo  , true)
		   order by nome ; 

drop procedure if exists prc_buscar_fluxo_Caixa_Ano;

/*
    exemplo de uso:

        use SalaoConsultorio;
    
        call prc_buscar_fluxo_Caixa_Ano (5, 2019); 

*/

create procedure prc_buscar_fluxo_Caixa_Ano (in $mes int, in $ano int)			
	select entradasAnual, saidasAnual  from 
		(select ifnull(sum(valor), 0) entradasAnual   
		   from fluxoCaixa 
				where tipo = 'E' 
                  and situacao = 'fechada'
                  and not (meioPgto = 'CR' and  id_parcela = 0)  
				  and month(dataHora) <= $mes
				  and year(dataHora) = $ano) E,
		(select ifnull(sum(valor), 0) saidasAnual
		   from fluxoCaixa 
				where tipo = 'S' 
                  and not (meioPgto = 'CR' and  id_parcela = 0)  
				  and month(dataHora) <= $mes
				  and year(dataHora) = $ano) S;   
                            
drop procedure if exists prc_buscar_fluxo_Caixa_Mes ;

create procedure prc_buscar_fluxo_Caixa_Mes (in $mes int, in $ano int)

		select distinct x.id_fluxoCaixa
            , f1.id_funcionario id_operadorCaixa  
            , ifnull(f1.nome,'') operadorCaixa 
            ,  case 
                  when i.id_funcionario != 0 and i.id_agenda = 0 
                      then 
                          concat('remuneracao de ', f.nome) 
                      else  
                          concat(case 
                                   when convert(c.nome using utf8) is not null 
                                       then  
                                           concat('cliente ', convert(c.nome using utf8) , ' - ' )  
                                       else 
                                           '' 
                                 end,
                                 case                                  
                                     when tipo = 'E' 
                                         then 
                                             ' venda ' 
                                         else 
                                             ' compra ' 
                                 end,                
			                     case 
                                     when meioPgto = 'DI' 
                                         then 
                                             'com dinheiro '            
                                    when meioPgto = 'DE' 
                                         then 
                                             'com cartão de débito '
                                    when meioPgto = 'CR' 
                                         then 
                                             'a crédito ' 
                                         else 
                                             'com cheque ' 
                                 end, 
                                 ifnull(x.observacao,'')) 
               end descricao 
            , i.descricao descricaoItem        
			, x.valor totalPreco 
			, x.tipo  
            , '' observacaoCli
            , situacao
            , ifnull((select diaPgtoCartao from fluxoCaixa order by dataHora desc limit 1),1) maisRecenteDiaPgtoCartao
			, x.dataHora 
            , x.dataHora dataHoraInicio
            , '' dataHoraFim
            , x.meioPgto
            , x.diaPgtoCartao
            , x.id_parcela                                       
            , x.parcelas
            , x.observacao
			, x.ativo
		from  fluxoCaixa x
             inner join fluxoCaixaItem i 
                     on x.id_fluxoCaixa = i.id_fluxoCaixa
              left join cliente c 
                     on c.id_cliente = i.id_cliente 
              left join funcionario f 
                     on i.id_funcionario = f.id_funcionario
              left join funcionario f1 
                     on x.id_funcionario = f1.id_funcionario
			where month(x.dataHora) = $mes 
			  and year(x.dataHora) = $ano
	  order by x.dataHora desc, x.id_fluxoCaixa;

drop procedure if exists prc_atualizar_fluxoCaixa ;

delimiter $$

create procedure prc_atualizar_fluxoCaixa(in $id_fluxoCaixa int 
                                         ,in $id_principal int  
                                         ,in $dataHora datetime 
                                         ,in $valor float 
                                         ,in $tipo  varchar(1) 
                                         ,in $situacao varchar(10) 
                                         ,in $meioPgto varchar(2) 
                                         ,in $diaPgtoCartao integer 
                                         ,in $id_parcela integer 
                                         ,in $parcelas integer 
                                         ,in $observacao varchar(200) 
                                         ,in $ativo tinyint(1))
    begin 
        
        set @id_fluxoCaixa := case when $id_fluxoCaixa = 0 then null else $id_fluxoCaixa end; 
        
        if not ($meioPgto = "CR" and $id_parcela > 0 and $situacao = 'aberta') then 
				insert into fluxoCaixa( id_fluxoCaixa  
										,id_principal
										,dataHora 
										,valor 
										,tipo 
										,situacao 
										,meioPgto 
										,diaPgtoCartao
										,id_parcela                                       
										,parcelas
										,observacao 
										,ativo)
							   values ( @id_fluxoCaixa 
									   ,$id_principal  
									   ,$dataHora 
									   ,$valor 
									   ,$tipo 
									   ,$situacao
									   ,$meioPgto 
									   ,$diaPgtoCartao
									   ,$id_parcela                                
									   ,$parcelas
									   ,$observacao 
									   ,$ativo)                        
					on duplicate
					key update id_fluxoCaixa =  @id_fluxoCaixa 
							  ,id_principal = $id_principal
							  ,dataHora = $dataHora  
							  ,valor = $valor   
							  ,tipo = $tipo 
							  ,situacao = $situacao  
							  ,meioPgto = $meioPgto
							  ,diaPgtoCartao = $diaPgtoCartao
							  ,id_parcela = $id_parcela                                                      
							  ,parcelas = $parcelas
							  ,observacao = $observacao 
							  ,ativo = $ativo;  
                              
                set @id_fluxoCaixa := case when ifnull(@id_fluxoCaixa,0) = 0 then last_insert_id() else @id_fluxoCaixa end;              
        end if;         
        
        select ifnull(@id_fluxoCaixa,0)  id; 
        
    end $$  
    
delimiter ;         

drop procedure if exists prc_deletar_fluxoCaixaItem ;

delimiter $$

create procedure prc_deletar_fluxoCaixaItem (in $id_fluxoCaixa int)
    begin
	   if (select tipo from fluxoCaixa where id_fluxoCaixa = $id_fluxoCaixa) = "E" then
          update produto p 
                inner join fluxoCaixaItem i 
                        on  p.id_produto = i.id_produto 
                set p.estoqueatual = p.estoqueatual - i.quantidade 
                where i.id_fluxoCaixa = $id_fluxoCaixa ;        
	   else 
          update produto p 
                inner join fluxoCaixaItem i 
                        on  p.id_produto = i.id_produto 
                set p.estoqueatual = p.estoqueatual + i.quantidade 
                where i.id_fluxoCaixa = $id_fluxoCaixa ;        
	   end if;  
       delete from fluxoCaixaItem where id_fluxoCaixa = $id_fluxoCaixa;   
   end $$

delimiter ; 

drop procedure if exists prc_deletar_fluxoCaixa ;
    
delimiter $$
    
create procedure prc_deletar_fluxoCaixa (in $id_fluxoCaixa int)
    begin                                
		call prc_deletar_fluxoCaixaItem ($id_fluxoCaixa);

        delete from fluxoCaixa  where id_fluxoCaixa = $id_fluxoCaixa 
                                   or id_principal =  $id_fluxoCaixa ;
    end $$ 

delimiter ;    
    
drop procedure if exists prc_buscar_receitas_despesas ;

create procedure prc_buscar_receitas_despesas(in $ano integer)
	select m.ano, m.nome mes, ifnull(s.despesas,0) despesas , ifnull(e.receitas,0) receitas 
           from (select id_mes, nome, $ano ano from mes) m   
				 left join (select year(dataHora) ano,  month(dataHora) id_mes, sum(valor) receitas    
									from fluxoCaixa 
                                        where tipo = 'E' 
                                          and situacao = 'fechada'  
									    group by month(dataHora)) e 
						on m.id_mes = e.id_mes
					   and m.ano = e.ano
				 left join (select year(dataHora) ano,  month(dataHora) id_mes, sum(valor) despesas    
									from fluxoCaixa 
                                        where tipo = 'S' 
                                          and situacao = 'fechada'  
									    group by month(dataHora)) s 
						on m.id_mes = s.id_mes
					   and m.ano = s.ano
                  order by m.id_mes ;

drop procedure if exists prc_buscar_grafico_especialidade ;

create procedure prc_buscar_grafico_especialidade(in $ano integer)
  
	select e.nome , count(1) volume 
		   from especialidade e 
				inner join agendaEspecialidade ae 
					   on e.id_especialidade = ae.id_especialidade  
				inner join agenda a 
					   on ae.id_agenda = a.id_agenda 
            where year(a.dataHoraInicio) = $ano                                   
			 group by e.nome
			 order by volume desc
             limit 10;
   
drop procedure if exists prc_buscar_feriado ;

create procedure prc_buscar_feriado (in $apenasativos tinyint)
	select id_feriado 
          ,dataFeriado 
          ,nome 
          ,ativo  
		from feriado 
		   where ativo = if ($apenasativos = false , ativo  , true)
		   order by dataFeriado ; 

drop procedure if exists prc_atualizar_feriado ;

delimiter $$ 

create procedure prc_atualizar_feriado (in $id_feriado  INT
                                       ,in $dataFeriado datetime 
                                       ,in $nome  varchar(100)  
                                       ,in $ativo integer) 
									   
	begin 
		insert into feriado ( id_feriado
							, dataFeriado 
							, nome 
							, ativo) 
					values ( $id_feriado 
							,$dataFeriado 
							,$nome  
							,$ativo )
		on duplicate
			  key update id_feriado = $id_feriado
						,dataFeriado = $dataFeriado 
						,nome = $nome 
						,ativo = $ativo;  
                        
       select case when $id_feriado = 0 then last_insert_id() else $id_feriado end id; 
	end $$ 
	
delimiter ; 	

drop procedure if exists prc_deletar_feriado;

create procedure prc_deletar_feriado (in $id_feriado int)
    delete from feriado  where id_feriado = $id_feriado;

drop procedure if exists prc_grafico_agendamentos_funcionario ;

create procedure prc_grafico_agendamentos_funcionario(in $ano int)
    select f.nome, count(1) agendamentos  
		from agenda a 
			 inner join funcionario f 
					 on a.id_funcionario = f.id_funcionario 
		where year(a.dataHoraInicio) = $ano           
		group by a.id_funcionario 
        order by f.nome ;        

drop procedure if exists prc_grafico_produto;

create procedure prc_grafico_produto(in $ano integer)
     select p.nome, sum(f.valor) lucro  
            from  fluxoCaixa f 
               inner join fluxoCaixaItem i 
                       on f.id_fluxoCaixa = i.id_fluxoCaixa        
               inner join produto p
	                   on i.id_produto = p.id_produto 
	        where year(f.dataHora) = $ano  
                   and f.situacao = 'fechada'
                   and f.tipo = 'E' 
	        group by p.id_produto 
	        order by p.nome; 

drop procedure if exists prc_buscar_grupo ;

create procedure prc_buscar_grupo (in $apenasativos tinyint)
	select id_grupo 
          ,nome 
          ,ativo  
		from grupo  
		   where ativo = if ($apenasativos = false , ativo  , true)
		   order by nome ; 


drop procedure if exists prc_atualizar_grupo ;

delimiter $$

	create procedure prc_atualizar_grupo (in $id_grupo  INT
										 ,in $nome  varchar(100)  
										 ,in $ativo integer) 
	   begin 
			insert into grupo ( id_grupo
							  , nome 
							  , ativo) 
						values ( $id_grupo 
								,$nome  
								,$ativo )
			on duplicate
				  key update id_grupo = $id_grupo
							,nome = $nome 
							,ativo = $ativo; 
                            
		   select case when $id_grupo = 0 then last_insert_id() else $id_grupo end id; 
	end $$
   
delimiter ;   

drop procedure if exists prc_deletar_grupo;

create procedure prc_deletar_grupo (in $id_grupo int)
    delete from grupo  where id_grupo = $id_grupo;

drop procedure if exists prc_atualizar_observacao_cliente ;

create procedure prc_atualizar_observacao_cliente (in $id_cliente int, in $observacaoCli text) 
   update cliente set observacaoCli = $observacaoCli  where  id_cliente = $id_cliente; 

drop procedure if exists prc_buscar_campanha ;

create procedure prc_buscar_campanha (in $apenasativos tinyint)
   select id_campanha  
         ,imagem 
         ,imagemPropriedade 
         ,nome 
	     ,dataHoraUltimoDisparo  
	     ,texto 
         ,ativo 
	     from campanha 
		       where ativo = if ($apenasativos = false , ativo  , true)
		       order by nome ; 

drop procedure if exists prc_deletar_campanha;

create procedure prc_deletar_campanha (in $id_campanha int)
    delete from campanha where id_campanha = $id_campanha;

drop procedure if exists prc_buscar_campanha_grupo;

create procedure prc_buscar_campanha_grupo (in $id_campanha tinyint)
	select * from campanhaGrupo where id_campanha = $id_campanha;

drop procedure if exists prc_atualizar_campanha ;

delimiter $$

create procedure prc_atualizar_campanha(in $id_campanha INT
                                       ,in $imagem varchar(45)
                                       ,in $imagemPropriedade varchar(80) 
									   ,in $nome varchar(100) 
                                       ,in $nomeArquivoTransmitido varchar(100) 
									   ,in $dataHoraUltimoDisparo datetime 
									   ,in $texto text 
                                       ,in $ativo tinyint(1))
	begin 
		insert into campanha( id_campanha
							 ,imagem 
							 ,imagemPropriedade 
							 ,nome
							 ,nomeArquivoTransmitido
							 ,dataHoraUltimoDisparo
							 ,texto
							 ,ativo)
					values  ($id_campanha
							,$imagem  
							,$imagemPropriedade 
							,$nome
							,$nomeArquivoTransmitido
							,$dataHoraUltimoDisparo
							,$texto
							,$ativo)
					on duplicate
					key update id_campanha = $id_campanha
							  ,imagem = $imagem 
							  ,imagemPropriedade = $imagemPropriedade 
							  ,nome = $nome
							  ,nomeArquivoTransmitido = $nomeArquivoTransmitido
							  ,dataHoraUltimoDisparo = $dataHoraUltimoDisparo
							  ,texto = $texto
							  ,ativo = $ativo; 
                              
       select case when $id_campanha = 0 then last_insert_id() else $id_campanha end id;                
	end $$ 

delimiter ;    
    
drop procedure if exists prc_atualizar_campanha_grupo;

delimiter $$ 

create procedure prc_atualizar_campanha_grupo(in $id_campanha int 
                                             ,in $id_grupo int)
	begin 
		insert into campanhaGrupo (id_campanha 
								,id_grupo)
						values  ($id_campanha
								,$id_grupo)
					on duplicate
					key update id_grupo = $id_campanha
							  ,id_grupo = $id_grupo;
                              
		select $id_campanha  id;         
    end $$

delimiter ;

drop procedure if exists prc_enviar_campanha;

create procedure prc_enviar_campanha (in $id_campanha int) 
	select distinct '' pasta 
                   ,ca.nome campanhaNome 
				   ,cl.nome clienteNome 
				   ,cl.telefone clienteCelular 
                   ,ca.dataHoraUltimoDisparo dataHora 
				   ,ca.nomeArquivoTransmitido   	
		 from cliente cl 
              inner join grupoCliente gc  
                      on cl.id_cliente = gc.id_cliente 
              inner join campanhaGrupo cg
                      on gc.id_grupo = cg.id_grupo 
			  inner join campanha ca 
                      on cg.id_campanha = ca.id_campanha 
              where cg.id_campanha = $id_campanha
              order by cl.nome ;

drop procedure if exists prc_deletar_campanha_grupo ;

create procedure prc_deletar_campanha_grupo (in $id_campanha int) 
    delete from campanhaGrupo where id_campanha = $id_campanha;           

drop procedure if exists prc_enviar_comissao ;

delimiter $$ 

create procedure prc_enviar_comissao (in $id_funcionario int) 
    begin 

		set @totalComissoes := (select ifnull(sum(i.valor),0)   
                                       from fluxoCaixaItem i 
									         inner join fluxoCaixa x 
											        on i.id_fluxoCaixa = x.id_fluxoCaixa 
		                               where x.situacao = 'fechada' 
				                         and i.id_funcionario = $id_funcionario
					                     and x.tipo = 'E' 
						                 and x.id_parcela = 0 
						                 and month(x.dataHora) = month(curdate() )
						                and year(x.dataHora) = year( curdate()));        

		set @Comissao := (select ifnull(i.valor,0)   
							   from fluxoCaixaItem i 
									 inner join fluxoCaixa x 
											on i.id_fluxoCaixa = x.id_fluxoCaixa 
							   where x.situacao = 'fechada' 
								 and i.id_funcionario = $id_funcionario
								 and x.tipo = 'E' 
								 and x.id_parcela = 0 
								 and month(x.dataHora) = month(curdate() )
								 and year(x.dataHora) = year( curdate())
                               order by x.dataHora desc limit 1); 

         set @funcionarioNome = '' 
            ,@funcionarioCelular := '';
            
         select case apelido when '' then nome else apelido end 
               ,telefone 
                into 
                @funcionarioNome
               ,@funcionarioCelular 
               from funcionario  
                    where id_funcionario = $id_funcionario;
                    
        set @mensagem := concat('Oi!' , @funcionarioNome, ', Você acabou de receber R$ ', format(@Comissao ,2) , ' graças ao seu excelente serviço! Agora seu saldo deste mês é de R$ ', format(@totalComissoes ,2), ' Continue assim!');             
                               
        select concat(curDate(),' ',curTime()) dataHora, 
               @funcionarioCelular funcionarioCelular, 
               @funcionarioNome funcionarioNome,
               @mensagem mensagem;  
    end $$ 

delimiter ;
                          
-- Carga das Tabelas  --------------------------------------------------------------------------------------------------------
 
-- use SalaoConsultorio;

INSERT INTO empresa (
    nomeEmpresa,
    telefone,
    responsavel,
    adesao,
    nomeUsuario,
    endereco,
    cep,
    email,
    cnpj,
    instagram,
    nomeBot,
    avatar,
    horario,
    atenderNaoCadastrados,
    modalidade,
    diaRemuneracao1,
    percentagemRemuneracao1,
    diaRemuneracao2,
    percentagemRemuneracao2,
    percentagemRemuneracaoGeral,
    semana
) VALUES (
    'nelltek hair style salon',
    '(11) 4292-3746',
    'Angela de Oliveira',
    'setembro 2018',
    'nell',
    'Estrada dos tijolos dourados,1234 - Suzano - São Paulo',
    '08830000',
    'atendimento@neiltek.com',
    '10.090.807/0605-04',
    '', -- Instagram
    'Angel',
    'brunetteHair',
    '{"abre":"09:00","fecha":"19:00"}', 
    true,
    'mensal',
    '01',
    100,
    '00',
    50,
    65,
    '{"domingo":false,"segunda":true,"terca":true,"quarta":true,"quinta":true,"sexta":true,"sabado":true,"feriado":true}' 
);

INSERT INTO `cliente` (`id_cliente`, `nome`, `contato`, `telefone`, `aniversario`, `genero`, `observacaoCli`, `avatar`, `email`, `enviarEmail`, `divulgacao`, `roboPodeAtender`, `roboPodeAgendar`, `ativo`) VALUES
(1, 'Renato Carvalho', 'Renato', '551199985645', NULL, 'm', 'Ele prefere que sua barba seja feito só com homens', './cliente/rajkoothrappali.png', 'nelljunior@hotmail.com', 0, 1, 1, 1, 1),
(2, 'Dr Sílvio Cunha', 'Silvio', '552199342323', NULL, 'm', '', './cliente/sheldon.png', 'nelltechnology@outlook.com', 0, 1, 1, 1, 1),
(3, 'Patrícia Silva', 'Pati', '5511877991122', NULL, 'f', 'A cliente gosta de fazer as unhas com a a Emmy', './cliente/penny.png', 'neliodominguesjr@gmail.com', 0, 1, 1, 1, 1),
(4, 'Leonardo Silva', 'Silva', '55316777655', NULL, 'm', '', './cliente/leonardhofstadter.png', 'nelljunior@hotmail.com', 0, 1, 1, 1, 1),
(5, 'Haroldo Gomes', 'Haroldo', '5521922166741', NULL, 'm', '', './cliente/howardwolowitz.png', 'nelltechnology@outlook.com', 0, 1, 0, 0, 1),
(6, 'Bernadete Santos', 'Bernadete', '5521922113434', NULL, 'f', 'A cliente gosta muito de fazer as unhas com a a Emmy, mas não gosta do jeito que ela corta os cabelos', './cliente/bernadette.png', 'corneliojr@hotmail.com', 0, 1, 1, 1, 1),
(7, 'Amélia Rodrigues', 'Mel', '5521922113311', NULL, 'f', '', './cliente/amy.png', 'nelltechnology@outlook.com', 0, 1, 1, 1, 1),
(8, 'Emília Santos', 'Emmy', '552192211344', NULL, 'f', NULL, './cliente/emily.png', 'nelljunior@hotmail.com', 0, 1, 1, 1, 1),
(9, 'Nell Junior', 'Nell', '5511996813646', NULL, 'm', NULL, './cliente/nelio.png', 'nelljunior@hotmail.com', 0, 1, 1, 1, 1),
(10, 'júnior Gonçalves', 'ju', '115599680000', NULL, 'm', '', './img/semavatar.png', 'nelljunior@hotmail.com', 0, 1, 1, 1, 1),
(11, 'Angela de Oliveira', 'Angela', '5511997500734', NULL, 'f', 'Cliente VIP, ou seja, mimada e enjoada, melhor ser muito cortêz para evitar problemas', './cliente/angela.png', 'angela@gmail.com', 0, 1, 1, 1, 1),
(12, 'natasha', 'natasha', '5511975723032', NULL, 'f', '', './cliente/natasha.png', 'natashavalencia@gmail.com', 0, 1, 1, 1, 1),
(13, 'Ricardo', 'Ricardo', '5511940072224', NULL, 'm', '', './cliente/ricardo.png', '', 0, 1, 1, 1, 1),
(14, 'bruno', 'bruno', '119876655', NULL, 'm', '', './img/semavatar.png', NULL, 0, 1, 1, 1, 1),
(15, 'karen', 'karen', '115785857111', NULL, 'f', '', './img/semavatar.png', NULL, 0, 1, 1, 1, 1),
(16, 'Simone', 'Simone', '656565555656', NULL, 'f', '', './img/semavatar.png', NULL, 0, 1, 1, 1, 1),
(17, 'marcos', 'marcos', '5454554554', NULL, 'm', '', './img/semavatar.png', NULL, 0, 1, 1, 1, 1),
(18, 'Hillary', 'hila', '55566666655', NULL, 'f', '', './img/semavatar.png', NULL, 0, 1, 1, 1, 1),
(19, 'karcia lima', 'karcia', '6565656556', NULL, 'f', '', './img/semavatar.png', NULL, 0, 1, 1, 1, 1);

INSERT INTO `campanha` (`id_campanha`, `imagem`, `imagemPropriedade`, `nome`, `nomeArquivoTransmitido`, `dataHoraUltimoDisparo`, `texto`, `ativo`) VALUES
(1, '../../fila/acmebottle.png', '{\"sx\":161,\"sy\":61,\"swidth\":297,\"sheight\":150}', 'produto acme para cachos de cabelos', '../../fila/m54m2.png', '2022-09-09 19:27:00', '[{\"text\":\"Acabou de chegar o novo produto Acme para cachos perfeitos.\nquantidade limitada\",\"italic\":true,\"size\":\"18\",\"align\":\"center\",\"script\":\"sub\"},{\"text\":\"\n\",\"size\":\"18\",\"align\":\"center\"}]', 1),
(2, '../../fila/sapo.png', '{\"sx\":351,\"sy\":11,\"swidth\":297,\"sheight\":150}', 'dicas cabelos ressecados', '../../fila/papiel.png', '2022-09-09 19:18:00', '[{\"text\":\"\nVocê sabia ???\",\"bold\":true,\"italic\":true,\"font\":\"cursive\",\"size\":\"14\"},{\"text\":\"\n\n\"},{\"text\":\"A saliva do sapo ajuda a acabar com os cabelos secos?\nO cabelo fica gosmento, mas definitivamente é o fim \ndos seus cabelos secos!\",\"italic\":true}]', 1),
(3, '../../fila/vclinda.png', '{\"sx\":31,\"sy\":1,\"swidth\":687,\"sheight\":670}', 'voce é linda', '', '2022-09-08 11:00:00', '[{\"text\":\"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\"},{\"text\":\"Nós queremos que você \nse mantenha assim!\",\"italic\":true,\"size\":\"16\",\"align\":\"right\"}]', 1),
(4, '../../fila/littlecat.png', '{\"sx\":1,\"sy\":1,\"swidth\":647,\"sheight\":500}', 'Só tem um jeito de vc ser mais fofa!', '', '2022-09-08 14:00:00', '[{\"text\":\"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\",\"size\":\"14\",\"align\":\"center\"},{\"text\":\"Só tem um jeito de vc ser mais fofa! É usando a nova linha de produtos ACME. Encomende o seu com a gente ! !\",\"bold\":true,\"color\":\"Chocolate\",\"size\":\"18\",\"align\":\"center\"},{\"text\":\"\\n\",\"align\":\"center\"}]', 1),
(5, '../../fila/botsbots.png', '{\"sx\":-19,\"sy\":-19,\"swidth\":677,\"sheight\":680}', 'assistente virtual', '../../fila/5rewrd.png', '2022-09-09 19:25:00', '[{\"text\":\"Você vai pirar !\",\"bold\":true,\"color\":\"SteelBlue\",\"size\":\"20\"},{\"text\":\" \\n\\n\",\"color\":\"SteelBlue\"},{\"text\":\"Agora com nosso assistente Virtual,você poderá marcar seus agendamentos                                                    qualquer hora e em qualquer dia.\\n\\n\\n\",\"italic\":true,\"color\":\"SteelBlue\",\"size\":\"14\"},{\"text\":\"Experimente!\",\"bold\":true,\"italic\":true,\"color\":\"SteelBlue\",\"size\":\"18\"}]', 1),
(6, '../../fila/birthday.png', '{\"sx\":1,\"sy\":1,\"swidth\":647,\"sheight\":630}', 'mês de aniversário', '', '2022-09-08 09:00:00', '[{\"text\":\"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\"},{\"text\":\"Promoção de aniversário! \",\"bold\":true,\"italic\":true,\"font\":\"fantasy\",\"size\":\"12\",\"align\":\"center\"},{\"text\":\"\n\n\",\"bold\":true,\"italic\":true,\"align\":\"center\"},{\"text\":\"Cortes feminino 25% OFF \npor todo emês!Hidradação e escova pela metade \ndo preço\",\"bold\":true,\"align\":\"center\"},{\"text\":\".\n\",\"bold\":true,\"italic\":true,\"align\":\"center\"},{\"text\":\"\n\",\"align\":\"center\"}]', 1),
(7, '../../fila/apresentacaoAssistente.png', '{\"sx\":1,\"sy\":11	,\"swidth\":617,\"sheight\":610}', 'apresentação assistente virtual', '', '0000-00-00 00:00:00', '[{\"text\":\"               \\n\\n\\n\\n\",\"font\":\"cursive\",\"size\":\"14\"},{\"text\":\"                             Olá, eu sou a Nelly \n                             a assistente virtual da Nell Tek \n\n                             É um prazer te conhecer. \n\n   Comigo agora vc pode contatar a Neil Tech de forma rápida e a \n   qualquer hora do dia para agendar nossos serviços, além disso \n   você poderá ter informação de um monte de coisa da gente. \n\n                                                          E ai? Já podemos começar ?\n\",\"color\":\"DarkOrange\",\"font\":\"cursive\",\"size\":\"14\"},{\"text\":\"               \n\n\n\n\",\"font\":\"cursive\",\"size\":\"14\"}]', 1);

INSERT INTO `campanhaGrupo` (`id_campanha`, `id_grupo`) VALUES
(1, 4),
(2, 1),
(5, 15),
(1, 13);

INSERT INTO `cargo` (`id_cargo`, `nome`, `ativo`) VALUES
(1, 'Assistente', 1),
(2, 'Acupunturista', 1),
(3, 'Administrativo', 1),
(4, 'Auxiliar de serviços gerais', 1),
(5, 'Barbeiro', 1),
(6, 'Caixa', 1),
(7, 'Cabeleireiro', 1),
(8, 'Café', 1),
(9, 'Colorista', 1),
(10, 'Copeira', 1),
(11, 'Consultor', 1),
(12, 'Cirurgião Plástico', 1),
(13, 'Depilador', 1),
(14, 'Designer de sobrancelhas', 1),
(15, 'Estoquista', 1),
(16, 'Esteticista', 1),
(17, 'Faxineira', 1),
(18, 'Freelancer', 1),
(19, 'Fisioterapeuta', 1),
(20, 'Financeiro', 1),
(21, 'Gerente', 1),
(22, 'Gestor', 1),
(23, 'Marketing', 1),
(24, 'Manicure', 1),
(25, 'Manobrista', 1),
(26, 'Manutenção', 1),
(27, 'Maquiador', 1),
(28, 'Massagista', 1),
(29, 'Micropigmentador', 1),
(30, 'Nutricionista', 1),
(31, 'Pedicure', 1),
(32, 'Podologista', 1),
(33, 'Recepcionista', 1),
(34, 'Terapeuta', 1),
(35, 'Tatuador', 1),
(36, 'Vendedor', 1);

INSERT INTO `especialidade` (`id_especialidade`, `nome`, `palavrasChaves`, `descricao`, `avatar`, `emoji`, `preco`, `sessoes`, `tempoNecessarioPorSessao`, `ativo`) VALUES
(1, 'Baby Liss', 'cabelos cabelo ondular ondas cacheamento baby liss', 'Ondulamos e cacheamos 190º a 230ºC', './img/BabyLiss.png', '', 40, 1, 30, 1),
(2, 'Barba', 'fazer barba barba barbeiro barbear ', 'Barba desenhada', './img/Barba.png', '{scissors}', 37, 1, 30, 1),
(3, 'Barbearia em geral', 'barba geral barbear completa bigode costeleta nariz ouvido', 'Barbearia completa, barba, cabelo, costeleta e bigode', './img/Barbeariageral.png', '{barbearia}', 14, 1, 30, 0),
(4, 'Bigode', 'bigode', 'Cortamos e pintamos,no modelo que o cliente desejar', './img/Bigode.png', '{ruivo}', 20, 1, 30, 1),
(5, 'alisamento', 'cabelo cabelos prancha chapinha alisamento relaxamento capilar', 'liso perfeito 150c a 200c', './img/prancha.png', '', 55, 1, 30, 1),
(6, 'Coloracao', 'ruiva ruivo loira loiro morena moreno cor coloracao tinta tintura tingir tingir pintar re-pintar re-colorir repintar recolorir colorir cabelo cabelos', ' Todas as cores,e tintas das melhores marcas', './img/coloracao.png', '{pintar}', 70, 1, 30, 1),
(7, 'Corte de cabelo feminino', 'corte de cabelo cabelereira cabelereiro \ncortar cabelo ', 'temos Diversos tipos de cortes', './img/CorteFeminino.png', '{hair}', 43, 1, 30, 1),
(8, 'Corte de cabelo feminino infantil ', 'corte de cabelo cabelereira cabelereiro \ncortar cabelo menina crianca infantil', 'temos s tipos de cortes infantil', './img/CorteInfantilFeminino.png', '{unicorn}', 32, 1, 30, 1),
(9, 'Corte de cabelo Infantil Masculino', 'corte de cabelo cabelereira cabelereiro \ncortar cabelo menino crianca infantil', 'temos Diversos tipos de cortes infantil', './img/CorteInfantilMasculino.png', '{kid}', 22, 1, 30, 1),
(10, 'Corte de cabelo masculino', 'corte cabelo cabelereira cabelereiro cortar cabelos', 'temos Diversos tipos de cortes masculino', './img/CorteMasculino.png', '{man}', 20, 1, 30, 1),
(11, 'Hidratação', 'hidratacao hidratar capilar hidratar hidratacao hidratar cabelo cabelos', 'Hidratação capilar fio a fio', './img/Hidratacao.png', '{massage}', 45, 1, 30, 1),
(12, 'Luzes', 'luzes tingir mecha cabelo highlight', 'Californiana,Luzes invertidas,com os melhores Especialidades do mercado', './img/Luzes.png', '{Light Bulb}', 60, 1, 30, 1),
(13, 'Manicure', 'manicure esmalte esmaltacao pintar pintar re-pintar re-colorir repintar recolorir colorir dedos cortar corte unhas unhas unhas unhas unhas unha unha unha unha mãos mãos mão mão cuticula cuticulas', 'esmaltacao diversas cores ', './img/Manicure.png', '{manicure}', 20, 1, 30, 1),
(14, 'Pedicure', 'pedicure esmalte pes pes pes pes pintar pintar re-pintar re-colorir repintar recolorir dedos corte cortar unhas unhas unha unha', 'Pedicure, cuidados com os pes', './img/Pedicure.png', '{foot}', 25, 1, 30, 1),
(15, 'Podologo', 'podologo podologo unhas podologia', 'pes unhas encravadas - calos - calossidades - Cerreção de unhas - Fissuras', './img/Podologo.png', '{foot}', 90, 1, 30, 1),
(16, 'Progressiva', 'progressiva cabelos cabelo progressivo marroquina escova chocolate inteligente', 'Marroquina - progressiva sem formol - escova inteligente - escova chocolate -escova americana.', './img/Progressiva.png', '', 75, 1, 30, 1),
(17, 'Alisamento', 'alisamento chapinha alisar cabelos cabelo liso', 'Chapinha 360º', './img/alisamento.png', '', 50, 1, 30, 0),
(18, 'Alongamento', 'alongamento cabelo cabelos alongar', 'Temos cabelos de diversos modelos', './img/Alongamento.png', '{scissors}', 65, 1, 30, 1),
(19, 'Alongamento de Cilios', 'alongamento cilios cilio  sobrancelha sobrancelha alongar alongados chapinha', 'Chapinha 360º', './img/AlongamentoCilios.png', '{one eye}', 50, 1, 30, 1),
(20, 'Alongamento com Fita', 'alongamento alongar fita fitas', 'Alongamento Fita', './img/AlongamentoFita.png', '{ribbon}', 45, 1, 30, 1),
(21, 'Amarradinho, Nó italiano', 'amarradinho, no italiano amarrar', '', './img/AmarradinhoNoitaliano.png', '{italy}', 45, 1, 30, 1),
(22, 'Aplicação de Pelicula', 'aplicacao de pelicula aplicar', 'aplicacao de pelicula', './img/AplicaocaoPelicula.png', '{paint}', 0, 1, 30, 0),
(23, 'Balaiagem', 'balaiagem cabelo cabelos', 'balaiagem ', './img/Balaiagem.png', '', 45, 1, 30, 1),
(24, 'Banho de Lua', 'banho lua esteticista estetico ', 'banho lua', './img/BanhodeLua.png', '{crescent moon}', 85, 1, 30, 1),
(25, 'Banho de Petroleo', 'banho petroleo esteticista estetico', 'banho petroleo', './img/banhoDePetroleo.png', '', 85, 1, 30, 1),
(26, 'Barba e bigodeBarba e bigode', 'barba bigode barbeiro costeletas costeleta', '', './img/Barbabigode.png', '{beard}', 0, 1, 30, 0),
(27, 'Barba na Maquina', 'barba bigode maquina barbeiro costeletas costeleta', 'Barba Maquina', './img/BarbaMaquina.png', '{man}', 0, 1, 30, 0),
(28, 'Barba Modelada', 'barba bigode modelado modelada modelado', 'bigode modelado', './img/barbaModelada.png', '{beard}', 0, 1, 30, 0),
(29, 'Bigode Modelado', 'so bigode modelado', '', './img/BigodeModelado.png', '{ruivo}', 0, 1, 30, 0),
(30, 'Botox', 'botox medico esteticista estetica', '', './img/Botox.png', '', 65, 1, 30, 1),
(31, 'Bronzeamento', 'bronze bronzeamento estetico esteticista estetica', 'bronzeamento', './img/Bronzeamento.png', '{sun with face}', 0, 1, 30, 0),
(32, 'Californiana', 'massagem  californiana', 'massagem  californiana', './img/Californiana.png', '{massage}', 75, 1, 30, 1),
(33, 'Carbox', 'carbox reducao celulite carboxiterapia:', '', './img/Carbox.png', '{sauna}', 0, 1, 30, 0),
(34, 'Cauterizacao', 'capilar cabelo cabelos', 'Cauterizacao ', './img/Cauterizacao.png', '', 0, 1, 30, 0),
(35, 'Cauterizacao a Frio', 'Cauterizacao frio capilar cabelo cabelos', 'Cauterizacao a  frio ', './img/CauterizacaoFrio.png', '{cold face}', 0, 1, 30, 0),
(36, 'criolipolise', 'criolipolise reducao gordura', 'criolipolise reducao gordura', './img/criolipolise.png', '', 0, 1, 30, 0),
(37, 'Decapagem', 'cabelo cabelos decapagem', 'cabelo cabelos decapagem', './img/Decapagem.png', '', 0, 1, 30, 0),
(38, 'Depilacao', 'depilar depilacao depilador depiladora esteticista', 'depilação', './img/Depilacao.png', '{sauna}', 40, 1, 30, 1),
(39, 'Depilacao Masculina', 'depilar depilacao depilador depiladora Esteticista', '', './img/DepilacaoMasculina.png', '', 0, 1, 30, 0),
(40, 'Designer de sobrancelha', 'designer sobrancelha', 'designer sobrancelha', './img/Sobrancelha.png', '{eyebrow}', 25, 1, 30, 1),
(41, 'Dreadlock de lã', 'dreadlockdela', '', './img/Dreadlockdela.png', '', 0, 1, 30, 0),
(42, 'Drenagem Linfática', 'drenar drenagem linfatica', 'drenagem', './img/DrenagemLinfatica.png', '', 0, 1, 30, 0),
(43, 'Drenagem Facial ', 'drenar drenagem facial', 'drenagem facial', './img/DrenagemFacial.png', '', 0, 1, 30, 0),
(44, 'Entrelace', 'cabelos cabelo entrelace', ' cabelo entrelace', './img/Entrelace.png', '', 0, 1, 30, 0),
(45, 'Escova', 'cabelo cabelos escova', 'cabelos escova', './img/escova.png', '', 30, 1, 30, 1),
(46, 'Escova+Prancha', 'escova prancha', 'scova prancha', './img/EscovaPrancha.png', '{scissors}', 15, 1, 30, 1),
(47, 'Escova de Brilho', 'escova brilho', '', './img/EscovaBrilho.png', '{corte}', 55, 1, 30, 1),
(48, 'escova gradativa', 'escova gradativa', '', './img/escovagradativa.png', '', 10, 1, 30, 1),
(49, 'escova MegaHair', 'escova MegaHair Mega Hair', '', './img/escovaMegaHair.png', '{corte}', 0, 1, 30, 0),
(50, 'Escova Redutora', 'Escova Redutora', '', './img/EscovaRedutora.png', '', 0, 1, 30, 0),
(51, 'Esfoliacao', 'corporal corpo esfoliacao', '', './img/Esfoliacao.png', '', 45, 1, 30, 1),
(52, 'Escova Modeladora', 'Escova Modeladora', '', './img/EscovaModeladora.png', '', 0, 1, 30, 0),
(53, 'Esmaltação', 'manicure esmaltação', '', './img/esmaltacao.png', '', 0, 1, 30, 0),
(54, 'Filha Unica', 'Filha Unica', '', './img/FilhaUnica.png', '', 0, 1, 30, 0),
(55, 'FioaFio', 'fios fio', '', './img/FioaFio.png', '', 0, 1, 30, 0),
(56, 'fiobranco', 'fio brancao', '', './img/fiobranco.png', '', 0, 1, 30, 0),
(57, 'gloss Capilar', 'gloss Capilar', '', './img/glossCapilar.png', '', 0, 1, 30, 0),
(58, 'Hidratacao Lazer', 'Hidratacao Lazer', '', './img/HidratacaoLazer.png', '', 0, 1, 30, 0),
(59, 'Ionização de Superficie', 'onização de Superficie', '', './img/ionizacaodeSuperficie.png', '', 0, 1, 30, 0),
(60, 'Lavar', 'Lavar cabelos cabelo', '', './img/Lavar.png', '{shower}', 0, 1, 30, 0),
(61, 'Limpeza de Pele', 'Limpeza de pele', '', './img/limpezaPele.png', '', 0, 1, 30, 0),
(62, 'lipocavitação', 'lipocavitacao lipo cavitacao', '', './img/lipocavitacao.png', '', 85, 1, 30, 1),
(63, 'Maguiagem Artistica', 'Maguiagem Artistica', '', './img/MaguiagemArtistica.png', '', 11, 1, 30, 1),
(64, 'make up', 'make up', '', './img/makeup.png', '', 22, 1, 30, 1),
(65, 'Manutencao de Cilios', 'Manutencao de Cilios', '', './img/ManutencaoCilios.png', '{one eye}', 34, 1, 30, 1),
(66, 'Mão+Pé', 'mao pe mãos pedicure manicurw', '', './img/maope.png', '', 25, 1, 30, 0),
(67, 'maquiagem e cilios', 'maquiagem cilios', '', './img/maquiagemcilios.png', '', 0, 1, 30, 0),
(68, 'Maquiagem', 'maquiadora maquiador maquiagem pele rosto fase', '', './img/Maquiagem.png', '{kiss mark}', 35, 1, 30, 1),
(69, 'Maquiagem Definitiva', 'Maquiagem Definitiva olhos cilios sobrancelha', '', './img/MaquiagemDefinitiva.png', '{one eye}', 0, 1, 30, 0),
(70, 'Mascara Facial', 'mascara Facial rosto', '', './img/mascaraFacial.png', '', 0, 1, 30, 0),
(71, 'Massagem Modeladora', 'Massagem Modeladora', '', './img/MassagemModeladora.png', '', 0, 1, 30, 0),
(72, 'Massoterapia', 'Massoterapia', '', './img/Massoterapia.png', '', 0, 1, 30, 0),
(73, 'Matizador', 'Matizador', '', './img/Matizador.png', '', 0, 1, 30, 0),
(74, 'Mecha', 'cabelo cabelos mecha', '', './img/Mecha.png', '', 0, 1, 30, 0),
(75, 'MegaHair', 'cabelo cabelos megahair mega hair', '', './img/MegaHair.png', '', 0, 1, 30, 0),
(76, 'Mexas Invertidas', 'cabelos cabelo mexas invertidas', '', './img/MexasInvertidas.png', '', 0, 1, 30, 0),
(77, 'Micropigmentação de Sobrancelhas', 'Micropigmentação de Sobrancelhas', '', './img/MicropigmentacaodeSobrancelhas.png', '', 0, 1, 30, 0),
(78, 'Noiva/Debutante', 'Noiva Debutante casamento cerimonia', 'Noivas, Debutantes. Casamento e cerimonias ', './img/NoivaDebutante.png', '{bride}', 0, 1, 30, 0),
(79, 'Nutricao', 'Nutricao', 'Nutricao', './img/Nutricao.png', '', 0, 1, 30, 0),
(80, 'Ombre Hair', 'Ombre Hair', 'Ombre Hair', './img/OmbreHair.png', '', 0, 1, 30, 0),
(81, 'Pacote diversos', '', 'Pacote incluindo diversos serviços', './img/pacote.png', '', 0, 1, 30, 0),
(82, 'Peeling de Cristal', 'Peeling de Cristal pele rosto', 'Peeling de Cristal', './img/PeelingdeCristal.png', '{joia}', 0, 1, 30, 0),
(83, 'Peeling facial', 'Peeling facial pele rosto', 'Peeling facial ', './img/Peelingfacial.png', '', 0, 1, 30, 0),
(84, 'Penteado', 'penteado pentear cabelo cabelos lavar ', 'penteado', './img/Penteado.png', '', 43, 1, 30, 1),
(85, 'Pentiado Infantil', 'Pentiado Infantil', 'Pentiado Infantil', './img/PentiadoInfantil.png', '', 0, 1, 30, 0),
(86, 'Permamente', 'cabelo cabelos permamente', 'cabelos permamente', './img/Permamente.png', '', 0, 1, 30, 0),
(87, 'Progressiva A lazer', 'Progressiva A lazer', 'Progressiva A lazer', './img/lazer.png', '{corte}', 0, 1, 30, 0),
(88, 'Progressiva cabelo Comprido', 'Progressiva cabelo Comprido', 'Progressiva cabelo Comprido', './img/ProgressivaComprido.png', '{corte}', 0, 1, 30, 0),
(89, 'Progressiva cabelos Curto', 'Progressiva cabelos Curto', 'rogressiva cabelos Curto', './img/ProgressivaCurto.png', '{corte}', 0, 1, 30, 0),
(90, 'Progressiva cabelos Medio', 'Progressiva cabelos cabelo Medio', 'Progressiva cabelos Medio', './img/ProgressivaMedio.png', '{corte}', 0, 1, 30, 0),
(91, 'Remocao', 'Remocao', '', './img/Ramocao.png', '{loira}', 0, 1, 30, 0),
(92, 'rasteirao', 'rasteirao', 'rasteirao', './img/rasteirao.png', '', 90, 1, 30, 1),
(93, 'Reconstrucao', 'Reconstrucao', 'Reconstrucao', './img/Reconstrucao.png', '', 0, 1, 30, 0),
(94, 'Relaxamento', 'Relaxamento', 'Relaxamento', './img/Relaxamento.png', '{massage}', 0, 1, 30, 0),
(95, 'Renna', 'Renna', '', './img/Renna.png', '', 0, 1, 30, 0),
(96, 'Retoque Raiz', 'Retoque Raiz', 'Retoque Raiz', './img/RetoqueRaiz.png', '', 0, 1, 30, 0),
(97, 'secagem', 'secagem', '', './img/secagem.png', '', 0, 1, 30, 0),
(98, 'Escova Sem Formol', 'sem formol', 'sem formol', './img/SemFormol.png', '', 0, 1, 30, 0),
(99, 'Sessao de Tratamento', 'sessao de tratamento', 'sessao de tratamento', './img/SessaoTratamento.png', '', 0, 1, 30, 0),
(100, 'Sobrancelha com Cera', 'sobrancelha sobrancelhas cera', 'sobrancelhas com cera', './img/SobrancelhaCera.png', '', 0, 1, 30, 0),
(101, 'Spa Mao e Pe', 'Spa Mao e Pe', '', './img/SpaMaosePe.png', '', 0, 1, 30, 0),
(102, 'Terapia Capilar', 'terapia capilar', '', './img/TerapiaCapilar.png', '', 0, 1, 30, 0),
(103, 'Tiarinha', 'cabelo Tiarinha', 'Tiarinha', './img/Tiarinha.png', '', 0, 1, 30, 0),
(104, 'Toalha Quente', 'Toalha Quente', 'oalha Quente', './img/ToalhaQuente.png', '', 0, 1, 30, 0),
(105, 'Tonalizacao', 'cabelo cabelos ton Tonalizacao', 'Tonalizacao', './img/Tonalizacao.png', '{hidrat}', 0, 1, 30, 0),
(106, 'Trança', 'cabelo cabelos tranca', 'cabelos tranca', './img/Tranca.png', '', 0, 1, 30, 0),
(107, 'Tratamento anticelulite', 'tratamento anticelulite  celulite', 'tratamento anticelulite  celulite', './img/Tratamentoanticelulite.png', '{hidrat}', 0, 1, 30, 0),
(108, 'Tratamento com Gesso Crioterapia Endermologia', 'tratamento gesso', 'tratamento gesso', './img/TratamentoGesso.png', '', 0, 1, 30, 0),
(109, 'Tratamento corporal ortomolecular', 'tratamento corporal ortomolecular', 'tratamento corporal ortomolecular', './img/Tratamentocorporalortomolecular.png', '', 0, 1, 30, 0),
(110, 'Tratamento Anti Acne', 'tratamento anti acne', 'tratamento anti acne', './img/TratamentoAntiAcne.png', '', 0, 1, 30, 0),
(111, 'Tratamento AntiIdade', 'tratamento anti idade antidade', 'tratamento anti idade antiidade', './img/TratamentoAntiIdade.png', '{old}', 0, 1, 30, 0),
(112, 'Unha Caviar', 'unha caviar', '', './img/unhaCaviar.png', '{nail}', 0, 1, 30, 0),
(113, 'Unha Porcela', 'unha porcelana', 'unhas porcelana', './img/unhaPorcela.png', '{nail}', 0, 1, 30, 0),
(114, 'Unha postica', 'unha unhas postica', 'unhas postica', './img/Unhapostica.png', '{nail}', 0, 1, 30, 0),
(115, 'UnisexCorte', 'corte unisex menino menina', 'corte unisex menino menina', './img/UnisexCorte.png', '{casal}', 0, 1, 30, 0),
(116, 'Unisex Infantil', '{kid} cabelos cabelo unisex infantil criança', 'cabelo unisex infantil', './img/unisexInfantil.png', '', 0, 1, 30, 0),
(117, 'Visagismo Capilar', 'visagismo capilar cabelo cabelos', '', './img/visagismocapilar.png', '', 200, 3, 60, 1),
(118, 'Sobrancelha', 'sobrancelha sobrancelha sobrancelhas', 'sobrancelhas design cilios', './img/Sobrancelha.png', '{one eye}', 27, 1, 30, 1),
(119, 'Penteado Especial', 'penteado pentear cabelo cabelos coque', 'penteado', './img/Penteado.png', NULL, 130, 1, 30, 0),
(120, 'franja', 'franja franjas', 'temos Diversos tipos de cortes infantil', './img/CorteInfantilFeminino.png', NULL, 32, 1, 30, 1),
(121, 'Tratamento de cabelo', 'tratamento cabelo reconstrucao fortalecimento queratina', 'tratamento', './img/Penteado.png', NULL, 90, 1, 30, 1);

INSERT INTO `fluxoCaixa` (`id_fluxoCaixa`, `id_principal`, `id_funcionario`, `horaDataAbertura`, `horaDataFechamento`, `valorAbertura`, `valorFechamento`, `dataHora`, `valor`, `tipo`, `situacao`, `meioPgto`, `diaPgtoCartao`, `id_parcela`, `parcelas`, `observacao`, `ativo`) VALUES
(1, NULL, NULL, NULL, NULL, 0, 0, '2024-06-14 11:45:00', 240, 'S', 'fechada', 'DI', 1, 0, 1, NULL, 1),
(2, NULL, NULL, NULL, NULL, 0, 0, '2024-06-14 14:15:00', 295, 'S', 'fechada', 'DE', 1, 0, 1, NULL, 1),
(3, NULL, NULL, NULL, NULL, 0, 0, '2024-06-14 15:10:00', 16.5, 'S', 'fechada', 'DI', 1, 0, 1, NULL, 1),
(4, NULL, NULL, NULL, NULL, 0, 0, '2024-06-14 16:30:00', 26, 'E', 'aberta', 'DE', 1, 0, 1, NULL, 1),
(5, NULL, NULL, NULL, NULL, 0, 0, '2024-06-14 16:30:00', 230, 'S', 'fechada', 'CR', 12, 0, 1, NULL, 1),
(6, NULL, NULL, NULL, NULL, 0, 0, '2024-06-14 16:30:00', 6, 'E', 'aberta', 'DE', 1, 0, 1, NULL, 1),
(7, NULL, NULL, NULL, NULL, 0, 0, '2024-02-08 11:30:00', 76.5, 'S', 'fechada', 'DE', 1, 0, 1, NULL, 1),
(8, NULL, NULL, NULL, NULL, 0, 0, '2024-02-08 15:30:00', 30, 'E', 'aberta', 'DE', 1, 0, 1, NULL, 1),
(9, NULL, NULL, NULL, NULL, 0, 0, '2024-02-08 15:00:00', 40, 'E', 'fechada', 'DE', 1, 0, 1, NULL, 1),
(10, NULL, NULL, NULL, NULL, 0, 0, '2024-02-12 15:00:00', 170, 'S', 'fechada', 'DE', 1, 0, 1, NULL, 1),
(11, NULL, NULL, NULL, NULL, 0, 0, '2024-03-13 00:00:00', 500, 'S', 'fechada', 'DE', 1, 0, 1, NULL, 1),
(12, NULL, NULL, NULL, NULL, 0, 0, '2024-03-11 00:00:00', 150, 'E', 'fechada', 'CR', 1, 0, 1, NULL, 1),
(13, NULL, NULL, NULL, NULL, 0, 0, '2024-03-16 00:00:00', 70, 'E', 'fechada', 'CR', 1, 0, 1, NULL, 1),
(27, 0, NULL, NULL, NULL, 0, 0, '2024-03-17 10:00:00', 50, 'E', 'aberta', 'DE', 1, 0, 1, '', 1),
(28, 0, NULL, NULL, NULL, 0, 0, '2024-03-17 10:00:00', 65, 'E', 'aberta', 'DE', 1, 0, 1, '', 1),
(66, 0, NULL, NULL, NULL, 0, 0, '2024-03-30 15:00:00', 20, 'E', 'aberta', 'DE', 1, 0, 1, '', 1),
(161, 0, NULL, NULL, NULL, 0, 0, '2024-04-20 11:00:00', 43, 'E', 'aberta', 'DE', 1, 0, 1, '', 1),
(171, 0, NULL, NULL, NULL, 0, 0, '2024-04-27 14:00:00', 43, 'E', 'aberta', 'DE', 1, 0, 1, '', 1),
(174, 0, NULL, NULL, NULL, 0, 0, '2024-05-02 14:00:00', 20, 'E', 'aberta', 'DE', 1, 0, 1, '', 1),
(175, 0, NULL, NULL, NULL, 0, 0, '2024-04-30 10:00:00', 55, 'E', 'aberta', 'DE', 1, 0, 1, '', 1),
(176, 0, NULL, NULL, NULL, 0, 0, '2024-04-30 13:00:00', 20, 'E', 'aberta', 'DE', 1, 0, 1, '', 1),
(177, 0, NULL, NULL, NULL, 0, 0, '2024-05-18 16:00:00', 37, 'E', 'aberta', 'DE', 1, 0, 1, '', 1);

INSERT INTO `fluxoCaixaItem` (`id_fluxoCaixaItem`, `id_fluxoCaixa`, `id_agenda`, `id_cliente`, `id_funcionario`, `descricao`, `id_produto`, `quantidade`, `valor`) VALUES
(1, 1, 0, 0, 0, 'secador de cabelos', 0, 2, 240),
(2, 2, 0, 0, 0, 'tv por assinatura', 0, 1, 65),
(3, 2, 0, 0, 0, 'serviço não catalogado', 0, 1, 115),
(4, 3, 0, 0, 0, 'compra de lampadas para luminaria', 0, 3, 5.5),
(5, 4, 0, 0, 0, 'shampoo seco revitalizante', 10, 2, 7),
(6, 4, 0, 0, 0, 'creme facial anti-idade', 1, 2, 6),
(7, 5, 0, 0, 0, 'pagamento da contabilidade', 0, 1, 230),
(8, 6, 0, 0, 0, 'perfume feminino floral', 5, 4, 30),
(9, 6, 0, 0, 0, 'protetor solar FPS 50', 7, 5, 40),
(10, 6, 0, 0, 0, 'perfume feminino floral', 5, 5, 40),
(11, 6, 0, 0, 0, 'shampoo seco revitalizante', 10, 5, 34),
(12, 6, 0, 0, 0, 'hidratante facial noturno', 7, 9, 40.2),
(13, 6, 0, 0, 0, 'creme facial anti-idade', 1, 21, 6),
(14, 7, 0, 0, 0, 'compra de marterial de limpeza', 0, 1, 230),
(15, 8, 0, 0, 0, 'Diversos a', 0, 1, 30),
(16, 9, 0, 0, 0, 'esmalte de unha azul', 7, 5, 40),
(17, 9, 0, 0, 0, 'condicionador', 4, 15, 40),
(18, 9, 0, 0, 0, 'shampoo seco revitalizante', 10, 2, 7),
(19, 10, 0, 0, 0, 'Conserto do encanamento da cozinha', 0, 1, 170),
(20, 11, 0, 0, 0, 'Novo bebedouro para a recepção', 0, 1, 500),
(21, 12, 0, 0, 0, 'Pgto atrazado de serviço feito no mes anterior', 0, 1, 150),
(22, 12, 0, 0, 0, 'sombra para os olhos neutra', 4, 4, 7),
(23, 12, 0, 0, 0, 'shampoo seco revitalizante', 10, 2, 7),
(24, 12, 0, 0, 0, 'kit manicure profissional', 6, 6, 90),
(25, 13, 0, 0, 0, 'Pgto antecipado de serviços externo de beleza', 0, 1, 70),
(79, 66, 100081, 9, 5, 'Serviços de estética prestados à Nell Junior pela profissional Pedro Dantas Matias', 0, 1, 20),
(186, 171, 100185, 8, 1, 'Serviços de estética prestados à Emília Santos pela profissional Sandra Florestan', 0, 1, 43),
(189, 174, 100188, 12, 6, 'Serviços de estética prestados à natasha pela profissional Emilia Carvalho', 0, 1, 20),
(190, 175, 100189, 18, 1, 'Serviços de estética prestados à Hillary pela profissional Sandra Florestan', 0, 1, 55),
(191, 176, 100190, 19, 6, 'Serviços de estética prestados à karcia lima pela profissional Emilia Carvalho', 0, 1, 20),
(192, 177, 100191, 9, 5, 'Serviços de estética prestados à Nell Junior pela profissional Pedro Dantas Matias', 0, 1, 37);

INSERT INTO `fornecedor` (`id_fornecedor`, `nome`, `razaoSocial`, `cnpjcpf`, `responsabel`, `email`, `telefone`, `celular`, `site`, `cep`, `endereco`, `bairro`, `cidade`, `estado`, `observacao`, `avatar`, `ativo`) VALUES
(1, 'loreal', 'loreal Brasil S.A.', NULL, NULL, NULL, '31212122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, './img/loreal.png', 1),
(2, 'avon', 'avon perfumes e afins', NULL, NULL, NULL, '6565656', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, './img/store.png', 1),
(3, 'oHub', 'oHub Cosmeticos', NULL, NULL, NULL, '767676767', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, './img/store.png', 1),
(4, 'Natura', 'NATURA COSMETICOS S.A.', NULL, NULL, NULL, '98987666', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, './img/natura.png', 1),
(5, 'Pedidos avulsos', '', NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, './img/store.png', 1),
(6, 'ACME cosmetivos', 'acme filial brasil', NULL, NULL, NULL, '10567555', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, './img/acme.png', 1);

INSERT INTO `funcionario` (`id_funcionario`, `nome`, `apelido`, `id_cargo`, `telefone`, `cpfCnpj`, `genero`, `id_banco`, `entradaManha`, `saidaManha`, `entradaTarde`, `saidaTarde`, `entradaNoite`, `saidaNoite`, `contaCorrente`, `modalidade`, `diaRemuneracao1`, `percentagemRemuneracao1`, `diaRemuneracao2`, `percentagemRemuneracao2`, `percentagemRemuneracaoGeral`, `remuneracaoFixa`, `domingo`, `segunda`, `terca`, `quarta`, `quinta`, `sexta`, `sabado`, `mes`, `cor`, `avatar`, `ativo`) VALUES
(1, 'Sandra Florestan', 'Sandra', 7, '551199878769', '', 'f', 123, '10:00', '13:00', '14:00', '18:00', '', '', '', 'mensal', '10', 60, '20', 40, 60, 0, 0, 0, 1, 1, 1, 1, 1, 1, '#ffff99', './funcionario/SansaStark.png', 1),
(2, 'Helena Soares', 'Helena', 7, '551198098977', '', 'f', 321, '', '', '14:30', '19:00', '', '', '', 'quinzenal', '05', 60, '25', 40, 70, 0, 0, 0, 1, 1, 1, 1, 0, 1, '#ff5050', './funcionario/Lenaheadey.png', 1),
(3, 'Cristiano Oharan', 'Cristiano', 5, '5511996813646', '', 'm', 333, '10:00', '12:00', '12:30', '17:00', '', '', '', 'mensal', '10', 60, '20', 40, 45, 0, 0, 1, 1, 1, 1, 1, 0, 1, '#cb3434', './funcionario/Christopher.png', 1),
(4, 'Natalia Domingos', 'Natalia', 13, '551199970909', '', 'f', 111, '09:00', '12:00', '13:00', '15:00', '', '', '', 'mensal', '05', 60, '20', 40, 50, 0, 0, 0, 1, 1, 1, 1, 0, 1, '#99ff99', './funcionario/NatalieDormer.png', 1),
(5, 'Pedro Dantas Matias', 'Pedro', 5, '5511996813646', '', 'm', 222, '09:00', '12:00', '14:00', '18:00', '', '', '', 'mensal', '05', 60, '20', 40, 45, 300, 0, 1, 1, 1, 1, 1, 1, 1, '#0099cc', './funcionario/Peterdinklage.png', 1),
(6, 'Emilia Carvalho', 'Emilia', 24, '551190909877', '', 'f', 123, '09:30', '13:30', '14:00', '15:00', '', '', '', 'mensal', '10', 60, '20', 40, 45, 0, 0, 0, 1, 1, 1, 1, 1, 1, '#ffcc66', './funcionario/EmiliaClarke.png', 1),
(7, 'Joice Barbosa', 'Joice', 3, '551190909877', NULL, 'f', 123, '09:30', '13:30', '14:00', '15:00', NULL, NULL, NULL, 'mensal', '10', 60, '20', 40, 45, 0, 0, 0, 1, 1, 1, 1, 1, 1, '#ffcc66', './funcionario/joyce.png', 1),
(8, 'Elenoa Silva', 'Elenoa', 3, '551190909877', NULL, 'f', 123, '09:30', '13:30', '14:00', '15:00', NULL, NULL, NULL, 'mensal', '10', 60, '20', 40, 45, 0, 0, 0, 1, 1, 1, 1, 1, 1, '#ffcc66', './funcionario/eleven.png', 1),
(9, 'Jonas Moraes', 'Jonas', 33, '551190909877', NULL, 'm', 123, '09:30', '13:30', '14:00', '15:00', NULL, NULL, NULL, 'mensal', '10', 60, '20', 40, 45, 0, 0, 0, 1, 1, 1, 1, 1, 1, '#ffcc66', './funcionario/jonhathan.png', 1),
(10, 'Jorge Silveira', 'Jorge', 36, '551190909877', NULL, 'm', 123, '09:30', '13:30', '14:00', '15:00', NULL, NULL, NULL, 'mensal', '10', 60, '20', 40, 45, 0, 0, 0, 1, 1, 1, 1, 1, 1, '#ffcc66', './funcionario/david.png', 1);

INSERT INTO `funcionarioEspecialidade` (`id_especialidade`, `id_funcionario`) VALUES
(4, 3),
(2, 3),
(10, 3),
(38, 4),
(118, 6),
(13, 6),
(14, 6),
(5, 2),
(1, 2),
(23, 2),
(6, 2),
(7, 2),
(8, 2),
(45, 2),
(11, 2),
(12, 2),
(84, 2),
(16, 2),
(92, 2),
(121, 2),
(5, 1),
(1, 1),
(2, 1),
(4, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(45, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(84, 1),
(15, 1),
(16, 1),
(92, 1),
(121, 1),
(117, 1),
(4, 5),
(2, 5),
(6, 5),
(10, 5);

INSERT INTO `grupo` (`id_grupo`, `nome`, `ativo`) VALUES
(1, 'cabelos ressecados', 1),
(2, 'cabelos oleosos', 1),
(3, 'cabelos negros', 1),
(4, 'cabelos ruivos', 1),
(5, 'cabelos afros', 1),
(6, 'cabelos cacheados', 1),
(7, 'cabelos loiros', 1),
(8, 'faixa etária - aprox.:15 aos 25', 1),
(9, 'faixa etária - aprox.:26 aos 35', 1),
(10, 'faixa etária - aprox.:36 aos 49', 1),
(11, 'faixa etária - 50 em diante', 1),
(12, 'promoção especial para os aniversariantes do mês', 1),
(13, 'cliente frequente', 1),
(14, 'cliente ocasional', 1),
(15, 'equipe neiltech', 1),
(16, 'cliente ausente a um bom tempo', 1),
(17, 'hipster - barba modelada', 1),
(18, 'profissionais - alto tiête', 1);

INSERT INTO `grupoCliente` (`id_grupo`, `id_cliente`) VALUES
(13, 1),
(11, 5),
(15, 11),
(15, 9),
(5, 3),
(7, 3),
(5, 15),
(6, 16),
(6, 18);

INSERT INTO `produto` (`id_produto`, `nome`, `codigobarras`, `marca`, `linha`, `categoria`, `descricao`, `precoCompra`, `precoVenda`, `id_fornecedor`, `prazoentrega`, `tipovenda`, `tipoconsumo`, `evitarsaidanegativa`, `estoqueatual`, `estoqueminimo`, `medida`, `observacao`, `avatar`, `ativo`) VALUES
(1, 'creme facial anti-idade', NULL, NULL, NULL, NULL, NULL, 45, 60, 3, 0, 1, 1, 0, 30, 10, NULL, NULL, NULL, 1),
(2, 'máscara capilar reconstrutora', NULL, NULL, NULL, NULL, NULL, 25, 35, 1, 0, 1, 1, 0, 40, 15, NULL, NULL, NULL, 1),
(3, 'batom matte nude', NULL, NULL, NULL, NULL, NULL, 12.5, 18, 4, 0, 1, 1, 0, 15, 5, NULL, NULL, NULL, 1),
(4, 'sombra para os olhos neutra', NULL, NULL, NULL, NULL, NULL, 20, 28, 4, 0, 1, 1, 0, 25, 10, NULL, NULL, NULL, 1),
(5, 'perfume feminino floral', NULL, NULL, NULL, NULL, NULL, 50, 75, 2, 0, 1, 1, 0, 18, 8, NULL, NULL, NULL, 1),
(6, 'kit manicure profissional', NULL, NULL, NULL, NULL, NULL, 65, 90, 3, 0, 1, 1, 0, 12, 5, NULL, NULL, NULL, 1),
(7, 'protetor solar FPS 50', NULL, NULL, NULL, NULL, NULL, 30, 45, 1, 0, 1, 1, 0, 22, 10, NULL, NULL, NULL, 1),
(8, 'pó compacto translúcido', NULL, NULL, NULL, NULL, NULL, 15, 22, 2, 0, 1, 1, 0, 30, 12, NULL, NULL, NULL, 1),
(9, 'máscara facial rejuvenescedora', NULL, NULL, NULL, NULL, NULL, 18, 25, 5, 0, 1, 1, 0, 28, 10, NULL, NULL, NULL, 1),
(10, 'shampoo seco revitalizante', NULL, NULL, NULL, NULL, NULL, 12, 18, 3, 0, 1, 1, 0, 20, 8, NULL, NULL, NULL, 1),
(11, 'esfoliante corporal de morango', NULL, NULL, NULL, NULL, NULL, 28, 35, 4, 0, 1, 1, 0, 15, 5, NULL, NULL, NULL, 1),
(12, 'removedor de maquiagem bifásico', NULL, NULL, NULL, NULL, NULL, 14, 20, 1, 0, 1, 1, 0, 25, 10, NULL, NULL, NULL, 1),
(13, 'gel para sobrancelhas', NULL, NULL, NULL, NULL, NULL, 10, 15, 2, 0, 1, 1, 0, 30, 12, NULL, NULL, NULL, 1),
(14, 'pincel de maquiagem profissional', NULL, NULL, NULL, NULL, NULL, 8, 12, 5, 0, 1, 1, 0, 40, 15, NULL, NULL, NULL, 1),
(15, 'cílios postiços naturais', NULL, NULL, NULL, NULL, NULL, 18, 25, 1, 0, 1, 1, 0, 20, 8, NULL, NULL, NULL, 1),
(16, 'creme depilatório suave', NULL, NULL, NULL, NULL, NULL, 16, 22, 3, 0, 1, 1, 0, 18, 8, NULL, NULL, NULL, 1),
(17, 'água micelar demaquilante', NULL, NULL, NULL, NULL, NULL, 25, 35, 2, 0, 1, 1, 0, 25, 10, NULL, NULL, NULL, 1),
(18, 'kit de esmaltes primavera', NULL, NULL, NULL, NULL, NULL, 40, 55, 4, 0, 1, 1, 0, 12, 5, NULL, NULL, NULL, 1),
(19, 'máscara para cílios volumosa', NULL, NULL, NULL, NULL, NULL, 14, 20, 5, 0, 1, 1, 0, 30, 12, NULL, NULL, NULL, 1),
(20, 'hidratante facial noturno', NULL, NULL, NULL, NULL, NULL, 28, 40, 6, 0, 1, 1, 0, 25, 10, NULL, NULL, NULL, 1),
(21, 'condicionador reparador de pontas', NULL, NULL, NULL, NULL, NULL, 15, 22, 6, 0, 1, 1, 0, 30, 12, NULL, NULL, NULL, 1),
(22, 'esmalte holográfico', NULL, NULL, NULL, NULL, NULL, 10, 18, 6, 0, 1, 1, 0, 20, 8, NULL, NULL, NULL, 1),
(23, 'perfume masculino amadeirado', NULL, NULL, NULL, NULL, NULL, 45, 65, 6, 0, 1, 1, 0, 15, 5, NULL, NULL, NULL, 1),
(24, 'sérum capilar revitalizante', NULL, NULL, NULL, NULL, NULL, 32, 48, 6, 0, 1, 1, 0, 18, 8, NULL, NULL, NULL, 1),
(25, 'máscara de argila purificante', NULL, NULL, NULL, NULL, NULL, 20, 30, 6, 0, 1, 1, 0, 25, 10, NULL, NULL, NULL, 1),
(26, 'kit de maquiagem profissional', NULL, NULL, NULL, NULL, NULL, 80, 120, 6, 0, 1, 1, 0, 12, 5, NULL, NULL, NULL, 1),
(27, 'óleo corporal hidratante', NULL, NULL, NULL, NULL, NULL, 22, 30, 1, 0, 1, 1, 0, 20, 8, NULL, NULL, NULL, 1);

INSERT INTO `agenda` (`id_agenda`, `id_agenda_original`, `id_funcionario`, `id_cliente`, `dataHoraInicio`, `dataHoraFim`, `sessaoNumero`, `totalSessoes`, `totalPreco`, `parcelarPrecoPorSessao`, `enviado`, `ativo`) VALUES
(100000, 0, 4, 2, '2022-06-25 10:00:00', '2022-06-25 11:30:00', 1, 1, 110, 1, 1, 1),
(100001, 0, 5, 1, '2022-06-01 10:00:00', '2022-06-01 11:00:00', 1, 1, 65, 1, 1, 1),
(100002, 0, 2, 3, '2022-06-25 16:30:00', '2022-06-25 17:30:00', 1, 1, 110, 1, 1, 1),
(100003, 0, 2, 1, '2022-06-25 14:00:00', '2022-06-25 15:00:00', 1, 1, 65, 1, 1, 1),
(100004, 0, 4, 4, '2022-06-25 13:00:00', '2022-06-25 14:00:00', 1, 1, 36, 1, 1, 1),
(100005, 0, 2, 2, '2022-06-25 17:00:00', '2022-06-25 18:00:00', 1, 1, 80, 1, 1, 1),
(100006, 0, 3, 1, '2022-05-25 14:00:00', '2022-05-25 14:50:00', 1, 1, 15, 1, 1, 1),
(100007, 0, 4, 4, '2022-05-27 13:00:00', '2022-05-27 14:00:00', 1, 1, 36, 1, 1, 1),
(100008, 0, 4, 2, '2022-05-27 10:30:00', '2022-05-27 12:00:00', 1, 1, 80, 1, 1, 1),
(100009, 0, 4, 1, '2022-05-27 14:00:00', '2022-05-27 14:50:00', 1, 1, 15, 1, 1, 1),
(100010, 0, 1, 11, '2024-06-12 10:00:00', '2024-03-12 11:00:00', 1, 1, 65, 1, 1, 1),
(100011, 0, 1, 9, '2024-06-12 13:00:00', '2024-03-12 14:00:00', 1, 1, 36, 1, 1, 1),
(100012, 0, 1, 5, '2024-06-12 11:00:00', '2024-03-12 12:00:00', 1, 1, 80, 1, 1, 1),
(100013, 0, 4, 6, '2024-06-13 10:30:00', '2024-03-13 12:00:00', 1, 1, 15, 1, 1, 1),
(100014, 0, 4, 7, '2024-06-13 13:00:00', '2024-03-13 14:00:00', 1, 1, 36, 1, 1, 1),
(100015, 0, 4, 8, '2024-06-13 14:00:00', '2024-03-13 15:00:00', 1, 1, 80, 1, 1, 1),
(100016, 0, 1, 10, '2024-06-13 15:00:00', '2024-03-13 16:00:00', 1, 1, 36, 1, 1, 1),
(100017, 0, 4, 12, '2024-06-13 17:30:00', '2024-03-13 18:30:00', 1, 1, 80, 1, 1, 1),
(100018, 0, 5, 1, '2024-06-14 10:30:00', '2024-03-14 11:30:00', 1, 1, 110, 1, 1, 1),
(100019, 0, 1, 4, '2024-06-14 10:30:00', '2024-03-14 12:00:00', 1, 1, 110, 1, 1, 1),
(100020, 0, 1, 2, '2024-06-14 10:00:00', '2024-03-14 10:30:00', 1, 1, 65, 1, 1, 1),
(100021, 0, 4, 5, '2024-06-14 13:00:00', '2024-03-14 14:30:00', 1, 1, 36, 1, 1, 1),
(100022, 0, 2, 7, '2024-06-14 15:00:00', '2024-03-14 15:30:00', 1, 1, 80, 1, 1, 1),
(100023, 0, 3, 1, '2024-06-14 13:00:00', '2024-03-14 14:00:00', 1, 1, 15, 1, 1, 1),
(100024, 0, 3, 6, '2024-06-14 15:00:00', '2024-03-14 16:30:00', 1, 1, 15, 1, 1, 1),
(100025, 0, 2, 3, '2024-06-14 18:00:00', '2024-03-14 19:00:00', 1, 1, 15, 1, 1, 1),
(100026, 0, 6, 6, '2024-06-14 11:00:00', '2024-03-14 11:30:00', 1, 1, 15, 1, 1, 1),
(100028, 0, 5, 7, '2024-06-15 10:30:00', '2024-03-17 11:30:00', 1, 1, 110, 1, 1, 1),
(100029, 0, 1, 8, '2024-06-15 10:30:00', '2024-03-17 11:00:00', 1, 1, 110, 1, 1, 1),
(100031, 0, 4, 12, '2024-06-15 13:30:00', '2024-03-17 14:30:00', 1, 1, 36, 1, 1, 1),
(100032, 0, 2, 6, '2024-06-15 16:00:00', '2024-03-17 16:30:00', 1, 1, 80, 1, 1, 1),
(100081, 0, 5, 9, '2024-06-30 15:00:00', '2024-03-30 16:00:00', 0, 1, 20, 1, 0, 1),
(100185, 0, 1, 8, '2024-04-27 14:00:00', '2024-04-27 15:00:00', 0, 1, 43, 1, 0, 1),
(100188, 0, 6, 12, '2024-05-02 14:00:00', '2024-05-02 15:00:00', 0, 1, 20, 1, 0, 1),
(100189, 0, 1, 18, '2024-04-30 10:00:00', '2024-04-30 11:00:00', 0, 1, 55, 1, 0, 1),
(100190, 0, 6, 19, '2024-04-30 13:00:00', '2024-04-30 14:00:00', 0, 1, 20, 1, 0, 1),
(100191, 0, 5, 9, '2024-05-18 16:00:00', '2024-05-18 17:00:00', 0, 1, 37, 1, 0, 1);

INSERT INTO `agendaEspecialidade` (`id_agenda`, `id_especialidade`) VALUES
(100005, 2),
(100008, 4),
(100009, 5),
(100010, 2),
(100001, 6),
(100001, 1),
(100002, 4),
(100002, 5),
(100003, 2),
(100002, 6),
(100006, 38),
(100004, 2),
(100026, 2),
(100026, 3),
(100023, 38),
(100024, 38),
(100025, 5),
(100025, 2),
(100016, 2),
(100017, 7),
(100019, 6),
(100019, 2),
(100011, 6),
(100013, 7),
(100016, 8),
(100007, 7),
(100007, 14),
(100018, 2),
(100020, 4),
(100021, 3),
(100022, 5),
(100023, 6),
(100024, 4),
(100025, 4),
(100026, 1),
(100081, 10),
(100185, 7),
(100188, 13),
(100189, 5),
(100190, 13),
(100191, 2);


-- Criação das triggers -----------------------------------------------------------------------------------------------------------------
drop trigger if exists after_insert_agenda;

DELIMITER //

CREATE TRIGGER after_insert_agenda
AFTER INSERT ON SalaoConsultorio.agenda
FOR EACH ROW
BEGIN
    INSERT INTO BusinessInteligence.agenda (
        id_agenda_original, id_funcionario, id_cliente, 
        data_hora_inicio, data_hora_fim, sessao_numero, 
        total_sessoes, total_preco, parcelar_preco_por_sessao, 
        enviado, ativo
    ) VALUES (
        NEW.id_agenda_original, NEW.id_funcionario, NEW.id_cliente, 
        NEW.dataHoraInicio, NEW.dataHoraFim, NEW.sessaoNumero, 
        NEW.totalSessoes, NEW.totalPreco, NEW.parcelarPrecoPorSessao, 
        NEW.enviado, NEW.ativo
    );
END //

DELIMITER ;

drop trigger if exists after_update_agenda;

DELIMITER //

CREATE TRIGGER after_update_agenda
AFTER UPDATE ON SalaoConsultorio.agenda
FOR EACH ROW
BEGIN
    UPDATE BusinessInteligence.agenda
    SET 
        id_agenda_original = NEW.id_agenda_original,
        id_funcionario = NEW.id_funcionario,
        id_cliente = NEW.id_cliente,
        data_hora_inicio = NEW.dataHoraInicio,
        data_hora_fim = NEW.dataHoraFim,
        sessao_numero = NEW.sessaoNumero,
        total_sessoes = NEW.totalSessoes,
        total_preco = NEW.totalPreco,
        parcelar_preco_por_sessao = NEW.parcelarPrecoPorSessao,
        enviado = NEW.enviado,
        ativo = NEW.ativo
    WHERE id_agenda = NEW.id_agenda;
END //

DELIMITER ;

drop trigger if exists after_delete_agenda;

DELIMITER //

CREATE TRIGGER after_delete_agenda
AFTER DELETE ON SalaoConsultorio.agenda
FOR EACH ROW
BEGIN
    DELETE FROM BusinessInteligence.agenda
    WHERE id_agenda = OLD.id_agenda;
END //

DELIMITER ;

drop trigger if exists after_insert_agendaEspecialidade;

DELIMITER //

CREATE TRIGGER after_insert_agendaEspecialidade
AFTER INSERT ON SalaoConsultorio.agendaEspecialidade
FOR EACH ROW
BEGIN
    INSERT INTO BusinessInteligence.agenda_servico (
        id_agenda, id_servico
    ) VALUES (
        NEW.id_agenda, NEW.id_especialidade
    );
END //

DELIMITER ;

drop trigger if exists after_update_agendaEspecialidade;

DELIMITER //

CREATE TRIGGER after_update_agendaEspecialidade
AFTER UPDATE ON SalaoConsultorio.agendaEspecialidade
FOR EACH ROW
BEGIN
    UPDATE BusinessInteligence.agenda_servico
    SET id_servico = NEW.id_especialidade
    WHERE id_agenda = OLD.id_agenda AND id_servico = OLD.id_especialidade;
END //

DELIMITER ;

drop trigger if exists after_delete_agendaEspecialidade;

DELIMITER //

CREATE TRIGGER after_delete_agendaEspecialidade
AFTER DELETE ON SalaoConsultorio.agendaEspecialidade
FOR EACH ROW
BEGIN
    DELETE FROM BusinessInteligence.agenda_servico
    WHERE id_agenda = OLD.id_agenda AND id_servico = OLD.id_especialidade;
END //

DELIMITER ;

drop trigger if exists after_insert_cliente;

DELIMITER //

CREATE TRIGGER after_insert_cliente
AFTER INSERT ON SalaoConsultorio.cliente
FOR EACH ROW
BEGIN
    INSERT INTO BusinessInteligence.cliente (
        id_cliente, nome, contato, telefone, aniversario, genero, 
        observacao_sobre_o_cliente, avatar, email, enviar_email, 
        divulgacao, robo_pode_atender, robo_pode_agendar, ativo
    ) VALUES (
        NEW.id_cliente, NEW.nome, NEW.contato, NEW.telefone, NEW.aniversario, NEW.genero, 
        NEW.observacaoCli, NEW.avatar, NEW.email, NEW.enviarEmail, 
        NEW.divulgacao, NEW.roboPodeAtender, NEW.roboPodeAgendar, NEW.ativo
    );
END //

DELIMITER ;

drop trigger if exists after_update_cliente;

DELIMITER //

CREATE TRIGGER after_update_cliente
AFTER UPDATE ON SalaoConsultorio.cliente
FOR EACH ROW
BEGIN
    UPDATE BusinessInteligence.cliente
    SET 
        nome = NEW.nome,
        contato = NEW.contato,
        telefone = NEW.telefone,
        aniversario = NEW.aniversario,
        genero = NEW.genero,
        observacao_sobre_o_cliente = NEW.observacaoCli,
        avatar = NEW.avatar,
        email = NEW.email,
        enviar_email = NEW.enviarEmail,
        divulgacao = NEW.divulgacao,
        robo_pode_atender = NEW.roboPodeAtender,
        robo_pode_agendar = NEW.roboPodeAgendar,
        ativo = NEW.ativo
    WHERE id_cliente = NEW.id_cliente;
END //

DELIMITER ;

drop trigger if exists after_delete_cliente;

DELIMITER //

CREATE TRIGGER after_delete_cliente
AFTER DELETE ON SalaoConsultorio.cliente
FOR EACH ROW
BEGIN
    DELETE FROM BusinessInteligence.cliente
    WHERE id_cliente = OLD.id_cliente;
END //

-- Procedures que atualizam BusinessInteligence -----------------------------------------------------------------------------------------------------------------

DELIMITER ;

drop procedure if exists load_agenda_data;

DELIMITER //

CREATE PROCEDURE load_agenda_data()
BEGIN
	SET GLOBAL SQL_SAFE_UPDATES = 0;

	DELETE FROM BusinessInteligence.agenda_servico;
	DELETE FROM BusinessInteligence.agenda;

	INSERT INTO BusinessInteligence.agenda (
		id_agenda, id_agenda_original, id_funcionario, id_cliente, 
		data_hora_inicio, data_hora_fim, sessao_numero, total_sessoes, 
		total_preco, parcelar_preco_por_sessao, enviado, ativo
	)
	SELECT 
		id_agenda, id_agenda_original, id_funcionario, id_cliente, 
		dataHoraInicio, dataHoraFim, sessaoNumero, totalSessoes, 
		totalPreco, parcelarPrecoPorSessao, enviado, ativo
	FROM SalaoConsultorio.agenda;

	INSERT INTO BusinessInteligence.agenda_servico (id_agenda, id_servico)
	SELECT id_agenda, id_especialidade
	FROM SalaoConsultorio.agendaEspecialidade;
END //

DELIMITER ;

drop procedure if exists load_cliente_data;

DELIMITER //

CREATE PROCEDURE load_cliente_data()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_cliente INT;
    DECLARE v_nome VARCHAR(50);
    DECLARE v_contato VARCHAR(50);
    DECLARE v_telefone VARCHAR(30);
    DECLARE v_aniversario DATETIME;
    DECLARE v_genero VARCHAR(1);
    DECLARE v_observacaoCli TEXT;
    DECLARE v_avatar VARCHAR(45);
    DECLARE v_email VARCHAR(40);
    DECLARE v_enviarEmail BOOLEAN;
    DECLARE v_divulgacao BOOLEAN;
    DECLARE v_roboPodeAtender BOOLEAN;
    DECLARE v_roboPodeAgendar BOOLEAN;
    DECLARE v_ativo INT;

    -- Cursor para percorrer a tabela SalaoConsultorio.cliente
    DECLARE cliente_cursor CURSOR FOR
        SELECT id_cliente, nome, contato, telefone, aniversario, genero, 
               observacaoCli, avatar, email, enviarEmail, divulgacao, 
               roboPodeAtender, roboPodeAgendar, ativo
        FROM SalaoConsultorio.cliente;

    -- Handler para encerrar o loop quando o cursor atingir o final
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cliente_cursor;

    read_loop: LOOP
        FETCH cliente_cursor INTO v_id_cliente, v_nome, v_contato, v_telefone, 
                                v_aniversario, v_genero, v_observacaoCli, 
                                v_avatar, v_email, v_enviarEmail, v_divulgacao, 
                                v_roboPodeAtender, v_roboPodeAgendar, v_ativo;

        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insere os dados na tabela BusinessInteligence.cliente
        INSERT INTO BusinessInteligence.cliente (
            id_cliente, nome, contato, telefone, aniversario, genero, 
            observacao_sobre_o_cliente, avatar, email, enviar_email, 
            divulgacao, robo_pode_atender, robo_pode_agendar, ativo
        ) VALUES (
            v_id_cliente, v_nome, v_contato, v_telefone, v_aniversario, v_genero, 
            v_observacaoCli, v_avatar, v_email, v_enviarEmail, v_divulgacao, 
            v_roboPodeAtender, v_roboPodeAgendar, v_ativo
        );
    END LOOP;

    CLOSE cliente_cursor;
END //
