BEGIN;

DELETE FROM trains;
DELETE FROM recruits;
DELETE FROM produce;
DELETE FROM includes;
DELETE FROM Product;
DELETE FROM Production;
DELETE FROM Warehouses;
DELETE FROM Invoice;
DELETE FROM CashRegister;
DELETE FROM Employee;
DELETE FROM Store;

SELECT setval('seq_store', 100, false);
SELECT setval('seq_register', 2, false);

COMMIT;


BEGIN;


INSERT INTO Store(Country, Address, main_RegisterNr) VALUES
        ('Brazil', 'Av. Paulista', 7),
        ('Spain', 'La Calle', 2),
        ('Germany', 'Bodensee', 12);

INSERT INTO CashRegister(StoreID, RegisterNr, Model) VALUES
        (110, 12, 'OLYMPIA'),
        (120, 7, 'STAR'),
        (100, 2, 'OLYMPIA');

COMMIT;

INSERT INTO Employee(SSNR, Name, StoreID) VALUES
        (1245, 'Jorge', 120),
        (9654, 'Alejandro', 120),
        (2478, 'Mario', 100),
        (0001, 'Ana', 110),
        (0002, 'Gustavo', 110),
        (0003, 'Emir', 100),
        (0004, 'Chris', 120),
        (0005, 'Sina', 110),
        (0006, 'Martin', 100);

INSERT INTO Invoice(StoreID, RegisterNr, Year, INR, Discount) VALUES
        (120, 7, 2020, 52465, 12.75),
        (110, 12, 2021, 35168, 5.1),
        (100, 2, 2022, 23156, 4);

INSERT INTO Warehouses(StoreID, m2) VALUES
        (110, 87941320),
        (120, 56312485),
        (100, 45534124);

INSERT INTO Production(StoreID, SecLvl) VALUES
        (100, 1),
        (110, 2),
        (120, 3);

INSERT INTO Product(VNr, Producer, SerNr, Designation, Price) VALUES
        (00012, 'Best Products', 57123, 'BBRA#keine', 1299.99),
        (00035, 'ACME', 963527, 'AUSA#apple', 3499.99),
        (00168, 'Good stuff', 5637439, 'CCHI#bears', 1.99);

INSERT INTO includes(StoreID, RegisterNr, Year, INR, VNr, Producer, SerNr, Count) VALUES
        (110, 12, 2021, 35168, 00168, 'Good stuff', 5637439, 10),
        (100, 2, 2022, 23156, 00012, 'Best Products', 57123, 25),
        (120, 7, 2020, 52465, 00035, 'ACME', 963527, 1000);

INSERT INTO produce(VNr, Producer, SerNr, StoreID, Date) VALUES
        (00168, 'Good stuff', 5637439, 110, '2020-04-11'),
        (00012, 'Best Products', 57123, 100, '2020-05-06'),
        (00035, 'ACME', 963527, 120, '2020-06-05');

INSERT INTO recruits(recruit, recruiter, Date) VALUES
        (2478, 1245, '2020-06-05'),
        (0003, 0002, '2021-07-05'),
        (9654, 2478, '2022-07-05'),
        (0001, 0003, '2022-09-05');

INSERT INTO trains(trainee, trainer, StoreID, RegisterNr, Grade) VALUES
        (1245, 9654, 120, 7, 1),
        (9654, 1245, 110, 12, 3),
        (2478, 9654, 100, 2, 2);