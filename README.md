# TP PowerShell — Scripting et automatisation

**Durée estimée :** 6h  
**Prérequis :** savoir utiliser `cd`, `ls`, lancer Python et npm, avoir Git installé  
**Environnement :**
- Windows → PowerShell 5.1 (intégré) ou PowerShell 7 (recommandé)
- macOS / Linux → PowerShell 7 requis (`brew install powershell` ou `apt install powershell`)

> **Ouvrir PowerShell :**
> - Windows : clic droit sur le menu Démarrer → "Windows PowerShell" ou "Terminal"
> - macOS : `pwsh` dans le Terminal

---

## Objectifs de la journée

À la fin de ce TP vous saurez naviguer dans PowerShell, manipuler des fichiers, exploiter le pipeline PowerShell, écrire des scripts `.ps1` réutilisables et automatiser des tâches DevOps — depuis Windows comme depuis macOS.

---

## Mise en place

```powershell
# Cloner le repo du TP
git clone <url-fournie-par-le-formateur>
Set-Location TP-PowerShell-Scripting

# Vérifier la version de PowerShell
$PSVersionTable.PSVersion

# Vérifier le dossier courant
Get-Location
Get-ChildItem
```

> **Politique d'exécution (Windows uniquement) :**  
> Si PowerShell refuse d'exécuter vos scripts, lancez cette commande une seule fois :
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

---

## Étape 1 — Découverte de PowerShell (45 min)

### Concept

PowerShell est un shell **orienté objet** — contrairement à Bash, les commandes ne retournent pas du texte brut mais des **objets** avec des propriétés. Cela rend le filtrage et la manipulation très puissants.

Les commandes PowerShell s'appellent des **cmdlets** et suivent toujours la convention `Verbe-Nom`.

### Commandes essentielles

| Cmdlet PowerShell | Équivalent Bash | Rôle |
|-------------------|-----------------|------|
| `Get-ChildItem` (`ls`, `dir`) | `ls` | Lister les fichiers |
| `Set-Location` (`cd`) | `cd` | Changer de dossier |
| `Get-Location` (`pwd`) | `pwd` | Dossier courant |
| `New-Item` | `mkdir` / `touch` | Créer fichier ou dossier |
| `Copy-Item` | `cp` | Copier |
| `Move-Item` | `mv` | Déplacer / renommer |
| `Remove-Item` | `rm` | Supprimer |
| `Get-Content` | `cat` | Lire un fichier |
| `Write-Output` | `echo` | Afficher du texte |
| `Clear-Host` (`cls`) | `clear` | Vider le terminal |

### Se repérer dans PowerShell

```powershell
# Obtenir de l'aide sur n'importe quelle cmdlet
Get-Help Get-ChildItem
Get-Help Get-ChildItem -Examples

# Lister toutes les cmdlets disponibles
Get-Command

# Chercher une cmdlet par mot-clé
Get-Command -Verb "Get"
Get-Command *Item*

# Les alias courants (raccourcis)
Get-Alias ls
Get-Alias cd
```

> **Astuce :** PowerShell a des alias pour les commandes Unix courantes (`ls`, `cd`, `pwd`, `cat`, `echo`). Ils fonctionnent, mais préférez les cmdlets complètes dans les scripts pour la lisibilité.

---

### Exercice 1.1 — Créer une arborescence de projet

Créez la structure suivante **uniquement avec des cmdlets PowerShell** :

```
mon-projet/
├── src/
│   └── app.ps1
├── logs/
│   └── app.log
├── config/
│   └── settings.txt
└── README.txt
```

**Instructions :**
```powershell
# 1. Créer le dossier mon-projet et ses sous-dossiers
New-Item -ItemType Directory -Path "mon-projet/src"
New-Item -ItemType Directory -Path "mon-projet/logs"
New-Item -ItemType Directory -Path "mon-projet/config"

# 2. Créer les fichiers
New-Item -ItemType File -Path "mon-projet/src/app.ps1"
New-Item -ItemType File -Path "mon-projet/logs/app.log"
New-Item -ItemType File -Path "mon-projet/config/settings.txt"

# 3. Écrire dans README.txt
"# Mon projet PowerShell" | Out-File "mon-projet/README.txt"

# 4. Vérifier l'arborescence
Get-ChildItem "mon-projet" -Recurse
```

---

