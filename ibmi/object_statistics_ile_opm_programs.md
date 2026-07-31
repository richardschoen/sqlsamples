## Decent object statistics query that also correctly returns source file info for OPM and ILE program and other objects in a single set of columns
```
-- Object statistics query    
-- Check m.bound_module for null
-- If not null, use the m. info for source 
-- files. Otherwise use the O. source file
-- info from the original OBJECT_STATISTICS
SELECT
    O.OBJLIB,
    O.OBJNAME,
    O.OBJTEXT,
    O.OBJTYPE,
    O.OBJATTRIBUTE,
    O.CHANGE_TIMESTAMP,
    O.JOURNALED,
    O.LAST_USED_TIMESTAMP,

    M.BOUND_MODULE,
    M.MODULE_ATTRIBUTE,
    M.MODULE_CREATE_TIMESTAMP,

    CASE
        WHEN M.BOUND_MODULE IS NOT NULL
            THEN M.SOURCE_FILE_LIBRARY
        ELSE O.SOURCE_LIBRARY
    END AS SOURCE_LIBRARY,

    CASE
        WHEN M.BOUND_MODULE IS NOT NULL
            THEN M.SOURCE_FILE
        ELSE O.SOURCE_FILE
    END AS SOURCE_FILE,

    CASE
        WHEN M.BOUND_MODULE IS NOT NULL
            THEN M.SOURCE_FILE_MEMBER
        ELSE O.SOURCE_MEMBER
    END AS SOURCE_MEMBER,

    CASE
        WHEN M.BOUND_MODULE IS NOT NULL
            THEN M.SOURCE_CHANGE_TIMESTAMP
        ELSE O.SOURCE_TIMESTAMP
    END AS SOURCE_TIMESTAMP,

    -- V7R3 no SOURCE_STREAM_FILE_PATH
    ' ' AS SOURCE_STREAM_FILE_PATH
    -- V7R4+ has SOURCE_STREAM_FILE_PATH
    --CASE
        --WHEN M.BOUND_MODULE IS NOT NULL
        --  THEN M.SOURCE_STREAM_FILE_PATH
        --ELSE NULL
    --END AS SOURCE_STREAM_FILE_PATH

FROM TABLE
(
    QSYS2.OBJECT_STATISTICS
    (
        OBJECT_SCHEMA => 'QSHONI',
        OBJTYPELIST   => '*ALL'
    )
) AS O

LEFT OUTER JOIN QSYS2.BOUND_MODULE_INFO AS M
  ON M.PROGRAM_LIBRARY = O.OBJLIB
 AND M.PROGRAM_NAME    = O.OBJNAME
 AND M.OBJECT_TYPE     = O.OBJTYPE

ORDER BY
    O.OBJLIB,
    O.OBJNAME,
    O.OBJTYPE,
    M.BOUND_MODULE;
```
