# Catalogue cybersécurité défensive

Sélection d'outils courants pour l'administration, la détection, l'investigation numérique et l'analyse de fichiers. Priorité aux projets open source ; les outils gratuits mais propriétaires et les composants intégrés à Windows sont signalés.

Ce catalogue est informatif : il n'installe, ne clone et n'exécute aucun outil. Utilise ces logiciels uniquement sur des systèmes et des données que tu es autorisé à analyser. Pour les fichiers suspects, préfère une machine virtuelle isolée avec instantanés ; ne partage pas ses dossiers, presse-papiers ou accès réseau avec l'hôte.

Les mentions **Windows**, **WSL/VM** et **Serveur** indiquent l'environnement le plus adapté, pas une garantie de compatibilité avec chaque version.

Les logos de marque sont utilisés lorsqu'ils sont disponibles ; les autres images sont des pictogrammes descriptifs, pas des logos officiels.

## Poste Windows, télémétrie et réponse à incident

| Logo / icône | Outil | Utilité | Licence / environnement |
|:--:|---|---|---|
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/wrench-adjustable-circle.svg" alt="Sysinternals" width="28" height="28"> | [Microsoft Sysinternals Suite](https://learn.microsoft.com/sysinternals/) | Process Explorer, Autoruns, TCPView, Sysmon et outils de diagnostic Windows. | Gratuit, propriétaire ; Windows. Déjà dans le catalogue d'installation. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/binoculars.svg" alt="Hayabusa" width="28" height="28"> | [Hayabusa](https://github.com/Yamato-Security/hayabusa) | Recherche et chronologie à partir des journaux d'événements Windows. | Open source ; Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/journal-text.svg" alt="Chainsaw" width="28" height="28"> | [Chainsaw](https://github.com/WithSecureLabs/chainsaw) | Investigation de journaux EVTX et règles de détection Sigma. | Open source ; Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/speedometer2.svg" alt="Velociraptor" width="28" height="28"> | [Velociraptor](https://github.com/Velocidex/velociraptor) | Collecte et réponse à incident sur des postes autorisés. | Open source ; agent Windows, plateforme de gestion. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/shield-check.svg" alt="Wazuh" width="28" height="28"> | [Wazuh](https://github.com/wazuh/wazuh) | Supervision, inventaire et détection sur des postes ; l'agent Windows s'administre depuis un serveur. | Open source ; agent Windows, serveur généralement Linux/VM. |

## Réseau et protocoles

| Logo / icône | Outil | Utilité | Licence / environnement |
|:--:|---|---|---|
| <img src="https://cdn.simpleicons.org/wireshark" alt="Wireshark" width="28" height="28"> | [Wireshark](https://www.wireshark.org/) | Capture et analyse de trafic réseau. | Open source ; Windows. Déjà dans le catalogue d'installation. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/diagram-3.svg" alt="mitmproxy" width="28" height="28"> | [mitmproxy](https://github.com/mitmproxy/mitmproxy) | Proxy d'inspection pour tester des applications et services dont tu as l'autorisation. | Open source ; Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/activity.svg" alt="Zeek" width="28" height="28"> | [Zeek](https://github.com/zeek/zeek) | Analyse et journalisation de trafic pour la supervision réseau. | Open source ; privilégier WSL ou une VM Linux. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/activity.svg" alt="Suricata" width="28" height="28"> | [Suricata](https://github.com/OISF/suricata) | Détection réseau IDS/IPS dans un environnement de supervision. | Open source ; privilégier Linux/VM. |

## Investigation numérique

| Logo / icône | Outil | Utilité | Licence / environnement |
|:--:|---|---|---|
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/hdd-stack.svg" alt="Autopsy" width="28" height="28"> | [Autopsy](https://github.com/sleuthkit/autopsy) | Interface d'analyse de supports et d'images disque. | Open source ; Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/search.svg" alt="The Sleuth Kit" width="28" height="28"> | [The Sleuth Kit](https://github.com/sleuthkit/sleuthkit) | Outils d'analyse de systèmes de fichiers et d'images disque. | Open source ; Windows/Linux. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/memory.svg" alt="Volatility 3" width="28" height="28"> | [Volatility 3](https://github.com/volatilityfoundation/volatility3) | Analyse de mémoire vive acquise dans un cadre autorisé. | Open source ; Python, Windows/Linux. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/clock-history.svg" alt="Plaso" width="28" height="28"> | [Plaso / log2timeline](https://github.com/log2timeline/plaso) | Construction de chronologies à partir d'artefacts numériques. | Open source ; WSL/VM recommandé. |
| <img src="https://cdn.simpleicons.org/android" alt="ALEAPP" width="28" height="28"> | [ALEAPP](https://github.com/abrignoni/ALEAPP) | Analyse d'artefacts provenant d'appareils Android. | Open source ; Python, Windows/Linux. |
| <img src="https://cdn.simpleicons.org/apple" alt="iLEAPP" width="28" height="28"> | [iLEAPP](https://github.com/abrignoni/iLEAPP) | Analyse d'artefacts provenant d'appareils iOS. | Open source ; Python, Windows/Linux. |

## Reverse engineering et analyse de fichiers

| Logo / icône | Outil | Utilité | Licence / environnement |
|:--:|---|---|---|
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/code-slash.svg" alt="Ghidra" width="28" height="28"> | [Ghidra](https://github.com/NationalSecurityAgency/ghidra) | Désassemblage et décompilation de binaires pour l'analyse. | Open source ; Windows/Linux, Java. Le socle WSL l'installe dans Kali quand le paquet est disponible. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/bug.svg" alt="x64dbg" width="28" height="28"> | [x64dbg](https://github.com/x64dbg/x64dbg) | Débogueur pour l'analyse de programmes Windows x86/x64. | Open source ; Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/scissors.svg" alt="Cutter" width="28" height="28"> | [Cutter](https://github.com/rizinorg/cutter) | Interface graphique de reverse engineering basée sur Rizin. | Open source ; Windows/Linux. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/file-binary.svg" alt="ImHex" width="28" height="28"> | [ImHex](https://github.com/WerWolv/ImHex) | Éditeur hexadécimal et analyse de formats binaires. | Open source ; Windows/Linux. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/file-earmark-check.svg" alt="Detect It Easy" width="28" height="28"> | [Detect It Easy](https://github.com/horsicq/Detect-It-Easy) | Identification du format, du compilateur et des packers d'un fichier. | Open source ; Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/diagram-3.svg" alt="capa" width="28" height="28"> | [capa](https://github.com/mandiant/capa) | Repérage de capacités dans des exécutables et fichiers analysés. | Open source ; Windows/Linux. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/text-left.svg" alt="FLOSS" width="28" height="28"> | [FLOSS](https://github.com/mandiant/flare-floss) | Extraction de chaînes de caractères utiles à l'analyse de binaires. | Open source ; Windows/Linux. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/magic.svg" alt="CyberChef" width="28" height="28"> | [CyberChef](https://github.com/gchq/CyberChef) | Transformations et décodages de données dans une interface locale ou navigateur. | Open source ; utilisable hors ligne. |

## Détection, règles et renseignement

| Logo / icône | Outil / dépôt | Utilité | Licence / environnement |
|:--:|---|---|---|
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/search.svg" alt="YARA" width="28" height="28"> | [YARA](https://github.com/VirusTotal/yara) | Moteur de règles pour classer et rechercher des motifs dans des fichiers. | Open source ; Windows/Linux. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/search.svg" alt="YARA-X" width="28" height="28"> | [YARA-X](https://github.com/VirusTotal/yara-x) | Implémentation moderne du format de règles YARA. | Open source ; Windows/Linux. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/filter-circle.svg" alt="Sigma" width="28" height="28"> | [Sigma](https://github.com/SigmaHQ/sigma) | Règles de détection portables pour les journaux et SIEM. | Open source ; règles à adapter à la source de logs. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/file-earmark-code.svg" alt="Sysmon configuration" width="28" height="28"> | [SwiftOnSecurity/sysmon-config](https://github.com/SwiftOnSecurity/sysmon-config) | Exemple commenté de configuration Sysmon ; à examiner et adapter avant usage. | Open source ; Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/share.svg" alt="MISP" width="28" height="28"> | [MISP](https://github.com/MISP/MISP) | Plateforme de partage et de gestion de renseignement sur les menaces. | Open source ; serveur Linux/VM recommandé. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/diagram-3.svg" alt="OpenCTI" width="28" height="28"> | [OpenCTI](https://github.com/OpenCTI-Platform/opencti) | Plateforme de gestion et de mise en relation de renseignement sur les menaces. | Open source ; serveur/VM. |

## Sécurité applicative et chaîne logicielle

À réserver aux applications, dépôts et environnements que tu possèdes ou es autorisé à tester.

| Logo / icône | Outil | Utilité | Licence / environnement |
|:--:|---|---|---|
| <img src="https://cdn.simpleicons.org/owasp" alt="OWASP ZAP" width="28" height="28"> | [OWASP ZAP](https://github.com/zaproxy/zaproxy) | Analyse de sécurité d'applications Web de test. | Open source ; Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/file-earmark-code.svg" alt="Semgrep" width="28" height="28"> | [Semgrep](https://github.com/semgrep/semgrep) | Analyse statique de code et règles de sécurité. | Open source ; WSL recommandé sur Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/key.svg" alt="Gitleaks" width="28" height="28"> | [Gitleaks](https://github.com/gitleaks/gitleaks) | Recherche de secrets accidentellement ajoutés au code ou à l'historique Git. | Open source ; Windows. |
| <img src="https://cdn.simpleicons.org/trivy" alt="Trivy" width="28" height="28"> | [Trivy](https://github.com/aquasecurity/trivy) | Analyse de dépendances, conteneurs et configurations. | Open source ; Windows/WSL. |
| <img src="https://cdn.simpleicons.org/google" alt="OSV-Scanner" width="28" height="28"> | [OSV-Scanner](https://github.com/google/osv-scanner) | Vérification de dépendances par rapport à la base OSV. | Open source ; Windows. |
| <img src="https://cdn.simpleicons.org/owasp" alt="OWASP Dependency-Check" width="28" height="28"> | [OWASP Dependency-Check](https://github.com/dependency-check/DependencyCheck) | Identification de dépendances potentiellement vulnérables. | Open source ; Windows/Java. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/shield.svg" alt="Attack Surface Analyzer" width="28" height="28"> | [Microsoft Attack Surface Analyzer](https://github.com/microsoft/AttackSurfaceAnalyzer) | Comparaison des changements système avant/après installation d'un logiciel. | Open source ; Windows. |

## Outils gratuits mais propriétaires

Ces outils peuvent être utiles en DFIR et en analyse de binaires, mais ils ne sont pas open source. Vérifie les conditions d'utilisation : certaines éditions gratuites sont limitées à un usage personnel ou non commercial.

| Logo / icône | Outil | Utilité | Licence / environnement |
|:--:|---|---|---|
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/code-slash.svg" alt="IDA Free" width="28" height="28"> | [IDA Free](https://hex-rays.com/ida-free/) | Désassembleur et décompilateur x86/x64 pour l'analyse de binaires. | Gratuit, propriétaire ; limites d'architecture et d'usage commercial selon l'édition. Windows/Linux. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/file-binary.svg" alt="PEStudio" width="28" height="28"> | [PEStudio](https://www.winitor.com/download) | Triage statique d'exécutables Windows et mise en évidence d'indicateurs. | Gratuit sous conditions, propriétaire ; Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/collection.svg" alt="KAPE" width="28" height="28"> | [KAPE](https://github.com/EricZimmerman/KapeFiles) | Collecte et traitement d'artefacts Windows pour les investigations. | Gratuit, propriétaire ; Windows. Le dépôt lié fournit notamment ses cibles et modules. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/tools.svg" alt="Eric Zimmerman Tools" width="28" height="28"> | [Eric Zimmerman Tools](https://ericzimmerman.github.io/) | Suite d'outils d'analyse d'artefacts Windows et de chronologies. | Gratuit ; licence à vérifier outil par outil ; Windows. |
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/memory.svg" alt="Magnet RAM Capture" width="28" height="28"> | [Magnet RAM Capture](https://www.magnetforensics.com/resources/magnet-ram-capture/) | Acquisition de mémoire vive pour une investigation autorisée. | Gratuit, propriétaire ; l'éditeur demande une inscription. Vérifie la compatibilité avec Windows 11 avant usage. |

## Environnements isolés

| Logo / icône | Outil | Utilité | Remarque |
|:--:|---|---|---|
| <img src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/icons/window-desktop.svg" alt="Windows Sandbox" width="28" height="28"> | [Windows Sandbox](https://learn.microsoft.com/windows/security/application-security/application-isolation/windows-sandbox/) | Session Windows temporaire pour tester des fichiers et applications. | Fonctionnalité intégrée, édition Windows compatible et virtualisation requises ; activation manuelle. |
| <img src="https://cdn.simpleicons.org/virtualbox" alt="VirtualBox" width="28" height="28"> | [Oracle VirtualBox](https://www.virtualbox.org/) | Machines virtuelles pour séparer des environnements de test. | Déjà dans le catalogue d'installation. |
| <img src="https://cdn.simpleicons.org/linux" alt="REMnux" width="28" height="28"> | [REMnux](https://remnux.org/) | Environnement Linux orienté analyse de logiciels suspects. | À utiliser dans une VM isolée, pas comme outil Windows natif. |

## Sélection déjà installable

Le [catalogue principal](../setup/windows/apps-windows.json) prévoit actuellement l'installation de Wireshark et de Microsoft Sysinternals Suite. Les [scripts WSL](../setup/wsl/Install-WSL-Distros.ps1) installent Ubuntu et Kali, puis un socle de paquets d'analyse depuis leurs dépôts officiels. Les autres projets listés ici restent des références à évaluer et ne sont pas téléchargés automatiquement.

Les outils et règles évoluent : vérifie les prérequis, la licence et les instructions de leur éditeur avant installation. N'applique pas une configuration de collecte ou de détection en production sans l'avoir testée et adaptée.
