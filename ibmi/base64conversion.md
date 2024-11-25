# Base64 Encode/Decode with IBM i DB2

## First create the Unhex function. We used QGPL library
```
-- Create this function
CREATE FUNCTION Qgpl.UNHEX (          
  "IN" VARCHAR(32000) FOR BIT DATA )  
  RETURNS VARCHAR(32000)              
  LANGUAGE SQL                        
  SPECIFIC Qgpl.UNHEX                 
  DETERMINISTIC                       
  CONTAINS SQL                        
  CALLED ON NULL INPUT                
  NO EXTERNAL ACTION                  
  SET OPTION  ALWBLK = *ALLREAD ,     
  ALWCPYDTA = *OPTIMIZE ,             
  COMMIT = *CHG ,                     
  DECRESULT = (31, 31, 00) ,          
  DYNDFTCOL = *NO ,                   
  DYNUSRPRF = *USER ,                 
  SRTSEQ = *HEX                       
  BEGIN ATOMIC                        
RETURN IN ;                           
END  ;                                
```
## Usage to encode and decode values
-- Encode value to Base64
```
values qsys2.base64_encode('foo bar');

Result: hpaWQIKBmQ==

```
-- Decode value and convert from Hex to string
```
values qgpl.unhex(qsys2.base64_decode('hpaWQIKBmQ=='));
```


