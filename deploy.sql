-- Products Table Schema
-- Stores menu items available for sale

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC NOT NULL CHECK (price > 0),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Add index for product name searches
CREATE INDEX idx_products_name ON products(name);

-- Add comment for documentation
COMMENT ON TABLE products IS 'Menu items available for sale in the coffee shop';
COMMENT ON COLUMN products.price IS 'Product price in dollars (must be positive)';
-- Customers Table Schema
-- Stores customer information and loyalty points

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT,
  points INT DEFAULT 0 CHECK (points >= 0),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Add index for customer name searches
CREATE INDEX idx_customers_name ON customers(name);

-- Add index for phone number lookups
CREATE INDEX idx_customers_phone ON customers(phone);

-- Add comment for documentation
COMMENT ON TABLE customers IS 'Customer information and loyalty program data';
COMMENT ON COLUMN customers.points IS 'Loyalty program points (cannot be negative)';
-- Staff Table Schema
-- Stores staff member information and roles

CREATE TABLE staff (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Add index for role-based queries
CREATE INDEX idx_staff_role ON staff(role);

-- Add comment for documentation
COMMENT ON TABLE staff IS 'Staff members and their roles';
COMMENT ON COLUMN staff.role IS 'Staff role';
-- Orders Table Schema
-- Stores order header information

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  order_date TIMESTAMP DEFAULT NOW(),
  customer_id INT REFERENCES customers(id) ON DELETE SET NULL
);

-- Add index for customer lookups
CREATE INDEX idx_orders_customer ON orders(customer_id);

-- Add index for date-based queries
CREATE INDEX idx_orders_date ON orders(order_date);

-- Add comment for documentation
COMMENT ON TABLE orders IS 'Order header with date and customer reference';
COMMENT ON COLUMN orders.customer_id IS 'Customer who placed the order (NULL for walk-in customers)';
-- Order Items Table Schema
-- Stores individual items within each order

CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(id) ON DELETE CASCADE,
  product_id INT REFERENCES products(id) ON DELETE RESTRICT,
  quantity INT NOT NULL CHECK (quantity > 0),
  price NUMERIC NOT NULL CHECK (price > 0)
);

-- Add index for order lookups
CREATE INDEX idx_order_items_order ON order_items(order_id);

-- Add index for product analytics
CREATE INDEX idx_order_items_product ON order_items(product_id);

-- Add comment for documentation
COMMENT ON TABLE order_items IS 'Individual items within each order';
COMMENT ON COLUMN order_items.price IS 'Price at time of order (historical record)';
COMMENT ON COLUMN order_items.quantity IS 'Number of items ordered';
-- Sample Products Data
-- 10 coffee shop menu items

INSERT INTO products(name, price) VALUES
('Latte', 4.50),
('Cappuccino', 4.00),
('Espresso', 3.00),
('Mocha', 5.00),
('Americano', 3.50),
('Flat White', 4.80),
('Macchiato', 4.20),
('Cold Brew', 4.70),
('Iced Latte', 5.10),
('Matcha Latte', 5.30);
-- Sample Customers Data
-- 10 customers with loyalty points

INSERT INTO customers(name, phone, points) VALUES
('Alice Johnson', '111-111-1111', 10),
('Bob Smith', '222-222-2222', 0),
('Charlie Brown', '333-333-3333', 5),
('Dana White', '444-444-4444', 12),
('Eve Adam', '555-555-5555', 18),
('Frank Miller', '666-666-6666', 0),
('Grace Down', '777-777-7777', 7),
('Hector up', '888-888-8888', 2),
('Ivy Yvi', '999-999-9999', 1),
('Jackie Chan', '000-000-0000', 9);
-- Sample Staff Data
-- 3 staff members with different roles

INSERT INTO staff(name, role) VALUES
('David Martinez', 'admin'),
('Brad Pitt', 'cashier'),
('John Travolta', 'barista');
-- Sample Orders Data
-- 5 orders with line items

-- Order 1: 2 Lattes (2 days ago) and so on. ...
INSERT INTO orders(customer_id, order_date) 
VALUES(1, NOW() - INTERVAL '2 days');

INSERT INTO order_items(order_id, product_id, quantity, price)
VALUES(1, 1, 2, 4.50);

INSERT INTO orders(customer_id, order_date) 
VALUES(2, NOW() - INTERVAL '1 day');

INSERT INTO order_items(order_id, product_id, quantity, price)
VALUES(2, 3, 1, 3.00),
      (2, 2, 1, 4.00);

INSERT INTO orders(customer_id, order_date) 
VALUES(3, NOW());

INSERT INTO order_items(order_id, product_id, quantity, price)
VALUES(3, 8, 3, 4.70);

INSERT INTO orders(customer_id, order_date) 
VALUES(4, NOW());

INSERT INTO order_items(order_id, product_id, quantity, price)
VALUES(4, 4, 1, 5.00);

INSERT INTO orders(customer_id, order_date) 
VALUES(5, NOW());

INSERT INTO order_items(order_id, product_id, quantity, price)
VALUES(5, 10, 2, 5.30);
-- Function: Get all products
-- Returns: Table with product details (id, name, price)
-- Usage: SELECT * FROM fn_get_products();

