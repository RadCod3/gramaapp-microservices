CREATE DATABASE  IF NOT EXISTS `idcheckdb`;
use `idcheckdb`;

-- Drop the tables if they already exist

DROP TABLE IF EXISTS `Citizen`;
DROP TABLE IF EXISTS `status`;
DROP TABLE IF EXISTS `Gender`;

CREATE TABLE status (
    statusID INT AUTO_INCREMENT PRIMARY KEY,
    statusName VARCHAR(255) NOT NULL
);


-- Insert 'Active' status
INSERT INTO status (statusName) VALUES ('Active');
-- Insert 'Suspended' status
INSERT INTO status (statusName) VALUES ('Suspended');

CREATE TABLE Gender (
    GenderID INT AUTO_INCREMENT PRIMARY KEY,
    Gender VARCHAR(20) NOT NULL
);


-- Insert 'Male' gender
INSERT INTO Gender (Gender) VALUES ('Male');
-- Insert 'Female' gender
INSERT INTO Gender (Gender) VALUES ('Female');

CREATE TABLE Citizen (
    Userid VARCHAR(50) PRIMARY KEY,
    NIC VARCHAR(20) NOT NULL,
    Name VARCHAR(255) NOT NULL,
    gramaID VARCHAR(50) NOT NuLL,
    genderID INT,
    accountStatusID INT,
    FOREIGN KEY (genderID) REFERENCES Gender(GenderID),
    FOREIGN KEY (accountStatusID) REFERENCES status(statusID)
);

-- Insert user with ID format (0-9)*(X|V)
INSERT INTO Citizen (Userid,NIC ,Name, gramaID, genderID, accountStatusID) VALUES ('M_01','987654321V', 'Tharushi','MG_01', 2, 1);
-- Insert user with ID format (0-9)*(X|V)
INSERT INTO Citizen (Userid,NIC, Name, gramaID, genderID, accountStatusID) VALUES ('M_02','996789012X', 'Kamal', 'MG_01', 1, 2);

