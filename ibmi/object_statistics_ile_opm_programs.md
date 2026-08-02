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
## This one is another potential alternative
Not tested, but give it a try.
```
CREATE OR REPLACE TABLE qtemp.object_inventory AS
(
    WITH

    hard_coded (library_list) AS
    (
        VALUES(
            /*******************************************************************
            *  Here is where you can hard code a list of libraries.
            *  Leave this commented out to use the library list.
            *******************************************************************/
            -- CAST( 'LIB1, LIB2, LIB3' AS VARCHAR(144) )
            CAST( 'QSHONI' AS VARCHAR(144) )


            /*******************************************************************
            *  Leave this as NULL if you want to use the library list.
            *  Comment this line to use hard-coded list above
            *******************************************************************/
            -- CAST( NULL AS VARCHAR(144) )
        )
    )


    , library_scope (library) AS
    (
        -- Uses the hard-coded list from above if it's NOT NULL
        SELECT TRIM(UPPER(element))
        FROM hard_coded,
        LATERAL (
            SELECT * FROM TABLE(
                systools.split(hard_coded.library_list, ',')
            )
        )
        WHERE hard_coded.library_list IS NOT NULL

        UNION

        -- Uses the the library list if the hard-coded list is NULL
        SELECT system_schema_name AS library
        FROM hard_coded, qsys2.library_list_info
        WHERE hard_coded.library_list IS NULL
        AND TYPE IN('CURRENT', 'USER')
        AND schema_name NOT IN('QTEMP', 'QGPL')
    )

    , object_list AS
    (
        SELECT objstat.*
        FROM library_scope AS l,
        LATERAL(
            SELECT
                o.objlib, o.objname,  o.objtext, o.objtype, o.objattribute, o.objsize,
                o.change_timestamp, o.journaled, o.last_used_timestamp,
                m.bound_module, m.module_attribute, m.module_create_timestamp, m.number_procedures,
                COALESCE(o.source_library, m.source_file_library ) AS source_library,
                COALESCE(o.source_file, m.source_file) AS source_file,
                COALESCE(o.source_member, m.source_file_member) AS source_member,
                m.source_stream_file_path AS mod_source_stream_file_path,
                COALESCE(o.source_timestamp, m.source_change_timestamp) AS obj_source_timestamp

            FROM TABLE(
                object_statistics(
                    object_schema => l.library,
                    objtypelist => '*ALL'
                )
            ) AS o

            LEFT OUTER JOIN bound_module_info AS m
                ON program_library = o.objlib
                AND program_name = o.objname
                AND object_type = o.objtype

        ) AS objstat
    )


    SELECT o.*, COALESCE(s.last_source_update_timestamp, i.data_change_timestamp) AS source_change_timestamp
    FROM object_list AS o
    LEFT OUTER JOIN syspartitionstat AS s
        ON s.system_table_schema =  o.source_library
        AND s.system_table_name = o.source_file
        AND s.system_table_member = o.source_member
    LEFT OUTER JOIN TABLE(
        IFS_OBJECT_STATISTICS( o.mod_source_stream_file_path )
    ) AS i
        ON o.mod_source_stream_file_path IS NOT NULL

)
WITH DATA
ON REPLACE DELETE ROWS;
select * from qtemp.object_inventory;
```
