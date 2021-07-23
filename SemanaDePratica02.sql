-- 1) Crie um banco de dados chamado gesta_produto e um script para criar todas as tabelas envolvidas no modelo,
--    levando em consideração integridade de entidade, de domínio e relacional.

CREATE TABLE PRD_DEPARTAMENTO (
  ID_DEPARTAMENTO SERIAL NOT NULL PRIMARY KEY,
  DESCRICAO VARCHAR(100) NOT NULL
);

CREATE TABLE PRD_CATEGORIA (
  ID_CATEGORIA SERIAL NOT NULL PRIMARY KEY,
  DESCRICAO VARCHAR(100) NOT NULL,
  ID_DEPARTAMENTO INT NOT NULL,
  CONSTRAINT FK_DEPARTAMENTO FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES PRD_DEPARTAMENTO (ID_DEPARTAMENTO)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE PRD_SUBCATEGORIA (
  ID_SUBCATEGORIA SERIAL NOT NULL PRIMARY KEY,
  DESCRICAO VARCHAR(100) NOT NULL,
  ID_CATEGORIA INT NOT NULL,
  CONSTRAINT FK_CATEGORIA FOREIGN KEY (ID_CATEGORIA) REFERENCES PRD_CATEGORIA (ID_CATEGORIA)
    ON DELETE RESTRICT
    ON UPDATE CASCADE 
);

CREATE TABLE PRD_MARCA (
  ID_MARCA SERIAL NOT NULL PRIMARY KEY,
  DESCRICAO VARCHAR(100) NOT NULL
);

-- obs: ID_PRODUTO não pode ser uma foreign key, pois criaria um link circular entre as tabelas, impedindo a inserção/
--		remoção de elementos nas tabelas linkadas (PRD_UNIDADE_MEDIDA e PRD_PRODUTO)
CREATE TABLE PRD_UNIDADE_MEDIDA (
  ID_UNIDADE_MEDIDA SERIAL NOT NULL PRIMARY KEY,
  DESCRICAO VARCHAR(100) NOT NULL,
  ID_PRODUTO INT
);

-- obs2: ID_PRODUTO não pode ser uma foreign key, pois criaria um link circular entre as tabelas, impedindo a inserção/
--		remoção de elementos nas tabelas linkadas (PRD_PRODUTO e PRD_PRODUTO_SIMILAR)
CREATE TABLE PRD_PRODUTO (
  ID_PRODUTO SERIAL NOT NULL PRIMARY KEY,
  CODIGO INT NOT NULL,
  DESCRICAO VARCHAR(300) NOT NULL,
  ID_SUBCATEGORIA INT NOT NULL,
  ID_MARCA INT NOT NULL,
  ID_UNIDADE_MEDIDA INT,
  ESPECIFICACAO_TECNICA VARCHAR(500),
  STATUS BOOL NOT NULL,
  PESO_BRUTO FLOAT NOT NULL,
  PESO_LIQUIDO FLOAT NOT NULL,
  QTD_MULT INT NOT NULL,
  QTD_MIN INT NOT NULL,
  COD_BARRA VARCHAR(30) NOT NULL,
  CONSTRAINT FK_SUBCATEGORIA FOREIGN KEY (ID_SUBCATEGORIA) REFERENCES PRD_SUBCATEGORIA (ID_SUBCATEGORIA)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT FK_MARCA FOREIGN KEY (ID_MARCA) REFERENCES PRD_MARCA (ID_MARCA)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT FK_UNIDADE_MEDIDA FOREIGN KEY (ID_UNIDADE_MEDIDA) REFERENCES PRD_UNIDADE_MEDIDA (ID_UNIDADE_MEDIDA)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- obs3: Tendo em vista que a tabela PRD_PRODUTO_SIMILAR tem como objetivo linkar dois elementos da tabela produto com
--		cardinalidade 1:n, faz sentido tanto ID_PRODUTO quanto ID_PRODUTO_SIMILAR serem chaves primárias, já que se apenas
--		uma das colunas o fosse, um produto 'x' podería ter apenas um produto similar ao invés de vários.
CREATE TABLE PRD_PRODUTO_SIMILAR (
  ID_PRODUTO INT NOT NULL,
  ID_PRODUTO_SIMILAR INT NOT NULL,
	CONSTRAINT FK_PRODUTO FOREIGN KEY (ID_PRODUTO) REFERENCES PRD_PRODUTO (ID_PRODUTO)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	CONSTRAINT FK_PRODUTO_SIMILAR FOREIGN KEY (ID_PRODUTO_SIMILAR) REFERENCES PRD_PRODUTO (ID_PRODUTO)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	CONSTRAINT PK_PRODUTO_SIMILAR PRIMARY KEY (ID_PRODUTO, ID_PRODUTO_SIMILAR)
);
	
CREATE TABLE PRD_PRECO_VENDA (
  ID_PRECO_VENDA SERIAL NOT NULL PRIMARY KEY,
  ID_PRODUTO INT,
  PRECO_VENDA FLOAT NOT NULL,
  DATA_VALIDADE_INICIAL DATE NOT NULL,
  DATA_VALIDADE_FINAL DATE,
  CONSTRAINT FK_PRODUTO FOREIGN KEY (ID_PRODUTO) REFERENCES PRD_PRODUTO (ID_PRODUTO)
    ON DELETE RESTRICT
    ON UPDATE CASCADE 
);

-- 2) Crie um usuário (gestor_produto) e dê privilégio total a ele no banco criado e permissão para habilitar/
--    desabilitar triggers e apagar trigger. 

CREATE USER gestor_produto WITH PASSWORD 'SenhaDoGestor#10';

GRANT ALL PRIVILEGES ON DATABASE gesta_produto TO gestor_produto;

-- 3) Crie funções para inserir dados nas tabelas. 

