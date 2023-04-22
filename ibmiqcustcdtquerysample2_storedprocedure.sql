-- -------------------------------------------------------------
-- Create a stored procedure on IBM i DB2 with a Dynamic Select
-- There are very few IBM i dynamic SQL stored procedure samples 
-- available. Enjoy this one.
-- This version takes in a single 6 digit customer number filter parameter
-- and dynamically creates the final SQL statement 
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE MYLIB/QCUSTCDTQUERYSAMPLE2
(IN P_CUSNUM CHAR(6))

  DYNAMIC RESULT SETS 1 
  LANGUAGE SQL 
  SET OPTION COMMIT = *NONE
  BEGIN
  --Create variable for SQL statement
  DECLARE v_SQL VARCHAR(8000);
  DECLARE v_WHERE VARCHAR(8000);
  -- Create cursor for the SQL statement we will generate 
  DECLARE c1 CURSOR WITH RETURN FOR SQL_STATEMENT;
  
  -- Build the SQL statement string and WHERE criteria
  set v_SQL = 'SELECT * from QIWS.QCUSTCDT'; 
  set v_WHERE = 'WHERE CUSNUM = '; 

  -- Concatenate multiple values with space in between them  
  set v_SQL = CONCAT(CONCAT(RTRIM(v_SQL),' '),CONCAT(RTRIM(v_WHERE),P_CUSNUM));
  
  -- Concatenate 2 values with no trimming
  --set v_SQL = CONCAT(v_SQL,v_WHERE);
  
  -- Prepare the SQL statement from the SQL 
  PREPARE SQL_STATEMENT FROM v_SQL;
  
  -- Open the cursor 
  open c1;
  
  --Return results
  return;
  
  END;
   
-- Call the dynamic stored procedure. Returns a result set   
CALL  MYLIB/QCUSTCDTQUERYSAMPLE2('938472');
