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
