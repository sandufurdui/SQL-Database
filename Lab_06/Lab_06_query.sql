
use universitatea

-- ex 1 ----------------------------------------------------------

UPDATE profesori SET Adresa_Postala_Profesor = 'mun.Chisinau'
WHERE Adresa_Postala_Profesor is null;

-- ex 2 ----------------------------------------------------------

ALTER TABLE grupe
ALTER COLUMN Cod_Grupa varchar(255) NOT NULL  

ALTER TABLE grupe
ADD UNIQUE (Cod_Grupa)

-- ex 3 ----------------------------------------------------------

ALTER TABLE grupe
ADD Sef_Grupa INT, Prof_Indrumator INT


DECLARE @nr_de_grupe INT = (select count (Id_Grupa) from grupe)
DECLARE @index INT = 1
DECLARE @sef_grupa INT

WHILE (@index <= @nr_de_grupe)
BEGIN 
UPDATE grupe

-- setare sef grupa ----------------------------------------------

set Sef_Grupa = (select top(1) Id_Student from
(select Id_Student, avg (cast (Nota as float)) as nrNota
from studenti_reusita where Id_Grupa = @index group by Id_Student) as q1
order by q1.nrNota desc),

-- setare indrumator ---------------------------------------------

Prof_Indrumator = (select top(1) Id_Profesor from
(select Id_Profesor, count (distinct Id_Disciplina) as nr_Disciplina
from studenti_reusita where Id_Grupa = @index group by Id_Profesor) as q2
order by q2.nr_Disciplina desc) where Id_Grupa = @index;

set @index += 1;

END

-- ex 4 ----------------------------------------------------------

UPDATE studenti_reusita
set Nota += 1
where Id_Student = any (select Sef_Grupa from grupe) and nota != 10;

-- ex 5 ----------------------------------------------------------

create table profesori_new
	(Id_Profesor int NOT NULL, Nume_Profesor char(255), Prenume_Profesor char(255), Localitate char (255) DEFAULT ('mun. Chisinau'),
	Adresa_1 char (255), Adresa_2 char (255), CONSTRAINT [PK_profesori_new] PRIMARY KEY CLUSTERED (Id_Profesor)) ON [PRIMARY]

insert profesori_new (Id_Profesor,Nume_Profesor, Prenume_Profesor, Localitate,Adresa_1, Adresa_2)
	(SELECT Id_Profesor, Nume_Profesor, Prenume_Profesor, Adresa_Postala_Profesor, Adresa_Postala_Profesor, Adresa_Postala_Profesor
	from profesori)

UPDATE profesori_new
	SET Localitate = (case when CHARINDEX(', s.',Localitate) > 0
				 then case when CHARINDEX (', str.',Localitate) > 0 then SUBSTRING (Localitate, 1, CHARINDEX (', str.',Localitate) -1)
					        when CHARINDEX (', bd.',Localitate) > 0 then SUBSTRING (Localitate, 1, CHARINDEX (', bd.',Localitate) -1)
				      end
				  when  CHARINDEX(', or.',Localitate) > 0
				 then case when CHARINDEX (', str.',Localitate) > 0 then SUBSTRING (Localitate,1, CHARINDEX ('str.',Localitate) -3)
					        when CHARINDEX (', bd.',Localitate) > 0 then SUBSTRING (Localitate,1, CHARINDEX ('bd.',Localitate) -3)
					  end
				when CHARINDEX('nau',Localitate) > 0 then SUBSTRING(Localitate, 1, CHARINDEX('nau',Localitate)+2)
				end),
	Adresa_1 = (case when CHARINDEX('str.', Adresa_1) > 0
					then SUBSTRING(Adresa_1,CHARINDEX('str',Adresa_1), PATINDEX('%, [0-9]%',Adresa_1)- CHARINDEX('str.',Adresa_1))
			        when CHARINDEX('bd.',Adresa_1) > 0 then SUBSTRING(Adresa_1,CHARINDEX('bd',Adresa_1), PATINDEX('%, [0-9]%',Adresa_1) -  CHARINDEX('bd.',Adresa_1))
			   end),
	Adresa_2 = case when PATINDEX('%, [0-9]%',Adresa_2) > 0
					then SUBSTRING(Adresa_2, PATINDEX('%, [0-9]%',Adresa_2) +1,len(Adresa_2) - PATINDEX('%, [0-9]%',Adresa_2) +1)
				end
				

-- ex 6 ----------------------------------------------------------

create table orarul ( Id_Disciplina int, Id_Profesor int, Id_Grupa int default(1), Zi char(255), Ora Time, Auditoriu int,
					  Bloc char(1) default('B'), PRIMARY KEY (Id_Grupa, Zi, Ora, Auditoriu))

Insert orarul (Id_Disciplina , Id_Profesor, Zi, Ora, Auditoriu)
       values ( 107, 101, 'Lu','08:00', 202 )
Insert orarul (Id_Disciplina , Id_Profesor, Zi, Ora, Auditoriu)
       values ( 108, 101, 'Lu','11:30', 501 )
Insert orarul (Id_Disciplina , Id_Profesor, Zi, Ora, Auditoriu)
       values ( 109, 117, 'Lu','13:00', 501 )


-- ex 7 ----------------------------------------------------------

	   INSERT INTO orarul (Id_Disciplina, Id_Profesor, Id_Grupa, Zi, Ora)
values ((select Id_Disciplina from discipline where Disciplina = 'Structuri de date si algoritmi'),
		(select Id_Profesor from profesori where Nume_Profesor = 'Bivol' and Prenume_Profesor = 'Ion'),
		(select Id_Grupa from grupe where Cod_Grupa = 'INF171'), 'Lu', '08:00')

INSERT INTO orarul (Id_Disciplina, Id_Profesor, Id_Grupa, Zi, Ora)
values ((select Id_Disciplina from discipline where Disciplina = 'Programe aplicative'),
		(select Id_Profesor from profesori where Nume_Profesor = 'Mircea' and Prenume_Profesor = 'Sorin'),
		(select Id_Grupa from grupe where Cod_Grupa = 'INF171'), 'Lu', '11:30')

INSERT INTO orarul (Id_Disciplina, Id_Profesor, Id_Grupa, Zi, Ora)
values ((select Id_Disciplina from discipline where Disciplina = 'Baze de date'),
		(select Id_Profesor from profesori where Nume_Profesor = 'Micu' and Prenume_Profesor = 'Elena'),
		(select Id_Grupa from grupe where Cod_Grupa = 'INF171'), 'Lu', '13:00')

		

