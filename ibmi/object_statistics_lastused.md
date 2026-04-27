# List object statistics for one or more libraries. 
This example lists objects for QGPL and QIWS. You can use *ALL for library name but that can be SLOW. 
```
-- List All Objects and Fields in Library Based on Last Used Date,
-- sorted descending by LIB, Last Used Time.
-- This will give us statistics on objects used in QGPL and QIWS.
-- I used a UNION query since OBJECT-STATISTICS DB2 service can be slow over all
-- library names so I queried QGPL and QIWS individually with a union
-- query and combined the results
WITH LIB_OBJECTS AS
(
SELECT
    OBJNAME,
    OBJTYPE,
    OBJATTRIBUTE,
    OBJLONGSCHEMA AS OBJLIBRARY,
    OBJCREATED,
    coalesce(LAST_USED_TIMESTAMP,'1900-01-01 00:00:00.000000') as LAST_USED_TIMESTAMP,
    coalesce(CHANGE_TIMESTAMP,'1900-01-01 00:00:00.000000') as CHANGETIME,
    coalesce(OBJTEXT,'') as OBJTEXT,
    OBJSIZE,
    coalesce(SOURCE_FILE,'') as SRCFILE,
    coalesce(SOURCE_LIBRARY,'') as SRCLIB,
    coalesce(SOURCE_MEMBER,'') as SRCMBR,
    CREATED_SYSTEM,
    CREATED_SYSTEM_VERSION,
    coalesce(SAVE_TIMESTAMP,'1900-01-01 00:00:00.000000') as SAVETIME,
    coalesce(RESTORE_TIMESTAMP,'1900-01-01 00:00:00.000000') as RESTORETIME
    FROM TABLE(QSYS2.OBJECT_STATISTICS('QGPL', '*ALL'))

UNION ALL

SELECT
    OBJNAME,
    OBJTYPE,
    OBJATTRIBUTE,
    OBJLONGSCHEMA AS OBJLIBRARY,
    OBJCREATED,
    coalesce(LAST_USED_TIMESTAMP,'1900-01-01 00:00:00.000000') as LAST_USED_TIMESTAMP,
    coalesce(CHANGE_TIMESTAMP,'1900-01-01 00:00:00.000000') as CHANGETIME,
    coalesce(OBJTEXT,'') as OBJTEXT,
    OBJSIZE,
    coalesce(SOURCE_FILE,'') as SRCFILE,
    coalesce(SOURCE_LIBRARY,'') as SRCLIB,
    coalesce(SOURCE_MEMBER,'') as SRCMBR,
    CREATED_SYSTEM,
    CREATED_SYSTEM_VERSION,
    coalesce(SAVE_TIMESTAMP,'1900-01-01 00:00:00.000000') as SAVETIME,
    coalesce(RESTORE_TIMESTAMP,'1900-01-01 00:00:00.000000') as RESTORETIME
    FROM TABLE(QSYS2.OBJECT_STATISTICS('QIWS', '*ALL'))

)
select * from LIB_OBJECTS
    -- Uncomment WHERE statement to see objects not changed in past two years.
    -- Leave commented to get all objects into resultset and then you can manually filter
    -- the Excel results.
    --WHERE LAST_USED_TIMESTAMP < CURRENT_TIMESTAMP - 2 YEAR
    --OR LAST_USED_TIMESTAMP IS NULL
    --OR LAST_USED_TIMESTAMP = '1900-01-01 00:00:00.000000'
    ORDER BY OBJLIBRARY,LAST_USED_TIMESTAMP DESC, OBJNAME
```









