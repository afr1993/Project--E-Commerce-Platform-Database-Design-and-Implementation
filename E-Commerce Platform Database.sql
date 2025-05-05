-- Adrian Flores Rangel
-- Create table
CREATE DATABASE ECommercePlatform;
USE ECommercePlatform;

-- Tables
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role VARCHAR(20)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    order_status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(30),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    user_id INT,
    review_text TEXT,
    rating INT,
    review_date DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Sample data
INSERT INTO Users (username, email, password, role) VALUES
('alice123', 'alice@example.com', 'hashed_password1', 'customer'),
('bob_admin', 'bob@example.com', 'hashed_password2', 'admin'),
('charlie88', 'charlie@example.com', 'hashed_password3', 'customer'),
('diana.smith', 'diana@example.com', 'hashed_password4', 'customer');

INSERT INTO Products (product_name, category, price, stock_quantity) VALUES
('Wireless Mouse', 'Electronics', 25.99, 150),
('Mechanical Keyboard', 'Electronics', 75.49, 80),
('Yoga Mat', 'Fitness', 20.00, 120),
('Water Bottle', 'Fitness', 12.00, 200),
('Smartphone', 'Electronics', 599.99, 40),
('Running Shoes', 'Footwear', 89.95, 65),
('Bluetooth Speaker', 'Electronics', 45.00, 90),
('Backpack', 'Accessories', 39.99, 70);

INSERT INTO Orders (user_id, order_date, total_amount, order_status) VALUES
(1, '2025-05-01 10:15:00', 101.98, 'delivered'),
(3, '2025-05-02 14:30:00', 75.49, 'shipped'),
(1, '2025-05-03 09:00:00', 599.99, 'pending'),
(4, '2025-05-04 12:45:00', 134.95, 'delivered');

INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 25.99),
(1, 2, 1, 49.99),
(2, 2, 1, 75.49),
(3, 5, 1, 599.99),
(4, 6, 1, 89.95),
(4, 4, 2, 22.50);

INSERT INTO Payments (order_id, payment_date, payment_method, amount) VALUES
(1, '2025-05-01 10:16:00', 'credit_card', 101.98),
(2, '2025-05-02 14:32:00', 'paypal', 75.49),
(4, '2025-05-04 12:50:00', 'bank_transfer', 134.95);

INSERT INTO Reviews (product_id, user_id, review_text, rating, review_date) VALUES
(1, 1, 'Very responsive and fits well in hand.', 5, '2025-05-02 11:00:00'),
(2, 3, 'Keys feel great and durable.', 4, '2025-05-03 09:30:00'),
(5, 1, 'Great phone, battery life is decent.', 4, '2025-05-04 13:00:00'),
(6, 4, 'Comfortable for running, highly recommend.', 5, '2025-05-04 14:15:00'),
(4, 4, 'Keeps water cold for hours!', 5, '2025-05-04 14:17:00');


-- Consults
SELECT * FROM Products WHERE category = 'Electronics';

SELECT * FROM Users WHERE user_id = 1;

SELECT order_id, order_date, total_amount, order_status FROM Orders WHERE user_id = 1 ORDER BY order_date DESC;

SELECT P.product_name, OD.quantity, OD.unit_price,(OD.quantity * OD.unit_price) AS total_price
FROM OrderDetails OD 
JOIN Products P 
ON OD.product_id = P.product_id
WHERE OD.order_id = 1;

SELECT P.product_name, OD.quantity, OD.unit_price, (OD.quantity * OD.unit_price) AS total_price
FROM OrderDetails OD
JOIN Products P 
ON OD.product_id = P.product_id
WHERE OD.order_id = 1;

SELECT product_id, AVG(rating) AS average_rating
FROM Reviews
WHERE product_id = 1
GROUP BY product_id;

SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, SUM(amount) AS total_revenue
FROM Payments
WHERE payment_date BETWEEN '2025-05-01' AND '2025-05-31'
GROUP BY month;

-- Data modification
INSERT INTO Products (product_name, category, price, stock_quantity)
VALUES ('Gaming Headset', 'Electronics', 59.99, 50);

INSERT INTO Orders (user_id, order_date, total_amount, order_status)
VALUES (1, NOW(), 149.97, 'pending');

INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price)
VALUES 
(5, 1, 1, 25.99),
(5, 2, 1, 75.49),
(5, 4, 2, 24.25);

INSERT INTO Payments (order_id, payment_date, payment_method, amount)
VALUES (5, NOW(), 'credit_card', 149.97);

UPDATE Products
SET stock_quantity = stock_quantity - 2
WHERE product_id = 4;
 
DELETE FROM Reviews
WHERE user_id = 1 AND product_id = 1;

-- Complex Querys
SELECT P.product_id, P.product_name,
    SUM(OD.quantity) AS total_units_sold
FROM OrderDetails OD
JOIN Products P ON OD.product_id = P.product_id
GROUP BY P.product_id, P.product_name
ORDER BY total_units_sold DESC
LIMIT 10;  -- Adjust limit as needed

SELECT U.user_id, U.username, O.order_id, O.total_amount
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
WHERE O.total_amount > 100
ORDER BY O.total_amount DESC;

SELECT P.category,
    ROUND(AVG(R.rating), 2) AS average_category_rating
FROM Reviews R
JOIN Products P ON R.product_id = P.product_id
GROUP BY P.category
ORDER BY average_category_rating DESC;

-- Advanced Topics:
DELIMITER //

CREATE TRIGGER after_payment_insert
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET order_status = 'shipped'
    WHERE order_id = NEW.order_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetMostActiveUsers(IN min_orders INT)
BEGIN
    SELECT 
        U.user_id,
        U.username,
        COUNT(O.order_id) AS total_orders,
        SUM(O.total_amount) AS total_spent
    FROM Users U
    JOIN Orders O ON U.user_id = O.user_id
    GROUP BY U.user_id, U.username
    HAVING total_orders >= min_orders
    ORDER BY total_orders DESC, total_spent DESC;
END //

DELIMITER ;

CALL GetMostActiveUsers(3);



