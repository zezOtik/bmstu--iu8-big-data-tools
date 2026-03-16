--liquibase formatted sql

--changeset 12345678:grant:role:robots runOnChange:true

GRANT robots TO cibot;

--changeset 12345678:grant:role:dba runOnChange:true failOnError:false

GRANT dba TO cibot;

--changeset 12345678:grant:select:pxf runOnChange:true

GRANT SELECT ON PROTOCOL pxf TO pxf_select;
