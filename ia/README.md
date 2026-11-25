# IA locale et agents

Ce guide propose une première configuration locale pour créer des assistants spécialisés. Avec un moteur local sélectionné, les conversations sont traitées sur le PC ; télécharge les modèles uniquement depuis une source de confiance.

## Configuration conseillée pour débuter

1. Installe **LM Studio** depuis le script Windows du dépôt ou le [site officiel](https://lmstudio.ai/). LM Studio prend en charge Windows x64 et ARM, dont Snapdragon X Elite. Il sert à télécharger et tester des modèles locaux et peut fournir un serveur local.
2. Installe **AnythingLLM Desktop** depuis la [page d'installation Windows](https://docs.anythingllm.com/installation-desktop/windows). Choisis l'installeur **ARM64** pour la Surface Snapdragon et **x64** pour le PC avec Radeon. Installe l'application pour ton compte utilisateur, pas « pour tous les utilisateurs ».
3. Dans AnythingLLM, commence avec son moteur local intégré ou connecte-le au serveur local de LM Studio. Télécharge un modèle adapté à la mémoire de la machine ; commence avec un modèle quantifié de petite taille et vérifie qu'il sait utiliser les outils avant de bâtir des agents dessus.
4. Crée un espace de travail distinct par tâche (par exemple rédaction, recherche dans des documents ou aide au code), puis définis des consignes courtes et vérifiables. Active les outils ou serveurs MCP uniquement quand ils sont nécessaires et que tu en comprends les accès.

AnythingLLM fournit des agents capables d'utiliser des outils et des workflows. Son moteur local peut exploiter un GPU ou un NPU lorsque les dépendances matérielles correspondantes sont disponibles. LM Studio prend en charge la Surface Snapdragon X Elite ainsi que Windows x64 ; les performances et l'accélération dépendent du modèle, du pilote et des ressources disponibles.

## Matériel AMD

Sur le PC équipé de la **Radeon RX 7900 XTX**, l'installation d'**AMD Software: Adrenalin Edition** est facultative. Utilise la page officielle [AMD Drivers and Support](https://www.amd.com/en/support/download/drivers.html) pour sélectionner la carte exacte et le pilote Windows correspondant. Le logiciel AMD est à installer uniquement sur ce PC, pas sur la Surface Snapdragon.

## Installation via le dépôt

- **LM Studio** fait partie de la catégorie IA du catalogue WinGet ; `Install-Apps.ps1` l'installe automatiquement avec le reste du catalogue.
- **AnythingLLM Desktop** et **AMD Software: Adrenalin Edition** sont des options manuelles. Les liens, les consignes et les architectures sont aussi répertoriés dans le [catalogue Windows](../setup/windows/catalogue-applications.md).

L'installation des applications ne télécharge pas automatiquement de modèle. Prévois suffisamment d'espace disque, et vérifie le modèle et ses conditions d'utilisation avant de le télécharger.
