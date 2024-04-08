# cscl-refresh

We wish to refresh a lower level enterprise geodatabase in Oracle 19c with recent CSCL production data. 

Data owner schema inventory:

* CSCL
* CSCL_PUB
* CSCL_READ_ONLY

## Option 1: Oracle Data Pump


### 1. Source SDE: expdp

Here is a sample expdp command from the ESRI white paper under the doc directory.  

```sh
expdp \"sde/*****@mcsdboralnx3:1575/aeropro1.esri.com\"
ACCESS_METHOD=EXTERNAL_TABLE directory=data_pump_dir2
filesize=3G parallel=8 exclude=statistics logtime=all metrics=yes
dumpfile=dp_aeropro1_sde_%U.dmp schemas=sde logfile=dpexp_aeropro1_sde.log
```
### 2. Target SDE: drop with cascade option and recreate

```sql
@sql\recreate-sde.sql
```

### 3. Target SDE: impdp

Sample impdp from the white paper under /doc

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




## Option 2: Use ESRI Tools

This should be possible but will require familiarity with the CSCL data model. And because of the CSCL class extensions any automation must be developed with classic ArcPy 2.7.

## Option 3: ESRI XML Export Import

The CSCL experts suggest this. Unknown if it's even possible.