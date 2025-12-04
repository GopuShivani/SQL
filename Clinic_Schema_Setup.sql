--CREATION OF TABLES--

-- Clinics Table
CREATE TABLE clinics (
    cid VARCHAR PRIMARY KEY,
    clinic_name TEXT,
    city TEXT,
    state TEXT,
    country TEXT
);

-- Customers Table
CREATE TABLE customer (
    uid VARCHAR PRIMARY KEY,
    name TEXT,
    mobile VARCHAR
);

-- Clinic Sales Table  
CREATE TABLE clinic_sales (
    oid VARCHAR PRIMARY KEY,
    uid VARCHAR,
    cid VARCHAR,
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel TEXT,
    FOREIGN KEY (uid) REFERENCES customer(uid) ON DELETE CASCADE,
    FOREIGN KEY (cid) REFERENCES clinics(cid) ON DELETE CASCADE
);

-- Expenses Table
CREATE TABLE expenses (
    eid VARCHAR PRIMARY KEY,
    cid VARCHAR,
    description TEXT,
    amount DECIMAL(10,2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid) ON DELETE CASCADE 
);


--INSERTION OF DATA--

INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-0100001', 'XYZ Clinic', 'Lorem', 'Ipsum', 'Dolor'),
('cnc-0100002', 'ABC Clinic', 'Lorem', 'Ipsum', 'Dolor'),
('cnc-0100003', 'DEF Clinic', 'Amet', 'Consect', 'Dolor'),
('cnc-0100004', 'GHI Clinic', 'Amet', 'Consect', 'Dolor'),
('cnc-0100005', 'JKL Clinic', 'Sit', 'Amet', 'Dolor');


INSERT INTO customer (uid, name, mobile) VALUES
('bk-09f3e-95hj', 'Jon Doe', '9700000001'),
('bk-09f3e-95hk', 'Jane Smith', '9700000002'),
('bk-09f3e-95hl', 'Alice Brown', '9700000003'),
('bk-09f3e-95hm', 'Bob Johnson', '9700000004'),
('bk-09f3e-95hn', 'Carol White', '9700000005');

INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
('ord-00100-00100', 'bk-09f3e-95hj', 'cnc-0100001', 24999, '2021-09-23 12:03:22', 'online'),
('ord-00100-00101', 'bk-09f3e-95hk', 'cnc-0100001', 15000, '2021-09-23 13:00:00', 'walk-in'),
('ord-00100-00102', 'bk-09f3e-95hl', 'cnc-0100002', 35000, '2021-09-24 10:00:00', 'online'),
('ord-00100-00103', 'bk-09f3e-95hm', 'cnc-0100003', 28000, '2021-08-15 09:30:00', 'sodat'),
('ord-00100-00104', 'bk-09f3e-95hn', 'cnc-0100004', 40000, '2021-07-20 14:15:00', 'walk-in'),
('ord-00100-00105', 'bk-09f3e-95hj', 'cnc-0100002', 22000, '2021-06-10 11:00:00', 'online'),
('ord-00100-00106', 'bk-09f3e-95hk', 'cnc-0100005', 18000, '2021-12-05 16:00:00', 'sodat'),
('ord-00100-00107', 'bk-09f3e-95hl', 'cnc-0100003', 25000, '2021-05-18 10:45:00', 'online');

INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
('exp-0100-00100', 'cnc-0100001', 'First-aid supplies', 557, '2021-09-23 07:36:48'),
('exp-0100-00101', 'cnc-0100001', 'Staff salary', 5000, '2021-09-01 09:00:00'),
('exp-0100-00102', 'cnc-0100002', 'Medicines', 2000, '2021-09-24 08:00:00'),
('exp-0100-00103', 'cnc-0100003', 'Equipment maintenance', 3500, '2021-08-10 12:00:00'),
('exp-0100-00104', 'cnc-0100004', 'Electricity', 1200, '2021-07-15 10:00:00'),
('exp-0100-00105', 'cnc-0100005', 'Cleaning', 800, '2021-12-01 09:00:00');