CREATE OR REPLACE FUNCTION fn_get_products()
RETURNS TABLE(id INT, name TEXT, price NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT p.id, p.name, p.price 
  FROM products p 
  ORDER BY p.name;
END;
$$;
-- Function -Add a new product to the menu
--   p_name: Product name (TEXT)
--   p_price: Product price (NUMERIC)
-- Usage-> SELECT fn_add_product('Iced Tea', 3.50);

CREATE OR REPLACE FUNCTION fn_add_product(p_name TEXT, p_price NUMERIC)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  IF p_name IS NULL OR p_name = '' THEN
    RAISE EXCEPTION 'Product name cannot be empty';
  END IF;
  
  IF p_price IS NULL OR p_price <= 0 THEN
    RAISE EXCEPTION 'Product price must be greater than 0';
  END IF;
  
  INSERT INTO products(name, price) 
  VALUES(p_name, p_price);
END;
$$;
-- Function-> Create a new order
--   p_customer_id: Customer ID (INT, can be NULL for walk-in)
--   p_product_id: Product ID (INT)
--   p_qty: Quantity (INT)
-- Returns: Order ID (INT)
-- Usage-> SELECT fn_create_order(1, 2, 3);

CREATE OR REPLACE FUNCTION fn_create_order(
  p_customer_id INT,
  p_product_id INT,
  p_qty INT
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
  v_order_id INT;
  v_price NUMERIC;
BEGIN
  IF p_qty <= 0 THEN
    RAISE EXCEPTION 'Quantity must be greater than 0';
  END IF;
  
  INSERT INTO orders(customer_id)
  VALUES(p_customer_id)
  RETURNING id INTO v_order_id;
  
  SELECT price INTO v_price FROM products WHERE id = p_product_id;
  
  IF v_price IS NULL THEN
    RAISE EXCEPTION 'Product with ID % does not exist', p_product_id;
  END IF;
  
  INSERT INTO order_items(order_id, product_id, quantity, price)
  VALUES(v_order_id, p_product_id, p_qty, v_price);
  
  RETURN v_order_id;
END;
$$;
-- Function->Get order details with line items
--   p_order_id: Order ID (INT)
-- Returns:Table with product details and totals
-- Usage-> SELECT * FROM fn_get_order(1);

CREATE OR REPLACE FUNCTION fn_get_order(p_order_id INT)
RETURNS TABLE(
  product_name TEXT, 
  qty INT, 
  unit_price NUMERIC, 
  line_total NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM orders WHERE id = p_order_id) THEN
    RAISE EXCEPTION 'Order with ID % does not exist', p_order_id;
  END IF;
  
  RETURN QUERY
  SELECT 
    p.name AS product_name,
    oi.quantity AS qty,
    oi.price AS unit_price,
    (oi.quantity * oi.price) AS line_total
  FROM order_items oi
  JOIN products p ON p.id = oi.product_id
  WHERE oi.order_id = p_order_id
  ORDER BY oi.id;
END;
$$;
-- Function->Calculate total sales for today
-- Returns->Total sales amount(NUMERIC)
-- Usage-> SELECT fn_daily_sales();

CREATE OR REPLACE FUNCTION fn_daily_sales()
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
  v_total NUMERIC;
BEGIN
  SELECT COALESCE(SUM(oi.quantity * oi.price), 0)
  INTO v_total
  FROM order_items oi
  WHERE oi.order_id IN (
    SELECT id 
    FROM orders 
    WHERE DATE(order_date) = CURRENT_DATE
  );
  
  RETURN v_total;
END;
$$;
-- Function-> get best-selling product
-- Returns-> table with product name and quantity sold
-- Usage=> SELECT * FROM fn_best_seller();

CREATE OR REPLACE FUNCTION fn_best_seller()
RETURNS TABLE(
  product_name TEXT, 
  total_sold INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.name AS product_name,
    SUM(oi.quantity)::INT AS total_sold
  FROM order_items oi
  JOIN products p ON p.id = oi.product_id
  GROUP BY p.name
  ORDER BY total_sold DESC
  LIMIT 1;
END;
$$;
-- Function-> get all customers with loyalty information
-- Returns-> table with customer details and points
-- Usage=> SELECT * FROM fn_get_customers();

CREATE OR REPLACE FUNCTION fn_get_customers()
RETURNS TABLE(
  id INT, 
  name TEXT, 
  phone TEXT, 
  points INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    c.id,
    c.name,
    c.phone,
    c.points
  FROM customers c
  ORDER BY c.name;
END;
$$;
-- Function->add loyalty points to a customer
--  p_customer_id: Customer ID (INT)
--   p_points: Points to add(INT)
-- Returns VOID
-- Usage=> SELECT fn_add_points(1, 5);

CREATE OR REPLACE FUNCTION fn_add_points(p_customer_id INT, p_points INT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM customers WHERE id = p_customer_id) THEN
    RAISE EXCEPTION 'Customer with ID % does not exist', p_customer_id;
  END IF;
  
  UPDATE customers
  SET points = points + p_points
  WHERE id = p_customer_id;
END;
$$;
