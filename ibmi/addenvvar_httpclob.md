# Add environment variable in SQL function and call HTTPPOSTVERBOSE
This example shows how to use CL commands from a SQL function or stored procedure

```
--Set job JVM JAVA_HOME environment to Java 8 before running any HTTPCLOB calls
CALL QSYS2.QCMDEXC('ADDENVVAR ENVVAR(JAVA_HOME) VALUE(''/QOpenSys/QIBM/ProdData/JavaVM/jdk80/32bit'') CCSID(*JOB) LEVEL(*JOB) REPLACE(*YES)');

--This call to an API works with Java 8
select responsemsg,responsehttpheader 
  from table(systools.httppostclobverbose('https://api.dhlecs.com/auth/v4/accesstoken',
  '<httpHeader><header name="Content-Type" value="application/x-www-form-urlencoded"/><header name="Accept" value="*/*"/></httpHeader>',  'grant_type=client_credentials&client_id=myclientid&client_secret=myclientsecret')) as T;
```
