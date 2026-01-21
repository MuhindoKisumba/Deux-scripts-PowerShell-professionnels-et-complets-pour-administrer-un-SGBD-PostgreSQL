# ==============================
# PostgreSQL MONITORING & SECURITY
# ==============================

$PG_BIN = "C:\Program Files\PostgreSQL\15\bin"
$PG_HOST = "localhost"
$PG_PORT = "5432"
$PG_ADMIN = "postgres"
$PG_PASSWORD = "admin_password"
$LOG_FILE = "C:\pgsql_logs\monitoring.log"

$env:PGPASSWORD = $PG_PASSWORD

function Log {
    param($msg)
    "$(Get-Date) - $msg" | Tee-Object -Append $LOG_FILE
}

# ACTIVE CONNECTIONS
Log "Analyse des connexions actives..."
$queryConn = "
SELECT usename, client_addr, state, query
FROM pg_stat_activity
WHERE state != 'idle';
"

& "$PG_BIN\psql.exe" -h $PG_HOST -U $PG_ADMIN -d postgres -c $queryConn

# DATABASE SIZE
Log "Calcul de la taille des bases..."
$querySize = "
SELECT datname,
pg_size_pretty(pg_database_size(datname)) AS taille
FROM pg_database;
"

& "$PG_BIN\psql.exe" -h $PG_HOST -U $PG_ADMIN -d postgres -c $querySize

# SUSPICIOUS CONNECTIONS
Log "Détection IP suspectes..."
$querySuspect = "
SELECT usename, client_addr, count(*)
FROM pg_stat_activity
GROUP BY usename, client_addr
HAVING count(*) > 5;
"

$result = & "$PG_BIN\psql.exe" -t -h $PG_HOST -U $PG_ADMIN -d postgres -c $querySuspect

if ($result) {
    Log "Connexion suspecte détectée"
    Log $result
}

# LONG RUNNING QUERIES
Log "Requêtes longues..."
$queryLong = "
SELECT pid, now() - query_start AS duration, query
FROM pg_stat_activity
WHERE state='active'
AND now() - query_start > interval '5 minutes';
"

& "$PG_BIN\psql.exe" -h $PG_HOST -U $PG_ADMIN -d postgres -c $queryLong

Log "Monitoring terminé."