### Exercice 1.2 — Manipuler les fichiers

```powershell
# 1. Copier server.log dans le dossier logs/
Copy-Item "ressources/server.log" "mon-projet/logs/"

# 2. Renommer la copie en app.log
Rename-Item "mon-projet/logs/server.log" "app.log"

# 3. Afficher le contenu
Get-Content "mon-projet/logs/app.log"

# 4. Créer une sauvegarde
Copy-Item "mon-projet/logs/app.log" "mon-projet/logs/app.log.bak"

# 5. Lister le dossier logs
Get-ChildItem "mon-projet/logs/" | Format-Table Name, Length, LastWriteTime
```

---

### Pour aller plus loin — Étape 1

```powershell
# Afficher les propriétés d'un objet fichier
Get-Item "ressources/server.log" | Select-Object Name, Length, LastWriteTime

# Créer plusieurs dossiers en une commande
"src","tests","docs","logs" | ForEach-Object { New-Item -ItemType Directory -Path "projet/$_" }

# Trouver tous les fichiers .log dans le dossier courant
Get-ChildItem -Recurse -Filter "*.log"

# Afficher la taille totale d'un dossier
(Get-ChildItem "mon-projet" -Recurse | Measure-Object -Property Length -Sum).Sum
```

---

## Étape 2 — Lire, filtrer et exporter (45 min)

### Concept

PowerShell retourne des **objets**, pas du texte. Le pipeline `|` passe ces objets d'une cmdlet à l'autre, ce qui permet un filtrage très précis.

### Cmdlets de lecture et filtrage

| Cmdlet | Rôle | Exemple |
|--------|------|---------|
| `Get-Content` | Lire un fichier | `Get-Content server.log` |
| `Select-String` | Chercher un motif (comme grep) | `Select-String "ERROR" server.log` |
| `Where-Object` | Filtrer des objets | `... \| Where-Object { $_.Length -gt 100 }` |
| `Select-Object` | Choisir des propriétés | `... \| Select-Object Name, Length` |
| `Sort-Object` | Trier | `... \| Sort-Object Length` |
| `Measure-Object` | Compter, sommer, moyenner | `... \| Measure-Object -Line` |
| `Out-File` | Écrire dans un fichier | `... \| Out-File rapport.txt` |
| `Export-Csv` | Exporter en CSV | `... \| Export-Csv data.csv` |

### La variable automatique `$_`

Dans un pipeline, `$_` représente **l'objet courant** :

```powershell
# Afficher le nom de chaque fichier .log
Get-ChildItem "*.log" | ForEach-Object { Write-Output $_.Name }

# Filtrer les fichiers de plus de 1 Ko
Get-ChildItem | Where-Object { $_.Length -gt 1024 }
```

---

### Exercice 2.1 — Analyser server.log avec PowerShell

```powershell
# 1. Combien de lignes contient server.log ?
(Get-Content "ressources/server.log").Count

# 2. Afficher les 5 premières lignes
Get-Content "ressources/server.log" | Select-Object -First 5

# 3. Afficher les 3 dernières lignes
Get-Content "ressources/server.log" | Select-Object -Last 3

# 4. Combien de lignes contiennent ERROR ?
(Select-String "ERROR" "ressources/server.log").Count

# 5. Afficher les lignes WARNING
Select-String "WARNING" "ressources/server.log"

# 6. Afficher les lignes CRITICAL
Select-String "CRITICAL" "ressources/server.log"

# 7. Compter ERROR et CRITICAL ensemble
(Select-String "ERROR|CRITICAL" "ressources/server.log").Count
```

---

### Exercice 2.2 — Générer un rapport

```powershell
# Construire un rapport structuré
$logFile = "ressources/server.log"
$contenu = Get-Content $logFile

$rapport = @"
=== RAPPORT DE LOGS ===
Total lignes : $($contenu.Count)
Erreurs      : $((Select-String "ERROR" $logFile).Count)
Warnings     : $((Select-String "WARNING" $logFile).Count)
Critiques    : $((Select-String "CRITICAL" $logFile).Count)
"@

# Afficher dans le terminal
Write-Output $rapport

# Sauvegarder dans un fichier
$rapport | Out-File "rapport.txt" -Encoding UTF8
Write-Output "Rapport sauvegardé : rapport.txt"

# Extraire les erreurs dans un fichier séparé
Select-String "ERROR" $logFile | ForEach-Object { $_.Line } | Out-File "erreurs.txt"
```

