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
