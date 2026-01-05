# SQL Example to List Object Information

## Use cases
- Find large objects across libraries
- Check dates last used or changes on objects.
- Check when objects were last saved or restored.

## List top 10 objects across all user libraries in descending size order
Use to identify large objects.  
List all fields from list of user libraries.  
https://www.nicklitten.com/find-large-objects-on-my-ibm-i-system-use-sql-to-find-those-fat-files/
```
select 
    *
FROM 
TABLE(QSYS2.OBJECT_STATISTICS('*ALLUSR', 'ALL')) 
ORDER BY 
OBJSIZE DESC;
FETCH FIRST 10 ROWS ONLY;
```

## List all objects across all user libraries in descending size order
```
select 
    *
FROM 
TABLE(QSYS2.OBJECT_STATISTICS('*ALLUSR', 'ALL')) 
ORDER BY 
OBJSIZE DESC;
--FETCH FIRST 10 ROWS ONLY;
```

## List all objects across selected library in descending size order
```
select 
    *
FROM 
TABLE(QSYS2.OBJECT_STATISTICS('QGPL', 'ALL')) 
ORDER BY 
OBJSIZE DESC;
```

## List objects for selected library. Selected fields only
```
select 
    OBJNAME AS OBJECT, 
    OBJLONGSCHEMA AS LIBRARY,
    OBJTYPE as OBJECTTYPE,
    OBJATTRIBUTE AS ATTRIBUTE, 
    OBJSIZE AS SIZE, 
    COALESCE(OBJTEXT,'') AS OBJECTTEXT, 
    COALESCE(LAST_USED_TIMESTAMP,'1900-01-01 00:00:00.000000') AS LAST_USED_DATE, 
    COALESCE(OBJCREATED,'1900-01-01 00:00:00.000000') as CREATED_TIMESTAMP,
    COALESCE(CHANGE_TIMESTAMP,'1900-01-01 00:00:00.000000') as CHANGE_TIMESTAMP   
FROM 
TABLE(QSYS2.OBJECT_STATISTICS('QGPL', 'ALL')) 
ORDER BY 
OBJSIZE DESC;
--FETCH FIRST 10 ROWS ONLY;
```
