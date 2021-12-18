let render =
      λ(sqliteFile : Text) →
      λ(pgUri : Text) →
      λ(afterLoad : Text) →
        ''
        LOAD database
        FROM '${sqliteFile}'
        INTO ${pgUri}?sslmode=require
        WITH data only
        AFTER LOAD DO ${afterLoad}
        ;
        ''

in  render env:SQLITE_FILE as Text env:PG_URI as Text env:AFTERLOAD
