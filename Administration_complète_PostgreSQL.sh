# ==============================
# PostgreSQL ADMINISTRATION SCRIPT
# Auteur : Abdiel Kisumba
# ==============================

# CONFIGURATION
$PG_BIN = "C:\Program Files\PostgreSQL\15\bin"
$PG_HOST = "localhost"
$PG_PORT = "5432"
$PG_ADMIN = "postgres"
$PG_PASSWORD = "admin_password"
$LOG_FILE = "C:\pgsql_logs\admin.log"
$BACKUP_DIR = "C:\pgsql_backups"

$env:PGPASSWORD = $PG_PASSWORD

# LOG FUNCTION
function Write-Log {
    param([string]$Message)
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$date - $Message" | Tee-Object -Append $LOG_FILE
}

# CHECK SERVICE
Write-Log "Vérification du service PostgreSQL..."
$service = Get-Service postgresql* -ErrorAction SilentlyContinue
if ($service.Status -ne "Running") {
    Start-Service $service
    Write-Log "Service PostgreSQL démarré."
}

# CREATE DATABASE
$dbName = "gestion_facturation"
Write-Log "Création de la base $dbName..."
& "$PG_BIN\createdb.exe" -h $PG_HOST -p $PG_PORT -U $PG_ADMIN $dbName

# CREATE ROLE
$user = "app_user"
$password = "StrongPass@2026"
Write-Log "Création utilisateur $user..."

$sqlUser = @"
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$user') THEN
      CREATE ROLE $user LOGIN PASSWORD '$password';
   END IF;
END
\$\$;
"@

$sqlUser | & "$PG_BIN\psql.exe" -h $PG_HOST -U $PG_ADMIN -d $dbName

# GRANT PRIVILEGES
Write-Log "Attribution des privilèges..."
& "$PG_BIN\psql.exe" -h $PG_HOST -U $PG_ADMIN -d $dbName `
-c "GRANT ALL PRIVILEGES ON DATABASE $dbName TO $user;"

# BACKUP
$date = Get-Date -Format "yyyyMMdd_HHmm"
$backupFile = "$BACKUP_DIR\$dbName`_$date.backup"
Write-Log "Sauvegarde en cours..."
& "$PG_BIN\pg_dump.exe" -Fc -h $PG_HOST -U $PG_ADMIN $dbName > $backupFile

Write-Log "Sauvegarde terminée : $backupFile"

