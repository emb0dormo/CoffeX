-- Staff Table Schema
-- Stores staff member information and roles

CREATE TABLE staff (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Add index for role-based queries
CREATE INDEX idx_staff_role ON staff(role);

-- Add comment for documentation
COMMENT ON TABLE staff IS 'Staff members and their roles';
COMMENT ON COLUMN staff.role IS 'Staff role';
