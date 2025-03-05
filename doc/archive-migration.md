## Migrating Archive Classes

These are notes from an engagement with ESRI. Unlike the goals elsewhere in this repo, for this engagement we wish to migrate CSCL via an interim step like a file geodatabase.  In this interim step we will lose the archive.

The steps below describe our preferred archive restoration strategy. This strategy is not supported by the COTS software.

### Confirm All Datasets Have a Globalid

Objectid gets toasted on the target. Globalids will serve as a persistent unique identifier.

```sql
select 
    distinct table_name 
from 
    user_tab_columns
where 
    not REGEXP_LIKE(table_name, '^[DFS][0-9]+$')
    and table_name not like 'KEYSET%'
    and table_name not like 'SDE%'
    and table_name not like 'T_1%'
minus
select 
    table_name 
from 
    user_tab_columns 
where 
    column_name = 'GLOBALID';
```

### Test Migrate A Feature Class


1.	Set up a dummy feature class in source dev schema 

2.	Perform some archivable edits. Post them up to default.

3.	Copy the feature class to a target schema. It will be registered with the geodatabase but not registered as versioned, not archiving.

In the real workflow the data will move to an interim file geodatabase here.

4.	Stop archiving in source schema to excrete the _H table. You will need an exclusive lock for this.

5.	Copy the _H table to target schema and paste-very-special to rename to _H_BAK

6.	Go for the objectid update! 

    The row count in the base table will be different than _H_BAK. The goal here is to update altered objectids in the _H_BAK table to match the base table objectids. Unmatched objectids will exist in _H_BAK this is OK they are history. (TODO: confirm this bold statement)

    In a real migration there should be no A and D versioning tables in the target schema.  Verify this.

    Probably a good idea to regather any stale statistics.  Just in case.

```sql
BEGIN
    DBMS_STATS.GATHER_SCHEMA_STATS(
        ownname          => 'xxSCHEMAxx', 
        options          => 'GATHER STALE', 
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, 
        degree           => DBMS_STATS.DEFAULT_DEGREE
    );
END;
```

(TODO: Why so slow? Globalid is indexed on both sides)

```sql
update 
    xxFEATURECLASSxx_h_bak a
set
    a.objectid = (select 
                      b.objectid
                  from 
                      xxFEATURECLASSxx b
                  where
                      b.globalid = a.globalid)
where exists
    (select 
        1 
     from
        xxFEATURECLASSxx b
    where b.globalid = a.globalid);
```    
    
    See the src/py/resources directory of this repo for lists of CSCL feature classes and tables.  Consider stupid simple generating the final list of update SQLs by starting with these lists and typing out the update statement in "column mode" of a text editor. 

7. Register the target as versioned and archiving.

8. Delete all records from the new _H table on the target 

    (TODO: confirm this since this wasn't included in the initial procedure)
    (TODO: confirm delete vs truncate. Delete fires triggers and does not reset identity sequences)

9.	Insert records from _H_backup to _H 

    The columns should be identical in name and data type but the order will change.

    (TODO: figure out the listagg or comma trimming to make this work)

```sql
select 
    'insert into xxFEATURECLASSxx_h (' 
from dual
union all
select 
    column_name || ',' 
from 
    user_tab_columns where table_name ='xxFEATURECLASSxx_h'
union all
select
    ') select ' from dual
union all
select 
    column_name || ',' 
from 
    user_tab_columns where table_name ='xxFEATURECLASSxx_h'
union all
select 
    'from xxFEATURECLASSxx_h_bak;' from dual
```

10.	See what we’ve got

Gold.  We've got gold.


### Test Migrate Approach 2
