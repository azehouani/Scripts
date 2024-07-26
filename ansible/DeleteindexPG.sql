DO $$
DECLARE
    indexRecord RECORD;
BEGIN
    -- Add the indexes you want to check and potentially delete here
    FOR indexRecord IN
        SELECT 'index_name_1' AS index_name, 'table_name_1' AS table_name UNION ALL
        SELECT 'index_name_2', 'table_name_2' UNION ALL
        SELECT 'index_name_3', 'table_name_3'
        -- Add more indexes as needed
    LOOP
        -- Check if the index exists
        IF EXISTS (SELECT 1
                   FROM pg_indexes
                   WHERE indexname = indexRecord.index_name AND tablename = indexRecord.table_name) THEN
            -- If it exists, delete the index
            EXECUTE 'DROP INDEX ' || indexRecord.index_name;
            RAISE NOTICE 'Deleted index % on table %', indexRecord.index_name, indexRecord.table_name;
        ELSE
            RAISE NOTICE 'Index % on table % does not exist', indexRecord.index_name, indexRecord.table_name;
        END IF;
    END LOOP;
END $$;
