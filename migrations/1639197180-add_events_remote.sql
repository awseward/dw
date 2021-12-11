-- Migration: add_events_remote
-- Created at: 2021-12-10 20:33:00
-- ====  UP  ====

BEGIN;

  ALTER TABLE events ADD COLUMN remote TEXT;

COMMIT;

-- ==== DOWN ====

BEGIN;

  ALTER TABLE events DROP COLUMN remote TEXT;

COMMIT;
