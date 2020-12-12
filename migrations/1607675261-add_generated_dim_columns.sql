-- Migration: add_generated_dim_columns
-- Created at: 2020-12-11 00:27:41
-- ====  UP  ====

BEGIN;

  ALTER TABLE dim_repo ADD COLUMN repo_basename TEXT GENERATED ALWAYS AS (
    ltrim(
      (string_to_array(repo, '/'))[array_upper(string_to_array(repo, '/'), 1)]
    , '.'
    )
  ) STORED;

  ALTER TABLE dim_hook ADD COLUMN hook_basename TEXT GENERATED ALWAYS AS (
    (string_to_array(hook, '/'))[array_upper(string_to_array(hook, '/'), 1)]
  ) STORED;

COMMIT;

-- ==== DOWN ====

BEGIN;

  ALTER TABLE dim_repo DROP COLUMN repo_basename;

  ALTER TABLE dim_hook DROP COLUMN hook_basename;

COMMIT;
