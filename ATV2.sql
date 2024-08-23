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

--UTILIZANDO O MODELO DE DADOS DE CURSO:

--A-    Exercícios de SELECT básico                              

--1). Queremos selecionar todos os alunos cadastrados.
SELECT * FROM TB_ALUNO

--2). Queremos selecionar todos os nomes de disciplina, cujo a nota mínima seja maior que 5 ( cinco ).
SELECT * FROM TB_DISCIPLINA
WHERE nota_minima_disciplina > 5

--3). Queremos selecionar todas disciplinas que tenham nota mínima entre 3 (três) e 5 (cinco).
SELECT * FROM TB_DISCIPLINA
WHERE nota_minima_disciplina >3 AND nota_minima_disciplina <5

--B-    Exercícios de SELECT (Ordenando e agrupando dados)

--1). Queremos selecionar todos os alunos em ordem alfabética de nome de aluno, e também o número da classe que estuda.
SELECT * FROM TB_ALUNO ORDER BY nome_aluno

--2). Selecionaremos o item anterior, porém ordenado alfabeticamente pelo identificador do aluno de forma descendente  (ascendente é “default”). .
SELECT * FROM TB_ALUNO ORDER BY cod_aluno desc


--3). Selecionaremos  todos os alunos que cursam as disciplinas de matemática E de português agrupados por aluno e disciplina.
SELECT 
	al.nome_aluno AS Nome_Aluno
FROM TB_ALUNO_DISCIPLINA ad
INNER JOIN TB_ALUNO al ON ad.cod_aluno = al.cod_aluno
INNER JOIN TB_DISCIPLINA di ON di.id_disciplina = ad.id_disciplina
WHERE 
	di.nome_disciplina IN ('MATEMATICA', 'PORTUGUES')
GROUP BY al.nome_aluno
HAVING COUNT(DISTINCT di.nome_disciplina) = 2
ORDER BY al.nome_aluno



--C-    Exercícios de SELECT (Junção de Tabelas)

--1). Queremos selecionar todos os nomes de alunos que cursam Português ou Matemática.
SELECT
	al.nome_aluno
FROM TB_ALUNO al
INNER JOIN TB_ALUNO_DISCIPLINA ad ON ad.cod_aluno = al.cod_aluno
INNER JOIN TB_DISCIPLINA di ON di.id_disciplina = ad.id_disciplina
WHERE di.nome_disciplina = 'MATEMATICA' or di.nome_disciplina = 'PORTUGUES'

--2). Queremos selecionar todos os nomes de alunos cadastrados que cursam  a disciplina FÍSICA e seus respectivos endereços .

SELECT
	al.nome_aluno, al.end_aluno
FROM TB_ALUNO al
INNER JOIN TB_ALUNO_DISCIPLINA ad ON ad.cod_aluno = al.cod_aluno
INNER JOIN TB_DISCIPLINA di ON di.id_disciplina = ad.id_disciplina
WHERE di.nome_disciplina = 'FISICA' 
--3). Queremos selecionar todos os nomes de alunos cadastrados que cursam física e o andar que se encontra a classe dos mesmos.
--Preste atenção ao detalhe da concatenação de uma string "andar" junto à coluna do número do andar (Apenas para estética do resultado).
SELECT
	al.nome_aluno, concat (c.id_andar, ' Andar' ) AS AndarClasse
FROM TB_ALUNO al
INNER JOIN TB_ALUNO_DISCIPLINA ad ON ad.cod_aluno = al.cod_aluno
INNER JOIN TB_DISCIPLINA di ON di.id_disciplina = ad.id_disciplina
INNER JOIN TB_CLASSE c ON c.id_classe = al.id_classe
WHERE di.nome_disciplina = 'FISICA'

--D-    Exercícios de SELECT (OUTER JOIN)

--1.    Selecionar todos os Professores com suas respectivas disciplinas e os demais Professores que não lecionam disciplina alguma.
SELECT p.nome_professor, d.nome_disciplina
FROM TB_PROFESSOR p, TB_DISCIPLINA d
WHERE p.id_professor = d.id_professor_disciplina

--Não pode usar junção.


--1.    Selecionar todos os nomes de professores que tenham ministrado disciplina para alunos que sejam do Estado do Piaui,cujo a classe tenha sido no terceiro andar.
select nome_professor
from TB_PROFESSOR
where id_professor in (
    select id_professor_disciplina
    from TB_DISCIPLINA
    where id_disciplina in (
        select id_disciplina
        from TB_ALUNO_DISCIPLINA
        where cod_aluno in (
            select cod_aluno
            from TB_ALUNO
            where sigla_estado = 'PI'
            and id_classe in (
                select id_classe
                from TB_CLASSE
                where id_andar = 3
            )
        )
    )
)