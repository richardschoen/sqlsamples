https://www.ibm.com/docs/en/i/7.3?topic=services-generate-sql-procedure
```
// Generate DDL as recordset
CALL QSYS2.GENERATE_SQL('QCUSTCDT', 'QIWS', 'TABLE', REPLACE_OPTION => '0');
// Generate DDL as Source PF Member
CALL QSYS2.GENERATE_SQL('QCUSTCDT', 'QIWS', 'TABLE', 'GENFILE', 'DDLSOURCE', 'INDEXSRC', REPLACE_OPTION => '0');
// Generate DDL as Stream File
CALL QSYS2.GENERATE_SQL(DATABASE_OBJECT_NAME => 'QCUSTCDT', 
                        DATABASE_OBJECT_LIBRARY_NAME => 'QIWS', 
                        DATABASE_OBJECT_TYPE => 'TABLE', 
                        DATABASE_SOURCE_FILE_NAME =>'*STMF', 
                        SOURCE_STREAM_FILE =>'/tmp/qcustcdt.txt');
```
