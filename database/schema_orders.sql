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
