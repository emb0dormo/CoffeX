-- Function-> get best-selling product
-- Returns-> table with product name and quantity sold
-- Usage=> SELECT * FROM fn_best_seller();

CREATE OR REPLACE FUNCTION fn_best_seller()
RETURNS TABLE(
  product_name TEXT, 
  total_sold INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.name AS product_name,
    SUM(oi.quantity)::INT AS total_sold
  FROM order_items oi
  JOIN products p ON p.id = oi.product_id
  GROUP BY p.name
  ORDER BY total_sold DESC
  LIMIT 1;
END;
$$;
