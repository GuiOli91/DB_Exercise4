--- Query 1 -- Gesamtumsatz pro Grundstueck
CREATE OR REPLACE VIEW AnnualSalesVolume AS
	SELECT Jahr, SUM(w.Preis * e.Anzahl * (100 - r.Rabatt) / 100)
	FROM Rechnung r NATURAL JOIN enthaelt e NATURAL JOIN Ware w 
	GROUP BY Jahr;
SELECT * FROM AnnualSalesVolume;

--- Query 2 -- Transitiver Huelle von angeworbenen Neulingen
CREATE OR REPLACE VIEW AllRecruits AS
WITH RECURSIVE tmp(Werberin, Neuling) as ( 
       SELECT Werberin, Neuling 
	   FROM angeworben
       UNION
       SELECT tmp.Werberin, g.Neuling 
	   FROM angeworben g, tmp 
	   WHERE tmp.Neuling = g.Werberin
       ) SELECT * FROM tmp;
SELECT * FROM AllRecruits;


--- Query 3 -- Anzahl an Schritten zwischen Werberin A und Neuling B
CREATE OR REPLACE VIEW AllRecruitionSteps AS
WITH RECURSIVE tmp(Werberin, Neuling, Schritte) as ( 
       SELECT Werberin, Neuling, 1
	   FROM angeworben
       UNION
       SELECT tmp.Werberin, g.Neuling, tmp.Schritte + 1
	   FROM angeworben g, tmp
	   WHERE tmp.Neuling = g.Werberin
       ) SELECT * FROM tmp;
SELECT * FROM AllRecruitionSteps;