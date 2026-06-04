# Mon projet PowerShell

# 1. Combien de lignes contient server.log ?

    server.log contient 22 lignes

# 2. Afficher les 5 premières lignes

    2024-01-15 08:00:01 INFO  Application started on port 8080
    2024-01-15 08:00:05 INFO  Connected to Azure SQL Database successfully
    2024-01-15 08:01:22 WARNING High memory usage detected: 78%
    2024-01-15 08:02:45 ERROR Failed to connect to Azure Storage: connection timeout
    2024-01-15 08:03:10 INFO  Request processed: GET /api/health [200]

# 3. Afficher les 3 dernières lignes

    2024-01-15 08:19:30 CRITICAL Azure Key Vault unreachable — secrets cannot be retrieved
    2024-01-15 08:20:00 INFO  Health check passed: all 3 replicas running
    2024-01-15 08:21:00 CRITICAL Disk full on /var/log — logging suspended

# 4. Combien de lignes contiennent ERROR ?

    5 lignes contiennent le mot "ERROR"

# 5. Afficher les lignes WARNING

    ressources/server.log:3:2024-01-15 08:01:22 WARNING High memory usage detected: 78%
    ressources/server.log:7:2024-01-15 08:06:15 WARNING CPU usage spike detected: 92%
    ressources/server.log:12:2024-01-15 08:10:15 WARNING Disk space below threshold: 15% remaining on /dev/sda1
    ressources/server.log:17:2024-01-15 08:16:30 WARNING SSL certificate expires in 14 days for api.azuretech.fr

# 6. Afficher les lignes CRITICAL

    ressources/server.log:18:2024-01-15 08:18:00 CRITICAL Database connection pool exhausted — all 20 connections in use
    ressources/server.log:20:2024-01-15 08:19:30 CRITICAL Azure Key Vault unreachable — secrets cannot be retrieved
    ressources/server.log:22:2024-01-15 08:21:00 CRITICAL Disk full on /var/log — logging suspended

# 7. Compter ERROR et CRITICAL ensemble

    IL y a 8 lignes qui contiennent le mot "ERROR" ou le mot "CRITICAL" dans server.log