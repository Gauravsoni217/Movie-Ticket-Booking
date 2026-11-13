-- ============================================================
-- DBMS MINI PROJECT: MOVIE TICKET BOOKING SYSTEM
-- Database: MySQL 8.0+
-- Student: [Your Name] | UID: [Your UID] | Class: BCA Data Science
-- ============================================================

DROP DATABASE IF EXISTS movie_ticket_booking;
CREATE DATABASE movie_ticket_booking;
USE movie_ticket_booking;

-- 1. Movies available for screening
CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    language VARCHAR(30) NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    certificate VARCHAR(10) DEFAULT 'UA'
);

-- 2. Cinemas / theatres
CREATE TABLE Theatres (
    theatre_id INT AUTO_INCREMENT PRIMARY KEY,
    theatre_name VARCHAR(100) NOT NULL,
    city VARCHAR(60) NOT NULL
);

-- 3. Individual screens inside theatres
CREATE TABLE Screens (
    screen_id INT AUTO_INCREMENT PRIMARY KEY,
    theatre_id INT NOT NULL,
    screen_name VARCHAR(30) NOT NULL,
    total_seats INT NOT NULL CHECK (total_seats > 0),
    FOREIGN KEY (theatre_id) REFERENCES Theatres(theatre_id),
    UNIQUE (theatre_id, screen_name)
);

-- 4. Show schedules
CREATE TABLE Shows (
    show_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    screen_id INT NOT NULL,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    ticket_price DECIMAL(8,2) NOT NULL CHECK (ticket_price >= 0),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (screen_id) REFERENCES Screens(screen_id),
    UNIQUE (screen_id, show_date, show_time)
);

-- 5. Customers
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20)
);

-- 6. Bookings: one booking belongs to one customer and one show
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    show_id INT NOT NULL,
    booking_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    seats_booked INT NOT NULL CHECK (seats_booked > 0),
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    booking_status ENUM('CONFIRMED','CANCELLED') NOT NULL DEFAULT 'CONFIRMED',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id)
);

-- 7. Seats booked within each booking; a seat can be booked only once per show
CREATE TABLE Booking_Seats (
    booking_seat_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    show_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id),
    UNIQUE (show_id, seat_number)
);

-- -------------------- SAMPLE DATA --------------------
INSERT INTO Movies (title, genre, language, duration_minutes, certificate) VALUES
('Interstellar', 'Sci-Fi', 'English', 169, 'UA'),
('3 Idiots', 'Comedy/Drama', 'Hindi', 170, 'U'),
('Dangal', 'Sports/Drama', 'Hindi', 161, 'U'),
('Spider-Man: No Way Home', 'Action', 'English', 148, 'UA');

INSERT INTO Theatres (theatre_name, city) VALUES
('CineWorld Central', 'Chandigarh'),
('Galaxy Multiplex', 'Mohali');

INSERT INTO Screens (theatre_id, screen_name, total_seats) VALUES
(1, 'Screen 1', 100),
(1, 'Screen 2', 80),
(2, 'Screen 1', 120);

INSERT INTO Shows (movie_id, screen_id, show_date, show_time, ticket_price) VALUES
(1, 1, '2026-11-01', '18:30:00', 250.00),
(2, 2, '2026-11-01', '15:00:00', 180.00),
(3, 3, '2026-11-02', '19:00:00', 220.00),
(4, 1, '2026-11-02', '21:00:00', 280.00);

INSERT INTO Customers (full_name, email, phone) VALUES
('Aarav Sharma', 'aarav@example.com', '9876501001'),
('Meera Singh', 'meera@example.com', '9876501002'),
('Kabir Verma', 'kabir@example.com', '9876501003');

INSERT INTO Bookings (customer_id, show_id, booking_date, seats_booked, total_amount, booking_status) VALUES
(1, 1, '2026-10-20 12:15:00', 2, 500.00, 'CONFIRMED'),
(2, 2, '2026-10-20 13:20:00', 3, 540.00, 'CONFIRMED'),
(3, 3, '2026-10-20 16:05:00', 1, 220.00, 'CONFIRMED'),
(1, 4, '2026-10-21 10:00:00', 2, 560.00, 'CANCELLED');

INSERT INTO Booking_Seats (booking_id, show_id, seat_number) VALUES
(1, 1, 'A1'), (1, 1, 'A2'),
(2, 2, 'B1'), (2, 2, 'B2'), (2, 2, 'B3'),
(3, 3, 'C4');

