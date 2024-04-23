-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
DROP DATABASE IF EXISTS cool_db;
create database cool_db;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on cool_db.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use cool_db;

-- Put your DDL 
CREATE TABLE IF NOT EXISTS Restaurants (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255),
    Phone VARCHAR(20),
    Email VARCHAR(100)
);

-- Creating the Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100)
);

-- Creating the RestaurantTables Table
CREATE TABLE IF NOT EXISTS RestaurantTables (
    TableID INT AUTO_INCREMENT PRIMARY KEY,
    Seats INT,
    Location VARCHAR(100), -- For example, 'window', 'patio', etc.
    RestaurantID INT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- Creating the Reservations Table
CREATE TABLE IF NOT EXISTS Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    TableID INT,
    RestaurantID INT,
    ReservationTime DATETIME,
    Guests INT,
    SpecialRequests TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TableID) REFERENCES RestaurantTables(TableID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE IF NOT EXISTS Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    ReservationID INT,
    Amount DECIMAL(10,2),
    PaymentStatus ENUM('Pending', 'Completed', 'Cancelled'),
    PaymentMethod ENUM('Cash', 'Credit Card', 'Debit Card', 'Online'),
    PaymentTime DATETIME,
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

CREATE TABLE IF NOT EXISTS Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    Position VARCHAR(100), -- Job position such as 'Server', 'Manager', etc.
    RestaurantID INT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- Creating a linking table for Servers assigned to Restaurant Tables
CREATE TABLE IF NOT EXISTS TableServers (
    TableID INT,
    EmployeeID INT,
    AssignmentStart DATETIME,
    AssignmentEnd DATETIME,
    PRIMARY KEY (TableID, EmployeeID, AssignmentStart),
    FOREIGN KEY (TableID) REFERENCES RestaurantTables(TableID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


-- Creating the MenuItems Table
CREATE TABLE IF NOT EXISTS MenuItems (
    MenuItemID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10, 2),
    ItemType ENUM('Food', 'Drink', 'Hookah'), -- This categorizes the menu items.
    Available BOOLEAN DEFAULT TRUE -- Indicates if the item is generally available.
);

-- Creating a linking table for associating menu items with restaurant tables
CREATE TABLE IF NOT EXISTS TableMenuItems (
    TableID INT,
    MenuItemID INT,
    DrinksAvailable BOOLEAN,
    HookahAvailable BOOLEAN,
    PRIMARY KEY (TableID, MenuItemID),
    FOREIGN KEY (TableID) REFERENCES RestaurantTables(TableID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItems(MenuItemID)
);

CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    ReservationID INT,
    MenuItemID INT,
    Quantity INT,
    OrderTime DATETIME,
    Status ENUM('Placed', 'Preparing', 'Served', 'Cancelled'),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItems(MenuItemID)
);

CREATE TABLE IF NOT EXISTS CustomerFeedback (
    FeedbackID INT AUTO_INCREMENT PRIMARY KEY,
    ReservationID INT,
    Rating INT,  -- Could range for example from 1 to 5
    Comments TEXT,
    FeedbackTime DATETIME,
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

CREATE TABLE IF NOT EXISTS SpecialEvents (
    EventID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT,
    EventName VARCHAR(100),
    EventDate DATETIME,
    Description TEXT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE IF NOT EXISTS EmployeeShifts (
    ShiftID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    StartDateTime DATETIME,
    EndDateTime DATETIME,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


-- Add sample data. 
INSERT INTO Restaurants (Name, Address, Phone, Email) VALUES
('Test Restaurant Name', 'Test Address', '555-555-5555', 'testemail@northeastern.edu'),
('Test Restaurant 2', 'Test Address 2', '555-555-5555', 'testemail2@northeastern.edu');

INSERT INTO Customers (FirstName, LastName, PhoneNumber, Email) VALUES
('Omer', 'Asmat', '111-111-1111', 'omerasmat@northeastern.edu'),
('Jairaj', 'LastName', '222-222-2222', 'jairaj@northeastern.edu');

INSERT INTO RestaurantTables (Seats, Location, RestaurantID) VALUES
(4, 'window', 1),
(2, 'patio', 1),
(4, 'window', 2),
(8, 'private Seating', 2);

INSERT INTO Reservations (CustomerID, TableID, ReservationTime, Guests, SpecialRequests) VALUES
(1, 1, '2024-04-20 19:00:00', 2, 'Birthday'),
(2, 3, '2024-04-20 20:00:00', 4, 'Anniversary');

INSERT INTO Payments (ReservationID, Amount, PaymentStatus, PaymentMethod, PaymentTime) VALUES
(1, 85.00, 'Completed', 'Credit Card', '2024-04-20 21:00:00'),
(2, 120.00, 'Completed', 'Cash', '2024-04-20 22:00:00');

INSERT INTO Employees (FirstName, LastName, PhoneNumber, Email, Position, RestaurantID) VALUES
('Bob', 'The Builder', '555-555-5555', 'bobthebuilder@northeastern.edu', 'Server', 1),
('Mickey', 'Mouse', '222-222-2222', 'mickeymouse@northeastern.edu', 'Chef', 2);

INSERT INTO TableServers (TableID, EmployeeID, AssignmentStart, AssignmentEnd) VALUES
(1, 1, '2024-04-20 18:00:00', '2024-04-20 22:00:00'),
(3, 2, '2024-04-20 18:00:00', '2024-04-20 22:00:00');

INSERT INTO MenuItems (Name, Description, Price, ItemType, Available) VALUES
('Salmon', 'salmon with a lemon and rice', 18.99, 'Food', TRUE),
('Fries', 'potato fries', 7.50, 'Food', TRUE);

INSERT INTO TableMenuItems (TableID, MenuItemID, DrinksAvailable, HookahAvailable) VALUES
(1, 1, TRUE, FALSE),
(1, 2, TRUE, FALSE);

INSERT INTO Orders (ReservationID, MenuItemID, Quantity, OrderTime, Status) VALUES
(1, 1, 2, '2024-04-20 19:15:00', 'Served'),
(1, 2, 1, '2024-04-20 19:30:00', 'Served');

INSERT INTO CustomerFeedback (ReservationID, Rating, Comments, FeedbackTime) VALUES
(1, 5, 'Everything was very good', '2024-04-20 21:30:00');

INSERT INTO SpecialEvents (RestaurantID, EventName, EventDate, Description) VALUES
(1, 'Happy Hour', '2024-05-15 19:00:00', '50% discount on all food and drinks');

INSERT INTO EmployeeShifts (EmployeeID, StartDateTime, EndDateTime) VALUES
(1, '2024-04-20 17:00:00', '2024-04-20 23:00:00'),
(2, '2024-04-20 17:00:00', '2024-04-20 23:00:00');