---

### Pour aller plus loin — Étape 2

```powershell
# Exporter les résultats en CSV
Get-ChildItem "ressources/" | Select-Object Name, Length, LastWriteTime | Export-Csv "fichiers.csv" -NoTypeInformation

# Compter les occurrences par niveau de log
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")
$niveaux | ForEach-Object {
    $nb = (Select-String $_ "ressources/server.log").Count
    [PSCustomObject]@{ Niveau = $_; Occurrences = $nb }
} | Format-Table

# Chercher sans tenir compte de la casse
Select-String -Pattern "error" -Path "ressources/server.log" -CaseSensitive:$false
```

---

## Avant d'écrire vos premiers scripts

Avant de passer aux scripts, trois notions essentielles que vous allez croiser à chaque exercice :

### Pas de shebang en PowerShell

Contrairement à Bash, les scripts PowerShell n'ont **pas besoin d'une ligne `#!`** en début de fichier. L'extension `.ps1` suffit à indiquer au système qu'il s'agit d'un script PowerShell.

En revanche, il est courant d'ajouter un commentaire d'en-tête pour documenter le script :

```powershell
# mon-script.ps1 — Description de ce que fait le script
# Auteur : ...
```

---

### La politique d'exécution (ExecutionPolicy)

Par défaut sur Windows, PowerShell **refuse d'exécuter des scripts** `.ps1` pour des raisons de sécurité. Vous devez autoriser l'exécution une seule fois avec :

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

| Option | Signification |
|--------|--------------|
| `RemoteSigned` | Autorise les scripts locaux, bloque les scripts téléchargés non signés |
| `Scope CurrentUser` | S'applique uniquement à votre compte — pas besoin d'être administrateur |

Sur **macOS/Linux** avec PowerShell 7, cette restriction n'existe pas — vos scripts s'exécutent directement.

> **Règle :** faites cette commande une seule fois sur votre machine Windows. Elle persiste entre les sessions.

---

### `.\script.ps1` vs `pwsh -File script.ps1`

Il existe deux façons de lancer un script PowerShell :

| Commande | Ce qui se passe |
|----------|----------------|
| `.\mon-script.ps1` | Lance le script dans la session PowerShell courante — les variables et fonctions définies restent disponibles après l'exécution. |
| `pwsh -File mon-script.ps1` | Lance le script dans une nouvelle session PowerShell isolée — propre, sans hériter de l'environnement actuel. |

Dans ce TP, on utilise toujours `.\script.ps1` — c'est la pratique standard au quotidien.

> **Note :** sur macOS/Linux, le backslash `\` fonctionne, mais vous pouvez aussi utiliser `./mon-script.ps1` avec un slash normal.

---

## Étape 3 — Variables et conditions (1h)

### Variables

```powershell
# Déclarer et utiliser une variable
$nomProjet = "NexaCloud"
$port = 5001
Write-Output "Projet : $nomProjet, Port : $port"

# Typage explicite (optionnel mais recommandé dans les scripts)
[string]$nom   = "NexaCloud"
[int]$port     = 5001
[bool]$debug   = $true

# Tableau
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")
Write-Output $niveaux[0]   # INFO
Write-Output $niveaux.Count

# Hashtable (dictionnaire)
$config = @{
    projet = "NexaCloud"
    port   = 5001
    env    = "development"
}
Write-Output $config["projet"]
Write-Output $config.port
```

### Conditions

```powershell
$nb = 5

if ($nb -gt 10) {
    Write-Output "Grand"
} elseif ($nb -eq 5) {
    Write-Output "Exactement 5"
} else {
    Write-Output "Petit"
}
```

**Opérateurs de comparaison PowerShell :**

| Opérateur | Signification | Exemple |
|-----------|--------------|---------|
| `-eq` | égal | `$a -eq $b` |
| `-ne` | différent | `$a -ne $b` |
| `-gt` | supérieur | `$a -gt 5` |
| `-lt` | inférieur | `$a -lt 10` |
| `-ge` | supérieur ou égal | `$a -ge 3` |
| `-like` | correspondance avec joker | `$s -like "Error*"` |
| `-match` | correspondance regex | `$s -match "\d+"` |
| `-and` | ET logique | `$a -gt 0 -and $b -lt 10` |
| `-or` | OU logique | `$a -eq 1 -or $b -eq 2` |
| `-not` | NON logique | `-not $condition` |

---

### Exercice 3.1 — Script avec variables

Créez `mon-projet/src/info.ps1` :

```powershell
# info.ps1 — Affiche des informations sur l'environnement

