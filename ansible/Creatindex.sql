DO $$
DECLARE
    index_name TEXT := 'taser_t_workflow_execution_workflow_id_start_time_status_idx';
    table_name TEXT := 'taser_t_workflow_execution';
BEGIN
    -- Check if the index exists
    IF NOT EXISTS (SELECT 1
                   FROM pg_indexes
                   WHERE indexname = index_name AND tablename = table_name) THEN
        -- If it does not exist, create the index
        EXECUTE 'CREATE INDEX CONCURRENTLY ' || index_name || 
                ' ON ' || table_name || 
                ' (workflow_id, start_time DESC, status) WHERE status = ''DONE''';
        RAISE NOTICE 'Created index % on table %', index_name, table_name;
    ELSE
        RAISE NOTICE 'Index % on table % already exists', index_name, table_name;
    END IF;
END $$;
