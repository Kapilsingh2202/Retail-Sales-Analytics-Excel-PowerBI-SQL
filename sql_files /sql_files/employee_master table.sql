CREATE TABLE Employee_Master (
    Employee_ID VARCHAR(10) PRIMARY KEY,
    Employee_Name VARCHAR(100),
    Gender VARCHAR(10),
    Department VARCHAR(50),
    Designation VARCHAR(50),
    Salary DECIMAL(10,2),
    Store_ID VARCHAR(10),
    Joining_Date DATE,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    FOREIGN KEY (Store_ID) REFERENCES Store_Master(Store_ID)
);