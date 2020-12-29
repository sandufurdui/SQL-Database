use universitatea


-- Afisati numele si prenumele primelor 5 studenti, care au obtinut note in ordine descrescatoare la al doilea test la disciplina Baze de Date.
-- Sa se foloseasca instructiunea TOP .. WITH TIES.


SELECT TOP 5 WITH TIES Nume_Student, Prenume_Student
FROM studenti_reusita AS st_r INNER JOIN
studenti AS st ON st_r.Id_Student = st.Id_Student INNER JOIN
discipline AS disc ON st_r.Id_Disciplina = disc.Id_Disciplina WHERE 
Disciplina = 'Baze de date' AND Tip_Evaluare = 'Testul 2' ORDER BY 
Nota DESC


-- Sa se obtina numarul de discipline predate de fiecare profesor

SELECT Nume_Profesor, Prenume_Profesor, COUNT(DISTINCT Disciplina) AS Numar_de_Lectii
FROM profesori AS pr INNER JOIN studenti_reusita AS st_r
ON pr.Id_Profesor = st_r.Id_Profesor INNER JOIN discipline
as disc ON disc.Id_Disciplina = st_r.Id_Disciplina
GROUP BY Nume_Profesor, Prenume_Profesor


-- Sa se afiseze numele si prenumele studentilor care nu au nota de promovare la nici o disciplina la reusita curenta

Select DISTINCT Count(Nume_Student) as studs, Count(Prenume_Student) as prst, Nume_Student, Prenume_Student FROM studenti AS st 
INNER JOIN studenti_reusita AS st_r ON st.Id_Student = st_r.Id_Student INNER JOIN 
discipline AS d ON d.Id_Disciplina = st_r.Id_Disciplina
WHERE Tip_Evaluare = 'Reusita Curenta' AND Nota < 5
GROUP BY Nume_Student, Prenume_Student 
HAVING Count(Nume_Student) = 4

