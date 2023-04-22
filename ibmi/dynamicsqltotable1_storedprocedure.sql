-- -------------------------------------------------------------
-- Create a stored procedure on IBM i DB2 with a Dynamic Select
-- There are very few IBM i dynamic SQL stored procedure samples 
-- available. Enjoy this one.
-- ** NOTE: This version uses an entirely dynamic SQL statement.
-- Not recommended for production use, but a good example
-- of passing dynamic SQL select statements.
-- This version runs an SQL query and creates an output table
-- based on the query results and allows replacing the table.
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE MYLIB/DYNAMICSQLTOTABLE1
(IN P_SQL VARCHAR(8000),IN P_TOLIB VARCHAR(10),IN P_TOTABLE VARCHAR(30),IN P_REPLACE VARCHAR(1))

  LANGUAGE SQL 
  SET OPTION COMMIT = *NONE
  BEGIN
  
  --Create variable for SQL statement
  DECLARE V_SQL VARCHAR(8000);
  DECLARE V_TEMP VARCHAR(8000);
  
  -- TODO - Determine if exists, drop logic
  --if( exists(
  --  select 1 from syscat.tables where tabschema = 'MYSCHEMA' and tabname = 'MYTABLE'
  --)) then
  
  -- Attempt to DROP table before running SQL if selected
  -- Send SQL0204 if table no found. 
  -- TODO - Handle the not found error.
  if P_REPLACE='Y' THEN
     set V_TEMP = 'drop table ';
     set V_TEMP=CONCAT(V_TEMP,TRIM(P_TOLIB));
     set V_TEMP=CONCAT(V_TEMP,'.');
     set V_TEMP=CONCAT(V_TEMP,TRIM(P_TOTABLE));
     execute immediate V_TEMP;
  end if;
  
  -- Build query to select records and output to a table
  set V_SQL=CONCAT('create table ',TRIM(P_TOLIB));
  set V_SQL=CONCAT(V_SQL,'.');
  set V_SQL=CONCAT(V_SQL,TRIM(P_TOTABLE));
  set V_SQL=CONCAT(V_SQL,' as (');
  set V_SQL=CONCAT(V_SQL,CONCAT(P_SQL,') with data'));
    
  -- Prepare the SQL statement from the SQL 
  PREPARE SQL_STATEMENT FROM V_SQL;
  EXECUTE SQL_STATEMENT;
  
  END;
   
-- Call the dynamic stored procedure. Returns a result set   
CALL  MYLIB/DYNAMICSQLTOTABLE1('select * from qiws.qcustcdt where cusnum=938472','TMP','TEST6','Y');
