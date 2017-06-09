SELECT
    'CREATE TRIGGER '
    || tab_name
    || ' AFTER INSERT OR UPDATE OR DELETE FOR EACH ROW EXECUTE PROCEDURE function_replication();' AS trigger_creation_query
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
