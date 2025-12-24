# Nice example to list job descriptions on a system
```
SELECT trim(job_description_library) concat '/' concat job_description as jobd_lib ,
Message_Logging_Level, Message_Logging_Severity, Message_Logging_Text, Log_Cl_Program_Commands
FROM qsys2.job_description_info
where Log_Cl_Program_Commands = '*YES'
or Message_Logging_Text = '*SECLVL'
```
