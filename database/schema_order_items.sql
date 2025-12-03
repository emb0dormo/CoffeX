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
