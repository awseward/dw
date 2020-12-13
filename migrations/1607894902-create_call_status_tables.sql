-- Migration: create_call_status_tables
-- Created at: 2020-12-13 13:28:22
-- ====  UP  ====

BEGIN;

  CREATE TABLE call_status_events (
    timestamp  TIMESTAMPTZ NOT NULL,
    person_id  INT         NOT NULL,
    is_on_call BOOLEAN     NOT NULL
  );

COMMIT;

-- ==== DOWN ====

BEGIN;

  WARNING: Are you sure? (line added to intentionally fail the down migration)

  DROP TABLE call_status_events;

COMMIT;
