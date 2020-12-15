$$ BEGIN TRANSACTION; $$,
--
$$   CREATE TEMP TABLE _deduped AS SELECT DISTINCT * FROM bodyweight; $$,
$$   TRUNCATE TABLE bodyweight; $$,
$$   INSERT INTO bodyweight SELECT * FROM _deduped; $$,
$$   DROP TABLE _deduped; $$,
--
$$   CREATE TEMP TABLE _deduped AS SELECT DISTINCT * FROM water_consumption; $$,
$$   TRUNCATE TABLE water_consumption; $$,
$$   INSERT INTO water_consumption SELECT * FROM _deduped; $$,
$$   DROP TABLE _deduped; $$,
--
$$ COMMIT; $$
