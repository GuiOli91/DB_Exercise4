CREATE SEQUENCE seq_store INCREMENT BY 10 MINVALUE 100 NO CYCLE;
CREATE SEQUENCE seq_register INCREMENT BY 5 MINVALUE 2 NO CYCLE;
CREATE TYPE ModelEnum AS ENUM('OLYMPIA', 'QUIO', 'STAR');

CREATE TABLE Store(
    StoreID INTEGER NOT NULL DEFAULT NEXTVAL('seq_store'), 
    Country VARCHAR(255) NOT NULL, 
    Address VARCHAR(255) NOT NULL,
    main_RegisterNr INTEGER NOT NULL,
    -- FOREIGN KEY(main_RegisterNr) REFERENCES CashRegister(RegisterNr),
    PRIMARY KEY(StoreID)
);

CREATE TABLE CashRegister(
    StoreID INTEGER NOT NULL,
    RegisterNr INTEGER NOT NULL DEFAULT NEXTVAL('seq_register'),
    Model ModelEnum NOT NULL,
    PRIMARY KEY (StoreID, RegisterNr),
    FOREIGN KEY(StoreID) REFERENCES Store(StoreID),
    CONSTRAINT uc_cashregister_registernr UNIQUE (RegisterNr) -- Unique constraint
);

ALTER TABLE Store
    ADD CONSTRAINT fk_main_register
    FOREIGN KEY (main_RegisterNr)
    REFERENCES CashRegister (RegisterNr)
    DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE Employee(
    SSNR INTEGER NOT NULL, 
    Name VARCHAR(255) NOT NULL,
    StoreID INTEGER NOT NULL,
    FOREIGN KEY(StoreID) REFERENCES Store(StoreID),
    PRIMARY KEY(SSNR)
);

CREATE TABLE Invoice(
    StoreID INTEGER NOT NULL,
    RegisterNr INTEGER NOT NULL,
    Year INTEGER NOT NULL,
    INR INTEGER NOT NULL,
    Discount NUMERIC(5, 2) NOT NULL CHECK (Discount >= 0 AND Discount < 100),
    PRIMARY KEY(StoreID, RegisterNr, Year, INR),
    FOREIGN KEY(StoreID, RegisterNr) REFERENCES CashRegister(StoreID, RegisterNr)
);

CREATE TABLE Warehouses (
    StoreID INTEGER NOT NULL,
    m2 INTEGER NOT NULL,
    FOREIGN KEY(StoreID) REFERENCES Store(StoreID),
    PRIMARY KEY(StoreID)
);

CREATE TABLE Production(
    StoreID INTEGER NOT NULL,
    SecLvl INTEGER NOT NULL,
    FOREIGN KEY(StoreID) REFERENCES Warehouses(StoreID),
    PRIMARY KEY(StoreID)
);

CREATE TABLE Product(
    VNr INTEGER NOT NULL, 
    Producer VARCHAR(255) NOT NULL, 
    SerNr INTEGER NOT NULL, 
    Designation VARCHAR(10) NOT NULL CHECK (Designation ~* $$^([A-Z]{4})#[A-Za-z0-9]{5}$$), 
    Price NUMERIC(13,2) NOT NULL CHECK (Price > 0),
    PRIMARY KEY(VNr, Producer, SerNr)
);

CREATE TABLE includes(
    StoreID INTEGER NOT NULL,
    RegisterNr INTEGER NOT NULL,
    Year INTEGER NOT NULL,
    INR INTEGER NOT NULL,
    VNr INTEGER NOT NULL, 
    Producer VARCHAR(255) NOT NULL, 
    SerNr INTEGER NOT NULL, 
    Count INTEGER NOT NULL,
    PRIMARY KEY(StoreID, RegisterNr, Year, INR, VNr, Producer, SerNr),
    FOREIGN KEY(StoreID, RegisterNr, Year, INR) REFERENCES Invoice(StoreID, RegisterNr, Year, INR),
    FOREIGN KEY(VNr, Producer, SerNr) REFERENCES Product(VNr, Producer, SerNr)    
);

CREATE TABLE produce(
    VNr INTEGER NOT NULL, 
    Producer VARCHAR(255) NOT NULL, 
    SerNr INTEGER NOT NULL, 
    StoreID INTEGER NOT NULL, 
    Date DATE CHECK (Date > '2020-04-10'),
    PRIMARY KEY(VNr, Producer, SerNr),
    FOREIGN KEY(StoreID) REFERENCES Production(StoreID),
    FOREIGN KEY(VNr, Producer, SerNr) REFERENCES Product(VNr, Producer, SerNr)
);

CREATE TABLE recruits (
    recruit INTEGER NOT NULL,
    recruiter INTEGER NOT NULL,
    Date DATE,
    FOREIGN KEY(recruit) REFERENCES Employee(SSNR),
    FOREIGN KEY(recruiter) REFERENCES Employee(SSNR),
    PRIMARY KEY(recruit),
    CONSTRAINT constraint_recruit UNIQUE (recruit)
);

CREATE TABLE trains (
    trainee INTEGER NOT NULL, 
    trainer INTEGER NOT NULL, 
    StoreID INTEGER NOT NULL, 
    RegisterNr INTEGER NOT NULL, 
    Grade INTEGER NOT NULL,
    PRIMARY KEY(trainee, trainer, StoreID, RegisterNr),
    FOREIGN KEY(trainee) REFERENCES Employee(SSNR),
    FOREIGN KEY(trainer) REFERENCES Employee(SSNR),
    FOREIGN KEY(StoreID, RegisterNr) REFERENCES CashRegister(StoreID, RegisterNr),
    CONSTRAINT constraint_trainee UNIQUE (trainee, StoreID, RegisterNr)
);