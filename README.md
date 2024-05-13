# cscl-refresh

We wish to refresh a non-production enterprise geodatabase in Oracle 19c with recent Citywide Street Centerline (CSCL) production data. Friends this our CSCL geodatabase, our rules, the trick is never to be afraid. 

Data creator schema inventory:

* CSCL
* CSCL_PUB

## Option 1: Oracle Data Pump

Assumptions:

* We have previously completed all required setup outside of the geodatabase schemas.  Roles exist, Oracle Spatial and Oracle Text are installed, etc.
* All data creator schemas on the non-prod target will be refreshed.  Any data creator schema not refreshed must be abandoned. 


### 1. Source Geodatabase: Expdp All Schemas

Exporting all schemas at the same time reduces the possibility that SDE is out of synch with the data creator schemas.

For reference, here is a sample expdp command from the ESRI white paper under the /doc directory. We typically leave these details to the database administrators. Whatever standard procedure they use will work for us.


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


### 5. Import Data Creator Schemas

#### 5a

Drop and recreate cscl and cscl_pub on the target.

```sql
@sql\recreate-data-creators.sql
```

Check. Login as cscl and cscl_pub:

```sql
@sql\verify-creator.sql
```

#### 5b

impdp cscl and cscl_pub. 

Ignore errors like: ORA-31684: Object type INDEX:"XXXX"."A377_IX1" already exists

#### 5c

```sql
EXEC dbms_utility.compile_schema('CSCL', compile_all => FALSE );
EXEC dbms_utility.compile_schema('CSCL_PUB', compile_all => FALSE );
select * from all_indexes d where d.status not in ('VALID','N/A');
select distinct(owner) from dba_objects where status != 'VALID';
```

### 6 Check it Out

Refer to the checklist in doc\checklist.md

### 7 Post Import Tidying

1. Delete all versions except SDE.DEFAULT
2. Delete all replicas
3. Delete all rows from sde.compress_log  
4. Fully compress the database
5. Scrub security level 3 data
```sql
delete from 
    cscl.commonplace a
where 
    a.security_level = 3;
delete from 
    cscl.featurename a
where 
    a.security_level = 3;
commit;
```
6. Recreate cscl version tree

```
SDE.DEFAULT
    CSCL.WORKINGVERSION (Protected)
        CSCL.DCPWORKVERSION (Public)
        CSCL.DOITTWORKVERSION (Public)
```
7. (optional, out of scope for this repo) Remove the CSCL class extensions 



## Option 2: Use ESRI Tools

This should be possible but will require patience and familiarity with the CSCL data model. And because of the CSCL class extensions any automation must be developed with classic ArcPy 2.7.

## Option 3: ESRI XML Export Import

The CSCL experts suggest this and insist it is possible.