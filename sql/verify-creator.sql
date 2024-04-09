-- a "data creator" is missing privileges if anything is returned
-- when executed from the data creator 
-- https://pro.arcgis.com/en/pro-app/help/data/geodatabases/manage-oracle/privileges-oracle.htm
select missing from (
        select
            REGEXP_SUBSTR('GRANT EXECUTE ON SYS.DBMS_PIPE TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_LOCK TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_LOB TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_UTILITY TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_SQL TO PUBLIC,GRANT EXECUTE ON SYS.UTL_RAW TO PUBLIC', '[^,]+', 1, LEVEL) AS missing
        from
            dual
        connect by
            REGEXP_SUBSTR('GRANT EXECUTE ON SYS.DBMS_PIPE TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_LOCK TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_LOB TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_UTILITY TO PUBLIC,GRANT EXECUTE ON SYS.DBMS_SQL TO PUBLIC,GRANT EXECUTE ON SYS.UTL_RAW TO PUBLIC', '[^,]+', 1, LEVEL) IS NOT NULL
        minus
        select 
            'GRANT EXECUTE ON SYS.' || table_name || ' TO PUBLIC'
        from 
            all_tab_privs
        where 
            table_schema = 'SYS' 
        and table_name IN ('DBMS_LOB','DBMS_LOCK','DBMS_PIPE','DBMS_UTILITY','DBMS_SQL','UTL_RAW')
        and grantee = 'PUBLIC'
    union
        select regexp_substr('CREATE SEQUENCE,CREATE SESSION,CREATE TABLE,CREATE TRIGGER,CREATE VIEW','[^,]+', 1, level) as missing
            from dual
        connect by regexp_substr('CREATE SEQUENCE,CREATE SESSION,CREATE TABLE,CREATE TRIGGER,CREATE VIEW', '[^,]+', 1, level) is not null
        minus 
        (
        select privilege 
        from 
            user_sys_privs
        union
        select r.privilege
        from
            user_role_privs u
        join
            role_sys_privs r
        on 
            u.granted_role = r.role)
) order by missing