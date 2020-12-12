λ(sqliteFilepath : Text) →
λ(pgTarget : Text) →
  ''
  LOAD database
  FROM '${sqliteFilepath}'
  INTO ${pgTarget}

  WITH data only

  AFTER LOAD DO
    $$ BEGIN TRANSACTION; $$,
      $$ CREATE TEMP TABLE events_deduped AS SELECT DISTINCT * FROM events; $$,
      $$ TRUNCATE TABLE events; $$,
      $$ INSERT INTO events SELECT * FROM events_deduped; $$,
      $$ DROP TABLE events_deduped; $$,
    $$ COMMIT; $$,
    $$
      INSERT INTO dim_ref (ref)
        SELECT DISTINCT tbl.ref
        FROM events tbl
        FULL OUTER JOIN dim_ref dim ON tbl.ref = dim.ref
        WHERE dim.ref IS NULL
        ;
    $$,
    $$
      INSERT INTO dim_repo (repo)
        SELECT DISTINCT tbl.repo
        FROM events tbl
        FULL OUTER JOIN dim_repo dim ON tbl.repo = dim.repo
        WHERE dim.repo IS NULL
        ;
    $$,
    $$
      INSERT INTO dim_hook (hook)
        SELECT DISTINCT tbl.hook
        FROM events tbl
        FULL OUTER JOIN dim_hook dim ON tbl.hook = dim.hook
        WHERE dim.hook IS NULL
        ;
    $$
  ;
  ''
