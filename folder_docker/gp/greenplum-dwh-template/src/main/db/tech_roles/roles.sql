--liquibase formatted sql

--changeset 12345678:create:role:ldap_users

CREATE ROLE ldap_users NOLOGIN ADMIN cibot;
GRANT CONNECT ON DATABASE adb TO ldap_users;
COMMENT ON ROLE ldap_users IS 'Technical container for all lpad user';

--changeset 12345678:create:role:non_ldap_users

CREATE ROLE non_ldap_users NOLOGIN ADMIN cibot;
GRANT CONNECT ON DATABASE adb TO non_ldap_users;
COMMENT ON ROLE non_ldap_users IS 'Technical container for all non lpad user';

-- changeset 12345678:create:role:dba

CREATE ROLE dba NOLOGIN ADMIN cibot;
COMMENT ON ROLE dba IS 'Data base administrators group';

-- changeset 12345678:create:role:robots

CREATE ROLE robots NOLOGIN ADMIN cibot;
COMMENT ON ROLE robots IS 'Technical users group';

--changeset 12345678:create:group:pxf_select

CREATE ROLE "pxf_select" NOLOGIN ADMIN cibot;
COMMENT ON ROLE "pxf_select" IS 'technical group to read data from pxf';

--changeset 12345678:create:user:presql_etlbot

CREATE ROLE "presql_etlbot" LOGIN IN ROLE non_ldap_users, robots ADMIN cibot;
COMMENT ON ROLE "presql_etlbot" IS 'etl bot to execute presql scripts';

--changeset 12345678:create:role:changelog_reader

CREATE ROLE "changelog_reader" NOLOGIN ADMIN cibot;
COMMENT ON ROLE "changelog_reader" IS 'Role for reading liquebase service tables';
