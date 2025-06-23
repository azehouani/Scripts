static def data_retention(inputDataDuration) {
    println "[INFO] Starting data retention with duration: ${inputDataDuration}"

    Sql sql = init_sql_connection()
    if (sql == null) {
        println "[ERROR] SQL connection failed"
        return null
    }

    try {
        String data_retention = 'sql/call_function_data_retention.sql'
        def sql_request = get_sql_request_from_file(data_retention)

        println "[INFO] Executing SQL request..."
        execute_select_request(sql, sql_request, inputDataDuration)

        println "[INFO] SQL request executed successfully"

    } catch (Exception e) {
        println "[ERROR] Exception during SQL execution: ${e.message}"
    } finally {
        sql.close()
        println "[INFO] SQL connection closed"
    }
}

// ---------------- Main
static def main(String... args) {
    if (args.length > 0) {
        try {
            int inputDataDuration = Integer.parseInt(args[0])
            println "[INFO] Input argument parsed: ${inputDataDuration}"
            data_retention(inputDataDuration)
            println "[INFO] Script execution completed successfully"
        } catch (Exception e) {
            println "[ERROR] Failed to parse input or execute script: ${e.message}"
        }
    } else {
        println "[WARN] No input arguments"
    }
}
