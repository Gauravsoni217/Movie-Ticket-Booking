# Movie Ticket Booking System — DBMS Mini Project

A BCA-level DBMS mini-project built with MySQL. It models movies, theatres, screens, show schedules, customers, bookings, and seat assignments.

## Features
- Relational schema with primary keys and foreign keys
- Constraints: `NOT NULL`, `UNIQUE`, `CHECK`, and `ENUM`
- Sample data for demonstration
- SQL queries using `JOIN`, `GROUP BY`, aggregate functions, `LIKE`, subqueries, and `LEFT JOIN`
- `UPDATE`, transaction with `ROLLBACK`, and a reusable SQL view
- Seat uniqueness per show using `UNIQUE (show_id, seat_number)`

## Requirements
- MySQL 8.0 or later
- MySQL Workbench or MySQL command-line client

## Run the project
1. Install and start MySQL Server.
2. Open MySQL Workbench and connect to your local server.
3. Open `movie_ticket_booking.sql`.
4. Execute the whole script using the lightning-bolt **Execute** button.
5. In the Schemas panel, refresh and select `movie_ticket_booking`.
6. Run the individual queries under the “BASIC SELECT QUERIES” section one at a time to capture clear output screenshots.

> The SQL script drops and recreates a database named `movie_ticket_booking`. Do not run it if you already have a database with that exact name and need to preserve it.

## Suggested screenshots for the hard-copy report
Capture your own screenshots after running the project:
1. Successful execution of database and table creation.
2. `SELECT * FROM Movies;`
3. The joined show schedule query (Q2).
4. Confirmed booking report (Q3 or Q11).
5. Revenue per movie (Q4).
6. Customer booking count (Q5).
7. Seat lookup (Q7).
8. Database summary (Q12).

Use screenshots from your actual MySQL Workbench execution. Example tables in the report are illustrative expected results, not screenshots.

## Schema overview
- `Movies(movie_id PK, ...)`
- `Theatres(theatre_id PK, ...)`
- `Screens(screen_id PK, theatre_id FK, ...)`
- `Shows(show_id PK, movie_id FK, screen_id FK, ...)`
- `Customers(customer_id PK, ...)`
- `Bookings(booking_id PK, customer_id FK, show_id FK, ...)`
- `Booking_Seats(booking_seat_id PK, booking_id FK, show_id FK, seat_number, UNIQUE(show_id, seat_number))`

## Limitations and future scope
This is an academic database prototype. It does not implement a payment gateway, user authentication, a live web interface, or automatic seat locking under concurrent transactions. These can be added in a future version.

## Author
- Student: [Your Name]
- UID: [Your UID]
- Course: BCA Data Science
- Subject: Database Management Systems (DBMS)
