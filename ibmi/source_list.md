# Source Member List - Courtesy of Bob Cozzi
Get a list of source members. Replace the library and file name or templatize them with @@LIBRARY and @@FILE and use with QSHQRYTMP command from my QSHONI tools.
```
SELECT RTRIM(a.OBJLIB) AS LIBRARY,
    RTRIM(a.OBJNAME) AS SOURCE_FILE,
    RTRIM(b.SYSTEM_TABLE_MEMBER) AS NAME,
    B.AVGROWSIZE AS RECORD_LENGTH,
    a.IASP_NUMBER AS ASP,
    COALESCE(RTRIM(CAST(b.SOURCE_TYPE AS VARCHAR(10))), '') AS TYPE,
    COALESCE(RTRIM(VARCHAR(b.TEXT)), '') AS TEXT,
    b.NUMBER_ROWS AS LINES,
    EXTRACT(EPOCH FROM (b.CREATE_TIMESTAMP)) * 1000 AS CREATED,
    EXTRACT(EPOCH FROM (b.LAST_SOURCE_UPDATE_TIMESTAMP)) * 1000 AS CHANGED
 FROM TABLE (
     qsys2.object_statistics('QGPL', '*FILE', 'QCLSRC')
    ) A,
    LATERAL (
     SELECT *
      FROM TABLE (
        qsys2.PARTITION_STATISTICS(
         RPAD(A.OBJLIB, 10), RPAD(A.OBJNAME, 10))
       ) OD
    ) B
    order by objname;
```

    
