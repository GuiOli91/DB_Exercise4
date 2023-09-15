
CREATE TABLE Employee(
    SSNR INTEGER NOT NULL, 
    Name VARCHAR(255) NOT NULL,
    PRIMARY KEY(SSNR)
);

CREATE TABLE Store(
    StoreID INTEGER NOT NULL, 
    Country VARCHAR(255) NOT NULL, 
    Address VARCHAR(255) NOT NULL, 
    SSNR INTEGER NOT NULL,
    FOREIGN KEY(SSNR) REFERENCES Employee(SSNR),
    PRIMARY KEY(StoreID)
);

CREATE TABLE CashRegister(
    StoreID INTEGER NOT NULL,
    RegisterNr INTEGER NOT NULL,
    Model VARCHAR(255) NOT NULL,
    PRIMARY KEY (StoreID, RegisterNr),
    FOREIGN KEY(StoreID) REFERENCES Store(StoreID)
);

CREATE TABLE Invoice(
    StoreID INTEGER NOT NULL,
    RegisterNr INTEGER NOT NULL,
    Year INTEGER NOT NULL,
    INR INTEGER NOT NULL,
    Discount INTEGER NOT NULL,
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
    Designation VARCHAR(255) NOT NULL, 
    Price NUMERIC(18,2),
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
    Date DATE,
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
    PRIMARY KEY(recruit)
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
    FOREIGN KEY(StoreID, RegisterNr) REFERENCES CashRegister(StoreID, RegisterNr)    
);