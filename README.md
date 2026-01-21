# PostgreSQL Administration & Monitoring avec PowerShell

##  Description du projet

Ce projet fournit **deux scripts PowerShell professionnels** permettant l’**administration complète**, la **sécurisation**, la **surveillance** et l’**audit** d’un serveur **PostgreSQL** en environnement **production**.

Il est destiné aux profils :

* DBA PostgreSQL
* Administrateur Systèmes
* Data Engineer
* DevOps

Les scripts sont adaptés aux environnements **Windows Server / Windows 10+**, avec possibilité d’adaptation vers **Linux (PowerShell Core / pwsh)**.

---

## Structure du projet

```text
postgresql-powershell-admin/
│── postgres_admin.ps1          # Administration générale PostgreSQL
│── postgres_monitoring.ps1     # Monitoring, audit et sécurité
│── README.md                   # Documentation
│── logs/                       # Journaux d’exécution
│── backups/                    # Sauvegardes PostgreSQL
```

---

## Script 1 : `postgres_admin.ps1`

### Objectif

Automatiser l’**administration quotidienne** de PostgreSQL.

### Fonctionnalités

* Vérification et démarrage du service PostgreSQL
* Création de bases de données
* Création des rôles et utilisateurs
* Attribution des privilèges
* Sauvegarde automatique (`pg_dump` format custom)
* Journalisation complète des actions

### Sécurité

* Utilisation d’un compte administrateur PostgreSQL
* Séparation **admin / utilisateur applicatif**
* Logs horodatés pour audit

### Exécution

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
.
\postgres_admin.ps1
```

---

## Script 2 : `postgres_monitoring.ps1`

### Objectif

Surveiller la **santé**, la **sécurité** et la **performance** du serveur PostgreSQL.

### Fonctionnalités

* Connexions actives
* Détection des connexions suspectes
* Analyse des requêtes longues
* Taille des bases de données
* Journalisation des anomalies

### Cas d’usage

* Détection d’attaques internes
* Prévention du surcharge serveur
* Audit de performance

---

## Prérequis

* Windows 10 / Windows Server
* PostgreSQL 12+
* PowerShell 5.1 ou PowerShell Core (pwsh)
* Droits administrateur

### Outils PostgreSQL requis

* `psql`
* `pg_dump`
* `createdb`

---

## Automatisation (Task Scheduler)

Il est recommandé de planifier les scripts :

* `postgres_admin.ps1` → **1 fois par jour** (backup)
* `postgres_monitoring.ps1` → **toutes les 5 ou 10 minutes**

---

## Logs

Les logs sont stockés dans :

```text
C:\pgsql_logs\
├── admin.log
└── monitoring.log
```

Ils permettent :

* Audit de sécurité
* Débogage
* Historique d’exécution

---

## Bonnes pratiques recommandées

✔ Activer SSL (`postgresql.conf`)
✔ Restreindre `pg_hba.conf`
✔ Ne jamais exposer PostgreSQL sur Internet
✔ Sauvegardes hors serveur (offsite)
✔ Utiliser un mot de passe fort

---

## Évolutions possibles

* Alertes Email / Telegram
* Chiffrement des sauvegardes
* Support Linux (cron + pwsh)
* Intégration Grafana / Prometheus
* Haute disponibilité (replication)

---

## Auteur

**Muhindo Kisumba**
Administrateur Systèmes & Bases de Données
Spécialiste PostgreSQL | Linux | PowerShell
