
# GREENPLUM-DWH
Project contains template for storing SQL code for objects in Greenplum DWH

This structure provides compliance with Liquibase migration tool requirements for correct migrations appliance

## Repository sctructure

There are 2 main directories which contain SQL code - migrations - for a Greenplum cluster:
- `src/main/db` - this folder contains scripts for database global objects like schemas and roles ddl. If you want to add DDL for new schemas/roles or add objects for `public` schema, you should do it here, probably even inside existing files.
- `schemas/` - this folder containes code for all user schemas, like `sample_schema_ods/_dds/_marts` in here. Every schema folder contains sql files for init, drops and grants, and tables/views/functions/sequences folders for corresponding objects SQL. There is also a config `changelog.xml` file in a root of each schema folder which defines the appliance order and sources (either `.sql` files or other `changelog.xml` files - see [how Liquibase works](https://docs.liquibase.com/)) for migrations. If you want to add objects for your new schema, you should create new folder inside `schemas/` and copy structure from one of the existing schemas, then change/rename/create new tables/views/functions.




## How to run locally
You can run & test Greenplum DWH locally via Docker Compose. To do so, run the following command:
```sh
docker compose -f 'docker-compose.yml' up -d --build
```

This will create and run 4 containers:
- `gpdb` - Greenplum DWH public image with PXF. This instance will have only one active user from scratch - `gpadmin`
- `gradle-runner` - Gradle image which runs custom code. In this case, it runs Liquibase plugin which applies all migrations from `src/main/db` folder and all migrations from `schemas/` directory for schemas defined in a [settings.gradle](./settings.gradle) file in `defaultSchemas` and `includeOnlySchemas` variables
- `integration-tests` - this container runs custom integration tests for Greenplum DWH (see [this repo](https://github.com/ArtemiyNaumov/greenplum-dwh-integration-tests) for more details)
- `sql-static-tests` - this container runs custom SQL parser to check your SQL scripts for compliance with defined rules and anti-patterns (see [this repo](https://github.com/ArtemiyNaumov/greenplum-dwh-sql-static-tests) for more details)

Firstly, GP container will start and initialize a database. Secondly, Gradle-runner will wait until GP cluster starts to accept connections, then it will run Liquibase, which connects to the cluster and applies all given migrations. After that, integration tests begin - if there are any warnings or failures, it will print info about it in a container log.  
Static SQL tests you can run at any time, it does not have any dependencies and can be started independently