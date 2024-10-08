CREATE TABLE airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE flights (
    flight_id INT PRIMARY KEY,
    departure_airport CHAR(3),
    arrival_airport CHAR(3),
    departure_time TIME,
    arrival_time TIME,
    FOREIGN KEY (departure_airport) REFERENCES airports(airport_code),
    FOREIGN KEY (arrival_airport) REFERENCES airports(airport_code)
);

INSERT INTO airports (airport_code, airport_name, city, country) VALUES
('JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA'),
('LHR', 'London Heathrow Airport', 'London', 'UK'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
('NRT', 'Narita International Airport', 'Tokyo', 'Japan');

INSERT INTO flights (flight_id, departure_airport, arrival_airport, departure_time, arrival_time) VALUES
(1, 'JFK', 'LAX', '08:00', '11:00'),
(2, 'LAX', 'NRT', '13:00', '17:00'),
(3, 'NRT', 'LHR', '19:00', '23:00'),
(4, 'LHR', 'CDG', '09:00', '10:30'),
(5, 'CDG', 'JFK', '12:00', '14:00'),
(6, 'JFK', 'LHR', '18:00', '06:00'),
(7, 'LHR', 'LAX', '10:00', '13:00');

-- Find all possible one-stop flights from JFK to NRT
SELECT 
    f1.flight_id as first_flight_id, 
    f2.flight_id as second_flight_id,
    a1.city as departure_city, 
    a2.city as layover_city, 
    a3.city as arrival_city,
    f1.departure_time, 
    f1.arrival_time as layover_arrival, 
    f2.departure_time as layover_departure, 
    f2.arrival_time as final_arrival
FROM flights f1
JOIN flights f2 
    ON f1.arrival_airport = f2.departure_airport
JOIN airports a1 
    ON f1.departure_airport = a1.airport_code
JOIN airports a2 
    ON f1.arrival_airport = a2.airport_code
JOIN airports a3 
    ON f2.arrival_airport = a3.airport_code
WHERE f1.departure_airport = 'JFK'
AND f2.arrival_airport = 'NRT'
AND f2.departure_time > f1.arrival_time
ORDER BY f1.departure_time;