CREATE OR REPLACE FUNCTION popular_departamento()
  RETURNS VOID
  LANGUAGE plpgsql
  AS $$
  DECLARE
	  deps VARCHAR(40) ARRAY DEFAULT ARRAY['Casa', 'Tecnologia', 'Cultura e Lazer', 'Estilo e Bem Estar', 'Bebês e Crianças'];
	BEGIN
	  FOR i IN 1..5 LOOP
	    INSERT INTO PRD_DEPARTAMENTO VALUES (i - 1, deps[i]);
	  END LOOP;
	END;
  $$

SELECT popular_departamento();

CREATE OR REPLACE FUNCTION popular_categoria()
  RETURNS VOID
  LANGUAGE plpgsql
  AS $$
	BEGIN
	  INSERT INTO PRD_CATEGORIA VALUES(0, 'Alimentos e Bebidas', 0);
	  INSERT INTO PRD_CATEGORIA VALUES(1, 'Móveis e Decoração', 0);
	  INSERT INTO PRD_CATEGORIA VALUES(2, 'Segurança', 0);
	  INSERT INTO PRD_CATEGORIA VALUES(3, 'Eletrodomésticos', 0);
	  INSERT INTO PRD_CATEGORIA VALUES(4, 'Ferramentas e Jardim', 0);
	  INSERT INTO PRD_CATEGORIA VALUES(5, 'Pet Shop', 0);
	  INSERT INTO PRD_CATEGORIA VALUES(6, 'Acessórios', 1);
	  INSERT INTO PRD_CATEGORIA VALUES(7, 'Jogos e Consoles', 1);
	  INSERT INTO PRD_CATEGORIA VALUES(8, 'Informática', 1);
	  INSERT INTO PRD_CATEGORIA VALUES(9, 'Esporte', 2);
	  INSERT INTO PRD_CATEGORIA VALUES(10, 'Instrumentos Musicais', 2);
	  INSERT INTO PRD_CATEGORIA VALUES(11, 'Papelaria', 2);
	  INSERT INTO PRD_CATEGORIA VALUES(12, 'Beleza e Higiene', 3);
	  INSERT INTO PRD_CATEGORIA VALUES(13, 'Moda', 3);
	  INSERT INTO PRD_CATEGORIA VALUES(14, 'Úteis', 4);
	  INSERT INTO PRD_CATEGORIA VALUES(15, 'Brinquedos', 4);
	END;
  $$

SELECT popular_categoria();

