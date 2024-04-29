## Internal Procedure 

A generic procedure focusing on roles and responsibilities instead of technical details.

| Step | Person | Task |
|-----:|---------------|---------------|
|     1| DBA | investigate and prepare scripts |
|     2| DBA | export sde |
|     3| DBA | export cscl and scl_pub |
|     4| All | schedule/coordinate timeline for next steps |
|     5| DBA | grant dba to gis user on target |
|     6| GIS | target drop and recreate sde |
|     7| DBA | run anything that requires sysdba |
|     8| DBA | import sde |
|     9| GIS | verify and fix sde |
|    10| GIS | target drop and recreate data creators |
|    11| DBA | import data creators |
|    12| GIS | verify and fix data creators |
|    13| DBA | revoke dba from gis user |



