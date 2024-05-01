## Check it Out

As far as we know there is no documentation describing the CSCL schema or data model.  This checklist is not intended to be complete or comprehensive. It is intended to be a sample that is good enough to catch broad categories of refresh failures.

### Database

1. No invalid database objects in CSCL

```sql
select count(*) from user_objects where status <> 'VALID';
```

2. Some (but not all) versioned views. The CSCL team has enabled SQL access on a subset of CSCL versioned feature classes.

```sql
select count(*) from user_views where view_name like '%EVW';
```

3. Geometries remain stored in legacy SDELOB. The shape column should contain numeric pointers to the LOBs.

```sql
select min(shape) from centerline;
```

### Geodatabase

Review CSCL using classic 32 bit ArcCatalog.

1. One feature dataset named CSCL

2. 10 feature classes and 3 relationship classes inside the CSCL feature dataset

3. 64 additional registered feature classes if the source is CSCL production. In the ArcCatalog contents pane sort on "Type" and highlight.

4. 43 relationship classes. Sort on "Type" in the ArcCatalog contents pane.

5. 42 registered feature tables. Sort on "Type" in the ArcCatalog contents pane.

6. No registered archive feature tables. These table names end with "_H" 


### Data

1. Preview a couple of feature classes. You must have the CSCL class extensions installed.

2. If any members of the CSCL team are available ask them to perform test edits.