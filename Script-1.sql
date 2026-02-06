

-- STEP 1: ROLES
INSERT INTO Roles (role_id, role_name) VALUES 
(1, 'Admin'), (2, 'Travel Agent'), (3, 'Customer');

-- STEP 2: USERS
INSERT INTO Users (user_id, email, password_hash, role_id)
SELECT i, 'user' || i || '@easytravel.com', 'hashed_pass_' || i, 3
FROM generate_series(1, 30) s(i);

-- STEP 3: CUSTOMERS
INSERT INTO Customers (customer_id, user_id, first_name, last_name, phone)
SELECT i, i, 'First' || i, 'Last' || i, '555-010' || i
FROM generate_series(1, 30) s(i);

-- STEP 4: SERVICES (Flights with VARIED prices and classes)
-- This Logic ensures your GROUP BY query shows interesting results
INSERT INTO Flights (flight_id, flight_code, origin, destination, seat_class, capacity, price_per_seat)
SELECT 
    i, 
    'ET' || (100+i), 
    'London', 
    'Paris', 
    -- Rotate Seat Classes
    CASE 
        WHEN i % 3 = 0 THEN 'First'
        WHEN i % 3 = 1 THEN 'Business'
        ELSE 'Economy'
    END, 
    200, 
    -- Vary the price based on Class
    CASE 
        WHEN i % 3 = 0 THEN 800.00 + (i * 10)  -- First Class ($800+)
        WHEN i % 3 = 1 THEN 400.00 + (i * 5)   -- Business Class ($400+)
        ELSE 150.00 + (i * 2)                  -- Economy ($150+)
    END
FROM generate_series(1, 30) s(i);

INSERT INTO Accommodations (accommodation_id, name, location, price_per_night)
SELECT i, 'Hotel ' || i, 'Paris', 150.00 FROM generate_series(1, 30) s(i);

INSERT INTO Transfers (transfer_id, transfer_type, origin, destination, price)
SELECT i, 'Taxi', 'Airport', 'Hotel ' || i, 50.00 FROM generate_series(1, 30) s(i);

-- STEP 5: BOOKINGS
INSERT INTO Bookings (booking_id, customer_id, status, total_price)
SELECT i, i, 'Confirmed', 400.00 FROM generate_series(1, 30) s(i);

-- STEP 6: BOOKING DETAILS
INSERT INTO Booking_Details (booking_id, flight_id, accommodation_id, transfer_id, price)
SELECT i, i, i, i, 400.00 FROM generate_series(1, 30) s(i);

-- STEP 7: PAYMENTS & LOYALTY LEDGER
INSERT INTO Payments (booking_id, transaction_id, payment_method, amount, status)
SELECT i, 'TXN' || i, 'Credit Card', 400.00, 'Completed' FROM generate_series(1, 30) s(i);

INSERT INTO Loyalty_Ledger (customer_id, booking_id, points_earned)
SELECT i, i, 100 FROM generate_series(1, 30) s(i);

-- STEP 8: FEEDBACK & PROMOTIONS
INSERT INTO Feedback (customer_id, booking_id, service_type, rating, comments)
SELECT i, i, 'Flight', 5, 'Great service!' FROM generate_series(1, 30) s(i);

INSERT INTO Promotions (promo_code, description, discount_percent, start_date, end_date)
VALUES ('WINTER20', 'Winter Sale', 20.00, '2026-01-01', '2026-03-01')
ON CONFLICT (promo_code) DO NOTHING;

COMMIT;