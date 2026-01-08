# How do I read and process Blob fields in SQLRPGLE

## Problem
Wanting to download a blob field using the IBM i QSYS2.HTTP_GET_BLOB SQL function.

## Resolution

Initially used:   
```dcl-s zipBlob  SQLTYPE(BLOB: 16000000);```

This is fine if objects will always be less than 16mb.    

But SQLRPGLE won't compile if you set a BLOB type field larger than 16mb.   

BLOB_LOCATOR for the win:   
```dcl-s zipBlob  SQLTYPE(BLOB_LOCATOR);```

You also have to specify COMMIT=*CHG in your program or BLOB_LOCATOR won’t work.   

```
// Set SQL options. COMMIT=*CHG, system naming
// and close any SQL cursors on end of module.
// You may or may not want to leave this in the program.
// COMMIT=*CHG is needed for a blob locator to work.
// Otherwise you may get SQL error 2597 "The locator is invalid
exec sql
    SET OPTION COMMIT = *CHG,
              NAMING = *SYS,
              CLOSQLCSR = *ENDMOD;
```

Once you've made these changes your program should be able to use the QSYS2.HTTP_GET_BLOB function to successfully download larger files via URL and write to the IFS.  

```
// We now have our URL to download the ZIP file.
// Let's go get the file.
// Get the binary file

exec sql
  values QSYS2.HTTP_GET_BLOB(:downloadUrl)
  into :zipBlob;

// Build the IFS path and filename to write the ZIP file to
ifsPath = '/tmp/mydownload.zip';

// Write to IFS (binary-safe, replace if exists)
exec sql
  call QSYS2.IFS_WRITE_BINARY(
    PATH_NAME => :ifsPath,
    LINE      => :zipBlob,
    OVERWRITE => 'REPLACE'
  );
```


