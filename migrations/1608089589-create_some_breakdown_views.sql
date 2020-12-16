-- Migration: create_some_breakdown_views
-- Created at: 2020-12-15 19:33:09
-- ====  UP  ====

BEGIN;

  CREATE VIEW v_top_hooks AS
    SELECT
      COUNT(*)
    , dim_hook.hook_basename
    FROM fact_git_event f_ge
    JOIN dim_hook ON f_ge.hook_key = dim_hook.hook_key
    GROUP BY 2
    ORDER BY
      1 DESC
    , 2
  ;

  CREATE VIEW v_top_refs AS
    SELECT
      COUNT(*)
    , dim_ref.ref
    FROM fact_git_event f_ge
    JOIN dim_ref ON f_ge.ref_key = dim_ref.ref_key
    GROUP BY 2
    ORDER BY
      1 DESC
    , 2
  ;

  CREATE VIEW v_top_repos AS
    SELECT
      COUNT(*)
    , dim_repo.repo_basename
    FROM fact_git_event f_ge
    JOIN dim_repo ON f_ge.repo_key = dim_repo.repo_key
    GROUP BY 2
    ORDER BY
      1 DESC
    , 2
  ;

COMMIT;

-- ==== DOWN ====

BEGIN;

  DROP VIEW v_top_hooks;

  DROP VIEW v_top_refs;

  DROP VIEW v_top_repos;

COMMIT;
