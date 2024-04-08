
select count(*), status from dba_objects where status != 'VALID' group by status;

select * from dba_objects where status != 'VALID';

select 'CREATE OR REPLACE PUBLIC SYNONYM ' || object_name || ' FOR SDE.' || object_name || ';'
from dba_objects where status != 'VALID' and object_type = 'SYNONYM' and object_name not like
'DBA%';

select * from all_indexes d where d.status not in ('VALID','N/A');