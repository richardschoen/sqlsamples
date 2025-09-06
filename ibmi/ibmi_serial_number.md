# Get IBM i serial# and model info
SELECT SERIAL, PART_ID FROM QSYS2.SYSTEM_STATUS_INFO;   

SELECT * FROM QSYS2.SYSTEM_STATUS_INFO;   

SELECT machine_type,machine_model,serial_number,machine_SERIAL_number, PARTITION_ID FROM QSYS2.SYSTEM_STATUS_INFO;   
