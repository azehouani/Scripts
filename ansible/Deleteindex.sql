DECLARE @indexName NVARCHAR(128);
DECLARE @tableName NVARCHAR(128);
DECLARE @sql NVARCHAR(MAX);

-- Add the indexes you want to check and potentially delete here
DECLARE @indexesToDelete TABLE (IndexName NVARCHAR(128), TableName NVARCHAR(128));
INSERT INTO @indexesToDelete (IndexName, TableName)
VALUES
('Index1', 'Table1'),
('Index2', 'Table2'),
('Index3', 'Table3'); -- Add as many as needed

DECLARE index_cursor CURSOR FOR
SELECT IndexName, TableName
FROM @indexesToDelete;

OPEN index_cursor;

FETCH NEXT FROM index_cursor INTO @indexName, @tableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Check if the index exists
    IF EXISTS (SELECT 1
               FROM sys.indexes i
               INNER JOIN sys.tables t ON i.object_id = t.object_id
               WHERE i.name = @indexName AND t.name = @tableName)
    BEGIN
        -- If it exists, delete the index
        SET @sql = 'DROP INDEX ' + QUOTENAME(@indexName) + ' ON ' + QUOTENAME(@tableName);
        EXEC sp_executesql @sql;
        PRINT 'Deleted index ' + @indexName + ' on table ' + @tableName;
    END
    ELSE
    BEGIN
        PRINT 'Index ' + @indexName + ' on table ' + @tableName + ' does not exist';
    END

    FETCH NEXT FROM index_cursor INTO @indexName, @tableName;
END

CLOSE index_cursor;
DEALLOCATE index_cursor;
