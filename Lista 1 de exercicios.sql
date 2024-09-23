use master
drop database deptos
go
create database deptos
go 
use deptos
CREATE TABLE Predioo (
    CodPred INT,
    NomePredio VARCHAR(40),
    PRIMARY KEY (CodPred)
);
 
CREATE TABLE Sala (
    CodPred INT,
    NumSala INT,
    DescricaoSala VARCHAR(40),
    CapacSala INT,
    PRIMARY KEY (NumSala , CodPred),
    FOREIGN KEY (CodPred)
        REFERENCES Predioo (CodPred)
);
 
CREATE TABLE Depto (
    CodDepto CHAR(5),
    NomeDepto VARCHAR(40),
    PRIMARY KEY (CodDepto)
);
 
CREATE TABLE Titulacao (
    CodTit INT,
    NomeTit VARCHAR(40),
    PRIMARY KEY (CodTit)
);
 
CREATE TABLE Professor (
    CodProf INT,
    CodDepto CHAR(5),
    CodTit INT,
    NomeProf VARCHAR(40),
    PRIMARY KEY (CodProf),
    FOREIGN KEY (CodDepto)
        REFERENCES Depto (CodDepto),
    FOREIGN KEY (CodTit)
        REFERENCES Titulacao (CodTit)
);
 
CREATE TABLE Disciplina (
    CodDepto CHAR(5),
    NumDisc INT,
    NomeDisc VARCHAR(10),
    CreditoDisc INT,
    PRIMARY KEY (CodDepto , NumDisc),
    FOREIGN KEY (CodDepto)
        REFERENCES Depto (CodDepto)
);
 
CREATE TABLE PreReq (
    CodDeptoPreReq CHAR(5),
    NumDiscPreReq INT,
    CodDepto CHAR(5),
    NumDisc INT,
    PRIMARY KEY (CodDeptoPreReq , NumDiscPreReq , CodDepto , NumDisc),
    FOREIGN KEY (CodDepto , NumDisc)
        REFERENCES Disciplina (CodDepto , NumDisc),
    FOREIGN KEY (CodDeptoPreReq , NumDiscPreReq)
        REFERENCES Disciplina (CodDepto , NumDisc)
);
 
CREATE TABLE Turma (
    AnoSem INT,
    CodDepto CHAR(5),
    NumDisc INT,
    SiglaTur CHAR(2),
    CapacTur INT,
    PRIMARY KEY (AnoSem , CodDepto , NumDisc , SiglaTur),
    FOREIGN KEY (CodDepto , NumDisc)
        REFERENCES Disciplina (CodDepto , NumDisc)
);
 
CREATE TABLE ProfTurma (
    AnoSem INT,
    CodDepto CHAR(5),
    NumDisc INT,
    SiglaTur CHAR(2),
    CodProf INT,
    PRIMARY KEY (AnoSem , CodDepto , NumDisc , SiglaTur , CodProf),
    FOREIGN KEY (AnoSem , CodDepto , NumDisc , SiglaTur)
        REFERENCES Turma (AnoSem , CodDepto , NumDisc , SiglaTur),
    FOREIGN KEY (CodProf)
        REFERENCES Professor (CodProf)
);
 
CREATE TABLE Horario (
    AnoSem INT,
    CodDepto CHAR(5),
    NumDisc INT,
    SiglaTur CHAR(2),
    DiaSem INT,
    HoraInicio INT,
    NumSala INT,
    CodPred INT,
    NumHoras INT,
    PRIMARY KEY (AnoSem , CodDepto , NumDisc , SiglaTur , DiaSem , HoraInicio),
    FOREIGN KEY (AnoSem , CodDepto , NumDisc , SiglaTur)
        REFERENCES Turma (AnoSem , CodDepto , NumDisc , SiglaTur),
    FOREIGN KEY (NumSala , CodPred)
        REFERENCES Sala (NumSala , CodPred)
);

