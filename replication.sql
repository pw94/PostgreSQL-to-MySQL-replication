CREATE OR REPLACE FUNCTION function_replication() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        EXECUTE 'INSERT INTO ' || TG_TABLE_NAME || '_ft' || ' VALUES($1.*);' USING NEW;
        return NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        EXECUTE 'DELETE FROM ' || TG_TABLE_NAME || '_ft' || ' WHERE ID=$1.ID;' USING OLD;
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        EXECUTE 'DELETE FROM ' || TG_TABLE_NAME || '_ft' || ' WHERE ID=$1.ID;' USING OLD;
        EXECUTE 'INSERT INTO ' || TG_TABLE_NAME || '_ft' || ' VALUES($1.*);' USING NEW;
        RETURN NEW;
    END IF;
END;
$BODY$
language plpgsql;

