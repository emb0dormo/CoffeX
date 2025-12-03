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