INSERT INTO Predioo (CodPred, NomePredio) VALUES
(1, 'Predio A'),
(2, 'Predio B'),
(3, 'Predio C'),
(4, 'Predio D'),
(5, 'Predio E')
go

INSERT INTO Sala (CodPred, NumSala, DescricaoSala, CapacSala) VALUES
(1, 101, 'Sala de Aula 101', 30),
(1, 102, 'Sala de Aula 102', 25),
(2, 201, 'Sala de Aula 201', 40),
(2, 202, 'Sala de Aula 202', 35),
(3, 301, 'Sala de Aula 301', 50)
go

INSERT INTO Depto (CodDepto, NomeDepto) VALUES
('D001', 'Departamento de Matemática'),
('D002', 'Departamento de Física'),
('D003', 'Departamento de Química'),
('D004', 'Departamento de Biologia'),
('D005', 'Departamento de Computação')
go

INSERT INTO Titulacao (CodTit, NomeTit) VALUES
(1, 'Mestre'),
(2, 'Doutor'),
(3, 'Pós-Doutor'),
(4, 'Especialista'),
(5, 'Graduado')
go

INSERT INTO Professor (CodProf, CodDepto, CodTit, NomeProf) VALUES
(1, 'D001', 2, 'Prof. João Silva'),
(2, 'D002', 3, 'Prof. Maria Oliveira'),
(3, 'D003', 1, 'Prof. Carlos Souza'),
(4, 'D004', 4, 'Prof. Ana Lima'),
(5, 'D005', 5, 'Prof. Pedro Santos')
go

INSERT INTO Disciplina (CodDepto, NumDisc, NomeDisc, CreditoDisc) VALUES
('D001', 101, 'Calculo I', 4),
('D002', 102, 'Fisica I', 4),
('D003', 103, 'Quimica I', 4),
('D004', 104, 'Biologia I', 4),
('D005', 105, 'Prog', 4)
go

INSERT INTO PreReq (CodDeptoPreReq, NumDiscPreReq, CodDepto, NumDisc) VALUES
('D001', 101, 'D002', 102),
('D002', 102, 'D003', 103),
('D003', 103, 'D004', 104),
('D004', 104, 'D005', 105),
('D005', 105, 'D001', 101)
go

INSERT INTO Turma (AnoSem, CodDepto, NumDisc, SiglaTur, CapacTur) VALUES
(20021, 'D001', 101, 'A1', 30),
(20021, 'D002', 102, 'B1', 25),
(20021, 'D003', 103, 'C1', 40),
(20021, 'D004', 104, 'D1', 35),
(20021, 'D005', 105, 'E1', 50)
go

INSERT INTO ProfTurma (AnoSem, CodDepto, NumDisc, SiglaTur, CodProf) VALUES
(20021, 'D001', 101, 'A1', 1),
(20021, 'D002', 102, 'B1', 2),
(20021, 'D003', 103, 'C1', 3),
(20021, 'D004', 104, 'D1', 4),
(20021, 'D005', 105, 'E1', 5)
go

INSERT INTO Horario (AnoSem, CodDepto, NumDisc, SiglaTur, DiaSem, HoraInicio, NumSala, CodPred, NumHoras) VALUES
(20021, 'D001', 101, 'A1', 1, 800, 101, 1, 2),
(20021, 'D002', 102, 'B1', 2, 900, 102, 1, 2),
(20021, 'D003', 103, 'C1', 3, 1000, 201, 2, 3),
(20021, 'D004', 104, 'D1', 4, 1100, 202, 2, 3),
(20021, 'D005', 105, 'E1', 5, 1200, 301, 3, 4)
go

--Criar Procedure , usando cursor explicito, para Selecionar a quantidade de disciplinas agrupadas por Departamento.

