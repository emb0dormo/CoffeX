# CoffeeX Screen-to-Function Mapping
This document is to show which database function is used by each part of the application screens.
---
## Screen 1 Dashboard
**Reason** manager checks daily operations
### Details
#### Today's sales card
```
-------------------
│ Today's Sales   │
│   $247.50       │
------------------
```
**Function called** `fn_daily_sales()`
**Example result**
```sql
SELECT fn_daily_sales();
-- Returns: 247.50
```
**it displays** total revenue for current day
---
#### Best seller card
```
-------------------
│ Best Seller     │
│ Cold Brew (15)  │
-------------------
```
**Function called** `fn_best_seller()`
**Example result**
```sql
SELECT * FROM fn_best_seller();
-- Returns:
-- product_name | total_sold
-- Cold Brew    | 15
```
**it displays** most popular product and units sold
---
## Screen 2 menu management
**Reason** view and manage product list
### Details
#### Product list table
```
-------------------------------------
│ Name           │ Price  │ Actions │
-------------------------------------
│ Americano      │ $3.50  │ [Edit]  │
│ Cappuccino     │ $4.00  │ [Edit]  │
│ Cold Brew      │ $4.70  │ [Edit]  │
│ Espresso       │ $3.00  │ [Edit]  │
-------------------------------------
```
**Function called** `fn_get_products()`
**Example result**
```sql
SELECT * FROM fn_get_products();
-- Returns:
-- id | name        | price
--  5 | Americano   | 3.50
--  2 | Cappuccino  | 4.00
-- ...
```
**it displays** all menu items sorted alphabetically
---
## Screen 3 add product form
**Reason** add new item to menu
### Details
#### Add Product Form
```
---------------------------
│ Product Name:           │
│ [________________]      │
│                         │
│ Price:                  │
│ [______]                │
│                         │
│ [Cancel]  [Save]        │
---------------------------
```
**Function called** `fn_add_product(name, price)`
**Example usage**
```sql
SELECT fn_add_product('Iced Tea', 3.50);
```
**it** inserts new product into database
---
## Screen 4 create order
**Reason** process customer purchases
### Details
#### Product selection -> left panel
```
-------------------
│ [Latte $4.50]   │
│ [Espresso $3.00]│
│ [Mocha $5.00]   │
│ [Cold Brew$4.70]│
-------------------
```
**Function called** `fn_get_products()`
**Example result**
```sql
SELECT * FROM fn_get_products();
```
**it displays** clickable product buttons with prices
---
#### Order summary -> right panel
```
---------------------------
│ Customer: Tommy         │
│                         │
│ Items:                  │
│ - Latte (x2)    $9.00   │
│ - Mocha (x1)    $5.00   │
│                         │
│ Total: $14.00           │
│                         │
│ [Complete Order]        │
└─────────────────────────┘
```
**Function called** `fn_create_order(customer_id, product_id, qty)`
**Example usage**
```sql
SELECT fn_create_order(1, 1, 2);  -- Tommy orders 2 Latte
-- Returns 5 (order_id)
```
**it** creates order in database, returns order ID
---
## Screen 5 order receipt
**Reason** show order details after completion
### Details
#### Order details
```
-------------------------------
│ Order #5                    │
│                             │
│ Product      Qty  Price     │
│ Latte         2   $9.00     │
│ Mocha         1   $5.00     │
│                             │
│ Total:           $14.00     │
-------------------------------
```
**Function called** `fn_get_order(order_id)`
**Example result**
```sql
SELECT * FROM fn_get_order(5);
-- Returns:
-- product_name | qty | unit_price | line_total
-- Latte        |   2 |       4.50 |       9.00
-- Mocha        |   1 |       5.00 |       5.00
```
**it displays** line items with quantities and totals
---
## Screen 6 customer list
**Reason** view all customers and loyalty info
### Details
#### Customer Table
```
------------------------------------------
│ Name           │ Phone        │ Points │
------------------------------------------
│ Tommy Branson  │ 111-111-1111 │   10   │
│ Bob Smith      │ 222-222-2222 │    0   │
│ Charlie Brown  │ 333-333-3333 │    5   │
│ Dana Black     │ 444-444-4444 │   12   │
------------------------------------------
```
**Function called** `fn_get_customers()`
**Example result**
```sql
SELECT * FROM fn_get_customers();
-- Returns:
-- id | name          | phone        | points
--  1 | Tommy Branson | 111-111-1111 |     10
--  2 | Bob Smith     | 222-222-2222 |      0
--  3 | Charlie Brown | 333-333-3333 |      5
--  4 | Dana Black    | 444-444-4444 |     12
```
**it displays** customer list with loyalty points
---
## Screen 7 add loyalty points
**Result** reward customers with points
### Details
#### Points form
```
---------------------------
│ Customer: Tommy Branson │
│ Current Points: 10      │
│                         │
│ Add Points:             │
│ [_____]                 │
│                         │
│ [Cancel]  [Add]         │
---------------------------
```
**Function called** `fn_add_points(customer_id, points)`

**Example usage**
```sql
SELECT fn_add_points(1, 5);  -- Add 5 points to Tommy
```
**it** updates customer loyalty points
---
## Complete function summary

| Function | In Screen | Purpose |
|----------|---------------|---------|
| `fn_get_products()` | Menu Management, Create Order | Display product list |
| `fn_add_product()` | Add Product Form | Add new menu item |
| `fn_create_order()` | Create Order | Process purchase |
| `fn_get_order()` | Order Receipt | Show order details |
| `fn_daily_sales()` | Dashboard | Show today's revenue |
| `fn_best_seller()` | Dashboard | Show top product |
| `fn_get_customers()` | Customer List | Display all customers |
| `fn_add_points()` | Add Points Form | Update loyalty points |
---
## Data flow example
1. **Staff opens create order screen**
   - calls `fn_get_products()` -> displays menu
   - calls `fn_get_customers()` ->customer selection
2. **Customer select items**
   - add Latte x2, Mocha x1 to cart
   - UI calculates: 2x$4.50 + 1×$5.00 = $14.00
3. **Staff clicks "Complete Order"**
   - calls `fn_create_order(1, 1, 2)` -> creates order with Latte
   - calls `fn_create_order(1, 4, 1)`-> adds Mocha to same order
   - returns order_id = 5
4. **Show receipt**
   - calls `fn_get_order(5)` -> displays line items
5. **Points**
   - calls `fn_add_points(1, 14)`-> 1 point per dollar
6. **Manager checks dashboard**
   - calls `fn_daily_sales()`-> includes this $14 order
   - calls `fn_best_seller()`-> Latte count increased
---
## Visual map
```
Dashboard screen
-Today's sales card ─> fn_daily_sales()
-Best seller card ─> fn_best_seller()

Menu management screen
-Product list ─> fn_get_products()

Add product screen
─ Save button ─> fn_add_product(name, price)

Create order screen
─ Product buttons ─> fn_get_products()
─ Complete button ─> fn_create_order(cid, pid, qty)

Order receipt screen
─ Order details ─> fn_get_order(order_id)

Customer list screen
─ Customer table ─> fn_get_customers()

Add points screen
─ Add button ─> fn_add_points(cid, points)
```
