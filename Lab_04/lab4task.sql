use universitatea

-- Sa se afiseze numele si prenumele studentilor care nu au nota de promovare la nici o disciplina la reusita curenta

Select DISTINCT Count(Nume_Student) as studs, Count(Prenume_Student) as prst, Nume_Student, Prenume_Student FROM studenti.studenti AS st 
INNER JOIN studenti.studenti_reusita AS st_r ON st.Id_Student = st_r.Id_Student INNER JOIN 
plan_studii.discipline AS d ON d.Id_Disciplina = st_r.Id_Disciplina
WHERE Tip_Evaluare = 'Reusita Curenta' AND Nota < 5
GROUP BY Nume_Student, Prenume_Student 
HAVING Count(Nume_Student) = 
(select max(tr) from (select distinct Id_Student, count(d.Id_Disciplina) as tr from studenti.studenti_reusita as d 
where d.Nota < 5 and d.Tip_Evaluare='Reusita Curenta' 
group by d.Id_Student ) as tr1);

