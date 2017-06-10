SELECT
    'CREATE TRIGGER '
    || replace(tab_name, '.', '_')
    || ' AFTER INSERT OR DELETE ON '
    || tab_name
    || ' FOR EACH ROW EXECUTE PROCEDURE function_replication();' AS trigger_creation_query
FROM (
    SELECT
        quote_ident(table_schema) || '.' || quote_ident(table_name) as tab_name
    FROM
        information_schema.tables
    WHERE
        table_schema NOT IN ('pg_catalog', 'information_schema')
        AND table_schema NOT LIKE 'pg_toast%'
        AND table_type != 'FOREIGN TABLE'
) tablist
UNION
SELECT
    'CREATE TRIGGER '
    || replace(tab_name, '.', '_')
    || '_u'
    || ' AFTER UPDATE ON '
    || tab_name
    || ' FOR EACH ROW EXECUTE PROCEDURE function_replication_update();' AS trigger_creation_query
FROM (
    SELECT
        quote_ident(table_schema) || '.' || quote_ident(table_name) as tab_name
    FROM
        information_schema.tables
    WHERE
        table_schema NOT IN ('pg_catalog', 'information_schema')
        AND table_schema NOT LIKE 'pg_toast%'
        AND table_type != 'FOREIGN TABLE'
) tablist;
