--- Trigger fuer 4.a --- 
CREATE OR REPLACE FUNCTION fAddRecruitment() RETURNS TRIGGER AS $$
DECLARE
	w_date DATE;
BEGIN

	BEGIN
		SELECT Datum INTO w_date FROM angeworben WHERE Neuling = NEW.Werberin;
    END;

	IF w_date IS NULL OR NEW.Datum > w_date THEN 
		RETURN NEW;
	ELSE
	    RAISE WARNING 'Werberin wurde nach ihrem Neuling angeworben.';
		RETURN NULL;
	END IF;
	
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tAddRecruitment BEFORE INSERT
    ON angeworben FOR EACH ROW EXECUTE PROCEDURE fAddRecruitment();


--- Trigger fuer 4.b ---
CREATE OR REPLACE FUNCTION fUpdateProduct() RETURNS TRIGGER AS $$
DECLARE
	rec RECORD;
	max_vnr INTEGER;
BEGIN
	--- Erzeuge eine neue Version des Produkts, wenn sich der Preis aendert und es bereits in einer Rechnung vorkam ---
	IF NEW.Preis != OLD.Preis THEN
		SELECT * INTO rec FROM Ware w NATURAL JOIN enthaelt e NATURAL JOIN Rechnung r
			WHERE w.VNr = NEW.VNr AND w.Herstellerin = NEW.Herstellerin AND w.SerNr = NEW.SerNr;
		
		IF rec IS NULL THEN
			RAISE NOTICE 'Update kann durchgefuehrt werden.';
			RETURN NEW;
		ELSE
			SELECT MAX(w.VNR) INTO max_vnr FROM Ware w
				WHERE w.Herstellerin = NEW.Herstellerin AND w.SerNr = NEW.SerNr 
				GROUP BY w.Herstellerin, w.SerNr;
		
			INSERT INTO Ware(VNr, Herstellerin, SerNr, Bezeichnung, Preis) VALUES 
				(max_vnr + 1, NEW.Herstellerin, NEW.SerNr, NEW.Bezeichnung, NEW.Preis);
			RETURN OLD;
			RAISE WARNING 'Das Update wurde durch ein Insert ersetzt.';        
		END IF;					    
	END IF;					    

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tUpdateProduct BEFORE UPDATE OF Preis ON Ware
       FOR EACH ROW EXECUTE PROCEDURE fUpdateProduct();


--- Trigger fuer 4.c ---
CREATE OR REPLACE FUNCTION fUpdateRecruitmentDate() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.Datum > OLD.Datum THEN
		UPDATE angeworben SET Datum = Datum + (NEW.Datum - OLD.Datum)
       	    WHERE Werberin = NEW.Neuling;
	END IF;
		RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tUpdateRecruitmentDate AFTER UPDATE OF Datum ON angeworben
       FOR EACH ROW EXECUTE PROCEDURE fUpdateRecruitmentDate();
	   

--- Prozedure fuer 4.d ---
CREATE OR REPLACE FUNCTION CreateStore(IN SVNR INTEGER, IN AnzahlKassen INTEGER, IN Adresse VARCHAR(255), IN Land VARCHAR(255)) RETURNS VOID AS
$$
DECLARE
	kassenmodell ModellEnum;
BEGIN

    IF AnzahlKassen < 1 THEN
        RAISE EXCEPTION 'Die Anzahl an Kassen muss zumindest 1 sein.';
    END IF;
	
	FOR counter IN 0 .. AnzahlKassen - 1
    LOOP
		PERFORM NEXTVAL('seq_registerNr');
		
		IF counter = 0 THEN
			-- Erzeuge die Filiale und verwende die erste erstellte Kassa als Hauptkassa
			PERFORM NEXTVAL('seq_storeID');
			INSERT INTO Filiale(Filialnr, Land, Adresse, SVNR, HauptkassaFilialnr, HauptkassaKNR) VALUES 
				(CURRVAL('seq_storeID'), Land, Adresse, SVNR, CURRVAL('seq_storeID'), CURRVAL('seq_registerNr'));
		END IF;
		
		-- Waehle das Kassenmodell
		CASE counter % 3	
			WHEN 0 THEN			
				kassenmodell := 'OLYMPIA';
            WHEN 1 THEN
				kassenmodell :=  'QUIO';
            WHEN 2 THEN
				kassenmodell := 'STAR';
        END CASE;		
		
		-- Erzeuge die Kassa
		INSERT INTO Kassa(Filialnr, KNR, Modell) VALUES 
			(CURRVAL('seq_storeID'), CURRVAL('seq_registerNr'), kassenmodell);
	END LOOP;
END;
$$ LANGUAGE plpgsql;