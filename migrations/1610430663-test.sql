-- Migration: test
-- Created at: 2021-01-11 21:51:03
-- ====  UP  ====

BEGIN;

  CREATE TABLE test (
    foo TEXT
  );

  INSERT INTO test VALUES ('hello');

  DROP TABLE test;

COMMIT;

-- ==== DOWN ====

BEGIN;

  -- Nothing to do here

COMMIT;