-- -------------------- BASIC SELECT QUERIES --------------------

-- Q1. Display all movies
SELECT movie_id, title, genre, language, duration_minutes, certificate
FROM Movies
ORDER BY movie_id;

-- Q2. Show schedules with movie, theatre, screen, date and price
SELECT sh.show_id, m.title, t.theatre_name, sc.screen_name,
       sh.show_date, sh.show_time, sh.ticket_price
FROM Shows sh
JOIN Movies m ON sh.movie_id = m.movie_id
JOIN Screens sc ON sh.screen_id = sc.screen_id
JOIN Theatres t ON sc.theatre_id = t.theatre_id
ORDER BY sh.show_date, sh.show_time;

-- Q3. List confirmed bookings with customer and movie details
SELECT b.booking_id, c.full_name, m.title, sh.show_date,
       sh.show_time, b.seats_booked, b.total_amount, b.booking_status
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Shows sh ON b.show_id = sh.show_id
JOIN Movies m ON sh.movie_id = m.movie_id
WHERE b.booking_status = 'CONFIRMED'
ORDER BY b.booking_id;

-- Q4. Total confirmed revenue per movie
SELECT m.title, SUM(b.total_amount) AS confirmed_revenue
FROM Bookings b
JOIN Shows sh ON b.show_id = sh.show_id
JOIN Movies m ON sh.movie_id = m.movie_id
WHERE b.booking_status = 'CONFIRMED'
GROUP BY m.movie_id, m.title
ORDER BY confirmed_revenue DESC;

-- Q5. Number of bookings per customer
SELECT c.full_name, COUNT(b.booking_id) AS total_bookings
FROM Customers c
LEFT JOIN Bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_bookings DESC, c.full_name;

-- Q6. Search movies by genre (edit the value as required)
SELECT title, genre, language
FROM Movies
WHERE genre LIKE '%Drama%';

-- Q7. Find seats already booked for a particular show (example show_id = 1)
SELECT seat_number
FROM Booking_Seats
WHERE show_id = 1
ORDER BY seat_number;

-- Q8. Count confirmed seats booked for each show
SELECT sh.show_id, m.title, sh.show_date, sh.show_time,
       COALESCE(SUM(CASE WHEN b.booking_status = 'CONFIRMED' THEN b.seats_booked ELSE 0 END), 0)
       AS confirmed_seats
FROM Shows sh
JOIN Movies m ON sh.movie_id = m.movie_id
LEFT JOIN Bookings b ON sh.show_id = b.show_id
GROUP BY sh.show_id, m.title, sh.show_date, sh.show_time
ORDER BY sh.show_id;

-- Q9. Demonstrate UPDATE (change a customer's phone number)
UPDATE Customers
SET phone = '9876509999'
WHERE customer_id = 1;
SELECT customer_id, full_name, phone FROM Customers WHERE customer_id = 1;

-- Q10. Demonstrate transaction and rollback safely (no permanent data change)
START TRANSACTION;
UPDATE Movies SET certificate = 'UA' WHERE movie_id = 2;
SELECT movie_id, title, certificate FROM Movies WHERE movie_id = 2;
ROLLBACK;
SELECT movie_id, title, certificate FROM Movies WHERE movie_id = 2;

-- Q11. Example view for a reusable booking report
CREATE OR REPLACE VIEW Confirmed_Booking_Report AS
SELECT b.booking_id, c.full_name, m.title AS movie_title,
       sh.show_date, sh.show_time, b.seats_booked, b.total_amount
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Shows sh ON b.show_id = sh.show_id
JOIN Movies m ON sh.movie_id = m.movie_id
WHERE b.booking_status = 'CONFIRMED';

SELECT * FROM Confirmed_Booking_Report ORDER BY booking_id;

-- Q12. Database summary
SELECT
    (SELECT COUNT(*) FROM Movies) AS movie_count,
    (SELECT COUNT(*) FROM Theatres) AS theatre_count,
    (SELECT COUNT(*) FROM Shows) AS show_count,
    (SELECT COUNT(*) FROM Customers) AS customer_count,
    (SELECT COUNT(*) FROM Bookings WHERE booking_status = 'CONFIRMED') AS confirmed_bookings;
