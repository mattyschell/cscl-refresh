-- "You must grant the execute privilege on these packages to the public role to create or upgrade the geodatabase" 
--https://pro.arcgis.com/en/pro-app/latest/help/data/geodatabases/manage-oracle/privileges-oracle.htm
GRANT EXECUTE ON DBMS_PIPE TO public;
GRANT EXECUTE ON DBMS_LOCK TO public;
GRANT EXECUTE ON DBMS_UTILITY TO public;
GRANT EXECUTE ON DBMS_SQL TO public;
GRANT EXECUTE ON DBMS_LOB TO public;
GRANT EXECUTE ON UTL_RAW TO public;
DROP USER SDE CASCADE;
CREATE USER "SDE" IDENTIFIED BY **** DEFAULT TABLESPACE "SDEDATA" TEMPORARY TABLESPACE "TEMP" PROFILE "DB_APP_PROFILE";
-- "Privileges required for geodatabase creation or upgrade"
--  DB_APP_PROFILE only governs password policies and the like...
GRANT CREATE PROCEDURE TO "SDE";
GRANT CREATE SEQUENCE TO "SDE";
GRANT CREATE TABLE TO "SDE";
GRANT CREATE TRIGGER TO "SDE";
GRANT CREATE TYPE TO "SDE";
GRANT CREATE VIEW TO "SDE";
GRANT CREATE SYNONYM TO "SDE";
GRANT EXECUTE ON DBMS_CRYPTO to "SDE";
GRANT CREATE INDEXTYPE to "SDE";
GRANT CREATE LIBRARY to "SDE";
GRANT CREATE OPERATOR to "SDE";
GRANT CREATE PUBLIC SYNONYM to "SDE";
GRANT DROP PUBLIC SYNONYM to "SDE";
GRANT EXECUTE ON DBMS_CRYPTO to "SDE";
GRANT ADMINISTER DATABASE TRIGGER to "SDE";
-- optional, carried over from 11g.  Used to debug issues with geodatabase-issued SQL
GRANT SELECT ANY DICTIONARY to "SDE";
--
-- verify connect as SDE
--
--select missing from (
--        select
--            REGEXP_SUBSTR('GRANT EXECUTE ON SYS.DBMS_PIPE TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_LOCK TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_LOB TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_UTILITY TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_SQL TO PUBLIC,GRANT EXECUTE ON SYS.UTL_RAW TO PUBLIC', '[^,]+', 1, LEVEL) AS missing
--        from
--            dual
--        connect by
--            REGEXP_SUBSTR('GRANT EXECUTE ON SYS.DBMS_PIPE TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_LOCK TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_LOB TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_UTILITY TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_SQL TO PUBLIC,GRANT EXECUTE ON SYS.UTL_RAW TO PUBLIC', '[^,]+', 1, LEVEL) IS NOT NULL
--        minus
--        select 
--            'GRANT EXECUTE ON SYS.' || table_name || ' TO PUBLIC'
--        from 
--            all_tab_privs
--        where 
--            table_schema = 'SYS' 
--        and table_name IN ('DBMS_LOB','DBMS_LOCK','DBMS_PIPE','DBMS_UTILITY','DBMS_SQL','UTL_RAW')
--        and grantee = 'PUBLIC'
--    union
--        select regexp_substr('CREATE PROCEDURE,CREATE SEQUENCE,CREATE SESSION,CREATE TABLE,CREATE TRIGGER,CREATE INDEXTYPE,CREATE LIBRARY,CREATE OPERATOR,CREATE PUBLIC SYNONYM,CREATE TYPE,CREATE VIEW,DROP PUBLIC SYNONYM,ADMINISTER DATABASE TRIGGER','[^,]+', 1, level) as missing
--            from dual
--        connect by regexp_substr('CREATE PROCEDURE,CREATE SEQUENCE,CREATE SESSION,CREATE TABLE,CREATE TRIGGER,CREATE INDEXTYPE,CREATE LIBRARY,CREATE OPERATOR,CREATE PUBLIC SYNONYM,CREATE TYPE,CREATE VIEW,DROP PUBLIC SYNONYM,ADMINISTER DATABASE TRIGGER', '[^,]+', 1, level) is not null
--        minus 
--       (
--        select privilege 
--        from 
--            user_sys_privs
--        union
--        select r.privilege
--        from
--            user_role_privs u
--        join
--            role_sys_privs r
--        on 
--            u.granted_role = r.role)
--   union 
--        select 'GRANT EXECUTE ON SYS.DBMS_CRYPTO TO ' || user from dual
--        minus
--        select 
--            'GRANT EXECUTE ON SYS.' || table_name || ' TO ' || user
--        from 
--            all_tab_privs
--        where 
--            table_schema = 'SYS' 
--        and table_name IN ('DBMS_CRYPTO')
--        and grantee = user
--) order by missing;
