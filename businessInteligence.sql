 /* 
    Script de criação de estrutura do banco de dados mysql BusinessInteligence
    
						            	                             Nell Jr.

*/

set auto_increment_increment = 1;
use BusinessInteligence;

drop table if exists funcionario_servico;
drop table if exists agenda_servico;
drop table if exists agenda;
drop table if exists cliente;
drop table if exists servico;
drop table if exists fluxo_de_caixa_item; 
drop table if exists fluxo_de_caixa; 
drop table if exists funcionario;
drop table if exists cargo;
drop table if exists produto;                         
drop table if exists fornecedor;
drop table if exists mes; 
drop table if exists feriado;
drop table if exists empresa; 

create table if not exists empresa (id_empresa int auto_increment primary key,
                                    nome_empresa varchar(100) not null,
                                    telefone varchar(20) not null,
                                    responsavel varchar(200) not null,
                                    adesao varchar(20) not null,
                                    nome_usuario varchar(50) null, 
                                    endereco varchar(255) not null,
                                    cep varchar(10) not null,
                                    email varchar(100) not null,
                                    cnpj varchar(18) null,
                                    instagram varchar(200) null, 
                                    nome_do_bot  varchar(100) null, 
                                    avatar varchar(100) null, 
                                    horario json not null, 
                                    atender_nao_cadastrados int not null default true,
                                    modalidade varchar(20) not null,
                                    dia_remuneracao_1 varchar(2) not null default "01",
                                    percentagem_remuneracao_1 int not null default 0,
                                    dia_remuneracao_2 varchar(2) default "00",
                                    percentagem_remuneracao_2 int not null default 0,
                                    percentagem_remuneracao_geral int not null default 0,
                                    semana json not null, 
                                    ativo integer default 1 );

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
                                   ,data_feriado datetime 
                                   ,nome varchar(100) not null 
                                   ,ativo integer default 1);
                                   
	insert into feriado (data_feriado, nome, ativo) 
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
									   ,razao_social  varchar(100) null
									   ,cnpj_cpf varchar(20) null 
									   ,responsavel varchar(50) null 
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
									,codigo_de_barras  varchar(40) null 
									,marca varchar(40) null 
									,linha varchar(10) null 
									,categoria varchar(10) null 
									,descricao varchar(100) null 
									,preco_compra float default 0  
                                    ,preco_venda float default 0  
									,id_fornecedor integer 
									,prazo_entrega integer default 0 
									,tipo_venda integer default 1 
									,tipo_consumo integer default 1
									,evitar_saida_negativa integer default 0  
									,estoque_atual float default 0 
									,estoque_minimo  float default 0 
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
                                  ,observacao_sobre_o_cliente text  
								  ,avatar varchar(45) null
								  ,email varchar(40) 
								  ,enviar_email boolean default 0
								  ,divulgacao boolean default 1
                                  ,robo_pode_atender boolean default 0
                                  ,robo_pode_agendar boolean default 0
								  ,ativo integer default 1);

create table if not exists servico(id_servico integer primary key auto_increment 
										,nome varchar(50) not null
                                        ,palavras_chaves varchar (200) not null 
										,descricao varchar(100) null
										,avatar varchar(45) null 
                                        ,emoji varchar(20) null 
										,preco double not null default 0 
                                        ,sessoes integer not null default 1
                                        ,tempo_necessario_por_sessao  integer default 30
										,ativo boolean default 0);

create table if not exists cargo (id_cargo integer primary key auto_increment 
								 ,nome varchar(50) not null
								 ,ativo integer default 1); 

create table if not exists funcionario(id_funcionario integer primary key auto_increment 
									   ,nome varchar(50) not null
									   ,apelido varchar(30) default ''
									   ,id_cargo integer 
									   ,telefone varchar(30) null
									   ,cpf_cnpj varchar(14) null
									   ,genero varchar(1) default 'f'  
									   ,id_banco  integer null
									   ,entrada_manha varchar(5) 
									   ,saida_manha varchar(5)                                                    
									   ,entrada_tarde varchar(5) 
									   ,saida_tarde varchar(5) 
									   ,entrada_noite varchar(5) 
									   ,saida_noite varchar(5)                                                    
									   ,conta_corrente varchar(14) null
                                       ,modalidade varchar(10) default ''  
                                       ,dia_remuneracao_1 varchar(10) default ''  
                                       ,percentagem_remuneracao_1 integer default 0 
                                       ,dia_remuneracao_2 varchar(10) default ''  
                                       ,percentagem_remuneracao_2 integer default 0                                           
                                       ,percentagem_remuneracao_geral integer default 0
                                       ,remuneracao_fixa float default 0
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
								 ,data_hora_inicio datetime not null
								 ,data_hora_fim datetime not null
                                 ,sessao_numero integer not null default 1 
                                 ,total_sessoes integer not null default 1																
								 ,total_preco double not null default 0
                                 ,parcelar_preco_por_sessao tinyint(1) default true  
								 ,enviado boolean default 0
								 ,ativo tinyint(1)  default true                
								 ,constraint foreign key(id_cliente) references cliente(id_cliente)
								 ,constraint foreign key(id_funcionario) references funcionario(id_funcionario));

