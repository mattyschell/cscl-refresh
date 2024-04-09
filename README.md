# cscl-refresh

We wish to refresh a lower level enterprise geodatabase in Oracle 19c with recent CSCL production data. 

Data creator schema inventory:

* CSCL
* CSCL_PUB
* CSCL_READ_ONLY

## Option 1: Oracle Data Pump

Assumptions:

* We have previously completed all required setup outside of the geodatabase schemas.  Roles exist, Oracle Spatial and Oracle Text are installed, etc.
* All data owner schemas on the non-prod target will be refreshed.  If not refreshed, these schemas must be abandoned.


### 1. Source SDE: expdp

For reference, here is a sample expdp command from the ESRI white paper under the /doc directory. We typically leave these details to the database administrators. Whatever standard procedure they use is likely good for us.

```sh
expdp \"sde/*****@mcsdboralnx3:1575/aeropro1.esri.com\"
ACCESS_METHOD=EXTERNAL_TABLE directory=data_pump_dir2
filesize=3G parallel=8 exclude=statistics logtime=all metrics=yes
dumpfile=dp_aeropro1_sde_%U.dmp schemas=sde logfile=dpexp_aeropro1_sde.log
```
### 2. Target SDE: drop with cascade option and recreate

Update the password (placeholder: ****) in the script.   

```sql
@sql\recreate-sde.sql
```

### 3. Target SDE: impdp

Reference sample impdp from the white paper under /doc.

```sh
impdp \"sde/*****@mcsdboralnx7:1577/aeropro1.esri.com\" directory=data_pump_dir2
dumpfile=dp_aeropro1_sde_%U.dmp full=y content=all
logfile=data_pump_dir2:dpimp_aeropro1_sde.log
parallel=4 exclude=statistics logtime=all metrics=yes
transform=disable_archive_logging:y,lob_storage:securefile
remap_tablespace=sde:gis_sde,sdeindex:gis_sdeindex
```

Ignore these errors types:

    ORA-31684: Object type INDEX:"SDE"."A1_IX1" already exists

    Error: ORA-31684 'Index already exists' when importing ST_GEOMETRY


### 4. Verify, fix as necessary

Refer to:
    
    sde-check-post-imdp.sql

    sde-post-imdp.sql



### 5. Repeat for data owner schemas

#### 5a 

What do we have on the source that could be exported? Probably cscl and cscl_pub plus some randos we should ignore.

```sql
select distinct(owner) from sde.table_registry order by 1;
```

#### 5b

Drop cscl and cscl_pub on the target.

```sql
@sql\recreate-sde.sql
```

#### 5c

Recreate cscl and cscl_pub with the style that the DBA knows and loves.

Check. Login as cscl and cscl_pub:

```sql
@sql\verify-creator.sql
```


#### 5d

impdp cscl and cscl_pub. 

Ignore errors like: ORA-31684: Object type INDEX:"XXXX"."A377_IX1" already exists


#### 5e

```sql
EXEC dbms_utility.compile_schema( 'CSCL', compile_all => FALSE );
EXEC dbms_utility.compile_schema( 'CSCL_PUB', compile_all => FALSE );
select * from all_indexes d where d.status not in ('VALID','N/A');
```



## Option 2: Use ESRI Tools

This should be possible but will require familiarity with the CSCL data model. And because of the CSCL class extensions any automation must be developed with classic ArcPy 2.7.

## Option 3: ESRI XML Export Import

The CSCL experts suggest this. Unknown if it's even possible.