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

--**LISTA 1

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
CREATE PROCEDURE ObterProfessoresINF01
AS
BEGIN
    DECLARE @CodProf INT
    DECLARE ProfessorCursor CURSOR FOR
    SELECT DISTINCT PT.CodProf
    FROM ProfTurma PT
    JOIN Professor P ON PT.CodProf = P.CodProf
    WHERE P.CodDepto = 'INF01' AND PT.AnoSem = 20021

    OPEN ProfessorCursor
    FETCH NEXT FROM ProfessorCursor INTO @CodProf

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Professor: ' + CAST(@CodProf AS VARCHAR)
        FETCH NEXT FROM ProfessorCursor INTO @CodProf
    END

    CLOSE ProfessorCursor
    DEALLOCATE ProfessorCursor
END

EXEC ObterProfessoresINF01

--Obter os horários de aula (dia da semana,hora inicial e número de horas ministradas) do professor "Antunes" em 20021.
CREATE PROCEDURE ObterHorariosProfessorAntunes
AS
BEGIN
    DECLARE @DiaSem INT, @HoraInicio INT, @NumHoras INT
    DECLARE HorarioCursor CURSOR FOR
    SELECT H.DiaSem, H.HoraInicio, H.NumHoras
    FROM Horario H
    JOIN ProfTurma PT ON H.AnoSem = PT.AnoSem AND H.CodDepto = PT.CodDepto AND H.NumDisc = PT.NumDisc AND H.SiglaTur = PT.SiglaTur
    JOIN Professor P ON PT.CodProf = P.CodProf
    WHERE P.NomeProf = 'Antunes' AND H.AnoSem = 20021

    OPEN HorarioCursor
    FETCH NEXT FROM HorarioCursor INTO @DiaSem, @HoraInicio, @NumHoras

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Dia da Semana: ' + CAST(@DiaSem AS VARCHAR) + ', Hora Inicial: ' + CAST(@HoraInicio AS VARCHAR) + ', Número de Horas: ' + CAST(@NumHoras AS VARCHAR)
        FETCH NEXT FROM HorarioCursor INTO @DiaSem, @HoraInicio, @NumHoras
    END

    CLOSE HorarioCursor
    DEALLOCATE HorarioCursor
END

--Obter os nomes dos departamentos que têm turmas que, em 2002/1, têm aulas na sala 101 do prédio denominado 'Informática - aulas'.  
CREATE PROCEDURE ObterDeptosSala101
AS
BEGIN
    DECLARE @NomeDepto VARCHAR(40)
    DECLARE DeptoCursor CURSOR FOR
    SELECT DISTINCT D.NomeDepto
    FROM Depto D
    JOIN Disciplina DI ON D.CodDepto = DI.CodDepto
    JOIN Turma T ON DI.CodDepto = T.CodDepto AND DI.NumDisc = T.NumDisc
    JOIN Horario H ON T.AnoSem = H.AnoSem AND T.CodDepto = H.CodDepto AND T.NumDisc = H.NumDisc AND T.SiglaTur = H.SiglaTur
    JOIN Sala S ON H.NumSala = S.NumSala AND H.CodPred = S.CodPred
    JOIN Predioo P ON S.CodPred = P.CodPred
    WHERE H.AnoSem = 20021 AND H.NumSala = 101 AND P.NomePredio = 'Informática - aulas'

    OPEN DeptoCursor
    FETCH NEXT FROM DeptoCursor INTO @NomeDepto

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Departamento: ' + @NomeDepto
        FETCH NEXT FROM DeptoCursor INTO @NomeDepto
    END

    CLOSE DeptoCursor
    DEALLOCATE DeptoCursor
END

--Obter os códigos dos professores com título denominado 'Doutor' que não ministraram aulas em 2002/1.
CREATE PROCEDURE ObterProfessoresDoutoresSemAulas
AS
BEGIN
    DECLARE @CodProf INT
    DECLARE ProfessorCursor CURSOR FOR
    SELECT P.CodProf
    FROM Professor P
    JOIN Titulacao T ON P.CodTit = T.CodTit
    LEFT JOIN ProfTurma PT ON P.CodProf = PT.CodProf AND PT.AnoSem = 20021
    WHERE T.NomeTit = 'Doutor' AND PT.CodProf IS NULL

    OPEN ProfessorCursor
    FETCH NEXT FROM ProfessorCursor INTO @CodProf

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Professor: ' + CAST(@CodProf AS VARCHAR)
        FETCH NEXT FROM ProfessorCursor INTO @CodProf
    END

    CLOSE ProfessorCursor
    DEALLOCATE ProfessorCursor
