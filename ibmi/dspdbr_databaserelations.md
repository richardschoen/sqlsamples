# Display database relations for selected library and then query the results
```
-- Display database relations and then query results
CL: DSPDBR FILE(QSHONI/*ALL)        
       OUTPUT(*OUTFILE)         
       OUTFILE(TMP/DSPDBRTMP1)  
       OUTMBR(*FIRST *REPLACE);
-- Query DSPDBR results table
select * from TMP.DSPDBRTMP1;
```

       
