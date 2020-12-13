-- Migration: create_initial_health_tables
-- Created at: 2020-12-12 18:23:38
-- ====  UP  ====

BEGIN;

CREATE TABLE bodyweight (
  pounds    NUMERIC(4, 1) NOT NULL,
  timestamp TIMESTAMPTZ   NOT NULL,
  note      TEXT
);

CREATE TABLE water_consumption (
  ounces    NUMERIC(4, 1) NOT NULL,
  timestamp TIMESTAMPTZ   NOT NULL,
  note      TEXT
);

COMMIT;

-- ==== DOWN ====

BEGIN;

  WARNING: Are you sure? (line added to intentionally fail the down migration)

  DROP TABLE bodyweight;

  DROP TABLE water_consumption;

COMMIT;
