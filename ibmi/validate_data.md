# Run Validate data and get all bad data responses

## Query Table to Check for Data Errors. 
If possible start with a small subset of a table as this is resource intensive.
```
Select * from TABLE(systools.validate_data(         
Library_name => 'LIBRARY',                        
FILE_NAME => 'TABLENAME',                              
MEMBER_NAME => '*FIRST')) 
```

## Get resulting joblog messages that contain errors in CPF5035 message
The joblog hold error information.
```
SELECT * FROM TABLE(QSYS2.JOBLOG_INFO('745985/QUSER/QZDASSINIT')) A
where MESSAGE_ID='CPF5035';
```
