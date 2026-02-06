CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role_id INT REFERENCES Roles(role_id)
);
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20)
);
CREATE TABLE Flights (
    flight_id SERIAL PRIMARY KEY,
    flight_code VARCHAR(10) UNIQUE,
    origin VARCHAR(50),
    destination VARCHAR(50),
    seat_class VARCHAR(20) CHECK (seat_class IN ('Economy', 'Business', 'First')),
    capacity INT CHECK (capacity > 0),
    price_per_seat NUMERIC(10, 2)
);
CREATE TABLE Accommodations (
    accommodation_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    price_per_night NUMERIC(10, 2)
);
CREATE TABLE Transfers (
    transfer_id SERIAL PRIMARY KEY,
    transfer_type VARCHAR(20) CHECK (transfer_type IN ('Taxi', 'Shuttle')),
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) CHECK (price > 0),
    special_request TEXT
);
CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    booking_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Confirmed', 'Cancelled')) DEFAULT 'Pending',
    total_price NUMERIC(12, 2) DEFAULT 0
);

CREATE TABLE Booking_Details (
    detail_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES Bookings(booking_id),
    flight_id INT REFERENCES Flights(flight_id),
    accommodation_id INT REFERENCES Accommodations(accommodation_id),
    transfer_id INT REFERENCES Transfers(transfer_id),
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    price NUMERIC(10, 2)
);
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES Bookings(booking_id),
    transaction_id VARCHAR(100) UNIQUE NOT NULL,
    payment_method VARCHAR(30) CHECK (payment_method IN ('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer')),
    amount NUMERIC(12, 2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Completed', 'Failed', 'Refunded')) DEFAULT 'Pending',
    payment_date DATE DEFAULT CURRENT_DATE
);
CREATE TABLE Loyalty_Ledger (
    ledger_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    booking_id INT REFERENCES Bookings(booking_id),
    points_earned INT DEFAULT 0,
    points_redeemed INT DEFAULT 0,
    balance INT GENERATED ALWAYS AS (points_earned - points_redeemed) STORED,
    created_at DATE DEFAULT CURRENT_DATE
);
CREATE TABLE Feedback (
    feedback_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    booking_id INT REFERENCES Bookings(booking_id),
    service_type VARCHAR(20) CHECK (service_type IN ('Flight', 'Accommodation', 'Transfer')),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATE DEFAULT CURRENT_DATE
);
CREATE TABLE Promotions (
    promotion_id SERIAL PRIMARY KEY,
    promo_code VARCHAR(30) UNIQUE NOT NULL,
    description TEXT,
    discount_percent NUMERIC(5, 2) CHECK (discount_percent > 0 AND discount_percent <= 100),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);
