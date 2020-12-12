-- Migration: create_git_events_dims
-- Created at: 2020-12-10 21:25:34
-- ====  UP  ====

BEGIN;

  CREATE TABLE dim_ref (
    ref_key SERIAL PRIMARY KEY
  , ref     TEXT UNIQUE
  );

  CREATE TABLE dim_hook (
    hook_key SERIAL PRIMARY KEY
  , hook     TEXT UNIQUE
  );

  CREATE TABLE dim_repo (
    repo_key SERIAL PRIMARY KEY
  , repo     TEXT UNIQUE
  );

COMMIT;

-- ==== DOWN ====

BEGIN;

  DROP TABLE dim_ref;

  DROP TABLE dim_hook;

  DROP TABLE dim_repo;

COMMIT;