$nomProjet = "NexaCloud"
$version   = "1.1.0"
$logFile   = "ressources/server.log"

Write-Output "==============================="
Write-Output "  Projet   : $nomProjet"
Write-Output "  Version  : $version"
Write-Output "==============================="

if (Test-Path $logFile) {
    $nbLignes = (Get-Content $logFile).Count
    Write-Output "  Log      : $logFile ($nbLignes lignes)"
} else {
    Write-Output "  Log      : fichier introuvable !"
}

Write-Output "==============================="
```

```powershell
# Exécuter le script
.\mon-projet\src\info.ps1
```

---

### Exercice 3.2 — Script de vérification des logs

Créez `mon-projet/src/check-logs.ps1` :

```powershell
# check-logs.ps1 — Vérifie l'état des logs et alerte si nécessaire

$logFile       = "ressources/server.log"
$seuilErreurs  = 3

if (-not (Test-Path $logFile)) {
    Write-Error "Le fichier $logFile n'existe pas."
    exit 1
}

$nbErreurs   = (Select-String "ERROR"    $logFile).Count
$nbCritiques = (Select-String "CRITICAL" $logFile).Count
$nbWarnings  = (Select-String "WARNING"  $logFile).Count
$nbInfos     = (Select-String "INFO"     $logFile).Count

Write-Output "=== Analyse de $logFile ==="
Write-Output "  INFO     : $nbInfos"
Write-Output "  WARNING  : $nbWarnings"
Write-Output "  ERROR    : $nbErreurs"
Write-Output "  CRITICAL : $nbCritiques"
Write-Output "==========================="

if ($nbCritiques -gt 0) {
    Write-Warning "ALERTE CRITIQUE : $nbCritiques incident(s) critique(s) détecté(s) !"
} elseif ($nbErreurs -gt $seuilErreurs) {
    Write-Warning "ATTENTION : $nbErreurs erreurs détectées (seuil : $seuilErreurs)"
} else {
    Write-Output "OK : les logs sont dans les normes."
}
```

```powershell
.\mon-projet\src\check-logs.ps1
```

---

### Pour aller plus loin — Étape 3

```powershell
# Passer le fichier en paramètre du script
# En haut du script, remplacer la ligne $logFile = ... par :
param(
    [string]$LogFile = "ressources/server.log",
    [int]$Seuil = 3
)
# Appel : .\check-logs.ps1 -LogFile "autre.log" -Seuil 5

# Switch (comme un if/elseif chaîné)
$niveau = "ERROR"
switch ($niveau) {
    "INFO"     { Write-Output "Informatif" }
    "WARNING"  { Write-Output "Attention" }
    "ERROR"    { Write-Output "Erreur !" }
    "CRITICAL" { Write-Output "CRITIQUE !" }
    default    { Write-Output "Inconnu" }
}
```

---

## Étape 4 — Boucles et fonctions (1h)

### Les boucles

```powershell
# ForEach-Object (pipeline)
1..5 | ForEach-Object { Write-Output "Itération $_" }

# foreach (boucle classique)
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")
foreach ($niveau in $niveaux) {
    Write-Output "Niveau : $niveau"
}

# for (numérique)
for ($i = 1; $i -le 5; $i++) {
    Write-Output "Tour $i"
}

# while
$compteur = 0
while ($compteur -lt 3) {
    Write-Output "Compteur : $compteur"
    $compteur++
}
```

### Les fonctions

```powershell
# Déclarer une fonction
function Afficher-Message {
    param([string]$Texte, [string]$Couleur = "White")
    Write-Host $Texte -ForegroundColor $Couleur
}

# Appeler la fonction
Afficher-Message "Bonjour" "Green"
Afficher-Message "Attention" "Yellow"
Afficher-Message "Erreur" "Red"

# Fonction qui retourne une valeur
function Compter-Niveau {
    param([string]$Niveau, [string]$Fichier)
    return (Select-String $Niveau $Fichier).Count
}

