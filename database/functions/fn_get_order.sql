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