alter table agenda auto_increment = 100000;

create table if not exists agenda_servico(id_agenda integer not null
										,id_servico integer not null
										,foreign key(id_agenda) references agenda(id_agenda)
										,foreign key(id_servico) references servico(id_servico));
										
CREATE TABLE IF NOT EXISTS funcionario_servico (
		id_servico INTEGER NOT NULL,
		id_funcionario INTEGER NOT NULL,
		CONSTRAINT idxfuncionario_servico 
			FOREIGN KEY (id_servico)
				REFERENCES servico (id_servico),
			FOREIGN KEY (id_funcionario)
				REFERENCES funcionario (id_funcionario));

create table if not exists fluxo_de_caixa( id_fluxo_de_caixa integer primary key auto_increment
                                      ,id_principal integer                 /* Para o caso de parcelamento e consequentemente novos registros vinculados  */
                                      ,id_funcionario integer
                                      ,hora_data_abertura datetime null    
                                      ,hora_data_fechamento datetime null  
                                      ,valor_abertura  float default 0
                                      ,valor_fechamento float default 0                                                                            
                                      ,data_hora datetime not null  
                                      ,valor float default 0  
                                      ,tipo  varchar(1) default 'E'        /*  Valores possiveis  'E' = Entrada de valor e  'S' Saida de valor   */
                                      ,situacao varchar(10) default 'aberta' 
                                      ,meio_pagamento varchar(2) default 'DI'    /* Valores possiveis: 'DI': Dinheiro, 'DE': Cartão de Débito , 'CR': Cartão de Crédito, 'CH': Cheque */   
                                      ,dia_pagamento_cartao integer default 1
                                      ,id_parcela integer default 0 
                                      ,parcelas integer default 1  
                                      ,observacao varchar(200) null 
                                      ,ativo integer default true
                                      ,foreign key(id_funcionario) references funcionario(id_funcionario)); 

create table if not exists fluxo_de_caixa_item (id_fluxo_de_caixa_item integer auto_increment
                                          ,id_fluxo_de_caixa integer  
                                          ,id_agenda integer default 0 
                                          ,id_cliente integer default 0  
                                          ,id_funcionario integer default 0  
                                          ,descricao  varchar(200) not null
                                          ,id_produto integer default 0 
                                          ,quantidade integer default 1  
                                          ,valor float default 0 
                                          ,foreign key(id_fluxo_de_caixa) references fluxo_de_caixa(id_fluxo_de_caixa) on delete cascade  
                                          ,primary key (id_fluxo_de_caixa_item,id_fluxo_de_caixa ));

                          
-- Carga das Tabelas  --------------------------------------------------------------------------------------------------------
 
