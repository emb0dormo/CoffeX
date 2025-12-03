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
