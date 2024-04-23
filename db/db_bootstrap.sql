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


-- Adding more Restaurants
INSERT INTO Restaurants (Name, Address, Phone, Email) VALUES
('Test Restaurant Name', 'Test Address', '555-555-5555', 'testemail@northeastern.edu'),
('Test Restaurant 2', 'Test Address 2', '555-555-5555', 'testemail2@northeastern.edu'),
('Gourmet Delight', '123 Food Street, Foodtown', '123-456-7890', 'contact@gourmetdelight.com'),
('Seafood Heaven', '456 Ocean Avenue, Seaville', '234-567-8901', 'info@seafoodheaven.com'),
('Spice Kingdom', '789 Curry Road, Spicetown', '345-678-9012', 'support@spicekingdom.com'),
('Pasta Palace', '12 Italy Ave, Pastaville', '567-890-1234', 'contact@pastapalace.com'),
('Burger Town', '34 Grill Rd, Meatland', '678-901-2345', 'info@burgertown.com'),
('Vegetable Garden', '56 Green Street, Plantcity', '789-012-3456', 'support@vegetablegarden.com'),
('Sushi House', '78 Fish Lane, Sushitown', '890-123-4567', 'contact@sushihouse.com'),
('Steakhouse Supreme', '90 Meat Ave, Steaktown', '901-234-5678', 'info@steakhousesupreme.com');

-- Adding more Customers
INSERT INTO Customers (FirstName, LastName, PhoneNumber, Email) VALUES
('Omer', 'Asmat', '111-111-1111', 'omerasmat@northeastern.edu'),
('Jairaj', 'LastName', '222-222-2222', 'jairaj@northeastern.edu'),
('Jane', 'Doe', '333-444-5555', 'jane.doe@example.com'),
('John', 'Smith', '444-555-6666', 'john.smith@example.com'),
('Alice', 'Johnson', '555-666-7777', 'alice.johnson@example.com'),
('Bob', 'Brown', '666-777-8888', 'bob.brown@example.com'),
('Mary', 'Davis', '777-888-9999', 'mary.davis@example.com'),
('Michael', 'Jones', '888-999-0000', 'michael.jones@example.com'),
('Chris', 'Williams', '999-000-1111', 'chris.williams@example.com'),
('Jessica', 'Garcia', '000-111-2222', 'jessica.garcia@example.com');

-- Adding more RestaurantTables
INSERT INTO RestaurantTables (Seats, Location, RestaurantID) VALUES
(4, 'window', 1),
(2, 'patio', 1),
(4, 'window', 2),
(8, 'private Seating', 2),
(6, 'outdoor', 3),
(8, 'private', 1),
(10, 'rooftop', 2),
(4, 'indoor', 3),
(6, 'terrace', 3),
(10, 'outdoor', 4);

-- Adding more Reservations
INSERT INTO Reservations (CustomerID, TableID, ReservationTime, Guests, SpecialRequests) VALUES
(1, 1, '2024-04-20 19:00:00', 2, 'Birthday'),
(2, 3, '2024-04-20 20:00:00', 4, 'Anniversary'),
(3, 5, '2024-04-21 12:00:00', 6, 'Vegetarian meals'),
(4, 6, '2024-04-21 19:00:00', 8, 'No seafood'),
(5, 7, '2024-04-22 18:00:00', 10, 'Anniversary celebration'),
(6, 8, '2024-04-22 20:00:00', 4, 'Window seat preferred'),
(7, 4, '2024-04-23 13:00:00', 6, 'Business lunch'),
(8, 5, '2024-04-23 14:00:00', 8, 'Family gathering'),
(9, 6, '2024-04-24 18:00:00', 10, 'Dinner with friends'),
(10, 7, '2024-04-24 19:00:00', 4, 'Casual dinner with colleagues');