$nbErreurs = Compter-Niveau -Niveau "ERROR" -Fichier "ressources/server.log"
Write-Output "Erreurs : $nbErreurs"
```

---

### Exercice 4.1 — Boucle sur les niveaux de log

Créez `mon-projet/src/analyse-niveaux.ps1` :

```powershell
# analyse-niveaux.ps1 — Compte chaque niveau de log

$logFile = "ressources/server.log"
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")

Write-Output "=== Analyse par niveau ==="

foreach ($niveau in $niveaux) {
    $nb = (Select-String $niveau $logFile).Count
    Write-Output "  $niveau : $nb occurrence(s)"
}

$total = (Get-Content $logFile).Count
Write-Output "=========================="
Write-Output "  TOTAL : $total lignes"
```

```powershell
.\mon-projet\src\analyse-niveaux.ps1
```

---

### Exercice 4.2 — Script avec fonctions

Créez `mon-projet/src/rapport.ps1` :

```powershell
# rapport.ps1 — Génère un rapport complet avec des fonctions

param([string]$LogFile = "ressources/server.log")

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$rapportPath = "mon-projet/logs/rapport-$timestamp.txt"

# ── Fonctions ──────────────────────────────────────────────────────────

function Ecrire-Titre {
    param([string]$Titre)
    $separateur = "=" * 45
    Write-Output $separateur
    Write-Output "  $Titre"
    Write-Output $separateur
}

function Compter-Niveau {
    param([string]$Niveau, [string]$Fichier)
    return (Select-String $Niveau $Fichier).Count
}

function Ecrire-Rapport {
    param([string]$Section, [string]$Contenu, [string]$Fichier)
    Add-Content -Path $Fichier -Value ""
    Add-Content -Path $Fichier -Value "--- $Section ---"
    Add-Content -Path $Fichier -Value $Contenu
}

# ── Script principal ────────────────────────────────────────────────────

if (-not (Test-Path $LogFile)) {
    Write-Error "Fichier introuvable : $LogFile"
    exit 1
}

Ecrire-Titre "RAPPORT D'ANALYSE — $(Get-Date -Format 'dd/MM/yyyy HH:mm')"

$info     = Compter-Niveau "INFO"     $LogFile
$warning  = Compter-Niveau "WARNING"  $LogFile
$error    = Compter-Niveau "ERROR"    $LogFile
$critical = Compter-Niveau "CRITICAL" $LogFile

Write-Output "  INFO     : $info"
Write-Output "  WARNING  : $warning"
Write-Output "  ERROR    : $error"
Write-Output "  CRITICAL : $critical"

# Écrire dans le fichier rapport
"RAPPORT D'ANALYSE — $(Get-Date -Format 'dd/MM/yyyy HH:mm')" | Out-File $rapportPath -Encoding UTF8

Ecrire-Rapport "Compteurs" "INFO=$info  WARNING=$warning  ERROR=$error  CRITICAL=$critical" $rapportPath
Ecrire-Rapport "Incidents critiques" (Select-String "CRITICAL" $LogFile | ForEach-Object { $_.Line } | Out-String) $rapportPath
Ecrire-Rapport "Erreurs" (Select-String "ERROR" $LogFile | ForEach-Object { $_.Line } | Out-String) $rapportPath

Write-Output ""
Write-Output "Rapport sauvegardé : $rapportPath"
```

```powershell
.\mon-projet\src\rapport.ps1
```

---

### Pour aller plus loin — Étape 4

```powershell
# Utiliser des objets personnalisés dans une boucle
$resultats = foreach ($niveau in @("INFO","WARNING","ERROR","CRITICAL")) {
    [PSCustomObject]@{
        Niveau      = $niveau
        Occurrences = (Select-String $niveau "ressources/server.log").Count
    }
}
$resultats | Format-Table
$resultats | Export-Csv "stats.csv" -NoTypeInformation

# Pipeline avec filtrage et tri
Get-ChildItem -Recurse | Where-Object { $_.Extension -eq ".log" } |
    Sort-Object Length -Descending |
    Select-Object Name, Length |
    Format-Table
