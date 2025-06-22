-- List physical files and SQL tables
-- Only include data files, not source files with 'D'
-- Source files would be 'S'
SELECT *
FROM QSYS2.SYSTABLES
WHERE TABLE_TYPE IN ('P', 'T')
AND TABLE_SCHEMA = 'LIBNAME' 
AND FILE_TYPE = 'D';
