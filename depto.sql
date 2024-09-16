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

