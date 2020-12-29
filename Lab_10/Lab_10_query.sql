use universitatea

DROP TRIGGER IF EXISTS Inregistrare_noua 
GO
CREATE TRIGGER Inregistrare_noua ON plan_studii.orarul
AFTER UPDATE
AS SET NOCOUNT ON
IF UPDATE(Auditoriu)
SELECT 'Disciplina ' + UPPER(plan_studii.discipline.Disciplina)+ 
		'Grupa: ' + grupe.Cod_Grupa +
		'Ziua: ' + CAST(inserted.Zi as VARCHAR(5)) + 
		'Ora ' + CAST(inserted.Ora as VARCHAR(5)) + 
		'Auditoriul nou: ' + CAST(inserted.Auditoriu as VARCHAR(5)) + CAST(inserted.Bloc as VARCHAR(5)) +
		'Auditoriul vechi: ' + CAST(deleted.Auditoriu as VARCHAR(5))
FROM inserted,deleted, plan_studii.discipline, grupe
WHERE deleted.Id_Disciplina = plan_studii.discipline.Id_Disciplina
AND inserted.Id_Grupa = grupe.Id_Grupa


GO
UPDATE plan_studii.orarul
SET Auditoriu = 200
WHERE Id_Grupa = 1 AND Id_Profesor = 117; 


GO
CREATE TRIGGER EX2 ON studenti.studenti_reusita
INSTEAD OF INSERT
AS SET NOCOUNT ON
   
  INSERT INTO studenti.studenti_reusita 
  SELECT * FROM inserted
  WHERE Id_Student in (SELECT Id_Student FROM studenti.studenti)
  GO

  INSERT INTO studenti.studenti values (667,'Nume', 'Prenume', '1998-06-07', 'MD-2022')
  INSERT INTO studenti.studenti_reusita values (667, 101, 101, 1, 'Examen', null, null)

 
  select * from studenti.studenti where Id_Student= 667
  select * from studenti.studenti_reusita where Id_Student = 667


GO


CREATE TRIGGER EX3 ON studenti.studenti_reusita
AFTER UPDATE
AS
SET NOCOUNT ON

IF UPDATE (Nota)
DECLARE @CIB_ID INT = (SELECT Id_Grupa  FROM grupe WHERE Cod_Grupa = 'CIB171')

DECLARE @count int = (SELECT count(*) FROM deleted, inserted 
			WHERE deleted.Id_Disciplina = inserted.Id_Disciplina AND deleted.Id_Grupa = inserted.Id_Grupa AND deleted.Id_Profesor = inserted.Id_Profesor AND deleted.Tip_Evaluare = inserted.Tip_Evaluare AND deleted.Id_Student = inserted.Id_Student
			AND inserted.Nota < deleted.Nota 
			AND inserted.Id_Grupa = @CIB_ID)
	
BEGIN
	IF (@count > 0 )
	PRINT ('Cant Lower Grades For CIB 171')
	ROLLBACK TRANSACTION
END

IF UPDATE(Data_Evaluare)
		SET @count = (SELECT count(*) FROM deleted 
		WHERE Data_Evaluare IS NOT NULL AND Id_Grupa = @CIB_ID)

		IF @count > 0
		BEGIN
			PRINT ('Cant Modify Data Evaluare')
			ROLLBACK TRANSACTION
		END


GO

DECLARE @CIB_ID INT = (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa = 'CIB171')

UPDATE studenti.studenti_reusita
SET Data_Evaluare = '2018-01-01'
WHERE Id_Grupa = @CIB_ID; 

GO

DECLARE @CIB_ID INT = (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa = 'CIB171')

UPDATE studenti.studenti_reusita
SET Nota = 8
WHERE Nota = 9 AND Id_Grupa = @CIB_ID;


IF OBJECT_ID('EX4', 'TR') is not null
   DROP TRIGGER EX4
GO
CREATE TRIGGER EX4 ON DATABASE
FOR ALTER_TABLE
AS 
SET NOCOUNT ON
DECLARE @ID_DISCPLINA varchar(60)
SET @ID_DISCPLINA = EVENTDATA().value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]', 'nvarchar(100)') 
IF @ID_DISCPLINA ='Id_Disciplina'
BEGIN 
PRINT ('Cant ALTER Id_Disciplina')
ROLLBACK;
END

--ALTER TABLE plan_studii.discipline ALTER COLUMN Id_Disciplina varchar(100)


DROP TRIGGER IF EXISTS EX5
GO
CREATE TRIGGER EX5
ON DATABASE

FOR ALTER_TABLE
AS
SET NOCOUNT ON
DECLARE @START TIME
DECLARE @END TIME
DECLARE @CURRENT_TIME TIME

SET @CURRENT_TIME = CONVERT(Time, GETDATE())
SET @START = '8:00:00'
SET @END = '17:00:00'

IF (@CURRENT_TIME < @START) OR (@CURRENT_TIME > @END)
BEGIN	
PRINT ' STILL AT WORK, CANT ALTER DATABASE '
ROLLBACK
END

GO
CREATE TABLE test_ex_5 (
    column1 INT,
    column2 INT,
); 

GO
ALTER TABLE test_ex_5 ALTER COLUMN column1 varchar(1230);


GO


CREATE TRIGGER EX6
ON DATABASE
FOR ALTER_TABLE
AS
SET NOCOUNT ON

DECLARE @COMANDA varchar(500)
DECLARE @ID_PROFESOR varchar (20)
DECLARE @TABELUL varchar (50)
DECLARE @COMANDA_NOUA varchar(500)

SELECT @ID_PROFESOR = EVENTDATA().value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]', 'nvarchar(max)')
IF @ID_PROFESOR = 'Id_Profesor'
BEGIN

SELECT @COMANDA = EVENTDATA().value ('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'nvarchar(max)')
SELECT @TABELUL = EVENTDATA().value ('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(max)')
SELECT @COMANDA_NOUA = REPLACE(@ID_PROFESOR, @TABELUL, 'studenti.studenti_reusita');
EXECUTE (@COMANDA_NOUA)
SELECT @COMANDA_NOUA = REPLACE(@ID_PROFESOR, @TABELUL, 'cadre_didactice.profesori');
EXECUTE (@COMANDA_NOUA)
SELECT @COMANDA_NOUA = REPLACE(@ID_PROFESOR, @TABELUL, 'plan_studii.orarul');
EXECUTE (@COMANDA_NOUA)

PRINT 'Data Modified Across All Occurences'
END

ALTER TABLE cadre_didactice.profesori ALTER COLUMN Id_Profesor SMALLINT
	