END

--Obter os identificadores das salas (código do prédio e número da sala) que, em 2002/1:  
	--nas segundas-feiras (dia da semana = 2), tiveram ao menos uma turma do departamento 'Informática', e  
	--nas quartas-feiras (dia da semana = 4), tiveram ao menos uma turma ministrada pelo professor denominado 'Antunes'.
	
	CREATE PROCEDURE ObterSalasInformáticaAntunes
AS
BEGIN
    DECLARE @CodPred INT, @NumSala INT
    DECLARE SalaCursor CURSOR FOR
    SELECT DISTINCT H.CodPred, H.NumSala
    FROM Horario H
    JOIN Turma T ON H.AnoSem = T.AnoSem AND H.CodDepto = T.CodDepto AND H.NumDisc = T.NumDisc AND H.SiglaTur = T.SiglaTur
    JOIN Disciplina D ON T.CodDepto = D.CodDepto AND T.NumDisc = D.NumDisc
    JOIN Professor P ON P.CodProf = (SELECT PT.CodProf FROM ProfTurma PT WHERE PT.AnoSem = H.AnoSem AND PT.CodDepto = H.CodDepto AND PT.NumDisc = H.NumDisc AND PT.SiglaTur = H.SiglaTur AND P.NomeProf = 'Antunes')
    WHERE (H.DiaSem = 2 AND D.CodDepto = 'INF01') OR (H.DiaSem = 4 AND P.NomeProf = 'Antunes' AND H.AnoSem = 20021)

    OPEN SalaCursor
    FETCH NEXT FROM SalaCursor INTO @CodPred, @NumSala

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Prédio: ' + CAST(@CodPred AS VARCHAR) + ', Sala: ' + CAST(@NumSala AS VARCHAR)
        FETCH NEXT FROM SalaCursor INTO @CodPred, @NumSala
    END

    CLOSE SalaCursor
    DEALLOCATE SalaCursor
END

