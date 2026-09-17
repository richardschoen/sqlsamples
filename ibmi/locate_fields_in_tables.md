# Locating fields in tables via SQL
Borrowed from Pete Massielo's Linked In Post. 
  
Here is a developer-facing tip that will save you real time the next time you need to make a change and know what it touches. 
Your entire database schema, every table and every column, is itself queryable. The system catalogs its own structure, and 
you can search it.

Say you need to find every table that has a customer number column, because a field is changing and you need to know the 
blast radius:

```
SELECT TABLE_SCHEMA, TABLE_NAME,
 COLUMN_NAME, DATA_TYPE, LENGTH
 FROM QSYS2.SYSCOLUMNS
 WHERE COLUMN_NAME LIKE '%CUST%'
 ORDER BY TABLE_SCHEMA, TABLE_NAME;
```
That searches every column on the system for a name pattern and tells you exactly where it appears, in which tables, 
with what data type and length. Change the LIKE pattern, and you can locate any field across your entire database 
in seconds. Of course, having good field names will help this process.

This is the query I wish every developer and every administrator knew, because it answers the question that 
starts a hundred change projects: where does this data actually live, and what will I break if I touch it? Without 
this, you are grepping through source, asking around, and hoping you found everything. With it, you have an 
authoritative answer straight from the database itself.

There is a companion view, QSYS2.SYSTABLES, that does the same for files/tables, and between the two you can 
explore and understand a database you did not build, which is a situation every one of us lands in eventually. 
Inheriting an undocumented system is far less daunting when the system can describe itself to you.

The lesson underneath all of this, the one I keep coming back to, is that IBM i is open to you. 
It will tell you about itself if you know how to ask. Learn to query the catalog, and no database 
on this platform is ever fully a mystery again.
