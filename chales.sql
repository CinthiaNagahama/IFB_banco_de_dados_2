CREATE TABLE cliente(
	cod_cliente serial NOT NULL PRIMARY KEY,
	nome_cliente varchar(60) NOT null,
	endereco_cliente varchar(50),
	bairro_cliente varchar(40),
	cidade_cliente varchar(40),
	estado_cliente char(2),
	nascimento_cliente date
);

CREATE TABLE telefone(
	telefone varchar(9) NOT NULL,
	cod_cliente int NOT NULL,
	tipo_telefone char(1),
	CONSTRAINT pk_telefone PRIMARY KEY (telefone,cod_cliente),
	CONSTRAINT fk_cliente_telefone FOREIGN KEY (cod_cliente) 
	REFERENCES cliente(cod_cliente) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE chale(
	cod_chale serial NOT NULL PRIMARY KEY,
	localizacao varchar(50) NOT NULL,
	capacidade int,
	valor_alta_estacao decimal(8,2),
	valor_baixa_estacao decimal(8,2)
);


CREATE TABLE servico(
	cod_servico serial NOT NULL PRIMARY KEY,
	nome_servico varchar(60) NOT NULL,
	valor_servico decimal(8,2) NOT NULL
);

CREATE TABLE item(
	nome_item varchar(50) NOT NULL PRIMARY KEY,
	descricao_item varchar(255) NOT NULL
);

CREATE TABLE chale_item(
	cod_chale int NOT NULL,
	nome_item varchar(50) NOT NULL,
	CONSTRAINT pk_item PRIMARY KEY(cod_chale,nome_item),
	CONSTRAINT fk_chale FOREIGN KEY (cod_chale) 
	REFERENCES chale(cod_chale) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_item FOREIGN KEY(nome_item)
	REFERENCES item (nome_item) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE hospedagem(
	cod_hospedagem serial NOT NULL PRIMARY KEY,
	cod_chale int NOT NULL,
	cod_cliente int NOT NULL,
	status char(1) NOT NULL,
	data_inicial date NOT NULL,
	data_final date NOT NULL,
	qtd_pessoas int,
	desconto decimal(5,2),
	valor_final decimal(8,2),
	CONSTRAINT fk_chale_hospedagem FOREIGN KEY(cod_chale)
	REFERENCES chale(cod_chale) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_cliente_hospedagem FOREIGN KEY(cod_cliente)
	REFERENCES cliente(cod_cliente) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE hospedagem_servico(
	cod_hospedagem int NOT NULL,
	cod_servico int NOT NULL,
	data_servico date NOT NULL,
	valor_servico decimal(8,2) NOT NULL,
	CONSTRAINT pk_hospedagem_servico PRIMARY KEY(cod_hospedagem,cod_servico,data_servico),
	CONSTRAINT fk_hosp_serv_hospedagem FOREIGN KEY(cod_hospedagem)
	REFERENCES hospedagem(cod_hospedagem) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_hosp_serv_servico FOREIGN KEY(cod_servico) 
	REFERENCES servico(cod_servico) ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO cliente(nome_cliente,
	endereco_cliente,
	bairro_cliente,
	cidade_cliente,
	estado_cliente,
	nascimento_cliente) VALUES ('Pateta',
	'Rua A, 25', 'Pat 1', 'Patópolis', 'PC', '1965-05-25');

INSERT INTO cliente(nome_cliente,
	endereco_cliente,
	bairro_cliente,
	cidade_cliente,
	estado_cliente,
	nascimento_cliente) VALUES ('Horácio',
	'Rua B, 23', 'Pat 1', 'Patópolis', 'PC', '1966-09-12');
	
INSERT INTO cliente(nome_cliente,
	endereco_cliente,
	bairro_cliente,
	cidade_cliente,
	estado_cliente,
	nascimento_cliente) VALUES ('Minie',
	'Rua C, 25', 'Pat 1', 'Patópolis', 'PC', '1950-03-21');
	
INSERT INTO cliente(nome_cliente,
	endereco_cliente,
	bairro_cliente,
	cidade_cliente,
	estado_cliente,
	nascimento_cliente) VALUES ('Mickey',
	'Rua T, 789', 'Pat 1', 'Patópolis', 'PC', '1938-03-18');


INSERT INTO chale (
	localizacao,
	capacidade,
	valor_alta_estacao,
	valor_baixa_estacao) VALUES ('Guará', 10, 500.0,300.0);

INSERT INTO chale (
	localizacao,
	capacidade,
	valor_alta_estacao,
	valor_baixa_estacao) VALUES ('Águas Claras', 15, 1500.0,1000.0);
	
INSERT INTO chale (
	localizacao,
	capacidade,
	valor_alta_estacao,
	valor_baixa_estacao) VALUES ('Taguatinga', 3, 200.0,150.0);
	
INSERT INTO chale (
	localizacao,
	capacidade,
	valor_alta_estacao,
	valor_baixa_estacao) VALUES ('Asa Sul', 10, 2000.0,1300.0);


INSERT INTO hospedagem (cod_chale,
	cod_cliente,
	status,
	data_inicial,
	data_final,
	qtd_pessoas,
	valor_final) values(5,6,'A','2021-05-24','2021-06-06',5,3000.0);

INSERT INTO hospedagem (cod_chale,
	cod_cliente,
	status,
	data_inicial,
	data_final,
	qtd_pessoas,
	valor_final) values(6,7,'I','2021-02-15','2021-04-04',3,2500.0);
	
INSERT INTO hospedagem (cod_chale,
	cod_cliente,
	status,
	data_inicial,
	data_final,
	qtd_pessoas,
	valor_final) values(7,8,'A','2021-05-24','2021-06-06',5,3000.0);
	
INSERT INTO hospedagem (cod_chale,
	cod_cliente,
	status,
	data_inicial,
	data_final,
	qtd_pessoas,
	valor_final) values(8,5,'A','2021-05-24','2021-06-06',6,2000.0);
	
	select * from hospedagem;