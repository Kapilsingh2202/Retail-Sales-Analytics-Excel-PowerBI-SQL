CREATE TABLE Product_Master (
    Product_ID VARCHAR(10) PRIMARY KEY,
    Product_Name VARCHAR(100),
    Brand VARCHAR(50),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Cost_Price DECIMAL(10,2),
    Selling_Price DECIMAL(10,2),
    Profit_Margin_Percent DECIMAL(5,2),
    Supplier_ID VARCHAR(10),
    Launch_Date DATE,
    Product_Status VARCHAR(20),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier_Master(Supplier_ID)
);
