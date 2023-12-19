CREATE DATABASE  IF NOT EXISTS `applicationStates`;
use `applicationStates`;

-- Drop the tables if they already exist
DROP TABLE IF EXISTS `request`;
DROP TABLE IF EXISTS `requestType`;
DROP TABLE IF EXISTS `checkstatus`;
DROP TABLE IF EXISTS `status`;
-- creating status table
CREATE TABLE status (
    statusID INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(255) NOT NULL
);

-- inserting values
INSERT INTO status (description) VALUES ('pending');
INSERT INTO status (description) VALUES ('processing');
INSERT INTO status (description) VALUES ('rejected');
INSERT INTO status (description) VALUES ('approved');

-- Create the checkstatus table
CREATE TABLE checkstatus (
    checkstatusID INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(255) NOT NULL
);

-- Insert values into the checkstatus table
INSERT INTO checkstatus (description) VALUES ('failed');
INSERT INTO checkstatus (description) VALUES ('pending');
INSERT INTO checkstatus (description) VALUES ('passed');

-- Create the requestType table
CREATE TABLE requestType (
    requestTypeID INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(255) NOT NULL
);

-- Insert a value into the requestType table
INSERT INTO requestType (description) VALUES ('Grama Certificate');

CREATE TABLE request (
    requestID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT,
    reason VARCHAR(255),
    requestTypeID INT,
    policeCheckstatus INT,
    identityCheckstatus INT,
    addressCheckstatus INT,
    statusID INT,
    FOREIGN KEY (requestTypeID) REFERENCES requestType(requestTypeID),
    FOREIGN KEY (policeCheckstatus) REFERENCES checkstatus(checkstatusID),
    FOREIGN KEY (identityCheckstatus) REFERENCES checkstatus(checkstatusID),
    FOREIGN KEY (addressCheckstatus) REFERENCES checkstatus(checkstatusID),
    FOREIGN KEY (statusID) REFERENCES status(statusID)
);

-- Add the gramaID column to the request table
ALTER TABLE request
ADD COLUMN gramaID INT;

-- Add the character column to the request table
ALTER TABLE request
ADD COLUMN `character` VARCHAR(255);