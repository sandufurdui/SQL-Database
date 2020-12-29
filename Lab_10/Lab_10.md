1. Sa se modifice declansatorul inregistrare_noua, in asa fel, incat in cazul actualizarii auditoriului sa apara mesajul de informare, care, in afara de disciplina si ora, va afisa codul grupei afectate, ziua, blocul, auditoriul vechi si auditoriul nou.

![image](https://user-images.githubusercontent.com/33174692/50052530-33c23600-012e-11e9-8cef-1408eeb9c887.png)

2. Sa se creeze declansatorul, care ar asigura popularea corecta (consecutiva) a tabelelor studenti si studenti_reusita,si ar permite evitarea erorilor la nivelul cheilor externe.

![image](https://user-images.githubusercontent.com/33174692/50052659-33c33580-0130-11e9-9aad-f168845e10f5.png)

3. Sa se creeze un declansator, care ar interzice micsorarea notelor in tabelul studenti_reusita si modificarea valorilor campului Data_Evaluare, unde valorile acestui camp sunt nenule. Declansatorul trebuie sa se lanseze, numai daca sunt afectate datele studentilor din grupa ,,CIB 171 ". Se va afisa un mesaj de avertizare in cazul tentativei de a incalca constrangerea.

![image](https://user-images.githubusercontent.com/33174692/50053050-e0a0b100-0136-11e9-849a-84cf7d01c780.png)

![image](https://user-images.githubusercontent.com/33174692/50053046-d1216800-0136-11e9-8be7-5693dd560f6e.png)

4. Sa se creeze un declansator DDL care ar interzice modificarea coloanei ld_Disciplina in tabelele bazei de date universitatea cu afisarea mesajului respectiv.

![image](https://user-images.githubusercontent.com/33174692/50053218-b13f7380-0139-11e9-9881-773a4511916a.png)

5. Sa se creeze un declansator DDL care ar interzice modificarea schemei bazei de date in afara orelor de lucru.

![image](https://user-images.githubusercontent.com/33174692/50053329-f795d200-013b-11e9-98fb-1aa764b6c140.png)

6. Sa se creeze un declansator DDL care, la modificarea proprietatilor coloanei ld_Profesor dintr-un tabel, ar face schimbari asemanatoare in mod automat in restul tabelelor.

![image](https://user-images.githubusercontent.com/33174692/50053366-b05c1100-013c-11e9-8b51-e8aa365f86ea.png)