-- Adding more Payments
INSERT INTO Payments (ReservationID, Amount, PaymentStatus, PaymentMethod, PaymentTime) VALUES
(1, 85.00, 'Completed', 'Credit Card', '2024-04-20 21:00:00'),
(2, 120.00, 'Completed', 'Cash', '2024-04-20 22:00:00'),
(3, 150.00, 'Completed', 'Credit Card', '2024-04-21 12:30:00'),
(4, 200.00, 'Pending', 'Credit Card', '2024-04-21 20:30:00'),
(5, 250.00, 'Completed', 'Credit Card', '2024-04-22 18:45:00'),
(6, 300.00, 'Completed', 'Cash', '2024-04-22 21:00:00'),
(7, 350.00, 'Completed', 'Debit Card', '2024-04-23 15:00:00'),
(8, 400.00, 'Pending', 'Credit Card', '2024-04-23 20:30:00'),
(9, 450.00, 'Cancelled', 'Cash', '2024-04-24 17:00:00'),
(10, 500.00, 'Completed', 'Online', '2024-04-24 19:30:00');

-- Adding more Employees
INSERT INTO Employees (FirstName, LastName, PhoneNumber, Email, Position, RestaurantID) VALUES
('Bob', 'The Builder', '555-555-5555', 'bobthebuilder@northeastern.edu', 'Server', 1),
('Mickey', 'Mouse', '222-222-2222', 'mickeymouse@northeastern.edu', 'Chef', 2),
('John', 'Doe', '333-444-5555', 'john.doe@northeastern.edu', 'Manager', 3),
('Alice', 'Johnson', '444-555-6666', 'alice.johnson@northeastern.edu', 'Server', 3),
('Michael', 'Smith', '555-666-7777', 'michael.smith@northeastern.edu', 'Server', 2),
('Chris', 'Brown', '666-777-8888', 'chris.brown@northeastern.edu', 'Chef', 3),
('Jessica', 'Williams', '777-888-9999', 'jessica.williams@northeastern.edu', 'Host', 2),
('Tom', 'Jones', '888-999-0000', 'tom.jones@northeastern.edu', 'Bartender', 3),
('Mary', 'Johnson', '999-000-1111', 'mary.johnson@northeastern.edu', 'Chef', 1),
('Lucy', 'Garcia', '000-111-2222', 'lucy.garcia@northeastern.edu', 'Manager', 1);

-- Adding more TableServers
INSERT INTO TableServers (TableID, EmployeeID, AssignmentStart, AssignmentEnd) VALUES
(1, 1, '2024-04-20 18:00:00', '2024-04-20 22:00:00'),
(3, 2, '2024-04-20 18:00:00', '2024-04-20 22:00:00'),
(2, 3, '2024-04-21 19:00:00', '2024-04-21 23:00:00'),
(4, 4, '2024-04-22 18:00:00', '2024-04-22 22:00:00'),
(5, 5, '2024-04-22 20:00:00', '2024-04-22 23:30:00'),
(6, 6, '2024-04-23 19:00:00', '2024-04-23 23:00:00'),
(7, 7, '2024-04-24 18:00:00', '2024-04-24 23:00:00'),
(8, 8, '2024-04-24 20:00:00', '2024-04-24 23:30:00'),
(9, 9, '2024-04-25 18:00:00', '2024-04-25 23:30:00'),
(10, 10, '2024-04-25 20:00:00', '2024-04-25 23:30:00');

-- Adding more MenuItems
INSERT INTO MenuItems (Name, Description, Price, ItemType, Available) VALUES
('Salmon', 'salmon with a lemon and rice', 18.99, 'Food', TRUE),
('Fries', 'potato fries', 7.50, 'Food', TRUE),
('Steak', 'grilled steak with mashed potatoes', 25.99, 'Food', TRUE),
('Lobster', 'grilled lobster with butter', 35.99, 'Food', TRUE),
('Chicken Alfredo', 'pasta with chicken and Alfredo sauce', 19.99, 'Food', TRUE),
('Cheeseburger', 'burger with cheese and fries', 14.99, 'Food', TRUE),
('Margarita', 'tequila-based cocktail', 12.99, 'Drink', TRUE),
('Pina Colada', 'rum-based cocktail with coconut cream', 10.99, 'Drink', TRUE),
('Mojito', 'rum-based cocktail with lime and mint', 11.99, 'Drink', TRUE),
('Hookah', 'assorted flavors', 20.99, 'Hookah', TRUE);

