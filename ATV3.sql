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
('P3', 'Mancal', 'Verde', 30, 'São Paulo')
 
INSERT INTO fornecedor (codFornecedor, nomeFornecedor, statusFornecedor, cidadeFornecedor) VALUES
('F1', 'Silva', 5, 'São Paulo'),
('F2', 'Souza', 10, 'Rio'),
('F3', 'Alvares', 5, 'São Paulo'),
('F4', 'Tavares', 8, 'Rio')
 
 
INSERT INTO embarq(codPeca, codFornecedor, qtdEmbarque) VALUES
('P1', 'F1', 300),
('P1', 'F2', 400),
('P1', 'F3', 200),
('P2', 'F1', 300),
('P2', 'F4', 350)

--1) Obter o número de fornecedores na base de dados
SELECT COUNT (codFornecedor) AS N_Fornecedores
FROM fornecedor

--2) Obter o número de cidades em que há fornecedores
SELECT COUNT(DISTINCT cidadeFornecedor) AS N_Cidades
FROM fornecedor

--3) Obter o número de fornecedores com cidade informada

SELECT COUNT(codFornecedor) AS N_Fornecedores_Com_Cidade
FROM fornecedor
WHERE cidadeFornecedor IS NOT NULL

--4) Obter a quantidade máxima embarcada
SELECT MAX(qtdEmbarque) AS Max_Quantidade_Embarcada
FROM embarq

--5) Obter o número de embarques de cada fornecedor
SELECT codFornecedor, COUNT(*) AS N_Embarques
FROM embarq
GROUP BY codFornecedor

--6) Obter o número de embarques de quantidade maior que 300 de cadafornecedor
SELECT codFornecedor, COUNT(*) AS N_Embarques_Maior_300
FROM embarq
WHERE qtdEmbarque > 300
GROUP BY codFornecedor

--7) Obter a quantidade total embarcada de peças de cor cinza para cada fornecedor
SELECT e.codFornecedor, SUM(e.qtdEmbarque) AS Total_Quantidade_Embarcada
FROM embarq e
JOIN peca p ON e.codPeca = p.codPeca
WHERE p.corPeca = 'Cinza'
GROUP BY e.codFornecedor

--8) Obter o quantidade total embarcada de peças para cada fornecedor. Exibir o resultado por ordem descendente de quantidade total embarcada.
SELECT codFornecedor, SUM(qtdEmbarque) AS Total_Quantidade_Embarcada
FROM embarq
GROUP BY codFornecedor
ORDER BY Total_Quantidade_Embarcada DESC

--9) Obter os códigos de fornecedores que tenham embarques de mais de 500 unidades de peças cinzas, junto com a quantidade de embarques de peças cinzas
SELECT e.codFornecedor, COUNT(*) AS N_Embarques_Cinza
FROM embarq e
JOIN peca p ON e.codPeca = p.codPeca
WHERE p.corPeca = 'Cinza' AND e.qtdEmbarque > 500
GROUP BY e.codFornecedor