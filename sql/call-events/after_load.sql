$$ BEGIN TRANSACTION; $$,
--
$$   CREATE TEMP TABLE _deduped AS SELECT DISTINCT * FROM call_status_events; $$,
$$   TRUNCATE TABLE call_status_events; $$,
$$   INSERT INTO call_status_events SELECT * FROM _deduped; $$,
$$   DROP TABLE _deduped; $$,
--
$$ COMMIT; $$
