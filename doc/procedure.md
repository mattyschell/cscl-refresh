## Internal Procedure 

A generic procedure focusing on roles and responsibilities instead of technical details.

| Step | Person | Task |
|-----:|---------------|---------------|
|     1| DBA | investigate and prepare scripts |
|     2| DBA | export sde |
|     3| DBA | export cscl and cscl_pub |
|     4| All | schedule/coordinate timeline for next steps |
|     5| GIS | submit ticket to request DBA on target |
|     6| DBA | spool GIS user grants and privileges to users and roles |
|     7| DBA | grant dba to gis user on target |
|     8| GIS | target drop and recreate sde |
|     9| DBA | run anything that requires sysdba |
|    10| DBA | import sde |
|    11| GIS | verify and fix sde |
|    12| GIS | target drop and recreate data creators |
|    13| DBA | import data creators (cscl and cscl_pub) |
|    14| GIS | verify and fix data creators |
|    15| DBA | revoke dba from gis user |
|    16| DBA | ensure no indirect system privileges exist |



