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
