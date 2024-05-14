-- as sde or dba
-- invalid objects will exist in data creator schemmas
select count(*), status from dba_objects where status != 'VALID' group by status;
-- take a look
select * from dba_objects where status != 'VALID';
-- none should be in SDE
select distinct owner from dba_objects where status != 'VALID';
-- have not needed this, from the white paper I think
select 'CREATE OR REPLACE PUBLIC SYNONYM ' || object_name || ' FOR SDE.' || object_name || ';'
from dba_objects where status != 'VALID' and object_type = 'SYNONYM' and object_name not like
'DBA%';
-- should be none here
select * from all_indexes d where d.status not in ('VALID','N/A');