CREATE DATABASE atv3
GO
USE atv3
GO
CREATE TABLE peca
(
	codPeca CHAR(2),
	nomePeca VARCHAR(50) NOT NULL,
	corPeca VARCHAR(15) NOT NULL,
	pesoPeca SMALLINT NOT NULL,
	cidadePeca VARCHAR(100) NOT NULL,
 
	PRIMARY KEY(codPeca)
)
GO
CREATE TABLE fornecedor
(
	codFornecedor CHAR(2),
	nomeFornecedor VARCHAR(100) NOT NULL,
	statusFornecedor SMALLINT NOT NULL,
	cidadeFornecedor VARCHAR(100) NOT NULL,
 
	PRIMARY KEY(codFornecedor)
)
GO
CREATE TABLE embarq
(
	codPeca CHAR(2),
	codFornecedor CHAR(2),
	qtdEmbarque INT NOT NULL,
 
	PRIMARY KEY(codPeca, codFornecedor),
	FOREIGN KEY(codPeca) REFERENCES peca(codPeca),
	FOREIGN KEY(codFornecedor) REFERENCES fornecedor(codFornecedor)
)
 
INSERT INTO peca (codPeca, nomePeca, corPeca, pesoPeca, cidadePeca) VALUES
('P1', 'Eixo', 'Cinza', 10, 'Poa'),
('P2', 'Rolamento', 'Preto', 16, 'Rio'),
('P3', 'Mancal', 'Verde', 30, 'São Paulo');
 
INSERT INTO fornecedor (codFornecedor, nomeFornecedor, statusFornecedor, cidadeFornecedor) VALUES
('F1', 'Silva', 5, 'São Paulo'),
('F2', 'Souza', 10, 'Rio'),
('F3', 'Alvares', 5, 'São Paulo'),
('F4', 'Tavares', 8, 'Rio');
 
 
INSERT INTO embarq(codPeca, codFornecedor, qtdEmbarque) VALUES
('P1', 'F1', 300),
('P1', 'F2', 400),
('P1', 'F3', 200),
('P2', 'F1', 300),
('P2', 'F4', 350);

--1) Obter o número de fornecedores na base de dados
SELECT COUNT (codFornecedor) AS N_Fornecedores
FROM fornecedor

--2) Obter o número de cidades em que há fornecedores
SELECT COUNT (DISTINCT codFornecedor ) AS N_cidade
FROM fornecedor

--3) Obter o número de fornecedores com cidade informada


--4) Obter a quantidade máxima embarcada
--5) Obter o número de embarques de cada fornecedor
--6) Obter o número de embarques de quantidade maior que 300 de cadafornecedor
--7) Obter a quantidade total embarcada de peças de cor cinza para cada fornecedor
--8) Obter o quantidade total embarcada de peças para cada fornecedor. Exibir o resultado por ordem descendente de quantidade total embarcada.
--9) Obter os códigos de fornecedores que tenham embarques de mais de 500 unidades de peças cinzas, junto com a quantidade de embarques de peças cinzas