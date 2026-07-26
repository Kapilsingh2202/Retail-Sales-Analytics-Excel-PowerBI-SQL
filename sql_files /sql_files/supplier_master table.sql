CREATE TABLE Supplier_Master (
    Supplier_ID VARCHAR(10) PRIMARY KEY,
    Supplier_Name VARCHAR(100),
    GST_Number VARCHAR(20),
    Contact_Person VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Supplier_Rating DECIMAL(3,1)
);