-- Table Creation

CREATE TABLE IF NOT EXISTS Store (
    StoreID INTEGER NOT NULL,
    Country VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    SSNR INTEGER NOT NULL,
    PRIMARY KEY(StoreID)
);

CREATE TABLE IF NOT EXISTS CashRegister (
    StoreID INTEGER NOT NULL,
    RegisterNr INTEGER NOT NULL,
    Model VARCHAR(255) NOT NULL,
    PRIMARY KEY(StoreID, RegisterNr),
    FOREIGN KEY(StoreID) REFERENCES Store(StoreID)
);

CREATE TABLE IF NOT EXISTS Invoice (
    StoreID INTEGER NOT NULL,
    RegisterNr INTEGER NOT NULL,
    Year DATE NOT NULL,
    INR INTEGER NOT NULL,
    Discount NUMERIC(5,2) NOT NULL,
    PRIMARY KEY(StoreID, RegisterNr, Year, INR),
    FOREIGN KEY(StoreID, RegisterNr) REFERENCES CashRegister(StoreID, RegisterNr)
);

CREATE TABLE IF NOT EXISTS Warehouses (
    StoreID INTEGER NOT NULL,
    m2 INTEGER NOT NULL,
    PRIMARY KEY(StoreID),
    FOREIGN KEY(StoreID) REFERENCES Store(StoreID)
);

CREATE TABLE IF NOT EXISTS Production (
    StoreID INTEGER NOT NULL,
    SecLvl INTEGER NOT NULL,
    PRIMARY KEY(StoreID),
    FOREIGN KEY(StoreID) REFERENCES Warehouses(StoreID)    
);

CREATE TABLE IF NOT EXISTS Employee (
    SSNR INTEGER NOT NULL,
    Name VARCHAR(255) NOT NULL,
    PRIMARY KEY(SSNR)
);

CREATE TABLE IF NOT EXISTS Product (
    VNr INTEGER NOT NULL, 
    Producer VARCHAR(255) NOT NULL, 
    SerNr INTEGER NOT NULL, 
    Designation VARCHAR(255) NOT NULL, 
    Price NUMERIC(14,2) NOT NULL,
    PRIMARY KEY(VNr, Producer, SerNr)
);

CREATE TABLE IF NOT EXISTS includes (
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

CREATE TABLE IF NOT EXISTS produce (
    VNr INTEGER NOT NULL, 
    Producer INTEGER NOT NULL, 
    SerNr INTEGER NOT NULL,
    Date DATE NOT NULL,
    PRIMARY KEY(VNr, Producer, SerNr),
    FOREIGN KEY(VNr, Producer, SerNr) REFERENCES Product(VNr, Producer, SerNr),
    FOREIGN KEY(StoreID) REFERENCES Production(StoreID)
);

CREATE TABLE IF NOT EXISTS recruits (
    recruit INTEGER NOT NULL, 
    recruiter INTEGER NOT NULL,  
    Date DATE NOT NULL,
    PRIMARY KEY(recruit),
    FOREIGN KEY(recruit) REFERENCES Employee(SSNR),
    FOREIGN KEY(recruiter) REFERENCES Employee(SSNR)
);

CREATE TABLE IF NOT EXISTS trains(
    trainee INTEGER NOT NULL,
    trainer INTEGER NOT NULL,
    StoreID INTEGER NOT NULL, 
    RegisterNr INTEGER NOT NULL, 
    Grade NUMERIC(5,2) NOT NULL,
    PRIMARY KEY(trainee, trainer, StoreID, RegisterNr),
    FOREIGN KEY(trainee) REFERENCES Employee(SSNR),
    FOREIGN KEY(trainer) REFERENCES Employee(SSNR),
    FOREIGN KEY(StoreID, RegisterNr)
);
