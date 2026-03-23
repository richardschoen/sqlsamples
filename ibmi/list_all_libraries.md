# List all libraries SQL

## List all libraries to a resultset where we can use status field to filter
```
-- This bring all library names in and 
-- Eliminates QTEMP from the list. I also added a 
-- filter on QTEMP to make sure it does not show up in list.
-- We also cast the fields to the desired field size
SELECT 
CAST(OBJNAME as CHAR(10)) AS LIBRARY,
CAST(COALESCE(OBJTEXT,'') as CHAR(50)) as LIBTEXT,
CAST('N' as CHAR(10)) as STATUS
FROM TABLE(QSYS2.OBJECT_STATISTICS('*ALL', '*LIB')) A
where OBJNAME <> 'QTEMP';
```

## List all libraries to a resultset where we can use status field to filter
```
-- This bring all library names in and 
-- Eliminates QTEMP from the list. I also added a 
-- filter on QTEMP to make sure it does not show up in list.
-- We also cast the fields to the desired field size
SELECT 
CAST(OBJNAME as CHAR(10)) AS LIBRARY,
CAST(COALESCE(OBJTEXT,'') as CHAR(50)) as LIBTEXT,
CAST('N' as CHAR(10)) as STATUS
FROM TABLE(QSYS2.OBJECT_STATISTICS('*ALL', '*LIB')) A
where OBJNAME <> 'QTEMP';
```
## List all libraries via DSPOBJD
```
-- Did this also with DSPOBJD to list libraries
--DSPOBJD OBJ(QSYS/*ALL)            
--        OBJTYPE(*LIB)             
--        OUTPUT(*OUTFILE)          
--        OUTFILE(TMP/LIBLIST01)
-- Then make sure to filter out QTEMP
select * from TMP/LIBLIST01 where odobnm <> 'QTEMP';
```

## List all libraries by filtering all objects in QSYS
```
-- This brings back a list of libraries. SLOW
-- If I don't filter on QTEMP it also includes QTEMP
-- for some reason. So we filter QTEMP out of the list.
SELECT * FROM TABLE(QSYS2.OBJECT_STATISTICS('QSYS', '*ALL')) A
where OBJTYPE='*LIB' and OBJNAME <> 'QTEMP' order by OBJNAME;
```

## List all libraries by filtering for *LIB object types
```
-- This brings back a list of library objects. They all exist in QSYS. FAST
-- This version automatically eliminates QTEMP from the list. 
-- I also added a filter on QTEMP to make sure it does not show up in list.
SELECT * FROM TABLE(QSYS2.OBJECT_STATISTICS('*ALL', '*LIB')) A
where OBJNAME <> 'QTEMP';
```