CREATE OR REPLACE FUNCTION popular_subcategoria()
  RETURNS VOID
  LANGUAGE plpgsql
  AS $$
	BEGIN
	  INSERT INTO PRD_SUBCATEGORIA VALUES(0, 'Adega', 0);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(1, 'Padaria', 0);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(2, 'Frios', 0);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(3, 'Laticínios', 0);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(4, 'Sofás', 1);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(5, 'Camas', 1);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(6, 'Armários', 1);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(7, 'Câmera de Vigilância', 2);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(8, 'Extintores de Incêndio', 2);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(9, 'Microondas', 3);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(10, 'Geladeiras', 3);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(11, 'Máquinas de Lavar', 3);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(12, 'Mudas e Sementes', 4);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(13, 'Mangueiras e Irrigadores', 4);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(14, 'Aves', 5);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(15, 'Cachorros', 5);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(16, 'Gatos', 5);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(17, 'Case e Película', 6);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(18, 'XBOX', 7);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(19, 'Mouse', 8);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(20, 'Monitor', 8);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(21, 'Bolas', 9);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(22, 'Redes', 9);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(23, 'Percurssão', 10);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(24, 'Sopro', 10);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(25, 'Cadernos', 11);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(26, 'Lápis de Cor', 11);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(27, 'Massa de Modelar', 11);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(28, 'Pastas de Dente', 12);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(29, 'Roupas', 13);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(30, 'Mamadeiras', 14);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(31, 'Fraldas', 14);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(32, 'Bonecas', 15);
	  INSERT INTO PRD_SUBCATEGORIA VALUES(33, 'Construção', 15);
	END;
  $$

SELECT popular_subcategoria();

CREATE OR REPLACE FUNCTION popular_marca_petshop()
  RETURNS VOID
  LANGUAGE plpgsql
  AS $$
  DECLARE
	  marcas VARCHAR(40) ARRAY DEFAULT ARRAY['Pedigree', 'DogShow', 'Premier Pet', 'Whiskas', 'Royal Canin', 'NuTrópica'];
	BEGIN
	  FOR i IN 1..6 LOOP
	    INSERT INTO PRD_MARCA VALUES (i - 1, marcas[i]);
	  END LOOP;
	END;
  $$
  
SELECT popular_marca_petshop();

CREATE OR REPLACE FUNCTION popular_unidade_medida_sem_produto()
  RETURNS VOID
  LANGUAGE plpgsql
  AS $$
  DECLARE
	  u VARCHAR(40) ARRAY DEFAULT ARRAY['Quilograma', 'Grama', 'Unidade', 'Litro'];
	BEGIN
	  FOR i IN 1..4 LOOP
	    INSERT INTO PRD_UNIDADE_MEDIDA VALUES (i - 1, u[i]);
	  END LOOP;
	END;
  $$
  
SELECT popular_unidade_medida_sem_produto();

CREATE OR REPLACE FUNCTION popular_produto_similar()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
	BEGIN
	  IF EXISTS (SELECT 1 FROM PRD_PRODUTO WHERE CODIGO = NEW.CODIGO AND ID_PRODUTO <> NEW.ID_PRODUTO) THEN
			INSERT INTO PRD_PRODUTO_SIMILAR (ID_PRODUTO, ID_PRODUTO_SIMILAR) VALUES (
				(SELECT ID_PRODUTO FROM PRD_PRODUTO WHERE CODIGO = NEW.CODIGO LIMIT 1), 
				NEW.ID_PRODUTO
			);
	  END IF;
	  RETURN NEW;
	END;
  $$

CREATE TRIGGER trigger_popular_produto_similar AFTER INSERT ON PRD_PRODUTO 
  FOR EACH ROW EXECUTE PROCEDURE popular_produto_similar();

