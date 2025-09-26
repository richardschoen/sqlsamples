## Check for object lock 

This example checks for a file lock.

```
SELECT MEMBER_LOCK_TYPE,LOCK_STATE,LOCK_SCOPE,JOB_NAME,
             SUBSTR(JOB_NAME,8,LOCATE_IN_STRING(JOB_NAME,'/',8)-8) AS "User"
        FROM QSYS2.OBJECT_LOCK_INFO
       WHERE SYSTEM_OBJECT_SCHEMA = 'QIWS' 
         AND SYSTEM_OBJECT_NAME = 'QCUSTCDT'
         AND OBJECT_TYPE = '*FILE';
```

Reference link:
https://www.rpgpgm.com/2020/01/using-sql-to-look-for-record-locks.html
