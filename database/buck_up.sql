DO $$
DECLARE
    indexRecord RECORD;
    index_exists BOOLEAN;
BEGIN
    -- Add the indexes you want to check and potentially create here
    FOR indexRecord IN
        SELECT 'index1_name' AS index_name, 'table1_name' AS table_name, 'column1_1, column1_2' AS columns UNION ALL
        SELECT 'index2_name', 'table2_name', 'column2_1, column2_2' UNION ALL
        SELECT 'index3_name', 'table3_name', 'column3_1, column3_2, column3_3'
        -- Add more indexes as needed
    LOOP
        -- Check if the index exists
        EXECUTE format('SELECT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = %L AND tablename = %L)', 
                       indexRecord.index_name, indexRecord.table_name)
        INTO index_exists;

        -- If the index does not exist, create the index
        IF NOT index_exists THEN
            EXECUTE format('CREATE INDEX CONCURRENTLY %I ON %I (%s)', 
                           indexRecord.index_name, indexRecord.table_name, indexRecord.columns);
            RAISE NOTICE 'Created index % on table %', indexRecord.index_name, indexRecord.table_name;
        ELSE
            RAISE NOTICE 'Index % on table % already exists', indexRecord.index_name, indexRecord.table_name;
        END IF;
    END LOOP;
END $$;
