use universitatea


-- Task 1 ---------------------------------------------------------------------@

DECLARE @Nl INT, @N2 INT, @N3 INT; 
DECLARE @MAI_MARE INT; 
SET @Nl = 60 * RAND(); 
SET @N2 = 60 * RAND(); 
SET @N3 = 60 * RAND(); 
IF @Nl > @N2 AND @Nl > @N3
   SELECT @MAI_MARE = @Nl; 
   ELSE IF @N2 > @Nl AND @N2 > @N3
   SELECT @MAI_MARE = @N2;
   ELSE IF @N3 > @Nl AND @N3 > @N2
   SELECT @MAI_MARE = @N3;
PRINT @Nl; 
PRINT @N2; 
PRINT @N3; 
PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 

-- Task 2 ---------------------------------------------------------------------@

declare @IgnoreMark_01 int = 6;
declare @IgnoreMark_02 int = 8;

select  top (30) Nume_Student, Prenume_Student, Nota
from studenti, studenti_reusita, discipline
where discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
and studenti.Id_Student = studenti_reusita.Id_Student
and Disciplina = 'Baze de date'
and Tip_Evaluare = 'Testul 1'
and Nota = IIF(Nota != @IgnoreMark_01 AND Nota != @IgnoreMark_02, Nota, 0);

-- Task 3 ---------------------------------------------------------------------@

set @Nl = 60 * rand();
set @N2 = 60 * rand();
set @N3 = 60 * rand();
set @MAI_MARE = @Nl;
set @MAI_MARE = case 
when @MAI_MARE < @N3 and @N2<@N3 then  @N3
when  @MAI_MARE < @N2 and @N3 < @N2 then  @N2
else @MAI_MARE
end   
print @Nl;
print @N2;
print @N3;
print 'Mai mare = ' + cast( @MAI_MARE as varchar(2));

-- Task 4 Part 1---------------------------------------------------------------------@


SET @Nl = 60 * RAND(); 
SET @N2 = 60 * RAND(); 
SET @N3 = 60 * RAND(); 

BEGIN TRY
IF @Nl > @N2 AND @Nl > @N3
   SELECT @MAI_MARE = @Nl; 
   ELSE IF @N2 > @Nl AND @N2 > @N3
   SELECT @MAI_MARE = @N2;
   ELSE IF @N3 > @Nl AND @N3 > @N2
   SELECT @MAI_MARE = @N3;
   ELSE 
   RAISERROR('Mai mare nu a fost setat deoarece valoarea maxima se repeta de cel putin doua ori', 16, 1);
END TRY 

BEGIN CATCH
	print ' ERROR :' + cast(ERROR_LINE() as varchar(20));
END CATCH

PRINT @Nl; 
PRINT @N2; 
PRINT @N3; 
PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 

-- Task 4 Part 2---------------------------------------------------------------------@


BEGIN TRY

select  top (30) Nume_Student, Prenume_Student, Nota
from studenti, studenti_reusita, discipline
where discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
and studenti.Id_Student = studenti_reusita.Id_Student
and Disciplina = 'Baze de date'
and Tip_Evaluare = 'Testul 1'
and Nota = IIF(Nota != @IgnoreMark_01 AND Nota != @IgnoreMark_02, Nota, null);

END TRY 

BEGIN CATCH 
	print ' ERROR :' + cast(ERROR_LINE() as varchar(20));
END CATCH 