```

---

## Étape 5 — Script DevOps complet (1h30)

### Concept

En PowerShell, les scripts DevOps vérifient l'environnement, installent les dépendances et analysent les logs. Vous allez construire ce script **progressivement**, bloc par bloc.

### Une notion à retenir avant de commencer

**`Write-Host` avec des couleurs**

PowerShell permet d'afficher du texte coloré directement avec `-ForegroundColor`. Pas de codes à retenir :

```powershell
Write-Host "Tout va bien"     -ForegroundColor Green
Write-Host "Attention"        -ForegroundColor Yellow
Write-Host "Erreur détectée"  -ForegroundColor Red
Write-Host "Information"      -ForegroundColor Cyan
```

On encapsule ça dans des fonctions courtes pour ne pas répéter :

```powershell
function Write-Ok   { param($m) Write-Host "[OK]   $m" -ForegroundColor Green }
function Write-Info { param($m) Write-Host "[INFO] $m" -ForegroundColor Cyan }
# Appel : Write-Ok "Dépendances installées"
```

---

### Exercice 5.1 — Fonctions d'affichage coloré

Créez `mon-projet/src/couleurs.ps1` et **complétez les parties manquantes** :

```powershell
# couleurs.ps1 — Tester les fonctions d'affichage

# Ces deux fonctions sont déjà écrites — observez leur structure
function Write-Ok   { param($m) Write-Host "[OK]   $m" -ForegroundColor Green }
function Write-Info { param($m) Write-Host "[INFO] $m" -ForegroundColor Cyan }

# TODO: écrivez Write-Warn en jaune avec le préfixe [WARN]
# TODO: écrivez Write-Err  en rouge avec le préfixe [ERR]



# Test — ces 4 lignes doivent s'afficher chacune dans la bonne couleur
Write-Ok   "Installation réussie"
Write-Info "Démarrage du serveur..."
Write-Warn "Mémoire basse : 78%"
Write-Err  "Connexion échouée"
```

> 💡 **Indice :** `Write-Ok` et `Write-Info` ont exactement la même structure. Changez uniquement le préfixe entre crochets et la couleur après `-ForegroundColor`.

```powershell
.\mon-projet\src\couleurs.ps1
```

---

### Exercice 5.2 — Script de vérification de l'environnement

Créez `mon-projet/src/check-env.ps1` à partir de ce squelette. **Complétez les blocs TODO :**

```powershell
# check-env.ps1 — Vérifie que l'environnement est prêt pour NexaCloud

function Write-Ok   { param($m) Write-Host "  [OK]   $m" -ForegroundColor Green }
function Write-Warn { param($m) Write-Host "  [WARN] $m" -ForegroundColor Yellow }
function Write-Err  { param($m) Write-Host "  [ERR]  $m" -ForegroundColor Red }

# Cette fonction vérifie si une commande est installée — elle est fournie
function Test-Commande {
    param([string]$Commande, [string]$Nom)
    # Get-Command cherche si la commande existe
    # -ErrorAction SilentlyContinue évite un message d'erreur si elle est absente
    if (Get-Command $Commande -ErrorAction SilentlyContinue) {
        Write-Ok "$Nom installé"
    } else {
        Write-Err "$Nom non trouvé"
    }
}

Write-Host ""
Write-Host "=== Vérification de l'environnement NexaCloud ===" -ForegroundColor Cyan
Write-Host ""

# TODO: appelez Test-Commande pour vérifier python3, node, npm et git
# Exemple : Test-Commande "python3" "Python"



Write-Host ""

# TODO: vérifiez que ces deux fichiers existent avec Test-Path
# Fichiers : "config.json" et "ressources/server.log"
# Si le fichier existe  -> Write-Ok "Fichier trouvé : ..."
# Si le fichier manque  -> Write-Warn "Fichier manquant : ..."
# Indice : vous avez déjà utilisé foreach à l'étape 4



Write-Host ""
Write-Host "=== Vérification terminée ===" -ForegroundColor Cyan
Write-Host ""
```

> 💡 **Indice :** pour parcourir les deux fichiers, utilisez `foreach ($f in @("fichier1","fichier2"))` avec `Test-Path` à l'intérieur — exactement comme à l'étape 4.

```powershell
.\mon-projet\src\check-env.ps1
```

---

### Exercice 5.3 — Assembler le script de setup complet

Vous avez maintenant toutes les briques. Créez `setup.ps1` **à la racine du repo**. Les parties techniques sont fournies — **complétez la logique de chaque section :**

```powershell
# setup.ps1 — Prépare le projet NexaCloud en une commande

