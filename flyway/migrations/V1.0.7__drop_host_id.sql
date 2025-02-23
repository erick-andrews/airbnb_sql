-- Dropping host_id as column is not needed.
ALTER TABLE host_dim
DROP COLUMN IF EXISTS host_id;