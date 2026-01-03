-- =========================
-- | Create the Database   |
-- =========================
CREATE DATABASE Vehicle_Rental;

-- =========================
-- | Define ENUM Types     |
-- =========================
CREATE TYPE user_role AS enum('admin','customer');

CREATE TYPE vehicle_type AS enum('car','bike' 'truck');

CREATE TYPE vehicle_status AS enum('available','rented','maintenance');

CREATE TYPE booking_status AS enum('pending','confirmed', 'complete', 'cancelled');

-- =========================
-- | Create Tables         |
-- =========================

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name varchar(150),
  email varchar(200) UNIQUE NOT NULL,
  password varchar(255) NOT NULL,
  phone varchar(15),
  role user_role DEFAULT ('customer')
);

-- Index on users email column
CREATE INDEX idx_users_email ON users (email);

-- Vehicles table
CREATE TABLE IF NOT EXISTS vehicles (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name varchar DEFAULT ('unnamed vehicle'),
  type vehicle_type,
  registration_number varchar UNIQUE NOT NULL,
  rent_price decimal(6, 2) NOT NULL,
  availability_status vehicle_status DEFAULT ('available')
);

-- Index on vehicle registration number
CREATE INDEX idx_vehicles_registration ON vehicles (registration_number);

-- Bookings table
CREATE TABLE IF NOT EXISTS bookings (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid REFERENCES users (id),
  vehicle_id uuid REFERENCES vehicles (id),
  start_date timestamptz NOT NULL,
  end_date timestamptz NOT NULL,
  status booking_status DEFAULT ('pending'),
  total_cost decimal(10, 2) NOT NULL
);

-- Index on user_id and vehicle_id
CREATE INDEX idx_bookings_ref ON bookings (user_id, vehicle_id);

-- ==========================================================
-- | JOIN Query                                              |
-- | Retrieve booking information with customer and vehicle |
-- ==========================================================
SELECT
  b.id AS "Booking ID",
  b.start_date AS "Start Date",
  b.end_date AS "End Date",
  b.status AS "Booking Status",
  b.total_cost AS "Total Cost",
  u.name AS "Customer Name",
  v.name AS "Vehicle Name"
FROM
  bookings AS b
  JOIN users AS u ON b.user_id = u.id
  JOIN vehicles AS v ON b.vehicle_id = v.id;

-- ======================================================
-- | EXISTS Query                                       |
-- | Find all vehicles that have never been booked     |
-- ======================================================
SELECT
  *
FROM
  vehicles
WHERE
  NOT EXISTS (
    SELECT
      vehicle_id
    FROM
      bookings
    WHERE
      vehicle_id = vehicles.id
  );

-- ======================================================
-- | WHERE Query                                        |
-- | Retrieve all available vehicles of a specific type|
-- ======================================================
SELECT
  *
FROM
  vehicles
WHERE
  type = 'bike'
  AND availability_status = 'available';

-- ==============================================================
-- | GROUP BY & HAVING Query                                   |
-- | Find vehicles with more than 2 total bookings             |
-- ==============================================================
SELECT
  v.name AS "Vehicle Name",
  count(b.vehicle_id) AS "Total Bookings"
FROM
  vehicles AS v
  JOIN bookings AS b ON b.vehicle_id = v.id
GROUP BY
  v.name
HAVING
  count(b.vehicle_id) > 2;

-- =========================
-- | Drop Database/Tables |
-- =========================
DROP DATABASE vehicle_rental_db;

DROP TABLE IF EXISTS users;
DROP INDEX idx_users_email;

DROP TABLE IF EXISTS vehicles;
DROP INDEX idx_vehicles_registration;

DROP TABLE IF EXISTS bookings;
DROP INDEX idx_bookings_ref;

-- =========================
-- | Insert Values: Users |
-- =========================
INSERT INTO
  users (name, email, password, phone, role)
