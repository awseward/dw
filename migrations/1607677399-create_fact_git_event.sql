-- Migration: create_fact_git_event
-- Created at: 2020-12-11 01:03:19
-- ====  UP  ====

BEGIN;

  CREATE VIEW fact_git_event AS
    SELECT
      tbl.timestamp
    , d_hook.hook_key
    , d_repo.repo_key
    , d_ref.ref_key
    FROM events tbl
    JOIN dim_hook d_hook ON tbl.hook = d_hook.hook
    JOIN dim_repo d_repo ON tbl.repo = d_repo.repo
    JOIN dim_ref  d_ref  ON tbl.ref  = d_ref.ref
    ORDER BY tbl.timestamp
    ;


COMMIT;

-- ==== DOWN ====

BEGIN;

  DROP VIEW fact_git_event;

COMMIT;
