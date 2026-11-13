# Generate list of libraries owned by IBM as part of OS
https://www.rpgpgm.com/2026/11/identifying-ibms-libraries.html
```
SELECT OBJNAME,OBJDEFINER,OBJOWNER,TEXT
FROM TABLE(QSYS2.OBJECT_STATISTICS('*ALL','*LIB'))
WHERE OBJDEFINER IN ('QLPINSTALL','*IBM','QSYS')
OR OBJOWNER = 'QSYS' 
ORDER BY OBJNAME;
```
