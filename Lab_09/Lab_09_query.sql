
use universitatea

 -- Ex 1 ------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS Proc_01;
GO

CREATE PROCEDURE Proc_01
		@disciplina VARCHAR(20) = 'Baze de date',
		@tip_evaluare VARCHAR(20) = 'Testul 2'
AS

SELECT TOP 5 WITH TIES Nume_Student, Prenume_Student
	FROM studenti.studenti_reusita AS st_r INNER JOIN
	studenti.studenti AS st ON st_r.Id_Student = st.Id_Student INNER JOIN
	plan_studii.discipline AS disc ON st_r.Id_Disciplina = disc.Id_Disciplina WHERE 
	Disciplina = @disciplina AND Tip_Evaluare = @tip_evaluare ORDER BY 
	Nota DESC


GO 
EXECUTE Proc_01 @tip_evaluare = 'Testul 2',
				@disciplina = 'Baze de date'


DROP PROCEDURE IF EXISTS Proc_02;
GO

CREATE PROCEDURE Proc_02
		@nota SMALLINT = 5,
		@tip_evaluare VARCHAR(20) = 'Reusita Curenta'
AS

Select DISTINCT Count(Nume_Student) as studs, Count(Prenume_Student) as prst, Nume_Student, Prenume_Student 
	FROM studenti.studenti AS st INNER JOIN studenti.studenti_reusita 
	AS st_r ON st.Id_Student = st_r.Id_Student INNER JOIN plan_studii.discipline 
	AS d ON d.Id_Disciplina = st_r.Id_Disciplina
	WHERE Tip_Evaluare = @tip_evaluare AND Nota < @nota
	GROUP BY Nume_Student, Prenume_Student 
	HAVING Count(Nume_Student) = 4

GO 
EXECUTE Proc_02 @nota = 5,
				@tip_evaluare = 'Reusita Curenta'




 -- Ex 2 ------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS Proc_03;
GO

CREATE PROCEDURE Proc_03
   @nr_de_studenti SMALLINT = NULL OUTPUT
AS
  
SELECT @nr_de_studenti =  COUNT(DISTINCT Id_student) 
	FROM studenti.studenti_reusita
	WHERE Nota < 5 OR Nota = NULL

GO
DECLARE @NR SMALLINT
	EXEC Proc_03 @NR OUTPUT
	PRINT ' Nr de studenti care au mai putin de 5 la cel putin o evaluare ' + CAST (@NR as VARCHAR(10))

 -- Ex 3 ------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS Proc_04
GO

CREATE PROCEDURE Proc_04 
	@id INT,
	@nume VARCHAR(50),
	@prenume VARCHAR(50),
	@data DATE,
	@adresa VARCHAR(500),
	@cod_grupa CHAR(6)

AS

INSERT INTO studenti.studenti VALUES (@id, @nume, @prenume, @data, @adresa)
INSERT INTO studenti.studenti_reusita VALUES (@id, 105, 101 , (SELECT Id_Grupa FROM dbo.grupe WHERE Cod_Grupa = @cod_grupa), 'Examen', NULL, '2018-12-9')


 -- Ex 4 ------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS Proc_05
GO


CREATE PROCEDURE Proc_05
	@disciplina VARCHAR(20),
	@nume_vechi VARCHAR(60),
	@prenume_vechi VARCHAR(60),
	@nume_nou VARCHAR(60),
	@prenume_nou VARCHAR(60)
AS

IF(
(SELECT discipline.Id_Disciplina FROM plan_studii.discipline WHERE Disciplina = @disciplina)
     IN (SELECT DISTINCT studenti_reusita.Id_Disciplina FROM studenti.studenti_reusita WHERE 
	 Id_Profesor = (SELECT cadre_didactice.profesori.Id_Profesor FROM cadre_didactice.profesori WHERE
	 Nume_Profesor = @nume_vechi AND Prenume_Profesor = @prenume_vechi))
)
BEGIN

UPDATE studenti.studenti_reusita
SET Id_Profesor =  (SELECT Id_Profesor
			      FROM cadre_didactice.profesori
				  WHERE Nume_Profesor = @nume_nou
				  AND   Prenume_Profesor = @prenume_nou)

WHERE Id_Profesor = (SELECT Id_profesor
					 FROM cadre_didactice.profesori
     			     WHERE Nume_Profesor = @nume_vechi
					 AND Prenume_Profesor = @prenume_vechi)
END

GO
EXECUTE Proc_05
		@disciplina = 'Baze de date',
		@nume_vechi = 'Popescu',
		@prenume_vechi = 'Gabriel',
		@nume_nou = 'Micu',
		@prenume_nou = 'Elena'

 -- Ex 5 ------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS Proc_06
GO

CREATE PROCEDURE Proc_06
	@disciplina VARCHAR(30)
AS

DECLARE @Media_Studenti TABLE (Id_Student int, Id_Disciplina int, Media float)

INSERT INTO @Media_Studenti

	SELECT TOP (3) studenti.studenti_reusita.Id_Student, plan_studii.discipline.Id_Disciplina, AVG(cast (Nota as float)) as Media
	FROM studenti.studenti_reusita, plan_studii.discipline
	WHERE plan_studii.discipline.Id_Disciplina = studenti.studenti_reusita.Id_Disciplina
	AND Disciplina = @disciplina
	GROUP BY studenti.studenti_reusita.Id_Student, plan_studii.discipline.Id_Disciplina
	ORDER BY Media desc		

