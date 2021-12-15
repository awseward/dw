-- Migration: add_props_to_events
-- Created at: 2021-12-14 21:30:31
-- ====  UP  ====

BEGIN;

  ALTER TABLE events ADD COLUMN props JSONB NOT NULL DEFAULT '{}';

COMMIT;

-- ==== DOWN ====

BEGIN;

  ALTER TABLE events DROP COLUMN props;

COMMIT;