# Les fonctions d'affichage sont fournies
function Write-Banner {
    param([string]$Texte, [string]$Couleur = "Cyan")
    $sep = "=" * 44
    Write-Host $sep -ForegroundColor $Couleur
    Write-Host "   $Texte" -ForegroundColor $Couleur
    Write-Host $sep -ForegroundColor $Couleur
}
function Write-Ok   { param($m) Write-Host "[OK]   $m" -ForegroundColor Green }
function Write-Info { param($m) Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Write-Warn { param($m) Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Write-Err  { param($m) Write-Host "[ERR]  $m" -ForegroundColor Red; exit 1 }

# La bannière est fournie
Write-Host ""
Write-Banner "SETUP NEXACLOUD — $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
Write-Host ""

# -- 1. Vérification des prérequis -----------------------------------------
Write-Info "Vérification des prérequis..."

# TODO: parcourez @("python3","node","npm") avec foreach
# Pour chaque commande, vérifiez avec Get-Command si elle existe
# Si elle n'existe pas (-not ...) -> appelez Write-Err pour stopper



Write-Ok "Prérequis : Python3, Node.js, npm présents"

# -- 2. Dépendances Python --------------------------------------------------
Write-Info "Installation des dépendances Python..."

# TODO: si "python-api/requirements.txt" existe (Test-Path)
# -> pip install -r python-api/requirements.txt --quiet
# -> Write-Ok "Dépendances Python installées"
# Sinon -> Write-Warn pour prévenir sans bloquer



# -- 3. Dépendances Node ----------------------------------------------------
Write-Info "Installation des dépendances Node..."

# TODO: même logique pour "node-client/package.json"
# Si le fichier existe :
#   -> Set-Location "node-client"
#   -> npm install --silent
#   -> Set-Location ".."
#   -> Write-Ok
# Sinon -> Write-Warn



# -- 4. Analyse des logs ----------------------------------------------------
Write-Info "Analyse des logs..."
$logFile = "ressources/server.log"

# TODO: si $logFile existe :
# - comptez les ERROR  -> $nbErr  = (Select-String "ERROR"    $logFile).Count
# - comptez les CRITICAL -> $nbCrit = (Select-String "CRITICAL" $logFile).Count
# - affichez Write-Ok avec les deux compteurs
# - si $nbCrit -gt 0 : affichez un message en rouge
#   et listez les lignes avec Select-String + ForEach-Object { $_.Line }



# Le message de fin est fourni
Write-Host ""
Write-Banner "SETUP TERMINÉ AVEC SUCCÈS" "Green"
Write-Host ""
Write-Host "  Lancer l'API Python  : Set-Location python-api; python3 app.py"
Write-Host "  Lancer le client Node: Set-Location node-client; node app.js"
Write-Host ""
```

```powershell
.\setup.ps1
```

> 💡 **Rappels utiles :**
> - Tester si un fichier existe : `Test-Path "chemin"`
> - Compter des occurrences : `(Select-String "MOT" $fichier).Count`
> - Comparer des nombres : `$nb -gt 0`
> - Parcourir des résultats : `Select-String "MOT" $f | ForEach-Object { $_.Line }`

---

### Pour aller plus loin — Étape 5

```powershell
# Créer et charger un fichier .env
"PORT=5001" | Out-File ".env"
"ENV=development" | Add-Content ".env"

Get-Content ".env" | Where-Object { $_ -match "=" } | ForEach-Object {
    $cle, $valeur = $_ -split "=", 2
    [System.Environment]::SetEnvironmentVariable($cle.Trim(), $valeur.Trim(), "Process")
}
Write-Output "Port : $env:PORT"
```

---

## BONUS — Azure PowerShell (1h)

> Cette section nécessite un accès Azure actif.

### Prérequis

```powershell
# Installer le module Az si nécessaire (une seule fois)
Install-Module -Name Az -Scope CurrentUser -Force

# Se connecter à Azure
Connect-AzAccount

# Vérifier le compte actif
Get-AzContext

# Changer d'abonnement si nécessaire
Set-AzContext -SubscriptionId "votre-subscription-id"
```

---

### Bonus 1 — Créer et gérer des ressources

```powershell
$resourceGroup  = "rg-nexacloud-tp"
$location       = "francecentral"
$storageAccount = "stnexacloud$((Get-Random -Maximum 9999))"

# Créer un resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Lister les resource groups
Get-AzResourceGroup | Format-Table ResourceGroupName, Location, ProvisioningState

# Vérifier l'état
(Get-AzResourceGroup -Name $resourceGroup).ProvisioningState
```

---

### Bonus 2 — Script Azure Storage

Créez `mon-projet/src/azure-storage.ps1` :

```powershell
# azure-storage.ps1 — Crée un compte de stockage et uploade server.log

param(
    [string]$ResourceGroup  = "rg-nexacloud-tp",
    [string]$Location       = "francecentral",
    [string]$FichierLocal   = "ressources/server.log"
)

$storageAccount = "stnexacloud$((Get-Random -Maximum 9999))"
$container      = "logs"

Write-Host "=== Création du compte de stockage Azure ===" -ForegroundColor Cyan

# Créer le compte de stockage
$storage = New-AzStorageAccount `
    -ResourceGroupName $ResourceGroup `
    -Name $storageAccount `
    -Location $Location `
    -SkuName Standard_LRS `
    -Kind StorageV2

Write-Host "Compte créé : $storageAccount" -ForegroundColor Green

# Récupérer le contexte de stockage
$cle = (Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -Name $storageAccount)[0].Value
$ctx = New-AzStorageContext -StorageAccountName $storageAccount -StorageAccountKey $cle

# Créer le conteneur
New-AzStorageContainer -Name $container -Context $ctx -Permission Off | Out-Null
Write-Host "Conteneur créé : $container" -ForegroundColor Green

# Uploader le fichier
Set-AzStorageBlobContent `
    -Container $container `
    -File $FichierLocal `
    -Blob "server.log" `
    -Context $ctx | Out-Null

Write-Host "Fichier uploadé : server.log" -ForegroundColor Green

# Lister les blobs
Write-Host "`n=== Contenu du conteneur ===" -ForegroundColor Cyan
Get-AzStorageBlob -Container $container -Context $ctx |
    Select-Object Name, Length, LastModified | Format-Table
```

```powershell
.\mon-projet\src\azure-storage.ps1
```

---

### Bonus 3 — Azure Key Vault

```powershell
$keyVaultName = "kv-nexacloud-$((Get-Random -Maximum 9999))"

# Créer le Key Vault
New-AzKeyVault `
    -Name $keyVaultName `
    -ResourceGroupName "rg-nexacloud-tp" `
    -Location "francecentral"

# Ajouter un secret
$secret = ConvertTo-SecureString "MonMotDePasse123!" -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "db-password" -SecretValue $secret

# Récupérer un secret
$secretValue = (Get-AzKeyVaultSecret -VaultName $keyVaultName -Name "db-password" -AsPlainText)
Write-Host "Secret récupéré (longueur : $($secretValue.Length) caractères)" -ForegroundColor Green

# Lister tous les secrets
Get-AzKeyVaultSecret -VaultName $keyVaultName | Format-Table Name, Enabled, Created
```

---

### Bonus 4 — Connexion à une VM Azure en SSH

```powershell
$vmName = "vm-nexacloud-tp"

# Créer une VM
New-AzVM `
    -ResourceGroupName "rg-nexacloud-tp" `
    -Name $vmName `
    -Location "francecentral" `
    -Image "Ubuntu2204" `
    -Size "Standard_B1s" `
    -GenerateSshKey `
    -SshKeyName "cle-nexacloud"

# Récupérer l'IP publique
$ip = (Get-AzPublicIpAddress -ResourceGroupName "rg-nexacloud-tp").IpAddress
Write-Host "IP de la VM : $ip" -ForegroundColor Green

# Se connecter en SSH
ssh azureuser@$ip
```

> **Nettoyage :**
> ```powershell
> Remove-AzResourceGroup -Name "rg-nexacloud-tp" -Force -AsJob
> ```

---

## Grille d'évaluation (20 pts)

| Critère | Points |
|---------|--------|
| Étape 1 : arborescence créée avec les cmdlets PowerShell | 2 |
| Étape 2 : Select-String / filtrage pipeline fonctionnels | 3 |
| Étape 3 : script avec variables et conditions qui s'exécute | 3 |
| Étape 4 : script avec boucles et fonctions qui s'exécute | 4 |
| Étape 5 : setup.ps1 complet et fonctionnel | 5 |
| BONUS Azure (au moins 2 ressources créées avec script) | 3 |

---

*Formation DevSecOps Azure — Simplon*
