CREATE SEQUENCE seq_storeID INCREMENT BY 10 MINVALUE 100 NO CYCLE;
CREATE SEQUENCE seq_registerNr INCREMENT BY 5 MINVALUE 2 NO CYCLE;
CREATE TYPE ModellEnum AS ENUM ('OLYMPIA', 'QUIO', 'STAR');

CREATE TABLE Mitarbeiterin (
	Name VARCHAR(255) NOT NULL,
	SVNR INTEGER NOT NULL,
	Filialnr INTEGER NOT NULL,
	PRIMARY KEY(SVNR)
);

CREATE TABLE Filiale (
	Filialnr INTEGER NOT NULL DEFAULT NEXTVAL('seq_storeID'),
	Land VARCHAR(255) NOT NULL,
	Adresse VARCHAR(255) NOT NULL,
	SVNR INTEGER NOT NULL,
	HauptkassaFilialnr INTEGER NOT NULL,
	HauptkassaKNR INTEGER NOT NULL,
	FOREIGN KEY(SVNR) REFERENCES Mitarbeiterin(SVNR),	
	PRIMARY KEY(Filialnr)
);

ALTER TABLE Mitarbeiterin ADD CONSTRAINT fk_WorkPlace
      FOREIGN KEY (Filialnr) REFERENCES Filiale(Filialnr)
      DEFERRABLE INITIALLY DEFERRED;	  


CREATE TABLE Kassa (
	Filialnr INTEGER NOT NULL,
	KNR INTEGER NOT NULL DEFAULT NEXTVAL('seq_registerNr'), 
	Modell ModellEnum NOT NULL,
	FOREIGN KEY(Filialnr) REFERENCES Filiale(Filialnr),	
	PRIMARY KEY(Filialnr, KNR)
);

ALTER TABLE Filiale ADD CONSTRAINT fk_MainCashRegister
      FOREIGN KEY (HauptkassaFilialnr, HauptkassaKNR) REFERENCES Kassa(Filialnr, KNR)
      DEFERRABLE INITIALLY DEFERRED;	  


CREATE TABLE Rechnung (
	Filialnr INTEGER NOT NULL,
	KNR INTEGER NOT NULL,
	Jahr INTEGER NOT NULL,
	RNR INTEGER NOT NULL,
	Rabatt NUMERIC(10,2) NOT NULL CHECK(Rabatt >= 0 AND Rabatt < 100),
	FOREIGN KEY(Filialnr, KNR) REFERENCES Kassa(Filialnr, KNR),	
	PRIMARY KEY(Filialnr, KNR, Jahr, RNR)
);


CREATE TABLE Versandlager (
	Filialnr INTEGER NOT NULL,
	m2 INTEGER NOT NULL,
	FOREIGN KEY(Filialnr) REFERENCES Filiale(Filialnr),	
	PRIMARY KEY(Filialnr)
);

CREATE TABLE Produktion (
	Filialnr INTEGER NOT NULL,
	SecLvl INTEGER NOT NULL,
	FOREIGN KEY(Filialnr) REFERENCES Versandlager(Filialnr),	
	PRIMARY KEY(Filialnr)
);

CREATE TABLE Ware (
	VNr INTEGER NOT NULL,
	Herstellerin VARCHAR(255) NOT NULL,
	SerNr INTEGER NOT NULL,
	Bezeichnung VARCHAR(255) NOT NULL CHECK(Bezeichnung ~* $$^([A-Z]){4}\#\w{5}$$),
	Preis NUMERIC(10,2) NOT NULL CHECK(Preis > 0),
	PRIMARY KEY(VNr, Herstellerin, SerNr)
);

CREATE TABLE enthaelt (
	Filialnr INTEGER NOT NULL,
	KNR INTEGER NOT NULL,
	Jahr INTEGER NOT NULL,
	RNR INTEGER NOT NULL,
	VNr INTEGER NOT NULL,
	Herstellerin VARCHAR(255) NOT NULL,
	SerNr INTEGER NOT NULL,
	Anzahl INTEGER NOT NULL,
	FOREIGN KEY(Filialnr, KNR, Jahr, RNR) REFERENCES Rechnung(Filialnr, KNR, Jahr, RNR),	
	FOREIGN KEY(VNr, Herstellerin, SerNr) REFERENCES Ware(VNr, Herstellerin, SerNr),	
	PRIMARY KEY(Filialnr, KNR, Jahr, RNR, VNr, Herstellerin, SerNr)
);


CREATE TABLE hergestellt (
	VNr INTEGER NOT NULL,
	Herstellerin VARCHAR(255) NOT NULL,
	SerNr INTEGER NOT NULL,
	Filialnr INTEGER NOT NULL,
	Datum DATE NOT NULL CHECK(Datum > '2020-04-10'::DATE),
	FOREIGN KEY(Filialnr) REFERENCES Produktion(Filialnr),	
	FOREIGN KEY(VNr, Herstellerin, SerNr) REFERENCES Ware(VNr, Herstellerin, SerNr),	
	PRIMARY KEY(VNr, Herstellerin, SerNr)
);


CREATE TABLE angeworben (
	Neuling INTEGER NOT NULL,
	Werberin INTEGER NOT NULL,
	Datum DATE NOT NULL,
	FOREIGN KEY(Neuling) REFERENCES Mitarbeiterin(SVNR),	
	FOREIGN KEY(Werberin) REFERENCES Mitarbeiterin(SVNR),
	PRIMARY KEY(Neuling)
);

CREATE TABLE schult (
	Azubi INTEGER NOT NULL,
	Trainerin INTEGER NOT NULL,
	Filialnr INTEGER NOT NULL,
	KNR INTEGER NOT NULL,
	Bewertung VARCHAR(255) NOT NULL,
	UNIQUE(Azubi, Filialnr, KNR),
	FOREIGN KEY(Azubi) REFERENCES Mitarbeiterin(SVNR),	
	FOREIGN KEY(Trainerin) REFERENCES Mitarbeiterin(SVNR),	
	FOREIGN KEY(Filialnr, KNR) REFERENCES Kassa(Filialnr, KNR),	
	PRIMARY KEY(Azubi, Trainerin, Filialnr, KNR)
);