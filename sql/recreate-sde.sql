-- "You must grant the execute privilege on these packages to the public role to create or upgrade the geodatabase" 
--https://pro.arcgis.com/en/pro-app/latest/help/data/geodatabases/manage-oracle/privileges-oracle.htm
-- these require SYSDBA
--    most are default granted to public
--    and the others should have been granted in the past
--    check dba_tab_privs to confirm
GRANT EXECUTE ON sys.DBMS_PIPE TO public;
GRANT EXECUTE ON sys.DBMS_LOCK TO public;
GRANT EXECUTE ON sys.DBMS_UTILITY TO public;
GRANT EXECUTE ON sys.DBMS_SQL TO public;
GRANT EXECUTE ON sys.DBMS_LOB TO public;
GRANT EXECUTE ON sys.UTL_RAW TO public;
-- these require DBA
DROP USER SDE CASCADE;
CREATE USER "SDE" IDENTIFIED BY "*****" DEFAULT TABLESPACE "SDEDATA" TEMPORARY TABLESPACE "TEMP" PROFILE "DB_APP_PROFILE";
alter user sde quota unlimited on sdedata;
--"Privileges required for geodatabase creation or upgrade"
--     DB_APP_PROFILE only governs password policies and the like...
GRANT CREATE SESSION TO "SDE";
GRANT CREATE PROCEDURE TO "SDE";
GRANT CREATE SEQUENCE TO "SDE";
GRANT CREATE TABLE TO "SDE";
GRANT CREATE TRIGGER TO "SDE";
GRANT CREATE TYPE TO "SDE";
GRANT CREATE VIEW TO "SDE";
GRANT CREATE SYNONYM TO "SDE";
GRANT CREATE INDEXTYPE to "SDE";
GRANT CREATE LIBRARY to "SDE";
GRANT CREATE OPERATOR to "SDE";
GRANT CREATE PUBLIC SYNONYM to "SDE";
GRANT DROP PUBLIC SYNONYM to "SDE";
GRANT ADMINISTER DATABASE TRIGGER to "SDE";
-- optional, carried over from 11g.  Used to debug issues with geodatabase-issued SQL
GRANT SELECT ANY DICTIONARY to "SDE";
-- this requires SYSDBA and is required
--    see sql/test-dbmscrypto.sql
GRANT EXECUTE ON DBMS_CRYPTO to "SDE";
