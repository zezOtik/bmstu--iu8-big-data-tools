--liquibase formatted sql

--changeset 12345678:create:table:t_relation_access_map

CREATE TABLE t_relation_access_map
(
    schemaname text not null,
    tablename  text not null,
    ad_group   text not null
)
DISTRIBUTED REPLICATED;
