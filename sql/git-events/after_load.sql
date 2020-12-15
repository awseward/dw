$$ BEGIN TRANSACTION; $$,
--
$$   CREATE TEMP TABLE _deduped AS SELECT DISTINCT * FROM events; $$,
$$   TRUNCATE TABLE events; $$,
$$   INSERT INTO events SELECT * FROM _deduped; $$,
$$   DROP TABLE _deduped; $$,
--
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
