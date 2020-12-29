use universitatea

 -- Ex 1 ------------------------------------------------------------------------------------------------

GO
	CREATE VIEW Note_la_db AS 
	SELECT TOP 5 WITH TIES Nume_Student, Prenume_Student
	FROM studenti.studenti_reusita AS st_r INNER JOIN
	studenti.studenti AS st ON st_r.Id_Student = st.Id_Student INNER JOIN
	plan_studii.discipline AS disc ON st_r.Id_Disciplina = disc.Id_Disciplina WHERE 
	Disciplina = 'Baze de date' AND Tip_Evaluare = 'Testul 2' ORDER BY 
	Nota DESC

 -- Ex 2 ------------------------------------------------------------------------------------------------

GO 
	INSERT INTO Note_la_db (Nume_Student) VALUES 
	('Peter')

GO
	UPDATE Note_la_db
	SET Nume_Student = 'Filip' WHERE Nume_Student = 'Damian'
 
GO
	DELETE FROM Note_la_db
	WHERE Nume_Student = 'Ion'

 -- Ex 3 ------------------------------------------------------------------------------------------------

 GO
 DROP VIEW IF EXISTS 
 dbo.Note_la_db
 GO
	CREATE VIEW Note_la_db (Nume_Student, Prenume_Student) WITH SCHEMABINDING AS 
	SELECT TOP 5 WITH TIES Nume_Student, Prenume_Student
	FROM studenti.studenti_reusita AS st_r INNER JOIN
	studenti.studenti AS st ON st_r.Id_Student = st.Id_Student INNER JOIN
	plan_studii.discipline AS disc ON st_r.Id_Disciplina = disc.Id_Disciplina WHERE 
	Disciplina = 'Baze de date' AND Tip_Evaluare = 'Testul 2' ORDER BY 
	Nota DESC

-- Ex 4 -------------------------------------------------------------------------------------------------

GO 
ALTER TABLE studenti.studenti 
DROP COLUMN Nume_Student

-- Ex 5 -------------------------------------------------------------------------------------------------

GO
	WITH cte(Nume_Student, Prenume_Student, Id_Student, Id_Disciplina, Id_Profespr, Id_Grupa, Tip_Evalure, Nota, Data_Evaluare) AS 
	(Select Nume_Student, Prenume_Student, st.Id_Student, Id_Disciplina, Id_Profesor, Id_Grupa, Tip_Evaluare, Nota, Data_Evaluare from studenti.studenti_reusita AS st_r INNER JOIN
	studenti.studenti AS st ON st_r.Id_Student = st.Id_Student)

	SELECT TOP 5 WITH TIES Nume_Student, Prenume_Student
	FROM cte INNER JOIN 
	plan_studii.discipline AS disc ON cte.Id_Disciplina = disc.Id_Disciplina WHERE 
	disc.Disciplina = 'Baze de date' AND cte.Tip_Evalure = 'Testul 2' ORDER BY 
	cte.Nota DESC

GO
	WITH cte(Id_Disciplina, Id_Profespr, Id_Grupa, Tip_Evalure, Nota, Data_Evaluare, Nume_Profesor, Prenume_Profesor, Adresa_Postala_Profesor) AS 
	(Select  Id_Disciplina, pr.Id_Profesor, Id_Grupa, Tip_Evaluare, Nota, Data_Evaluare, Nume_Profesor, Prenume_Profesor, Adresa_Postala_Profesor from studenti.studenti_reusita AS st_r INNER JOIN
	cadre_didactice.profesori AS pr ON st_r.Id_Profesor = pr.Id_Profesor)

	SELECT cte.Nume_Profesor, cte.Prenume_Profesor, COUNT(DISTINCT disc.Disciplina) AS Numar_de_Lectii
	FROM cte INNER JOIN plan_studii.discipline AS disc ON disc.Id_Disciplina = cte.Id_Disciplina
	GROUP BY cte.Nume_Profesor, cte.Prenume_Profesor

-- Ex 6 -------------------------------------------------------------------------------------------------

CREATE TABLE Graph(Id int PRIMARY KEY, [Value] int);
INSERT INTO Graph VALUES(3,2), (4,2), (1,0), (5,0), (2,1);

SELECT * from Graph;

WITH GraphTemp AS (
		SELECT Id , [Value] FROM graph
		WHERE Id = 3 and Value = 2
		UNION ALL
		SELECT Graph.Id, graph.Value FROM graph
		INNER JOIN GraphTemp
		ON Graph.ID = GraphTemp.Value		
)

SELECT * from GraphTemp

