$$ BEGIN TRANSACTION; $$,
--
$$   CREATE TEMP TABLE _deduped AS SELECT DISTINCT * FROM call_status_events; $$,
$$   TRUNCATE TABLE call_status_events; $$,
$$   INSERT INTO call_status_events SELECT * FROM _deduped; $$,
$$   DROP TABLE _deduped; $$,
--
$$
     --
     -- This removes redundant updates; e.g. if a client sent true three times
     -- in a row, we only need to keep the first of those three events
     --
     CREATE TEMP TABLE _deduped_2 AS -- Maybe a better name than `_deduped_2`?
       SELECT
         cse.timestamp
       , cse.person_id
       , cse.is_on_call
       FROM (
         SELECT
           t.*
         , LAG(is_on_call) OVER (
             PARTITION BY person_id
             ORDER BY timestamp
           ) AS prev_is_on_call
         FROM call_status_events t
       ) cse
       WHERE prev_is_on_call IS DISTINCT FROM is_on_call
     ;
$$,
$$   TRUNCATE TABLE call_status_events; $$,
$$   INSERT INTO call_status_events SELECT * FROM _deduped_2; $$,
$$   DROP TABLE _deduped_2; $$,
--
$$ COMMIT; $$
