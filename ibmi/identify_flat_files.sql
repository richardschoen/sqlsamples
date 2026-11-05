# Identify flat non externally defined tables
From Simons blog: https://www.rpgpgm.com/2025/06/how-to-identify-flat-files.html

Example to list table that are program described without external DDS/DDL  
```
SELECT SYSTEM_TABLE_NAME,PROGRAM_DESCRIBED
    FROM QSYS2.SYSFILES
   WHERE SYSTEM_TABLE_SCHEMA = 'MYLIB'
     AND NATIVE_TYPE = 'PHYSICAL'
     AND FILE_TYPE = 'DATA'
     AND PROGRAM_DESCRIBED = 'YES'
```
