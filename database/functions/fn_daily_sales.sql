-- Function->Calculate total sales for today
-- Returns->Total sales amount(NUMERIC)
-- Usage-> SELECT fn_daily_sales();

CREATE OR REPLACE FUNCTION fn_daily_sales()
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
  v_total NUMERIC;
BEGIN
  SELECT COALESCE(SUM(oi.quantity * oi.price), 0)
  INTO v_total
  FROM order_items oi
  WHERE oi.order_id IN (
    SELECT id 
    FROM orders 
    WHERE DATE(order_date) = CURRENT_DATE
  );
  
  RETURN v_total;
END;
$$;
