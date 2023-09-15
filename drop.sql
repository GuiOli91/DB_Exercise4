
DROP TRIGGER trigger_recruit ON recruits;
DROP FUNCTION trigger_addrecruit();


DROP VIEW IF EXISTS AnnualSalesVolume;
DROP VIEW IF EXISTS AllRecruits;
DROP VIEW IF EXISTS AllRecruitionSteps;

DROP TABLE IF EXISTS trains;
DROP TABLE IF EXISTS recruits;
DROP TABLE IF EXISTS produce;
DROP TABLE IF EXISTS includes;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Production;
DROP TABLE IF EXISTS Warehouses;
DROP TABLE IF EXISTS Invoice;
DROP TABLE IF EXISTS Employee;

ALTER TABLE cashregister DROP CONSTRAINT cashregister_storeid_fkey;
ALTER TABLE store DROP CONSTRAINT fk_main_register;

DROP TABLE IF EXISTS Store;
DROP TABLE IF EXISTS CashRegister;
DROP TYPE IF EXISTS ModelEnum;


DROP SEQUENCE seq_store;
DROP SEQUENCE seq_register;