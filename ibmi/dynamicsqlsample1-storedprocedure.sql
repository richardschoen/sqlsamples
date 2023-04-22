-- -------------------------------------------------------------
-- Create a stored procedure on IBM i DB2 with a Dynamic Select
-- There are very few IBM i dynamic SQL stored procedure samples 
-- available. Enjoy this one.
-- ** NOTE: This version uses an entirely dynamic SQL statement.
-- Not recommended for production use, but a good example
-- of passing dynamic SQL select statements,
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE MYLIB/DYNAMICSQLSAMPLE1
(IN P_SQL VARCHAR(8000))

  DYNAMIC RESULT SETS 1 
  LANGUAGE SQL 
  SET OPTION COMMIT = *NONE
  BEGIN

  -- Create cursor for the SQL statement we will generate 
  DECLARE c1 CURSOR WITH RETURN FOR SQL_STATEMENT;
 
  -- Prepare the SQL statement from the SQL 
  PREPARE SQL_STATEMENT FROM P_SQL;
  
  -- Open the cursor 
  open c1;
  
  --Return results
  return;
  
  END;
   
-- Call the dynamic stored procedure. Returns a result set   
CALL  MYLIB/DYNAMICSQLSAMPLE1('select * from qiws.qcustcdt where cusnum=938472');