INSERT INTO `servico` (`id_servico`, `nome`, `palavras_chaves`, `descricao`, `avatar`, `emoji`, `preco`, `sessoes`, `tempo_necessario_por_sessao`, `ativo`) VALUES
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

			    insert into cargo (nome) values ("Assistente") 
							   ,("Acupunturista")
							   ,("Administrativo") 
							   ,("Auxiliar de serviços gerais")
							   ,("Barbeiro")
							   ,("Caixa")
							   ,("Cabeleireiro")
							   ,("Café")
							   ,("Colorista")
							   ,("Copeira")
							   ,("Consultor")
							   ,("Cirurgião Plástico")
							   ,("Depilador")
							   ,("Designer de sobrancelhas")
							   ,("Estoquista")
							   ,("Esteticista")
							   ,("Faxineira")
							   ,("Freelancer")
							   ,("Fisioterapeuta")
							   ,("Financeiro")
							   ,("Gerente")
							   ,("Gestor") 
							   ,("Marketing")
							   ,("Manicure")
							   ,("Manobrista")
							   ,("Manutenção")
							   ,("Maquiador")
							   ,("Massagista")
							   ,("Micropigmentador")
							   ,("Nutricionista")
							   ,("Pedicure")
							   ,("Podologista")
							   ,("Recepcionista")
							   ,("Terapeuta")
							   ,("Tatuador")
							   ,("Vendedor");

		    insert into funcionario(nome
					   ,apelido
					   ,id_cargo
					   ,genero
					   ,telefone
					   ,id_banco
					   ,domingo
					   ,segunda
					   ,terca
					   ,quarta
					   ,quinta
					   ,sexta
					   ,sabado
					   ,avatar
					   ,cor
					   ,entrada_manha
					   ,saida_manha
					   ,entrada_tarde
					   ,saida_tarde
					   ,dia_remuneracao_1
					  , percentagem_remuneracao_1
					  , dia_remuneracao_2
					  , percentagem_remuneracao_2 
					  , percentagem_remuneracao_geral 
					  , remuneracao_fixa 
                       ,modalidade ) 
														  
		       values('Sandra Florestan','Sandra','7','f', '551199878769','123',0,1,1,1,1,1,0,'./funcionario/SansaStark.png', '#ffff99', '10:00','13:00', '14:00', '18:00', '10', '60', '20', '40', '60', '0', 'mensal')  
			    ,('Helena Soares','Helena','7','f','551198098977','321',0,0,1,1,1,1,0,'./funcionario/Lenaheadey.png', '#ff5050', null , null, '14:30', '19:00','05', '60', '25', '40', '70', '0', 'quinzenal')
			    ,('Cristiano Oharan','Cristiano','7','m','5511996813646','333',0,1,1,1,1,1,0,'./funcionario/Christopher.png','#cb3434','10:00','12:00', '12:30', '17:00','10', 60, 20, 40, 45, 0, 'mensal')
			    ,('Natalia Domingos','Natalia','13', 'f', '551199970909','111',0,0,1,1,1,1,0,'./funcionario/NatalieDormer.png', '#99ff99','09:00','12:00', '13:00', '15:00','05', 60, 20, 40, 50,0, 'mensal')
			    ,('Pedro Dantas Matias','Pedro','5', 'm','5511996813646','222',0,1,1,1,1,1,1,'./funcionario/Peterdinklage.png', '#0099cc', '09:00','12:00', '14:00', '18:00', '05', 60, 20, 40, 45, 300.00, 'mensal')
			    ,('Emilia Carvalho','Emilia','24','f','551190909877','123', 0,0,1,1,1,1,1,'./funcionario/EmiliaClarke.png','#ffcc66', '09:30','13:30', '14:00', '15:00','10', 60, 20, 40, 45, 0, 'mensal')
			    ,('Joice Barbosa','Joice',(select id_cargo from cargo where nome = 'Administrativo'),'f','551190909877','123', 0,0,1,1,1,1,1,'./funcionario/joyce.png','#ffcc66', '09:30','13:30', '14:00', '15:00','10', 60, 20, 40, 45, 0, 'mensal')
			    ,('Elenoa Silva','Elenoa',(select id_cargo from cargo where nome = 'Administrativo'),'f','551190909877','123', 0,0,1,1,1,1,1,'./funcionario/eleven.png','#ffcc66', '09:30','13:30', '14:00', '15:00','10', 60, 20, 40, 45, 0, 'mensal')
			    ,('Jonas Moraes','Jonas',(select id_cargo from cargo where nome = 'Recepcionista'),'m','551190909877','123', 0,0,1,1,1,1,1,'./funcionario/jonhathan.png','#ffcc66', '09:30','13:30', '14:00', '15:00','10', 60, 20, 40, 45, 0, 'mensal')
			    ,('Jorge Silveira','Jorge',(select id_cargo from cargo where nome = 'Vendedor'),'m','551190909877','123', 0,0,1,1,1,1,1,'./funcionario/david.png','#ffcc66', '09:30','13:30', '14:00', '15:00','10', 60, 20, 40, 45, 0, 'mensal');

