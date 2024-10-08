CREATE DATABASE atv4
GO
USE atv4
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

--**********************************************************************************************
--Considerando a Lista de Exercícios da Aula de Funções Agregadas, criar a seguinte Stored Procedure:

--1- Procedure para Inserir um registro na Tabela Peça, usando parâmetros;

CREATE PROCEDURE InserirPeca
    @CodPeca CHAR(2),
    @NomePeca VARCHAR(50),
    @CorPeca VARCHAR(15),
    @PesoPeca SMALLINT,
    @CidadePeca VARCHAR(100)
AS
BEGIN
    
    INSERT INTO peca (CodPeca, NomePeca, CorPeca, PesoPeca, CidadePeca)
    VALUES (@CodPeca, @NomePeca, @CorPeca, @PesoPeca, @CidadePeca);
    
END;
GO
 
--1.2. Usando a procedure InserirPeca
EXEC InserirPeca
    @CodPeca = 'P5',
    @NomePeca = 'Bomba',
    @CorPeca = 'Vermelha',
    @PesoPeca = 18,
    @CidadePeca = 'Itaqua';
 
SELECT * FROM peca;


--2- Procedure para Inserir 5000 registros distintos na Tabela Peça;
CREATE PROCEDURE Inserir5000Pecas
AS
BEGIN
    DECLARE @contador INT = 1;
    DECLARE @CodPeca CHAR(2);
    DECLARE @NomePeca VARCHAR(50);
    DECLARE @CorPeca VARCHAR(15);
    DECLARE @PesoPeca SMALLINT;
    DECLARE @CidadePeca VARCHAR(100);
 
    
    WHILE @contador <= 5000
    BEGIN
        
        SET @CodPeca = RIGHT('P' + CAST(@contador AS VARCHAR(5)), 2);
        SET @NomePeca = 'Peca' + CAST(@contador AS VARCHAR(5));
        SET @CorPeca = CASE WHEN @contador % 3 = 0 THEN 'Preto'
                            WHEN @contador % 3 = 1 THEN 'Preto'
                            ELSE 'Verde' END;
        SET @PesoPeca = @contador % 100 + 1; -- Gera pesos entre 1 e 100
        SET @CidadePeca = CASE WHEN @contador % 2 = 0 THEN 'São Paulo' ELSE 'Rio' END;
 
        
        INSERT INTO peca (CodPeca, NomePeca, CorPeca, PesoPeca, CidadePeca)
        VALUES (@CodPeca, @NomePeca, @CorPeca, @PesoPeca, @CidadePeca);
 
        
        SET @contador = @contador + 1;
    END;
 
    
    PRINT '5000 registros foram inseridos com sucesso na tabela Peca';
END;
GO
 

EXEC Inserir5000Pecas;
 
SELECT * FROM peca;