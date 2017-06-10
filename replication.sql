CREATE OR REPLACE FUNCTION function_replication() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        EXECUTE 'INSERT INTO ' || TG_TABLE_NAME || '_ft' || ' VALUES($1.*);' USING NEW;
        return NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        EXECUTE 'DELETE FROM ' || TG_TABLE_NAME || '_ft' || ' WHERE ID=$1.ID;' USING OLD;
        RETURN OLD;
    END IF;
END;
$BODY$
language plpgsql;

CREATE OR REPLACE FUNCTION function_replication_update() RETURNS TRIGGER AS
$BODY$
DECLARE
    newh hstore = hstore(new);
    oldh hstore = hstore(old);
    key text;
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        FOREACH key IN ARRAY akeys(newh) LOOP
            IF newh->key != oldh->key THEN
                EXECUTE format('UPDATE %s_ft SET %s = %L WHERE ID = %s', TG_TABLE_NAME, key, newh->key, oldh->'id');
            END IF;
        END LOOP;
        RETURN NEW;
    END IF;
END;
$BODY$
language plpgsql;