insert into funcionario_servico(id_servico,id_funcionario) values(1,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(5,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(6,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(7,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(11,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(12,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(17,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(45,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(8,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(9,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(13,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(14,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(15,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(16,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(92,1) ;   
insert into funcionario_servico(id_servico,id_funcionario) values(16,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(2,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(3,1) ;
insert into funcionario_servico(id_servico,id_funcionario) values(2,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(1,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(4,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(5,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(6,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(7,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(11,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(12,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(17,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(45,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(16,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(92,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(5,3) ;
insert into funcionario_servico(id_servico,id_funcionario) values(6,3) ;
insert into funcionario_servico(id_servico,id_funcionario) values(7,3) ;
insert into funcionario_servico(id_servico,id_funcionario) values(11,3) ;
insert into funcionario_servico(id_servico,id_funcionario) values(12,3) ;
insert into funcionario_servico(id_servico,id_funcionario) values(17,3) ;
insert into funcionario_servico(id_servico,id_funcionario) values(45,3) ;
insert into funcionario_servico(id_servico,id_funcionario) values(38,3) ;
insert into funcionario_servico(id_servico,id_funcionario) values(10,3) ;
insert into funcionario_servico(id_servico,id_funcionario) values(2,5) ;																			   
insert into funcionario_servico(id_servico,id_funcionario) values(38,4) ;
insert into funcionario_servico(id_servico,id_funcionario) values(7,6) ;
insert into funcionario_servico(id_servico,id_funcionario) values(2,6) ;
insert into funcionario_servico(id_servico,id_funcionario) values(117,6) ;
insert into funcionario_servico(id_servico,id_funcionario) values(17,5) ;
insert into funcionario_servico(id_servico,id_funcionario) values(1,5) ;
insert into funcionario_servico(id_servico,id_funcionario) values(6,5) ;
insert into funcionario_servico(id_servico,id_funcionario) values(117,5) ;
insert into funcionario_servico(id_servico,id_funcionario) values(10,5) ;
insert into funcionario_servico(id_servico,id_funcionario) values(23,2) ;
insert into funcionario_servico(id_servico,id_funcionario) values(14,6) ;
insert into funcionario_servico(id_servico,id_funcionario) values(6,4) ;
insert into funcionario_servico(id_servico,id_funcionario) values(7,4) ;
insert into funcionario_servico(id_servico,id_funcionario) values(11,4) ;
insert into funcionario_servico(id_servico,id_funcionario) values(12,3) ;
insert into funcionario_servico(id_servico,id_funcionario) values(17,4) ;


insert into fornecedor (nome, razao_social, telefone, avatar ) 
	   values ('loreal' , 'loreal Brasil S.A.', '31212122','./img/loreal.png') 
			 ,('avon',  'avon perfumes e afins', '6565656', './img/store.png') 
			 ,('oHub', 'oHub Cosmeticos', '767676767', './img/store.png')
			 ,('Natura', 'NATURA COSMETICOS S.A.' ,'98987666','./img/natura.png')
             ,('Pedidos avulsos', '' ,'','./img/store.png')
			 ,('ACME cosmetivos' , 'acme filial brasil','10567555', './img/acme.png');
			 
insert into produto (nome, id_fornecedor, preco_compra, preco_venda, estoque_atual, estoque_minimo) 
	values 
		('creme facial anti-idade', 3, 45.00, 60.00, 30, 10),
		('máscara capilar reconstrutora', 1, 25.00, 35.00, 40, 15),
		('batom matte nude', 4, 12.50, 18.00, 15, 5),
		('sombra para os olhos neutra', 4, 20.00, 28.00, 25, 10),
		('perfume feminino floral', 2, 50.00, 75.00, 18, 8),
		('kit manicure profissional', 3, 65.00, 90.00, 12, 5),
		('protetor solar FPS 50', 1, 30.00, 45.00, 22, 10),
		('pó compacto translúcido', 2, 15.00, 22.00, 30, 12),
		('máscara facial rejuvenescedora', 5, 18.00, 25.00, 28, 10),
		('shampoo seco revitalizante', 3, 12.00, 18.00, 20, 8),
		('esfoliante corporal de morango', 4, 28.00, 35.00, 15, 5),
		('removedor de maquiagem bifásico', 1, 14.00, 20.00, 25, 10),
		('gel para sobrancelhas', 2, 10.00, 15.00, 30, 12),
		('pincel de maquiagem profissional', 5, 8.00, 12.00, 40, 15),
		('cílios postiços naturais', 1, 18.00, 25.00, 20, 8),
		('creme depilatório suave', 3, 16.00, 22.00, 18, 8),
		('água micelar demaquilante', 2, 25.00, 35.00, 25, 10),
		('kit de esmaltes primavera', 4, 40.00, 55.00, 12, 5),
		('máscara para cílios volumosa', 5, 14.00, 20.00, 30, 12),
        ('hidratante facial noturno', 6, 28.00, 40.00, 25, 10),
        ('condicionador reparador de pontas', 6, 15.00, 22.00, 30, 12),
        ('esmalte holográfico', 6, 10.00, 18.00, 20, 8),
        ('perfume masculino amadeirado', 6, 45.00, 65.00, 15, 5),
        ('sérum capilar revitalizante', 6, 32.00, 48.00, 18, 8),
        ('máscara de argila purificante', 6, 20.00, 30.00, 25, 10),
        ('kit de maquiagem profissional', 6, 80.00, 120.00, 12, 5),
		('óleo corporal hidratante', 1, 22.00, 30.00, 20, 8);
																		
insert into fluxo_de_caixa(data_hora, valor, tipo,meio_pagamento, situacao) 
values 
 (timestamp(curdate(),'11:45'),240.00,'S','DI', 'fechada')
,(timestamp(curdate(),'14:15'), 295.00 ,'S','DE', 'fechada') 
,(timestamp(curdate(),'15:10'),16.50,'S','DI', 'fechada')
,(timestamp(curdate(),'16:30'),26.00, 'E','DE', 'aberta')
,(timestamp(curdate(),'16:30'),230.00,'S','CR', 'fechada')
,(timestamp(curdate(),'16:30'),6.00,'E','DE', 'aberta')
,(timestamp(subdate(curdate(), 35),'11:30'),76.50,'S','DE', 'fechada')                                                                                     
,(timestamp(subdate(curdate(), 35),'15:30'),30.00,'E','DE', 'aberta')
,(timestamp(subdate(curdate(), 35),'15:00'),40.00,'E','DE', 'fechada')                                                                                     
,(timestamp(subdate(curdate(), 31),'15:00'),170.00,'S','DE', 'fechada')
,(timestamp(date_add(curdate(), interval -1 day)),500.00,'S','DE', 'fechada')
,(timestamp(date_add(curdate(), interval -3 day)),150.00,'E','CR', 'fechada')
,(timestamp(date_add(curdate(), interval 2 day)),70.00,'E','CR', 'fechada');

update fluxo_de_caixa set dia_pagamento_cartao = 12 where id_fluxo_de_caixa = 5 ; 

insert into fluxo_de_caixa_item (id_fluxo_de_caixa, descricao, valor, id_produto, quantidade) 
                   values (1, 'secador de cabelos' , 240.00 ,0 ,2) 
                         ,(2,'tv por assinatura', 65.00 , 0, 1) 
                         ,(2,'serviço não catalogado',115.00, 0, 1)
                         ,(3,'compra de lampadas para luminaria',5.50, 0,3)
                         ,(4,'shampoo seco revitalizante',7.00, 10,2)
                         ,(4,'creme facial anti-idade',6.00, 1,2)
                         ,(5,'pagamento da contabilidade',230.00,0,1)                                                                                     
                         ,(6,'perfume feminino floral',30.00,5,4)
                         ,(6,'protetor solar FPS 50',40.00, 7,5)                          
                         ,(6,'perfume feminino floral',40.00, 5,5)                          
                         ,(6,'shampoo seco revitalizante',34.00, 10,5) 
                         ,(6,'hidratante facial noturno',40.20, 7,9)                          
                         ,(6,'creme facial anti-idade',6.00, 1,21)
                         ,(7,'compra de marterial de limpeza',230.00, 0,1)
                         ,(8,'Diversos a',30.00, 0,1)
                         ,(9,'esmalte de unha azul',40.00, 7,5)                                                                                     
                         ,(9,'condicionador',40.00, 4,15) 
                         ,(9,'shampoo seco revitalizante',7.00, 10,2)
                         ,(10,'Conserto do encanamento da cozinha','170.00',0,1)
                         ,(11,'Novo bebedouro para a recepção','500.00',0,1)
                         ,(12,'Pgto atrazado de serviço feito no mes anterior','150.00',0,1)                         
                         ,(12,'sombra para os olhos neutra',7.00, 4,4)
                         ,(12,'shampoo seco revitalizante',7.00, 10,2)
                         ,(12,'kit manicure profissional',90, 6,6)
                         ,(13,'Pgto antecipado de serviços externo de beleza','70.00',0,1);
   
INSERT INTO empresa (
    nome_empresa,
    telefone,
    responsavel,
    adesao,
    nome_usuario,
    endereco,
    cep,
    email,
    cnpj,
    instagram,
    nome_do_bot,
    avatar,
    horario,
    atender_nao_cadastrados,
    modalidade,
    dia_remuneracao_1,
    percentagem_remuneracao_1,
    dia_remuneracao_2,
    percentagem_remuneracao_2,
    percentagem_remuneracao_geral,
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