-- Adding more TableMenuItems
INSERT INTO TableMenuItems (TableID, MenuItemID, DrinksAvailable, HookahAvailable) VALUES
(1, 1, TRUE, FALSE),
(1, 2, TRUE, FALSE),
(2, 3, TRUE, TRUE),
(3, 4, TRUE, TRUE),
(4, 5, TRUE, FALSE),
(5, 6, TRUE, TRUE),
(6, 7, TRUE, TRUE),
(7, 8, TRUE, TRUE),
(8, 9, TRUE, TRUE),
(9, 10, TRUE, TRUE);

-- Adding more Orders
INSERT INTO Orders (ReservationID, MenuItemID, Quantity, OrderTime, Status) VALUES
(1, 1, 2, '2024-04-20 19:15:00', 'Served'),
(1, 2, 1, '2024-04-20 19:30:00', 'Served'),
(3, 3, 1, '2024-04-21 12:30:00', 'Placed'),
(4, 4, 2, '2024-04-21 20:30:00', 'Served'),
(5, 5, 1, '2024-04-22 18:45:00', 'Preparing'),
(6, 6, 2, '2024-04-22 21:00:00', 'Served'),
(7, 7, 1, '2024-04-23 15:00:00', 'Served'),
(8, 8, 2, '2024-04-23 20:30:00', 'Preparing'),
(9, 9, 1, '2024-04-24 17:00:00', 'Placed'),
(10, 10, 2, '2024-04-24 19:30:00', 'Cancelled');

-- Adding more CustomerFeedback
INSERT INTO CustomerFeedback (ReservationID, Rating, Comments, FeedbackTime) VALUES
(1, 5, 'Everything was very good', '2024-04-20 21:30:00'),
(3, 4, 'Great service', '2024-04-21 13:00:00'),
(4, 3, 'Excellent food', '2024-04-21 21:00:00'),
(5, 2, 'Friendly staff', '2024-04-22 19:00:00'),
(6, 5, 'Could improve drinks', '2024-04-22 21:00:00'),
(7, 4, 'Amazing ambiance', '2024-04-23 15:30:00'),
(8, 3, 'Outstanding experience', '2024-04-23 21:00:00'),
(9, 5, 'Delicious dishes', '2024-04-24 17:30:00'),
(10, 4, 'Very clean', '2024-04-24 20:30:00'),
(2, 3, 'Overall a good visit', '2024-04-20 22:00:00');

-- Adding more SpecialEvents
INSERT INTO SpecialEvents (RestaurantID, EventName, EventDate, Description) VALUES
(1, 'Happy Hour', '2024-05-15 19:00:00', '50% discount on all food and drinks'),
(2, 'Karaoke Night', '2024-05-20 20:00:00', 'Fun karaoke evening with prizes'),
(3, 'Live Music Night', '2024-05-25 21:00:00', 'Live bands and solo artists'),
(4, 'Seafood Fest', '2024-06-10 19:00:00', 'Special seafood menu'),
(5, 'Wine Tasting', '2024-06-15 18:00:00', 'A variety of wines to taste'),
(6, 'Comedy Night', '2024-06-20 20:00:00', 'Stand-up comedy acts'),
(7, 'Game Night', '2024-06-25 19:00:00', 'Board games and trivia'),
(8, 'Art Exhibition', '2024-07-05 18:00:00', 'Local artists showcasing their work'),
(9, 'Craft Beer Festival', '2024-07-10 18:00:00', 'A selection of craft beers'),
(10, 'Summer BBQ', '2024-07-15 19:00:00', 'Outdoor barbecue and grilling');

-- Adding more EmployeeShifts
INSERT INTO EmployeeShifts (EmployeeID, StartDateTime, EndDateTime) VALUES
(1, '2024-04-20 17:00:00', '2024-04-20 23:00:00'),
(2, '2024-04-20 17:00:00', '2024-04-20 23:00:00'),
(3, '2024-04-21 16:00:00', '2024-04-21 22:00:00'),
(4, '2024-04-21 17:00:00', '2024-04-21 23:00:00'),
(5, '2024-04-22 18:00:00', '2024-04-22 23:00:00'),
(6, '2024-04-22 17:00:00', '2024-04-22 22:30:00'),
(7, '2024-04-23 18:00:00', '2024-04-23 22:30:00'),
(8, '2024-04-23 19:00:00', '2024-04-23 23:00:00'),
(9, '2024-04-24 20:00:00', '2024-04-24 23:30:00'),
(10, '2024-04-25 18:00:00', '2024-04-25 23:30:00');
