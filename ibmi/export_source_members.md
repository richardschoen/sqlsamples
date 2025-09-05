# Export source members via SQL 
From Liam Allan Gist   
https://gist.github.com/worksofliam/dc2923149d08f85170d4eaa2c0250f8c

migrate.sql  
```
create or replace procedure ileditor.migratesource(IN library char(10), IN outdir varchar(128))
  program type sub modifies sql data
  set option usrprf = *user, dynusrprf = *user, commit = *none
begin
  declare useless char(1);
  declare continue handler for sqlstate '38501' 
    set useless = 'x';

  FOR sourcefile AS
    select * from qsys2.sysfiles where system_table_schema = library and file_type = 'SOURCE'
  DO
    -- call systools.lprintf('Hello world');
    call systools.lprintf('MKDIR DIR(''' concat outdir concat '/' concat lower(sourcefile.table_name) concat ''')');
    call qsys2.qcmdexc('MKDIR DIR(''' concat outdir concat '/' concat lower(sourcefile.table_name) concat ''')');

    FOR sourcemember AS
      select * from qsys2.syspartitionstat where table_schema = library and table_name = sourcefile.table_name
    DO

      call systools.lprintf('CPYTOSTMF FROMMBR(''/QSYS.LIB/' concat rtrim(library) concat '.LIB/' concat rtrim(sourcemember.table_name) concat '.FILE/' concat rtrim(sourcemember.table_partition) concat '.MBR'') TOSTMF('''concat outdir concat '/' concat rtrim(lower(sourcemember.table_name)) concat  '/' concat rtrim(sourcemember.table_partition) concat '.' concat rtrim(sourcemember.SOURCE_TYPE) concat ''') STMFOPT(*REPLACE) STMFCCSID(1208)');
      call qsys2.qcmdexc('CPYTOSTMF FROMMBR(''/QSYS.LIB/' concat rtrim(library) concat '.LIB/' concat rtrim(sourcemember.table_name) concat '.FILE/' concat rtrim(sourcemember.table_partition) concat '.MBR'') TOSTMF('''concat outdir concat '/' concat rtrim(lower(sourcemember.table_name)) concat  '/' concat rtrim(sourcemember.table_partition) concat '.' concat rtrim(sourcemember.SOURCE_TYPE) concat ''') STMFOPT(*REPLACE) STMFCCSID(1208)');
    END FOR;
  END FOR;

end;

call ileditor.migratesource('CMPSYS', '/home/JGORZINS/testout');
```
