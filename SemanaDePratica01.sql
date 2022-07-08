CREATE TABLE atividade (
	idatividade INT NOT NULL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL
);

CREATE TABLE instrutor (
	idinstrutor INT NOT NULL PRIMARY KEY,
	RG int NOT NULL,
	nome VARCHAR(45) NOT NULL,
	nascimento DATE,
	titulacao INT
);

CREATE TABLE telefone_instrutor (
	idtelefone INT NOT NULL PRIMARY KEY,
	numero INT NOT NULL,
	tipo VARCHAR(45),
	instrutor_idinstrutor INT NOT NULL,
	CONSTRAINT fk_instrutor FOREIGN KEY (instrutor_idinstrutor)
		REFERENCES instrutor (idinstrutor)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE turma (
	idturma INT NOT NULL PRIMARY KEY,
	horario TIME NOT NULL,
	duracao INT NOT NULL,
	dataInicio DATE NOT NULL,
	dataFim DATE NOT NULL,
	atividade_idatividade INT NOT NULL,
	instrutor_idinstrutor INT NOT NULL,
	CONSTRAINT fk_atividade FOREIGN KEY (atividade_idatividade)
		REFERENCES atividade (idatividade)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	CONSTRAINT fk_instrutor FOREIGN KEY (instrutor_idinstrutor)
		REFERENCES instrutor (idinstrutor)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE aluno (
	codMatricula INT NOT NULL PRIMARY KEY,
	turma_idturma INT,
	dataMatricula DATE NOT NULL,
	nome VARCHAR(45) NOT NULL,
	endereco TEXT,
	telefone INT,
	dataNascimento DATE,
	altura FLOAT,
	peso INT,
	CONSTRAINT fk_turma FOREIGN KEY (turma_idturma)
		REFERENCES turma (idturma)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE matricula (
	aluno_codMatricula INT NOT NULL,
	turma_idturma INT NOT NULL,
	CONSTRAINT fk_aluno FOREIGN KEY (aluno_codMatricula)
		REFERENCES aluno (codMatricula)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	CONSTRAINT fk_turma FOREIGN KEY (turma_idturma)
		REFERENCES turma (idturma)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	CONSTRAINT pk_matricula PRIMARY KEY (aluno_codMatricula, turma_idturma)
);

CREATE TABLE chamada (
	idchamada INT NOT NULL PRIMARY KEY,
	dataChamada DATE NOT NULL,
	presente BOOL NOT NULL,
	matricula_aluno_codMatricula INT NOT NULL,
	matricula_turma_idturma INT NOT NULL,
	CONSTRAINT fk_matricula FOREIGN KEY (matricula_aluno_codMatricula, matricula_turma_idturma) 
		REFERENCES matricula (aluno_codMatricula, turma_idturma) 
		ON DELETE RESTRICT 
		ON UPDATE CASCADE
);

ALTER TABLE aluno ADD CONSTRAINT altura_check CHECK (altura <= 2.5 AND altura > 0 AND peso <= 400  AND peso > 0);

CREATE USER Diretor WITH PASSWORD 'SenhaDoDiretor@01';
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA public TO Diretor;

CREATE USER Instrutor WITH PASSWORD 'SenhaDoInstrutor@01';
GRANT INSERT, UPDATE, DELETE, SELECT ON TABLE chamada TO Instrutor;

CREATE USER Aluno WITH PASSWORD 'SenhaDoAluno@01';
GRANT SELECT ON TABLE chamada TO Aluno;