import os
import psycopg2
import csv

# Récupération des variables d'environnement
db_config = {
    'host': os.getenv('DB_HOST', 'localhost'),  # Adresse du serveur PostgreSQL, par défaut 'localhost'
    'dbname': os.getenv('DB_NAME'),  # Nom de la base de données
    'user': os.getenv('DB_USER'),  # Nom d'utilisateur PostgreSQL
    'password': os.getenv('DB_PASSWORD'),  # Mot de passe PostgreSQL
    'port': int(os.getenv('DB_PORT', 5432))  # Port PostgreSQL, par défaut 5432
}

# Requête SQL
query = """
SELECT
    userid,
    query AS short_query,
    round(total_exec_time::numeric, 2) AS total_timer,
    calls,
    round(mean_exec_time::numeric, 2) AS mean_ms,
    round((total_exec_time / sum(total_exec_time::numeric) OVER ()) * 100, 2) AS cpu_pct,
    sum(shared_blks_read) AS sum_of_shared_blks_read
FROM
    public.pg_stat_statements
GROUP BY
    userid,
    query,
    total_exec_time,
    mean_exec_time,
    calls
ORDER BY
    cpu_pct DESC
LIMIT 1000;
"""

# Nom du fichier CSV de sortie
output_file = 'query_results.csv'

try:
    # Connexion à la base de données
    connection = psycopg2.connect(**db_config)
    cursor = connection.cursor()

    # Exécution de la requête SQL
    cursor.execute(query)

    # Récupération des résultats
    results = cursor.fetchall()

    # Récupération des noms des colonnes
    columns = [desc[0] for desc in cursor.description]

    # Écriture des résultats dans un fichier CSV
    with open(output_file, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(columns)  # Écriture de l'en-tête
        writer.writerows(results)  # Écriture des données

    print(f"Les résultats ont été exportés avec succès dans le fichier '{output_file}'.")

except Exception as e:
    print(f"Erreur lors de l'exécution de la requête ou de l'exportation : {e}")

finally:
    # Fermeture de la connexion
    if connection:
        cursor.close()
        connection.close()