CREATE PROCEDURE ContarDisciplinasPorDepto
AS
BEGIN
    DECLARE @CodDepto CHAR(5);
    DECLARE @QuantidadeDisciplinas INT;

    -- Criação da tabela temporária
    CREATE TABLE #Resultados (
        CodDepto CHAR(5),
        QuantidadeDisciplinas INT
    );

    -- Declaração do cursor
    DECLARE cursorDepto CURSOR FOR
    SELECT CodDepto
    FROM Depto;

    -- Abrindo o cursor
    OPEN cursorDepto;

    -- Loop para percorrer os resultados do cursor
    FETCH NEXT FROM cursorDepto INTO @CodDepto;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Contando a quantidade de disciplinas por departamento
        SELECT @QuantidadeDisciplinas = COUNT(*)
        FROM Disciplina
        WHERE CodDepto = @CodDepto;

        -- Inserindo o resultado na tabela temporária
        INSERT INTO #Resultados (CodDepto, QuantidadeDisciplinas)
        VALUES (@CodDepto, @QuantidadeDisciplinas);

        -- Próximo registro
        FETCH NEXT FROM cursorDepto INTO @CodDepto;
    END;

    -- Fechando e desalocando o cursor
    CLOSE cursorDepto;
    DEALLOCATE cursorDepto;

    -- Selecionando os resultados da tabela temporária
    SELECT * FROM #Resultados;

    -- Dropando a tabela temporária
    DROP TABLE #Resultados;
END;


exec ContarDisciplinasPorDepto

--Obter os códigos dos diferentes departamentos que tem turmas no ano-semestre 2002/1
CREATE PROCEDURE ObterDeptosComTurmas
AS
BEGIN
    DECLARE @CodDepto CHAR(5)
    DECLARE DeptoCursor CURSOR FOR
    SELECT DISTINCT CodDepto
    FROM Turma
    WHERE AnoSem = 20021

    OPEN DeptoCursor
    FETCH NEXT FROM DeptoCursor INTO @CodDepto

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Departamento: ' + @CodDepto
        FETCH NEXT FROM DeptoCursor INTO @CodDepto
    END

    CLOSE DeptoCursor
    DEALLOCATE DeptoCursor
END
exec ObterDeptosComTurmas



--Obter os códigos dos professores que são do departamento de código 'INF01' e que ministraram ao menos uma turma em 2002/1. 

--Obter os horários de aula (dia da semana,hora inicial e número de horas ministradas) do professor "Antunes" em 20021.  
--Obter os nomes dos departamentos que têm turmas que, em 2002/1, têm aulas na sala 101 do prédio denominado 'Informática - aulas'.  
--Obter os códigos dos professores com título denominado 'Doutor' que não ministraram aulas em 2002/1.  
--Obter os identificadores das salas (código do prédio e número da sala) que, em 2002/1:  
	--nas segundas-feiras (dia da semana = 2), tiveram ao menos uma turma do departamento 'Informática', e  
	--nas quartas-feiras (dia da semana = 4), tiveram ao menos uma turma ministrada pelo professor denominado 'Antunes'.  
--Obter o dia da semana, a hora de início e o número de horas de cada horário de cada turma ministrada por um professor de nome `Antunes', em 2002/1, na sala número 101 do prédio de código 43423.  
--Um professor pode ministrar turmas de disciplinas pertencentes a outros departamentos. Para cada professor que já ministrou aulas em disciplinas de outros departamentos, obter o código do professor, seu nome, o nome de seu departamento e o nome do departamento no qual ministrou disciplina.  
--Obter o nome dos professores que possuem horários conflitantes (possuem turmas que tenham a mesma hora inicial, no mesmo dia da semana e no mesmo semestre). Além dos nomes, mostrar as chaves primárias das turmas em conflito.  
--Para cada disciplina que possui pré-requisito, obter o nome da disciplina seguido do nome da disciplina que é seu pré-requisito.  
--Obter os nomes das disciplinas que não têm pré-requisito.  
--Obter o nome de cada disciplina que possui ao menos dois pré-requisitos.

