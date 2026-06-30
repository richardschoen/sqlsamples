# List jobs submitted to job queues
This is good if you want to programatically release or manipulate jobs in a job queue.   

## Use cases
- Find and release or end selected jobs.    

List all jobs and all fields in job queue lists.     
```
-- Query all jobs in job queue
SELECT *
FROM TABLE(QSYS2.JOB_INFO(JOB_STATUS_FILTER => '*JOBQ'));
WHERE JOB_NAME = '%%';
```

List all jobs with selected columns   
```
-- Query all jobs in job queue with only selected fields.   
SELECT 
CAST(JOB_NAME as CHAR(30)) as JOB_NAME,
CAST(JOB_NAME_SHORT as CHAR(10)) as JOB_NAME_SHORT,
JOB_USER,
JOB_NUMBER,
JOB_STATUS,
JOB_TYPE,
COALESCE(JOB_SUBSYSTEM,''),
JOB_DATE,
JOB_ENTERED_SYSTEM_TIME,
JOB_QUEUE_LIBRARY,
JOB_QUEUE_NAME,
JOB_QUEUE_STATUS,
JOB_QUEUE_TIME,
OUTPUT_QUEUE_LIBRARY,
OUTPUT_QUEUE_NAME
FROM TABLE(QSYS2.JOB_INFO(JOB_STATUS_FILTER => '*JOBQ'))
WHERE JOB_NAME_SHORT like '%%' 
AND JOB_QUEUE_NAME LIKE  '%%';
```
