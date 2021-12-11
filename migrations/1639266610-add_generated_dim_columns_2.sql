-- Migration: add_generated_dim_columns_2
-- Created at: 2021-12-11 15:50:11
-- ====  UP  ====

BEGIN;

  ALTER TABLE dim_repo ADD COLUMN repo_normalized TEXT GENERATED ALWAYS AS (
    REGEXP_REPLACE(repo, '^\/(Users|home)\/[^\/]+/', '$HOME/')
  ) STORED;

  ALTER TABLE dim_hook ADD COLUMN hook_normalized TEXT GENERATED ALWAYS AS (
    -- FIXME
    REGEXP_REPLACE(hook, '^\/(Users|home)\/[^\/]+/', '$HOME/')
  ) STORED;

COMMIT;

-- ==== DOWN ====

BEGIN;

  ALTER TABLE dim_repo DROP COLUMN repo_normalized;

  ALTER TABLE dim_hook DROP COLUMN hook_normalized;

COMMIT;
