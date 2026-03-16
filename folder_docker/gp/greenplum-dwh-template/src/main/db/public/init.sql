--liquibase formatted sql

--changeset 12345678:create:roles:public

CREATE ROLE public_r NOLOGIN ADMIN gpadmin;
CREATE ROLE public_w NOLOGIN ADMIN gpadmin;
CREATE ROLE public_x NOLOGIN ADMIN gpadmin;
CREATE ROLE public_rw NOLOGIN in role public_r, public_w ADMIN gpadmin;
CREATE ROLE public_rwx NOLOGIN in role public_rw, public_x ADMIN gpadmin;

--changeset 12345678:set:search_path:public runAlways:true runOnChange:true
set search_path to public;