UPDATE studenti.studenti_reusita
SET studenti.studenti_reusita.Nota = (CASE WHEN nota >= 9 THEN 10 ELSE nota + 1 END)
WHERE Tip_Evaluare = 'Examen'
AND Id_Disciplina IN (select Id_Disciplina from @Media_Studenti)
AND Id_Student IN (select Id_Student from @Media_Studenti)

GO 
EXECUTE Proc_06 @disciplina = 'Cercetari operationale'

 -- Ex 6 ------------------------------------------------------------------------------------------------

 DROP FUNCTION IF EXISTS Fun_01 
GO
CREATE FUNCTION Fun_01 (@tip_evaluare VARCHAR(10), @disciplina VARCHAR(20))
RETURNS TABLE
AS
RETURN(
SELECT TOP 5 WITH TIES Nume_Student, Prenume_Student
	FROM studenti.studenti_reusita AS st_r INNER JOIN
	studenti.studenti AS st ON st_r.Id_Student = st.Id_Student INNER JOIN
	plan_studii.discipline AS disc ON st_r.Id_Disciplina = disc.Id_Disciplina WHERE 
	Disciplina = @disciplina AND Tip_Evaluare = @tip_evaluare ORDER BY 
	Nota DESC)

GO
SELECT * FROM dbo.Fun_01('Examen', 'Baze de date')

GO
DROP FUNCTION IF EXISTS Fun_02 
GO
CREATE FUNCTION Fun_02 (@tip_evaluare VARCHAR(10), @nota SMALLINT)
RETURNS TABLE
AS
RETURN(
Select DISTINCT Count(Nume_Student) as studs, Count(Prenume_Student) as prst, Nume_Student, Prenume_Student 
	FROM studenti.studenti AS st INNER JOIN studenti.studenti_reusita 
	AS st_r ON st.Id_Student = st_r.Id_Student INNER JOIN plan_studii.discipline 
	AS d ON d.Id_Disciplina = st_r.Id_Disciplina
	WHERE Tip_Evaluare = @tip_evaluare AND Nota < @nota
	GROUP BY Nume_Student, Prenume_Student 
	HAVING Count(Nume_Student) = 4)

GO
SELECT * FROM dbo.Fun_02('Examen', 5)
 -- Ex 7 ------------------------------------------------------------------------------------------------

GO
DROP FUNCTION IF EXISTS Fun_03
GO

CREATE FUNCTION Fun_03 (@Data_Nasterii DATE )
RETURNS INT
 BEGIN
 DECLARE @age INT
 SELECT @age = (SELECT (YEAR(GETDATE()) - YEAR(@Data_Nasterii) - 
				CASE WHEN (MONTH(@Data_Nasterii) > MONTH(GETDATE())) OR
				(MONTH(@Data_Nasterii) = MONTH(GETDATE()) AND DAY(@Data_Nasterii)> DAY(GETDATE()))
				THEN 1 ELSE 0 END))
 RETURN @age
END



GO
PRINT dbo.Fun_03('2010-11-20')

 -- Ex 8 ------------------------------------------------------------------------------------------------

GO
DROP FUNCTION IF EXISTS Fun_04
GO

CREATE FUNCTION Fun_04 (@Nume_Prenume_Student VARCHAR(80))
RETURNS TABLE 
AS
RETURN
(SELECT Nume_Student + ' ' + Prenume_Student as Student, Nota, Disciplina, Data_Evaluare
 FROM studenti.studenti, plan_studii.discipline, studenti.studenti_reusita
 WHERE studenti.studenti.Id_Student = studenti_reusita.Id_Student
 AND discipline.Id_Disciplina = studenti_reusita.Id_Disciplina 
 AND Nume_Student + ' ' + Prenume_Student = @Nume_Prenume_Student)


 GO
SELECT * FROM dbo.Fun_04('Brasovianu Teodora')

 -- Ex 9 ------------------------------------------------------------------------------------------------

GO
DROP FUNCTION IF EXISTS Fun_05
GO

CREATE FUNCTION Fun_05 (@Cod_grupa VARCHAR(20), @is_good VARCHAR(20))
RETURNS @Rezultat Table (Cod_Grupa varchar(20), Nume_Student varchar (20), Prenume_Student varchar(20), Media decimal(4,2), Reusita varchar(20))

AS
BEGIN

IF @is_good = 'sarguincios'

INSERT INTO @Rezultat

SELECT TOP (1) Cod_Grupa, Nume_Student, Prenume_Student, CAST(AVG( Nota * 1.0) AS DECIMAL (4,2)) AS Media, @is_good
 FROM dbo.grupe, studenti.studenti, studenti.studenti_reusita
 WHERE grupe.Id_Grupa = studenti_reusita.Id_Grupa
 AND studenti.Id_Student = studenti_reusita.Id_Student AND Cod_Grupa = @Cod_grupa
 GROUP BY Cod_Grupa, Nume_Student, Prenume_Student
 ORDER BY Media DESC

ELSE

INSERT INTO @Rezultat
SELECT TOP (1) Cod_Grupa, Nume_Student, Prenume_Student, CAST(AVG( Nota * 1.0) AS DECIMAL (4,2)) AS Media, @is_good
 FROM dbo.grupe, studenti.studenti, studenti.studenti_reusita
 WHERE grupe.Id_Grupa = studenti_reusita.Id_Grupa
 AND studenti.Id_Student = studenti_reusita.Id_Student AND Cod_Grupa = @Cod_grupa
 GROUP BY Cod_Grupa, Nume_Student, Prenume_Student
 ORDER BY Media 

 RETURN 
END

 GO
SELECT * FROM dbo.Fun_05('INF171', 'sarguincios')

