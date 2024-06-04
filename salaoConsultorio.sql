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
