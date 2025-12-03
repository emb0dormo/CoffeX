# CoffeeX security

### 1 Input validation in functions
**Reason** Prevent SQL injection and invalid data entry
**Implementation**
- All functions validate inputs before executing queries
- Example from `fn_add_product`:
```sql
IF p_name IS NULL OR p_name = '' THEN
  RAISE EXCEPTION 'Product name cannot be empty';
END IF;
```
**Result** Prevents empty/null values from corrupting database
---
### 2 Foreign Key constraints

**Reason why** Maintain data integrity and prevent solo records
**Implementation**
```sql
order_id INT REFERENCES orders(id) ON DELETE CASCADE
customer_id INT REFERENCES customers(id) ON DELETE SET NULL
product_id INT REFERENCES products(id) ON DELETE RESTRICT
```

**Security benefits**
- CASCADE: Auto-delete order_items when order is deleted
- SET NULL: Keep order history even if customer deleted
- RESTRICT: Prevent deleting products that have been ordered
---
### 3 Check constraints
**Reason** Enforce business rules at database level
**Implementation**
```sql
price NUMERIC NOT NULL CHECK (price > 0)
quantity INT NOT NULL CHECK (quantity > 0)
points INT DEFAULT 0 CHECK (points >= 0)
```
**protection reason** Prevents negative prices, quantities, and loyalty points
---
### 4 Parameterized Queries

**reason** Prevent SQL injection attacks

**Implementation**
All PL/pgSQL functions use parameters e.g. `p_name`, `p_price` instead of string concatenation

**Example**
```sql
-- SECURE (what I use)
INSERT INTO products(name, price) VALUES(p_name, p_price);
-- INSECURE (what I try to avoid)
EXECUTE 'INSERT INTO products VALUES (' || unsafe_input || ')';
```
---
### 5 NOT NULL constraints
**reason why** Ensure critical data is always present
**Implementation**
```sql
name TEXT NOT NULL
price NUMERIC NOT NULL
quantity INT NOT NULL
```
**result** Prevents incomplete records
---
### 6 Indexed Foreign Keys
**resson** Improve query performance and prevent timing attacks

**Implementation**
```sql
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
```
**Security benefit** Fast lookups prevent timeout-based data discovery
---
## Security considerations
### planned additional measures
1. **User Authentication**
   - Add `users` table with hashed passwords
   - use bcryptfor password hashing
   - Implement role-based access control
2. **Environment Variables**
   - NEVER HARDCODE DATABASE 
   - Use `.env` files so it's more protective
4. **Rate Limiting**
   - limit function calls per user/IP
   - prevent brute force attacks
4. **Audit Logging**
   - log all data modifications
   - basically track who changed what and when
---
## Why I Chose These Security Measures
**Priority: Data Integrity**
- Coffee shops need accurate financial records
- Foreign keys and constraints prevent data corruption
- Input validation stops bad data at entry point

**Trade-offs**
- I chose indexes on foreign keys despite small storage cost
- Validation in functions adds minimal overhead
- Security > Speed for financial data
**Real-world Impact**
- Prevents accidental data deletion
- Catches user input errors before they cause problems
- Makes debugging easier ->database rejects bad data immediately