--Obter o dia da semana, a hora de início e o número de horas de cada horário de cada turma ministrada por um professor de nome `Antunes', em 2002/1, na sala número 101 do prédio de código 43423.
CREATE PROCEDURE ObterHorariosAntunesSala101
AS
BEGIN
    DECLARE @DiaSem INT, @HoraInicio INT, @NumHoras INT
    DECLARE HorarioCursor CURSOR FOR
    SELECT H.DiaSem, H.HoraInicio, H.NumHoras
    FROM Horario H
    JOIN ProfTurma PT ON H.AnoSem = PT.AnoSem AND H.CodDepto = PT.CodDepto AND H.NumDisc = PT.NumDisc AND H.SiglaTur = PT.SiglaTur
    JOIN Professor P ON PT.CodProf = P.CodProf
    WHERE P.NomeProf = 'Antunes' AND H.AnoSem = 20021 AND H.NumSala = 101 AND H.CodPred = 43423

    OPEN HorarioCursor
    FETCH NEXT FROM HorarioCursor INTO @DiaSem, @HoraInicio, @NumHoras

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Dia da Semana: ' + CAST(@DiaSem AS VARCHAR) + ', Hora Inicial: ' + CAST(@HoraInicio AS VARCHAR) + ', Número de Horas: ' + CAST(@NumHoras AS VARCHAR)
        FETCH NEXT FROM HorarioCursor INTO @DiaSem, @HoraInicio, @NumHoras
    END

    CLOSE HorarioCursor
    DEALLOCATE HorarioCursor
END

--Um professor pode ministrar turmas de disciplinas pertencentes a outros departamentos. Para cada professor que já ministrou aulas em disciplinas de outros departamentos, obter o código do professor, seu nome, o nome de seu departamento e o nome do departamento no qual ministrou disciplina.  
CREATE PROCEDURE ObterProfessoresOutrosDeptos
AS
BEGIN
    DECLARE @CodProf INT, @NomeProf VARCHAR(40), @NomeDeptoOrigem VARCHAR(40), @NomeDeptoDestino VARCHAR(40)
    DECLARE ProfessorCursor CURSOR FOR
    SELECT DISTINCT P.CodProf, P.NomeProf, DOrigem.NomeDepto AS NomeDeptoOrigem, DDestino.NomeDepto AS NomeDeptoDestino
    FROM Professor P
    JOIN Depto DOrigem ON P.CodDepto = DOrigem.CodDepto
    JOIN ProfTurma PT ON P.CodProf = PT.CodProf
    JOIN Disciplina DI ON PT.CodDepto = DI.CodDepto AND PT.NumDisc = DI.NumDisc
    JOIN Depto DDestino ON DI.CodDepto = DDestino.CodDepto
    WHERE P.CodDepto <> DI.CodDepto

    OPEN ProfessorCursor
    FETCH NEXT FROM ProfessorCursor INTO @CodProf, @NomeProf, @NomeDeptoOrigem, @NomeDeptoDestino

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Professor: ' + @NomeProf + ', Departamento de Origem: ' + @NomeDeptoOrigem + ', Departamento de Destino: ' + @NomeDeptoDestino
        FETCH NEXT FROM ProfessorCursor INTO @CodProf, @NomeProf, @NomeDeptoOrigem, @NomeDeptoDestino
    END

    CLOSE ProfessorCursor
    DEALLOCATE ProfessorCursor
END


--Obter o nome dos professores que possuem horários conflitantes (possuem turmas que tenham a mesma hora inicial, no mesmo dia da semana e no mesmo semestre). Além dos nomes, mostrar as chaves primárias das turmas em conflito.
CREATE PROCEDURE ObterHorariosConflitantes
AS
BEGIN
    DECLARE @CodProf INT, @NomeProf VARCHAR(40), @AnoSem INT, @CodDepto CHAR(5), @NumDisc INT, @SiglaTur CHAR(2), @DiaSem INT, @HoraInicio INT
    DECLARE @ConflitoEncontrado BIT
    DECLARE ProfessorCursor CURSOR FOR
    SELECT DISTINCT P.CodProf, P.NomeProf
    FROM Professor P
    JOIN ProfTurma PT ON P.CodProf = PT.CodProf
    JOIN Horario H ON PT.AnoSem = H.AnoSem AND PT.CodDepto = H.CodDepto AND PT.NumDisc = H.NumDisc AND PT.SiglaTur = H.SiglaTur
    WHERE EXISTS (
        SELECT 1
        FROM Horario H2
        WHERE H2.AnoSem = H.AnoSem AND H2.DiaSem = H.DiaSem AND H2.HoraInicio = H.HoraInicio
        AND H2.CodDepto <> H.CodDepto AND H2.NumDisc <> H.NumDisc AND H2.SiglaTur <> H.SiglaTur
        AND H2.CodProf = H.CodProf
    )

    OPEN ProfessorCursor
    FETCH NEXT FROM ProfessorCursor INTO @CodProf, @NomeProf

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ConflitoEncontrado = 0
        DECLARE ConflitoCursor CURSOR FOR
        SELECT H.AnoSem, H.CodDepto, H.NumDisc, H.SiglaTur, H.DiaSem, H.HoraInicio
        FROM Horario H
        JOIN ProfTurma PT ON H.AnoSem = PT.AnoSem AND H.CodDepto = PT.CodDepto AND H.NumDisc = PT.NumDisc AND H.SiglaTur = PT.SiglaTur
        WHERE PT.CodProf = @CodProf
        AND EXISTS (
            SELECT 1
            FROM Horario H2
            WHERE H2.AnoSem = H.AnoSem AND H2.DiaSem = H.DiaSem AND H2.HoraInicio = H.HoraInicio
            AND H2.CodDepto <> H.CodDepto AND H2.NumDisc <> H.NumDisc AND H2.SiglaTur <> H.SiglaTur
            AND H2.CodProf = H.CodProf
        )

        OPEN ConflitoCursor
        FETCH NEXT FROM ConflitoCursor INTO @AnoSem, @CodDepto, @NumDisc, @SiglaTur, @DiaSem, @HoraInicio

        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF @ConflitoEncontrado = 0
            BEGIN
                PRINT 'Professor: ' + @NomeProf
                SET @ConflitoEncontrado = 1
            END
            PRINT 'Turma em Conflito: AnoSem=' + CAST(@AnoSem AS VARCHAR) + ', CodDepto=' + @CodDepto + ', NumDisc=' + CAST(@NumDisc AS VARCHAR) + ', SiglaTur=' + @SiglaTur + ', DiaSem=' + CAST(@DiaSem AS VARCHAR) + ', HoraInicio=' + CAST(@HoraInicio AS VARCHAR)
            FETCH NEXT FROM ConflitoCursor INTO @AnoSem, @CodDepto, @NumDisc, @SiglaTur, @DiaSem, @HoraInicio
        END

        CLOSE ConflitoCursor
        DEALLOCATE ConflitoCursor

        FETCH NEXT FROM ProfessorCursor INTO @CodProf, @NomeProf
    END

    CLOSE ProfessorCursor
    DEALLOCATE ProfessorCursor
END


--Para cada disciplina que possui pré-requisito, obter o nome da disciplina seguido do nome da disciplina que é seu pré-requisito.  
CREATE PROCEDURE ObterDisciplinasComPreRequisitos
AS
BEGIN
    DECLARE @NomeDisc VARCHAR(10), @NomeDiscPreReq VARCHAR(10)
    DECLARE DisciplinaCursor CURSOR FOR
    SELECT D.NomeDisc, DP.NomeDisc AS NomeDiscPreReq
    FROM Disciplina D
    JOIN PreReq PR ON D.CodDepto = PR.CodDepto AND D.NumDisc = PR.NumDisc
    JOIN Disciplina DP ON PR.CodDeptoPreReq = DP.CodDepto AND PR.NumDiscPreReq = DP.NumDisc

    OPEN DisciplinaCursor
    FETCH NEXT FROM DisciplinaCursor INTO @NomeDisc, @NomeDiscPreReq

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Disciplina: ' + @NomeDisc + ', Pré-requisito: ' + @NomeDiscPreReq
        FETCH NEXT FROM DisciplinaCursor INTO @NomeDisc, @NomeDiscPreReq
    END

    CLOSE DisciplinaCursor
    DEALLOCATE DisciplinaCursor
END


--Obter os nomes das disciplinas que não têm pré-requisito.  
CREATE PROCEDURE ObterDisciplinasSemPreRequisitos
AS
BEGIN
    DECLARE @NomeDisc VARCHAR(10)
    DECLARE DisciplinaCursor CURSOR FOR
    SELECT D.NomeDisc
    FROM Disciplina D
    LEFT JOIN PreReq PR ON D.CodDepto = PR.CodDepto AND D.NumDisc = PR.NumDisc
    WHERE PR.CodDepto IS NULL AND PR.NumDisc IS NULL

    OPEN DisciplinaCursor
    FETCH NEXT FROM DisciplinaCursor INTO @NomeDisc

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Disciplina: ' + @NomeDisc
        FETCH NEXT FROM DisciplinaCursor INTO @NomeDisc
    END

    CLOSE DisciplinaCursor
    DEALLOCATE DisciplinaCursor
END


--Obter o nome de cada disciplina que possui ao menos dois pré-requisitos.
CREATE PROCEDURE ObterDisciplinasComDoisPreRequisitos
AS
BEGIN
    DECLARE @NomeDisc VARCHAR(10)
    DECLARE DisciplinaCursor CURSOR FOR
    SELECT D.NomeDisc
    FROM Disciplina D
    WHERE (SELECT COUNT(*) 
           FROM PreReq PR 
           WHERE PR.CodDepto = D.CodDepto AND PR.NumDisc = D.NumDisc) >= 2

    OPEN DisciplinaCursor
    FETCH NEXT FROM DisciplinaCursor INTO @NomeDisc

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Disciplina: ' + @NomeDisc
        FETCH NEXT FROM DisciplinaCursor INTO @NomeDisc
    END

    CLOSE DisciplinaCursor
    DEALLOCATE DisciplinaCursor
END




