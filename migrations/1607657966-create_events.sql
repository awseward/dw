-- Migration: create_events
-- Created at: 2020-12-10 19:39:26
-- ====  UP  ====

BEGIN;

  CREATE TABLE events (
    version   TEXT        NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL,
    hook      TEXT        NOT NULL,
    repo      TEXT        NOT NULL,
    ref       TEXT        NOT NULL
  );

COMMIT;

-- ==== DOWN ====

BEGIN;

  WARNING: Are you sure? (line added to intentionally fail the down migration)

  DROP TABLE events;

COMMIT;
