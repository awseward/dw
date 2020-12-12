λ(sqliteFile : Text) →
λ(pgUri : Text) →
λ(afterLoad : Text) →
  ''
  LOAD database
  FROM '${sqliteFile}'
  INTO ${pgUri}
  WITH data only
  AFTER LOAD DO ${afterLoad}
  ;
  ''
