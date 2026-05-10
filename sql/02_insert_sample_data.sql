/*
===============================================================================
 File Name   : 02_insert_sample_data.sql
 Project     : Advanced Ecommerce SQL Analytics
 Database    : PostgreSQL
 Purpose     : Insert sample ecommerce data for SQL portfolio analysis
===============================================================================
*/

INSERT INTO customers (id, name, email, city, created_at) VALUES
(1, 'Aarav Kumar', 'aarav@example.com', 'Chennai', '2025-12-15 10:00:00'),
(2, 'Meera Sharma', 'meera@example.com', 'Bangalore', '2025-12-20 11:30:00'),
(3, 'Ravi Nair', 'ravi@example.com', 'Kochi', '2026-01-05 09:15:00'),
(4, 'Ananya Rao', 'ananya@example.com', 'Hyderabad', '2026-01-18 16:45:00'),
(5, 'Karthik Menon', 'karthik@example.com', 'Coimbatore', '2026-02-02 13:20:00'),
(6, 'Priya Iyer', 'priya@example.com', 'Madurai', '2026-02-10 08:40:00'),
(7, 'Vikram Singh', 'vikram@example.com', 'Delhi', '2026-03-01 15:10:00'),
(8, 'Nisha Patel', 'nisha@example.com', 'Mumbai', '2026-03-12 18:30:00');

INSERT INTO orders (id, customer_id, status, grand_total, created_at) VALUES
(101, 1, 'PAID', 1250.00, '2026-01-03 10:30:00'),
(102, 2, 'PAID', 2200.00, '2026-01-05 14:20:00'),
(103, 1, 'PAID', 950.00, '2026-01-15 19:45:00'),
(104, 3, 'FAILED', 1800.00, '2026-01-20 12:10:00'),
(105, 4, 'PAID', 3100.00, '2026-02-02 11:05:00'),
(106, 2, 'PAID', 1450.00, '2026-02-08 17:25:00'),
(107, 5, 'PAID', 2750.00, '2026-02-14 20:15:00'),
(108, 6, 'PENDING', 1600.00, '2026-02-22 09:35:00'),
(109, 1, 'PAID', 3400.00, '2026-03-01 13:50:00'),
(110, 7, 'PAID', 2100.00, '2026-03-05 16:20:00'),
(111, 8, 'FAILED', 1200.00, '2026-03-12 18:55:00'),
(112, 3, 'PAID', 2600.00, '2026-03-18 11:45:00'),
(113, 4, 'PAID', 3900.00, '2026-04-04 15:05:00'),
(114, 5, 'PAID', 1800.00, '2026-04-10 10:25:00'),
(115, 2, 'PAID', 4200.00, '2026-04-18 19:10:00'),
(116, 6, 'PAID', 2400.00, '2026-05-02 08:50:00'),
(117, 7, 'PAID', 3600.00, '2026-05-05 21:30:00'),
(118, 8, 'PENDING', 1500.00, '2026-05-07 12:40:00');

INSERT INTO order_items (id, order_id, product_name, category_name, quantity, unit_price, total_amount) VALUES
(1001, 101, 'Rose Bouquet', 'Bouquets', 1, 1250.00, 1250.00),
(1002, 102, 'Chocolate Hamper', 'Hampers', 1, 2200.00, 2200.00),
(1003, 103, 'Jasmine Garland', 'Garlands', 1, 950.00, 950.00),
(1004, 104, 'Orchid Box', 'Premium Flowers', 1, 1800.00, 1800.00),
(1005, 105, 'Luxury Rose Basket', 'Bouquets', 1, 3100.00, 3100.00),
(1006, 106, 'Mixed Flower Bouquet', 'Bouquets', 1, 1450.00, 1450.00),
(1007, 107, 'Dry Fruit Hamper', 'Hampers', 1, 2750.00, 2750.00),
(1008, 108, 'Birthday Flower Box', 'Premium Flowers', 1, 1600.00, 1600.00),
(1009, 109, 'Wedding Garland Set', 'Garlands', 2, 1700.00, 3400.00),
(1010, 110, 'Chocolate Hamper', 'Hampers', 1, 2100.00, 2100.00),
(1011, 111, 'Rose Bouquet', 'Bouquets', 1, 1200.00, 1200.00),
(1012, 112, 'Orchid Box', 'Premium Flowers', 1, 2600.00, 2600.00),
(1013, 113, 'Luxury Rose Basket', 'Bouquets', 1, 3900.00, 3900.00),
(1014, 114, 'Jasmine Garland', 'Garlands', 2, 900.00, 1800.00),
(1015, 115, 'Dry Fruit Hamper', 'Hampers', 1, 4200.00, 4200.00),
(1016, 116, 'Birthday Flower Box', 'Premium Flowers', 1, 2400.00, 2400.00),
(1017, 117, 'Wedding Garland Set', 'Garlands', 2, 1800.00, 3600.00),
(1018, 118, 'Mixed Flower Bouquet', 'Bouquets', 1, 1500.00, 1500.00);

INSERT INTO payments (id, order_id, status, payment_method, amount, created_at) VALUES
(501, 101, 'SUCCESS', 'UPI', 1250.00, '2026-01-03 10:35:00'),
(502, 102, 'SUCCESS', 'CARD', 2200.00, '2026-01-05 14:25:00'),
(503, 103, 'SUCCESS', 'UPI', 950.00, '2026-01-15 19:50:00'),
(504, 104, 'FAILED', 'CARD', 1800.00, '2026-01-20 12:15:00'),
(505, 105, 'SUCCESS', 'UPI', 3100.00, '2026-02-02 11:10:00'),
(506, 106, 'SUCCESS', 'UPI', 1450.00, '2026-02-08 17:30:00'),
(507, 107, 'SUCCESS', 'CARD', 2750.00, '2026-02-14 20:20:00'),
(508, 108, 'PENDING', 'UPI', 1600.00, '2026-02-22 09:40:00'),
(509, 109, 'SUCCESS', 'UPI', 3400.00, '2026-03-01 13:55:00'),
(510, 110, 'SUCCESS', 'CARD', 2100.00, '2026-03-05 16:25:00'),
(511, 111, 'FAILED', 'UPI', 1200.00, '2026-03-12 19:00:00'),
(512, 112, 'SUCCESS', 'CARD', 2600.00, '2026-03-18 11:50:00'),
(513, 113, 'SUCCESS', 'UPI', 3900.00, '2026-04-04 15:10:00'),
(514, 114, 'SUCCESS', 'UPI', 1800.00, '2026-04-10 10:30:00'),
(515, 115, 'SUCCESS', 'CARD', 4200.00, '2026-04-18 19:15:00'),
(516, 116, 'SUCCESS', 'UPI', 2400.00, '2026-05-02 08:55:00'),
(517, 117, 'SUCCESS', 'CARD', 3600.00, '2026-05-05 21:35:00'),
(518, 118, 'PENDING', 'UPI', 1500.00, '2026-05-07 12:45:00');
