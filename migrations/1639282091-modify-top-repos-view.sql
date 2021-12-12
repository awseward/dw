-- Migration: modify-top-repos-view
-- Created at: 2021-12-11 20:08:11
-- ====  UP  ====

BEGIN;

  DROP VIEW v2.v_top_repos;

  CREATE VIEW v2.v_top_repos AS (
    SELECT
      COUNT(*) AS event_count
    , v_r.remote
    -- FIXME: This is not _quite_ right yet but is close enough for now…
    , ARRAY_AGG( DISTINCT v_r.local_path_normalized ) AS local_paths_normalized
    FROM fact_git_event f_ge
    JOIN v2.v_repo v_r ON f_ge.repo_key = v_r.repo_key
    WHERE v_r.remote IS NOT NULL
      AND v_r.remote != ''
    GROUP BY 2
    ORDER BY 1 DESC, 2
  );

COMMIT;

-- ==== DOWN ====

BEGIN;

  DROP VIEW v2.v_top_repos;

  CREATE VIEW v2.v_top_repos AS (
    SELECT
      COUNT(*) AS event_count
    , v_r.remote
    , ARRAY_AGG( DISTINCT v_r.local_path_normalized ) AS local_paths_normalized
    FROM fact_git_event f_ge
    JOIN v2.v_repo v_r ON f_ge.repo_key = v_r.repo_key
    GROUP BY 2
    ORDER BY 1 DESC, 2
  );

COMMIT;
