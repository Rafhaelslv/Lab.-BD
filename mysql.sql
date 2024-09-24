DROP DATABASE IF EXISTS deptos;
CREATE DATABASE deptos;
USE deptos;

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

#Criar trigger para registrar um LOG das atualizações das Tabela Professor. No Log deve existir:

 #          1-  código do usuário que fez a alteração;

  #         2-  chave primaria do registro alterado;

   #        3-  Tipo de alteração realizado (INSERT ou UPDATE ou DELETE);

    #       4-  Data e Hora da alteração.



#Entregar a estrutura da Tabela de LOG ( pode ser chamada Tabela_Log_Professor ) ;

#e o Código da(s) Trigger(s).

-- para selecionar o usuario corrente no mysql
SELECT CURRENT_USER();