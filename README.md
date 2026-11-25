# PC Setup

Installation reproductible de mes applications Windows, distributions WSL et outils de cybersécurité défensive.

## Structure

```text
.
|-- setup/
|   |-- windows/
|   |   |-- apps-windows.json
|   |   |-- Export-AppCatalogue.ps1
|   |   |-- Install-Apps.ps1
|   |   `-- catalogue-applications.md
|   `-- wsl/
|       |-- Install-WSL-Distros.ps1
|       |-- Install-DefensiveTools.ps1
|       `-- install-defensive-tools.sh
|-- ia/
|   `-- README.md
`-- cybersecurity/
    `-- README.md
```

## Catalogue des applications Windows

Le [catalogue des applications](setup/windows/catalogue-applications.md) répertorie les applications WinGet par utilité, avec leur logo ou une icône descriptive, leur version WinGet et leur éditeur. Les versions sont un instantané : pour les actualiser depuis les métadonnées WinGet, exécute :

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\setup\windows\Export-AppCatalogue.ps1
```

## Installation Windows

Le [catalogue WinGet](setup/windows/apps-windows.json) organise les applications par catégorie. Vérifie que **App Installer** est installé, puis exécute depuis la racine du dépôt :

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\setup\windows\Install-Apps.ps1
```

Le script installe les applications WinGet du catalogue, dont Sunshine et Moonlight sur chaque PC où il est exécuté. Sunshine sert d'hôte de streaming et Moonlight de client. Wireshark peut demander l'installation de Npcap et des droits administrateur.

Les éléments qui exigent un compte, une licence ou une activation manuelle — comme Hatch Embroidery, Ableton Live, Riot Client et Windows Sandbox — sont répertoriés dans le catalogue plutôt qu'installés automatiquement. **deemix n'est pas inclus** ; l'application officielle Deezer l'est.

## Ubuntu et Kali sous WSL 2

Ces scripts préparent les deux distributions sous WSL 2. WSL utilise une VM légère partagée : Ubuntu et Kali sont deux distributions séparées, mais pas deux VM VirtualBox indépendantes. Pour une isolation renforcée, crée des VM distinctes et limite leurs partages réseau et fichiers.

1. Ouvre PowerShell **en tant qu'administrateur**, puis lance :

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\setup\wsl\Install-WSL-Distros.ps1
   ```

   Si WSL n'est pas encore activé, le script installe ses composants et te demande de redémarrer Windows. Relance-le après le redémarrage pour installer Ubuntu et Kali.
2. Ouvre chaque distribution une première fois et crée son utilisateur Linux :

   ```powershell
   wsl --distribution Ubuntu
   wsl --distribution kali-linux
   ```
3. Après cette initialisation, lance le socle d'outils défensifs :

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\setup\wsl\Install-DefensiveTools.ps1
   ```

Le socle utilise les dépôts officiels des distributions : Git, Python, YARA, Sleuth Kit, TShark, Volatility 3, Binwalk, ExifTool, jq et `file`. Ghidra est ajouté dans Kali lorsqu'il est disponible dans ses dépôts. Les paquets absents des sources configurées sont signalés au lieu d'être ignorés.

## Catalogue cybersécurité

Le [catalogue défensif](cybersecurity/README.md) répertorie les outils par catégorie, leur compatibilité et leur licence. Il inclut des options open source ainsi que des utilitaires gratuits mais propriétaires ; ces derniers ne sont pas installés automatiquement.

Utilise les outils d'analyse uniquement sur des systèmes et des données que tu es autorisé à examiner. Teste les configurations dans un environnement isolé avant tout usage opérationnel.

## IA locale et agents

La catégorie **IA locale** ajoute LM Studio au catalogue WinGet ; le script d'installation Windows l'installe avec les autres applications. Le guide [IA locale](ia/README.md) explique comment commencer avec AnythingLLM Desktop pour créer des agents dédiés à des tâches et comment choisir le bon installeur pour la Surface Snapdragon ou le PC x64.

AMD Software: Adrenalin Edition est une option manuelle réservée au PC avec Radeon RX 7900 XTX. Les applications manuelles et les logiciels optionnels sont listés dans le [catalogue Windows](setup/windows/catalogue-applications.md).
