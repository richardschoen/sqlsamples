# Search source members using SQL
This SQL seems to do a good job searching source members without needing to create an SQL alias over a source member.

Gist: https://gist.github.com/BirgittaHauser/74b78ed5db37970155b5aacecb824266.  

```
--It was just a question in a Forum: How to search (all) source 
--physical file members 
--for a specific string and list all those members
--In this examples all source files beginning with "SRC" in the "YOURSCHEMA" library 
--are searched whether they include "String". 
--All Source Members that include "String" are returned
-- https://code400.com/forum/forum/iseries-programming-languages/sql
-- /154258-sql-equivalent-of-fndstrpdm-for-all-members
With a as (Select a.System_Table_Schema OrigSchema, 
     a.System_Table_Name   OrigTable, 
     a.System_Table_Member OrigMember,
     Trim(System_Table_Schema) concat '/' concat 
     Trim(System_Table_Name)   concat '(' concat 
     Trim(System_Table_Member) concat ')' as OrigCLOBMbr
     from qsys2.Syspartitionstat a
     Where  System_Table_Name like trim('SRC%')
     and System_Table_Schema = 'YOURSCHEMA')
Select OrigSchema, OrigTable, OrigMember 
   from a
   Where Get_Clob_From_File(OrigClobMbr) like '%String%' with CS;
```
