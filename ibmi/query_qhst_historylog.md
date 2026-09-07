# Query the QHST history log
The history log, QHST, records the significant events on your system, and like the operator message queue, most people only ever scroll it. You can query it instead.
```
SELECT MESSAGE_TIMESTAMP, MESSAGE_ID,
      MESSAGE_TYPE, FROM_JOB, FROM_USER,
      MESSAGE_TEXT
 FROM TABLE(QSYS2.HISTORY_LOG_INFO(
        START_TIME => CURRENT TIMESTAMP - 7 DAYS))
 ORDER BY MESSAGE_TIMESTAMP DESC
```
That reads the last seven days of your history log, newest first, as a table you can filter and search.

Same query with all fields.
```
SELECT *
 FROM TABLE(QSYS2.HISTORY_LOG_INFO(
        START_TIME => CURRENT TIMESTAMP - 7 DAYS))
 ORDER BY MESSAGE_TIMESTAMP DESC;
```