CREATE OR REPLACE FUNCTION popular_produto()
  RETURNS VOID
  LANGUAGE plpgsql
  AS $$
  	DECLARE
	BEGIN
	  INSERT INTO PRD_PRODUTO VALUES(
		  0, 15500, 'Carne Frango e Cereais Para Cães Adultos Raças Médias e Grandes', 15, 0, 0, 
		  'Proporciona alimentação completa e balanceada; 
		  Conta com fórmula enriquecida com ômega 6 e fibras naturais;
		  Contém o balanço ideal de proteínas e aminoácidos',
		  TRUE, 1.0, 1.0, 5, 2, '24113554134'
	  );
		INSERT INTO PRD_PRODUTO VALUES(
		  1, 15500, 'Carne Frango e Cereais Para Cães Adultos Raças Médias e Grandes', 15, 0, 0, 
		  'Proporciona alimentação completa e balanceada; 
		  Conta com fórmula enriquecida com ômega 6 e fibras naturais;
		  Contém o balanço ideal de proteínas e aminoácidos',
		  TRUE, 1.0, 1.0, 5, 2, '24113554134'
	  );
		INSERT INTO PRD_PRODUTO VALUES(
		  2, 15500, 'Carne Frango e Cereais Para Cães Adultos Raças Médias e Grandes', 15, 0, 0, 
		  'Proporciona alimentação completa e balanceada; 
		  Conta com fórmula enriquecida com ômega 6 e fibras naturais;
		  Contém o balanço ideal de proteínas e aminoácidos',
		  TRUE, 1.0, 1.0, 5, 2, '24113554134'
	  );
	  INSERT INTO PRD_PRODUTO VALUES(
		  3, 15501, 'Carne Frango e Cereais Para Cães Adultos Raças Médias e Grandes', 15, 0, 0, 
		  'Proporciona alimentação completa e balanceada; 
		  Conta com fórmula enriquecida com ômega 6 e fibras naturais;
		  Contém o balanço ideal de proteínas e aminoácidos',
		  TRUE, 3.0, 3.0, 5, 2, '24113554134'
	  );
	  INSERT INTO PRD_PRODUTO VALUES(
		  4, 15502, 'Carne Frango e Cereais Para Cães Adultos Raças Médias e Grandes', 15, 0, 0, 
		  'Proporciona alimentação completa e balanceada; 
		  Conta com fórmula enriquecida com ômega 6 e fibras naturais;
		  Contém o balanço ideal de proteínas e aminoácidos',
		  TRUE, 10.1, 10.1, 5, 2, '24113554134'
	  );
	  INSERT INTO PRD_PRODUTO VALUES(
		  5, 15503, 'Carne Frango e Cereais Para Cães Adultos Raças Médias e Grandes', 15, 0, 0, 
		  'Proporciona alimentação completa e balanceada; 
		  Conta com fórmula enriquecida com ômega 6 e fibras naturais;
		  Contém o balanço ideal de proteínas e aminoácidos',
		  TRUE, 15.0, 15.0, 5, 2, '24113554134'
	  );
	  INSERT INTO PRD_PRODUTO VALUES(
		  6, 15504, 'Carne Frango e Cereais Para Cães Adultos Raças Médias e Grandes', 15, 0, 0, 
		  'Proporciona alimentação completa e balanceada; 
		  Conta com fórmula enriquecida com ômega 6 e fibras naturais;
		  Contém o balanço ideal de proteínas e aminoácidos',
		  TRUE, 20.0, 20.0, 5, 2, '24113554134'
	  );
	END;
  $$
  
SELECT popular_produto();

CREATE OR REPLACE FUNCTION popular_venda()
  RETURNS VOID
  LANGUAGE plpgsql
  AS $$
  	DECLARE
	BEGIN
	  INSERT INTO PRD_PRECO_VENDA VALUES (0, 1, ((SELECT QTD_MIN FROM PRD_PRODUTO WHERE 1 = ID_PRODUTO) * 20.09), '2021-06-10', '2022-06-10');
	  INSERT INTO PRD_PRECO_VENDA VALUES (1, 2, ((SELECT QTD_MIN FROM PRD_PRODUTO WHERE 2 = ID_PRODUTO) * 20.09), '2021-06-10', '2022-06-10');
	  INSERT INTO PRD_PRECO_VENDA VALUES (2, 4, ((SELECT QTD_MIN FROM PRD_PRODUTO WHERE 4 = ID_PRODUTO) * 109.99), '2021-07-12', '2022-07-12');
	  INSERT INTO PRD_PRECO_VENDA VALUES (3, 6, ((SELECT QTD_MIN FROM PRD_PRODUTO WHERE 6 = ID_PRODUTO) * 212.49), '2021-07-12', '2022-07-12');
	END;
  $$
  
