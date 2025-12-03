--CREATING THE TABLES--
-- USERS TABLE
CREATE TABLE users (
    user_id VARCHAR PRIMARY KEY,
    name TEXT,
    phone_number VARCHAR,
    mail_id TEXT,
    billing_address TEXT
);

-- BOOKINGS TABLE
CREATE TABLE bookings (
    booking_id VARCHAR PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR,
    user_id VARCHAR,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ITEMS TABLE
CREATE TABLE items (
    item_id VARCHAR PRIMARY KEY,
    item_name TEXT,
    item_rate DECIMAL(10,2)
);

-- BOOKING COMMERCIALS TABLE
CREATE TABLE booking_commercials (
    id VARCHAR PRIMARY KEY,
    booking_id VARCHAR,
    bill_id VARCHAR,
    bill_date DATETIME,
    item_id VARCHAR,
    item_quantity DECIMAL(10,2),

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE
);


--INSERTION OF DATA INTO TABLES--
-- USERS table
INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
('U001', 'Alice Johnson', '9876543210', 'alice@example.com', '123 Main St'),
('U002', 'Bob Smith', '9123456780', 'bob@example.com', '456 Park Ave'),
('U003', 'Charlie Brown', '9988776655', 'charlie@example.com', '789 Oak Rd');

-- BOOKINGS table
INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
('B001', '2021-11-05 14:00:00', '101', 'U001'),
('B002', '2021-11-10 16:00:00', '102', 'U002'),
('B003', '2021-10-20 12:30:00', '103', 'U003'),
('B004', '2021-11-15 10:00:00', '104', 'U001'),
('B005', '2021-10-25 18:00:00', '105', 'U002'),
('B006', '2021-10-10 18:00:00', '106', 'U001'),
('B007', '2021-10-15 20:00:00', '107', 'U002');

-- ITEMS table
INSERT INTO items (item_id, item_name, item_rate) VALUES
('I001', 'Breakfast', 5.50),
('I002', 'Lunch', 10.00),
('I003', 'Dinner', 15.00),
('I004', 'Spa', 50.00),
('I005', 'Luxury Dinner', 500.00),
('I006', 'Premium Spa', 1200.00);

-- BOOKING_COMMERCIALS table
INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES
('BC001', 'B001', 'BL001', '2021-11-05', 'I001', 2),
('BC002', 'B001', 'BL001', '2021-11-05', 'I002', 1),
('BC003', 'B002', 'BL002', '2021-11-10', 'I003', 2),
('BC004', 'B003', 'BL003', '2021-10-20', 'I004', 1),
('BC005', 'B004', 'BL004', '2021-11-15', 'I001', 3),
('BC006', 'B004', 'BL004', '2021-11-15', 'I003', 1),
('BC007', 'B005', 'BL005', '2021-10-25', 'I002', 5),
('BC008', 'B006', 'BL006', '2021-10-10', 'I005', 3), 
('BC009', 'B007', 'BL007', '2021-10-15', 'I006', 1);


