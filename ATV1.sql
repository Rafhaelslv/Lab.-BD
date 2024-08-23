use master
drop database atv2
go
create database atv2 
go 
use atv2 
CREATE TABLE TB_ESTADO ( 
sigla_estado  char(2)    not null, 
nome_estado    varchar(40)  not null 
PRIMARY KEY (sigla_estado) 
) 
go 

CREATE TABLE TB_CLASSE ( 
id_classe    smallint  not null, 
id_andar    smallint  not null 
PRIMARY KEY  (id_classe) 
) 
go

CREATE TABLE TB_ALUNO ( 
cod_aluno    smallint    not null, 
nome_aluno    varchar(45)    not null, 
end_aluno    varchar(100)  not null, 
sigla_estado  char(2)      not null, 
id_classe    smallint    not null 
PRIMARY KEY  (cod_aluno) 
FOREIGN KEY (sigla_estado) REFERENCES TB_ESTADO (sigla_estado), 
FOREIGN KEY (id_classe) REFERENCES TB_CLASSE (id_classe) 
) 
go 
CREATE TABLE TB_PROFESSOR ( 
id_professor    char(3)      not null, 
nome_professor    varchar(25)    not null 
PRIMARY KEY  (id_professor) 
) 
go 

CREATE TABLE TB_DISCIPLINA ( 
id_disciplina    char(3)      not null, 
nome_disciplina    varchar(15)    not null, 
id_professor_disciplina  char(3)    not null, 
nota_minima_disciplina  smallint  not null 
PRIMARY KEY  (id_disciplina) 
FOREIGN KEY (id_professor_disciplina) REFERENCES TB_PROFESSOR (id_professor) 
) 
go 

CREATE TABLE TB_ALUNO_DISCIPLINA ( 
cod_aluno    smallint    not null, 
id_disciplina  char(3)   not null, 
nota_aluno    smallint   not null 
PRIMARY KEY   (cod_aluno, id_disciplina) 
FOREIGN KEY (id_disciplina) REFERENCES TB_DISCIPLINA (id_disciplina), 
FOREIGN KEY (cod_aluno) REFERENCES TB_ALUNO (cod_aluno) 
)
go

insert into TB_PROFESSOR VALUES
('JOI',  'JOILSON CARDOSO'),              
('OSE',  'OSEAS SANTANA '),           
('VIT', 'VITOR VASCONCELOS'),               
('FER', 'JOSE ROBERTO FERROLI') ,  
('LIM ', 'VALMIR LIMA')  ,          
('EDS',     'EDSON SILVA '),             
('WAG', 'WAGNER OKIDA ') 

go

INSERT INTO TB_ESTADO VALUES
('SP', 'sao paulo')

go 


INSERT INTO TB_CLASSE VALUES
('1', '1'),
('2', '1'),
('3', '1')

go

INSERT INTO TB_ALUNO VALUES
('1',    'ANTONIO CARLOS PENTEADO', 'RUA X',  'SP', '1'), 
('2',   'AUROMIR DA SILVA VALDEVINO',  'RUA W',    'SP',    '1'),
('3', 'ANDRE COSTA',    'RUA T',  'SP', '1') ,
('4', 'ROBERTO SOARES DE MENEZES', 'RUA BW', 'SP', '2'), 
('5', 'DANIA', 'RUA CCC', 'SP', '2') ,
('6', 'CARLOS MAGALHAES ', 'AV SP', 'SP', '2') ,
('7', 'MARCELO RAUBA ',                'AV SAO LUIS',    'SP', '3'), 
('8', 'FERNANDO',    'AV COUNTYR',  'SP', '3'), 
('9', 'WALMIR BURIN', 'RUA SSISIS', 'SP', '3')

go

INSERT INTO TB_DISCIPLINA VALUES
('MAT', 'MATEMATICA' , 'JOI',  '7'),        
('POR', 'PORTUGUES',   'VIT',  '5'),        
('FIS', 'FISICA' ,     'OSE',  '3') ,       
('HIS', 'HISTORIA',    'EDS',  '2 '),
('GEO', 'GEOGRAFIA',   'WAG ', ' 4 '),       
('ING', 'INGLES' ,     'LIM', '2')

go

INSERT INTO TB_ALUNO_DISCIPLINA VALUES
('1 ', 'MAT', '0'),     
('2', 'MAT', '0'),
('3', 'MAT', '1') ,
('4', 'POR', '2'),
('5', 'POR', '2') ,
('6', 'POR', '2'),
('7', 'FIS', '3'),
('8', 'FIS', '3'),
('9', 'FIS', '3') ,
('1', 'POR', '2'),
('2', 'POR', '2') ,
('7', 'POR', '2'),
('1', 'FIS', '3')

go

SELECT * FROM TB_ALUNO
SELECT * FROM TB_PROFESSOR
SELECT * FROM TB_ALUNO_DISCIPLINA

