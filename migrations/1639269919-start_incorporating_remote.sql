-- Migration: start_incorporating_remote
-- Created at: 2021-12-11 16:45:19
-- ====  UP  ====

BEGIN;

  CREATE schema IF NOT EXISTS v2;

  CREATE VIEW v2.v_repo AS (
    SELECT DISTINCT
      dr.repo_key
    , e.remote
    , dr.repo_normalized AS local_path_normalized
    FROM dim_repo dr
    JOIN events e ON e.repo = dr.repo
    WHERE e.remote IS NOT NULL
  );

  CREATE VIEW v2.v_top_repos AS (
    SELECT
      COUNT(*) AS event_count
    , v_r.remote
    -- FIXME: This is not _quite_ right yet but is close enough for now…
    , ARRAY_AGG( DISTINCT v_r.local_path_normalized ) AS local_paths_normalized
    FROM fact_git_event f_ge
    JOIN v2.v_repo v_r ON f_ge.repo_key = v_r.repo_key
    GROUP BY 2
    ORDER BY 1 DESC, 2
  );

COMMIT;

-- ==== DOWN ====

BEGIN;

  DROP schema v2 CASCADE;

COMMIT;
