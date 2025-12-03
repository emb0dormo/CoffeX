-- Sample Orders Data
-- 5 orders with line items

-- Order 1: Alice orders 2 Lattes (2 days ago)
INSERT INTO orders(customer_id, order_date) 
VALUES(1, NOW() - INTERVAL '2 days');

INSERT INTO order_items(order_id, product_id, quantity, price)
VALUES(1, 1, 2, 4.50);

-- Order 2: Bob orders 1 Espresso and 1 Cappuccino (1 day ago)
INSERT INTO orders(customer_id, order_date) 
VALUES(2, NOW() - INTERVAL '1 day');

INSERT INTO order_items(order_id, product_id, quantity, price)
VALUES(2, 3, 1, 3.00),
      (2, 2, 1, 4.00);

-- Order 3: Charlie orders 3 Cold Brews (today)
INSERT INTO orders(customer_id, order_date) 
VALUES(3, NOW());

INSERT INTO order_items(order_id, product_id, quantity, price)
VALUES(3, 8, 3, 4.70);

-- Order 4: Dana orders 1 Mocha (today)
INSERT INTO orders(customer_id, order_date) 
VALUES(4, NOW());

INSERT INTO order_items(order_id, product_id, quantity, price)
VALUES(4, 4, 1, 5.00);

-- Order 5: Eve orders 2 Matcha Lattes (today)
INSERT INTO orders(customer_id, order_date) 
VALUES(5, NOW());

INSERT INTO order_items(order_id, product_id, quantity, price)
VALUES(5, 10, 2, 5.30);
