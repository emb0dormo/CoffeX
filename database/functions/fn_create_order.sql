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