VALUES
('Ayaan Rahman', 'ayaan.rahman01@mail.com', 'hash_01', '01700000001', 'customer'),
('Nabila Islam', 'nabila.islam02@mail.com', 'hash_02', '01700000002', 'admin'),
('Tanvir Ahmed', 'tanvir.ahmed03@mail.com', 'hash_03', '01700000003', 'customer'),
('Sadia Khan', 'sadia.khan04@mail.com', 'hash_04', '01700000004', 'customer'),
('Rakib Hasan', 'rakib.hasan05@mail.com', 'hash_05', '01700000005', 'customer'),
('Mim Akter', 'mim.akter06@mail.com', 'hash_06', '01700000006', 'customer'),
('Farhan Chowdhury', 'farhan.chowdhury07@mail.com', 'hash_07', '01700000007', 'customer'),
('Tasnim Jahan', 'tasnim.jahan08@mail.com', 'hash_08', '01700000008', 'customer'),
('Shafiul Alam', 'shafiul.alam09@mail.com', 'hash_09', '01700000009', 'customer'),
('Ritu Sultana', 'ritu.sultana10@mail.com', 'hash_10', '01700000010', 'customer'),
('Imran Hossain', 'imran.hossain11@mail.com', 'hash_11', '01700000011', 'customer'),
('Nusrat Tabassum', 'nusrat.tabassum12@mail.com', 'hash_12', '01700000012', 'customer'),
('Sabbir Rahman', 'sabbir.rahman13@mail.com', 'hash_13', '01700000013', 'customer'),
('Anika Ferdous', 'anika.ferdous14@mail.com', 'hash_14', '01700000014', 'customer'),
('Mahmudul Hasan', 'mahmudul.hasan15@mail.com', 'hash_15', '01700000015', 'admin'),
('Sharmin Akter', 'sharmin.akter16@mail.com', 'hash_16', '01700000016', 'customer'),
('Towhidul Islam', 'towhidul.islam17@mail.com', 'hash_17', '01700000017', 'customer'),
('Afsana Rahman', 'afsana.rahman18@mail.com', 'hash_18', '01700000018', 'customer'),
('Saif Uddin', 'saif.uddin19@mail.com', 'hash_19', '01700000019', 'customer'),
('Mehjabin Noor', 'mehjabin.noor20@mail.com', 'hash_20', '01700000020', 'customer');

-- ============================
-- | Insert Values: Vehicles |
-- ============================
INSERT INTO
  vehicles (
    name,
    type,
    registration_number,
    rent_price,
    availability_status
  )
VALUES
('Toyota Corolla','car','CAR-1001',45.00,'available'),
('Honda Civic','car','CAR-1002',50.00,'available'),
('Ford F-150','truck','TRK-2001',85.50,'available'),
('Yamaha R1','bike','BIK-3001',30.00,'available'),
('Tesla Model 3','car','CAR-1003',95.00,'available'),
('Chevrolet Silverado','truck','TRK-2002',80.00,'maintenance'),
('Kawasaki Ninja','bike','BIK-3002',25.00,'available'),
('BMW 3 Series','car','CAR-1004',75.00,'rented'),
('Mercedes Sprinter','truck','TRK-2003',90.00,'available'),
('Harley Davidson','bike','BIK-3003',40.00,'available'),
('Hyundai Elantra','car','CAR-1005',40.00,'available'),
('Ram 1500','truck','TRK-2004',82.00,'available'),
('Suzuki Hayabusa','bike','BIK-3004',35.00,'rented'),
('Volkswagen Golf','car','CAR-1006',48.00,'available'),
('Volvo FH16','truck','TRK-2005',150.00,'available'),
('Ducati Panigale','bike','BIK-3005',55.00,'maintenance'),
('Audi A4','car','CAR-1007',70.00,'available'),
('Nissan Titan','truck','TRK-2006',78.00,'available'),
('Honda Rebel','bike','BIK-3006',20.00,'available'),
('Jeep Wrangler','car','CAR-1008',65.00,'available');

-- ============================
-- | Insert Values: Bookings |
-- ============================
INSERT INTO bookings (
  user_id,
  vehicle_id,
  start_date,
  end_date,
  status,
  total_cost
)
SELECT
  u.id,
  v.id,
  '2025-12-10 10:00:00'::timestamp + (random() * interval '30 days'),
  '2026-01-10 10:00:00'::timestamp + (random() * interval '30 days'),
  'confirmed',
  (random() * 500 + 50)::decimal(6, 2)
FROM
  users u
  CROSS JOIN vehicles v
ORDER BY
  random()
LIMIT
  18;