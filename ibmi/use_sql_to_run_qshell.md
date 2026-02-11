# Use QShell to Run SQL 
Running QShell commands from SQL

From this blog site:   
https://all4power.dev/using-sql-to-run-qshell-commands

## RunQsh.SQL

Listed below is the SQL:

```
-- Purpose: Running QSH command using SQL
-- Version: 1.0
-- Date 08/02/2026
-- Author: Andrea Buzzi
-- Docs: https://www.ibm.com/docs/en/i/7.6.0?topic=services-qcmdexc-procedure
--       https://www.ibm.com/docs/en/i/7.6.0?topic=services-environment-variable-info-view

CREATE OR REPLACE FUNCTION SQLTOOLS.RUN_QSHELL (
            INCMD VARCHAR(10000)
    )
    RETURNS INT
    LANGUAGE SQL
    SPECIFIC SQLTOOLS.RUNQSH
    NOT DETERMINISTIC
    MODIFIES SQL DATA
    CALLED ON NULL INPUT
    SET OPTION ALWBLK = *ALLREAD,
               ALWCPYDTA = *OPTIMIZE,
               COMMIT = *NONE,
               DECRESULT = (31,
               31,
               00),
               DYNDFTCOL = *NO,
               DYNUSRPRF = *USER,
               SRTSEQ = *HEX
    BEGIN
        DECLARE THERESULT INT;
        DECLARE CURCMD VARCHAR(10000);
        DECLARE ENVERR CHAR(1);
        --Initializing variables before checking ENVVARs
        SET ENVERR = NULL;
        --Retrieving QIBM_QSH_CMD_ESCAPE_MSG
        SELECT ENVIRONMENT_VARIABLE_VALUE
            INTO ENVERR
            FROM QSYS2.ENVIRONMENT_VARIABLE_INFO
            WHERE ENVIRONMENT_VARIABLE_TYPE = 'JOB'
                  AND ENVIRONMENT_VARIABLE_NAME = 'QIBM_QSH_CMD_ESCAPE_MSG';
        IF ENVERR IS NULL THEN
            CALL QSYS2.QCMDEXC('ADDENVVAR ENVVAR(QIBM_QSH_CMD_ESCAPE_MSG) VALUE(''Y'')');
        ELSE
            CALL QSYS2.QCMDEXC('CHGENVVAR ENVVAR(QIBM_QSH_CMD_ESCAPE_MSG) VALUE(''Y'')');
        END IF;
        --Running command
        VALUES
            QSYS2.QCMDEXC('QSH CMD(''' CONCAT REPLACE(INCMD, '''', '''''') CONCAT ''')') INTO THERESULT;
        --Restoring EVNVVARs
        IF ENVERR IS NULL THEN
            CALL QSYS2.QCMDEXC('RMVENVVAR ENVVAR(QIBM_QSH_CMD_ESCAPE_MSG)');
        ELSE
            CALL QSYS2.QCMDEXC(
                'CHGENVVAR ENVVAR(QIBM_QSH_CMD_ESCAPE_MSG) VALUE(''' CONCAT ENVERR CONCAT ''')'
            );
        END IF;
        RETURN THERESULT;
    END;
    
    stop;
    
    -- Example: 
    VALUES SQLTOOLS.RUN_QSHELL('touch /home/user/prova.txt')
    
    stop;

-- Purpose: Running QSH command using SQL and getting the command output
-- Version: 1.0
-- Date 08/02/2026
-- Author: Andrea Buzzi
-- PTF Requirements: IBM i 7.5 SF99950 level 7 or IBM i 7.4 SF99704 level 28
-- Docs: https://www.ibm.com/docs/en/i/7.6.0?topic=services-qcmdexc-procedure
--       https://www.ibm.com/docs/en/i/7.6.0?topic=services-environment-variable-info-view
--       https://www.ibm.com/docs/en/i/7.6.0?topic=is-ifs-read-ifs-read-binary-ifs-read-utf8-table-functions
--       https://www.ibm.com/docs/en/i/7.6.0?topic=services-ifs-unlink-scalar-function
    
CREATE OR REPLACE FUNCTION SQLTOOLS.RUN_QSHELL_VERBOSE (
            INCMD VARCHAR(10000)
    )
    RETURNS TABLE (
        LINENBR INT,
        ESITO VARCHAR(10000)
    )
    LANGUAGE SQL
    SPECIFIC SQLTOOLS.RUNQSHVERB
    NOT DETERMINISTIC
    MODIFIES SQL DATA
    CALLED ON NULL INPUT
    SET OPTION ALWBLK = *ALLREAD,
               ALWCPYDTA = *OPTIMIZE,
               COMMIT = *NONE,
               DECRESULT = (31,
               31,
               00),
               DYNDFTCOL = *NO,
               DYNUSRPRF = *USER,
               SRTSEQ = *HEX
    BEGIN
        DECLARE THERESULT INT;
        DECLARE CURCMD VARCHAR(10000);
        DECLARE TMPPATH CHAR(15);
        DECLARE ENVOUTPUT VARCHAR(100);
        DECLARE ENVERR CHAR(1);
        --Preparing output file name
        VALUES
            '/tmp/' CONCAT
                TRANSLATE(SUBSTR(HEX(GENERATE_UNIQUE()), 1, 10), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', '0123456789ABCDEF')
            INTO TMPPATH;
        --Preparing temporary file
        DROP TABLE QTEMP.QSHLOG;
        CREATE TABLE QTEMP.QSHLOG (
                    THENUMBER INT,
                    THEVALUE CLOB(2G)
                );
        --Initializing variables before checking ENVVARs
        SET ENVOUTPUT = NULL;
        SET ENVERR = NULL;
        --Retrieving QIBM_QSH_CMD_OUTPUT
        SELECT ENVIRONMENT_VARIABLE_VALUE
            INTO ENVOUTPUT
            FROM QSYS2.ENVIRONMENT_VARIABLE_INFO
            WHERE ENVIRONMENT_VARIABLE_TYPE = 'JOB'
                  AND ENVIRONMENT_VARIABLE_NAME = 'QIBM_QSH_CMD_OUTPUT';
        IF ENVOUTPUT IS NULL THEN
            CALL QSYS2.QCMDEXC(
                'ADDENVVAR ENVVAR(QIBM_QSH_CMD_OUTPUT) VALUE(''FILE=' CONCAT TMPPATH CONCAT ''')'
            );
        ELSE
            CALL QSYS2.QCMDEXC(
                'CHGENVVAR ENVVAR(QIBM_QSH_CMD_OUTPUT) VALUE(''FILE=' CONCAT TMPPATH CONCAT ''')'
            );
        END IF;
        --Retrieving QIBM_QSH_CMD_ESCAPE_MSG
        SELECT ENVIRONMENT_VARIABLE_VALUE
            INTO ENVERR
            FROM QSYS2.ENVIRONMENT_VARIABLE_INFO
            WHERE ENVIRONMENT_VARIABLE_TYPE = 'JOB'
                  AND ENVIRONMENT_VARIABLE_NAME = 'QIBM_QSH_CMD_ESCAPE_MSG';
        IF ENVERR IS NULL THEN
            CALL QSYS2.QCMDEXC('ADDENVVAR ENVVAR(QIBM_QSH_CMD_ESCAPE_MSG) VALUE(''Y'')');
        ELSE
            CALL QSYS2.QCMDEXC('CHGENVVAR ENVVAR(QIBM_QSH_CMD_ESCAPE_MSG) VALUE(''Y'')');
        END IF;
        --Running command
        VALUES
            QSYS2.QCMDEXC('QSH CMD(''' CONCAT REPLACE(INCMD, '''', '''''') CONCAT ''')') INTO THERESULT;
        --Restoring EVNVVARs
        IF ENVERR IS NULL THEN
            CALL QSYS2.QCMDEXC('RMVENVVAR ENVVAR(QIBM_QSH_CMD_OUTPUT)');
        ELSE
            CALL QSYS2.QCMDEXC(
                'CHGENVVAR ENVVAR(QIBM_QSH_CMD_OUTPUT) VALUE(''' CONCAT ENVOUTPUT CONCAT ''')'
            );
        END IF;
        IF ENVERR IS NULL THEN
            CALL QSYS2.QCMDEXC('RMVENVVAR ENVVAR(QIBM_QSH_CMD_ESCAPE_MSG)');
        ELSE
            CALL QSYS2.QCMDEXC(
                'CHGENVVAR ENVVAR(QIBM_QSH_CMD_ESCAPE_MSG) VALUE(''' CONCAT ENVERR CONCAT ''')'
            );
        END IF;
        --Getting command output
        INSERT INTO QTEMP.QSHLOG
            SELECT *
                FROM TABLE (
                        QSYS2.IFS_READ(PATH_NAME => TMPPATH, END_OF_LINE => 'ANY')
                    );
        VALUES
            SYSTOOLS.IFS_UNLINK(PATH_NAME => TMPPATH) INTO THERESULT;
        RETURN (SELECT *
                    FROM QTEMP.QSHLOG);
    END;
    
    stop;
    
    -- Example: 
    SELECT *
    FROM TABLE (
            SQLTOOLS.RUN_QSHELL_VERBOSE('ls -l /tmp')
        );
    
    stop;
```

