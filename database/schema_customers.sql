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