SELECT popular_venda();

-- 4) Crie exemplos de transações que terminem com commit, rollback e misto (usando savepoint). 

BEGIN;
	UPDATE PRD_SUBCATEGORIA SET DESCRICAO = 'Capa protetora' WHERE ID_SUBCATEGORIA = 17;
COMMIT;

BEGIN;
	INSERT INTO PRD_DEPARTAMENTO VALUES (9, 'Sem nome');
ROLLBACK;

BEGIN;
	INSERT INTO PRD_PRECO_VENDA VALUES (4, 5, ((SELECT QTD_MIN FROM PRD_PRODUTO WHERE 5 = ID_PRODUTO) * 150.49), '2021-07-23', '2022-07-23');
SAVEPOINT svp_venda_og;
	INSERT INTO PRD_PRECO_VENDA VALUES (6, 5, ((SELECT QTD_MIN FROM PRD_PRODUTO WHERE 5 = ID_PRODUTO) * 150.49), '2021-07-23', '2022-07-23');
ROLLBACK TO svp_venda_og;
COMMIT;


-- 5) Crie uma função para retornar o total do preço de venda de todos os produtos.

CREATE OR REPLACE FUNCTION total_preco_venda()
  RETURNS FLOAT
  LANGUAGE plpgsql
  AS $$
  DECLARE
  	total FLOAT;
  BEGIN
  	SELECT SUM(PRECO_VENDA) INTO total FROM PRD_PRECO_VENDA;
  	RETURN total;
  END;
  $$

SELECT total_preco_venda();

-- 6) Crie uma função para agrupar os produtos por data final de validade. 

CREATE OR REPLACE FUNCTION agrupar_por_data_validade_final()
  RETURNS TABLE (
  	ID_PRODUTOS TEXT[],
		TOTAL_VENDAS FLOAT,
		DATA_VALIDADE_FINAL DATE
  )
  LANGUAGE plpgsql
  AS $$
  BEGIN
   RETURN QUERY
    SELECT array_agg(prod.ID_PRODUTO :: TEXT), SUM(pv.PRECO_VENDA), pv.DATA_VALIDADE_FINAL
	  FROM PRD_PRODUTO prod, PRD_PRECO_VENDA pv
	  WHERE prod.ID_PRODUTO = pv.ID_PRODUTO
	  GROUP BY pv.DATA_VALIDADE_FINAL;
  END;
  $$

SELECT * FROM agrupar_por_data_validade_final();

-- 7) Crie um trigger para impedir que o preço de venda do produto seja menor ou igual a zero. 

CREATE OR REPLACE FUNCTION checa_preco()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
	BEGIN
	  IF NEW.PRECO_VENDA <= 0 THEN
			RAISE EXCEPTION 'Preço da venda não pode ser menor ou igual a zero';
	  END IF;
	  RETURN NEW;
	END;
  $$

CREATE TRIGGER trigger_checa_preco BEFORE INSERT OR UPDATE ON PRD_PRECO_VENDA 
  FOR EACH ROW EXECUTE PROCEDURE checa_preco();

-- 8) Crie um trigger para gravar o usuário, a data e a operação (em uma tabela de auditoria) feita na 
--    tabela PRD_PRECO_VENDA.

CREATE TABLE AUDITORIA_VENDA (
	USUARIO VARCHAR(50) NOT NULL,
	DATA_VENDA DATE NOT NULL,
	ID_VENDA INT NOT NULL
);

CREATE OR REPLACE FUNCTION venda()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
	BEGIN
	  INSERT INTO AUDITORIA_VENDA VALUES (
			current_user,
			current_date,
			NEW.ID_PRODUTO
	  );
	  RETURN NEW;
	END;
	$$

CREATE TRIGGER trigger_venda AFTER INSERT ON PRD_PRECO_VENDA 
	FOR EACH ROW EXECUTE PROCEDURE venda();