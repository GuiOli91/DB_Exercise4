BEGIN;

/* Die Reihenfolge der DELETE Answeisungen ist wichtig */

DELETE FROM schult;
DELETE FROM angeworben;
DELETE FROM enthaelt;
DELETE FROM Ware;
DELETE FROM Produktion;
DELETE FROM Versandlager;
DELETE FROM Rechnung;
DELETE FROM Kassa;
DELETE FROM Filiale;
DELETE FROM Mitarbeiterin;


SELECT setval('seq_storeID', 100, false);
SELECT setval('seq_registerNr', 2, false);

COMMIT;


BEGIN;

INSERT INTO Mitarbeiterin(SVNR, Name, Filialnr) VALUES
		(2440, 'Riley', 100),
		(2038, 'Noah', 110),
		(7462, 'Isabella', 120),
		(6271, 'Ida', 130),
		(3342, 'Helena', 140),
		(4632, 'Mailinda', 100),
		(9274, 'Aki', 100),
		(7115, 'Mia', 120),
		(1935, 'Kim', 150),
		(6762, 'Alice', 160);
		

SELECT CreateStore(2440, 3, 'A1', 'Rwanda');
SELECT CreateStore(2038, 1, 'A2', 'Japan');
SELECT CreateStore(7462, 2, 'A3', 'Chile');
SELECT CreateStore(6271, 3, 'A4', 'Albania');
SELECT CreateStore(3342, 1, 'A5', 'Mauritius');
SELECT CreateStore(1935, 2, 'A6', 'France');
SELECT CreateStore(6762, 2, 'A7', 'Brazil');

COMMIT;

INSERT INTO angeworben (Neuling, Werberin, Datum) VALUES
		(2440, 2038,'2020-01-01'),
		(2038, 7462, '2020-02-17');

SELECT * FROM AllRecruits;

INSERT INTO Rechnung(Filialnr, KNR, Jahr, RNR, Rabatt) VALUES
		(100, 2, 2021, 1, 10),
		(100, 2, 2021, 2, 50),
		(100, 7, 2021, 3, 0),
		(100, 12, 2022, 4, 25);


INSERT INTO Versandlager (Filialnr, m2) VALUES
		(130, 150),
		(140, 100),
		(150, 200),
		(160, 500);		

INSERT INTO Produktion (Filialnr, SecLvl) VALUES
		(130, 1),
		(140, 2),
		(150, 4);		

INSERT INTO Ware (VNr, Herstellerin, SerNr, Bezeichnung, Preis) VALUES
		(1, 'P1', 1, 'ADBS#54ad2', 100),
		(1, 'P2', 2, 'SBSC#gD422', 200),
		(1, 'P3', 3, 'CANO#40x12', 10),
		(1, 'P4', 4, 'SAMG#11x2S', 50),
		(1, 'P5', 5, 'SOLA#B22A1', 80);
		
INSERT INTO enthaelt (Filialnr, KNR, Jahr, RNR, VNr, Herstellerin, SerNr , Anzahl) VALUES
		(100, 2, 2021, 1, 1, 'P1', 1, 1),
		(100, 2, 2021, 1, 1, 'P2', 2, 2),
		(100, 2, 2021, 2, 1, 'P3', 3, 5),
		(100, 7, 2021, 3, 1, 'P4', 4, 3),
		(100, 12, 2022, 4, 1, 'P5', 5, 2);


INSERT INTO hergestellt (VNr, Herstellerin, SerNr , Filialnr, Datum) VALUES
		(1, 'P1', 1, 130, '2020-12-15'), --, 'H'),
		(1, 'P2', 2, 150, '2021-03-12'), --, 'H'),
		(1, 'P3', 3, 130, '2021-02-01'), --, 'M'),
		(1, 'P4', 4, 140, '2021-02-26'), --, 'M'),
		(1, 'P5', 5, 130, '2020-10-12'); --, 'H');


INSERT INTO angeworben (Neuling, Werberin, Datum) VALUES
		(9274, 2440,'2020-01-01'),
		(4632, 9274, '2020-02-17'),
		(1935, 4632, '2020-02-27');
		
INSERT INTO schult (Azubi, Trainerin, Filialnr, KNR, Bewertung) VALUES
		(9274, 2440, 100, 2, 'Good'),
		(9274, 2440, 100, 7, 'Good'),
		(4632, 2440, 100, 2, 'Good'),
		(4632, 9274, 100, 7, 'Good');