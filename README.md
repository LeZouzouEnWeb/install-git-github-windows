# 🔐 GitHub SSH – Windows 11 (2 comptes) – SNIPPET COMPLET

Ce snippet permet de configurer **2 comptes GitHub (perso + pro)** sur Windows 11 avec :

- PowerShell
- Git Bash
- VS Code
- **1 seule saisie de passphrase par session Windows**

---

## 1️⃣ Génération des clés SSH

```bash
# Compte personnel
ssh-keygen -t ed25519 -C "<email du dépôt>" -f ~/.ssh/home

# Compte professionnel
ssh-keygen -t ed25519 -C "<email du dépôt>" -f ~/.ssh/work
```

---

## 2️⃣ Ajouter les clés à l'agent SSH Windows

```powershell
# Vérifier le service
Get-Service ssh-agent

# Activer l'agent au démarrage
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent

# Ajouter les clés
ssh-add $env:USERPROFILE\.ssh\home
ssh-add $env:USERPROFILE\.ssh\work

# Vérification
ssh-add -l
```

---

## 3️⃣ Configuration SSH (`~/.ssh/config`)

```ssh
# Configuration par défaut pour GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile /c/Users/eric/.ssh/home
    IdentitiesOnly yes

# ===============================================================
# SSH CONFIG MULTI-COMPTES GITHUB (HOME + WORK)
# ===============================================================

# Désactive le hashing pour lisibilité
HashKnownHosts no

# ---------------------------------------------------------------
# Compte GitHub personnel (alias)
# ---------------------------------------------------------------
Host github-home
    HostName github.com
    User git
    IdentityFile /c/Users/eric/.ssh/home
    IdentitiesOnly yes

# ---------------------------------------------------------------
# Compte GitHub professionnel
# ---------------------------------------------------------------
Host github-work
    HostName github.com
    User git
    IdentityFile /c/Users/eric/.ssh/work
    IdentitiesOnly yes

# ---------------------------------------------------------------
# Fix Windows / Git Bash issues
# ---------------------------------------------------------------
ServerAliveInterval 120
TCPKeepAlive yes
ControlMaster auto
ControlPath ~/.ssh/control-%C
ControlPersist 5m
```

---

## 4️⃣ Tests de connexion SSH

```bash
ssh -T git@github-home
ssh -T git@github-work
```

Résultat attendu :

```text
Hi <username>! You've successfully authenticated, but GitHub does not provide shell access.
```

---

## 5️⃣ Initialiser un dépôt Git (NOUVEAU PROJET)

```bash
# Initialisation
git init

# Ajout des fichiers
git add .

# Premier commit
git commit -m "Initial commit"

# Forcer la branche main
git branch -M main
```

---

## 6️⃣ Lier le dépôt à GitHub (choisir le compte)

### Compte personnel

```bash
git remote add origin git@github-home:TonDepot/mon_repo.git
```

### Compte professionnel

```bash
git remote add origin git@github-work:TonDepot/mon_repo.git
```

Vérification :

```bash
git remote -v
```

---

## 7️⃣ Push initial

```bash
git push -u origin main
```

---

## 8️⃣ Corriger un remote existant (si erreur d'alias)

```bash
git remote set-url origin git@github-home:TonDepot/mon_repo.git
# ou
git remote set-url origin git@github-work:TonDepot/mon_repo.git
```

---

## 9️⃣ Configuration Git multi-comptes

### Structure des fichiers de configuration

```plaintext
C:/Users/<USERNAME>/
├── .gitconfig              # Configuration principale (compte HOME par défaut)
└── .gitconfig-work         # Configuration compte PRO (chargée conditionnellement)
```

### Configuration principale (`~/.gitconfig`)

Le fichier `.gitconfig` définit :

- L'identité par défaut (compte HOME)
- Les alias Git personnalisés
- La configuration LFS, couleurs, etc.
- Un chargement conditionnel pour le compte PRO

```properties
[user]
    name = <NOM Prénom>
    email = <EMAIL HOME>

# Applique automatiquement l'identité PRO dans le dossier work/
[includeIf "gitdir:C:/Users/<USERNAME>/Documents/work/"]
    path = C:/Users/<USERNAME>/.gitconfig-work
```

### Configuration PRO (`~/.gitconfig-work`)

Créer le fichier `C:/Users/<USERNAME>/.gitconfig-work` :

```properties
[user]
    name = <NOM Prénom Pro>
    email = <EMAIL WORK>
```

### 🎯 Fonctionnement automatique

- **Projets personnels** (n'importe où) → utilise `<EMAIL HOME>`
- **Projets dans `C:/Users/<USERNAME>/Documents/work/`** → utilise `<EMAIL WORK>`

Vérifier l'identité active :

```bash
git config user.email
git config user.name
```

---

## 🚀 Alias Git personnalisés

Le fichier `.gitconfig` inclut des alias puissants pour simplifier le workflow.

### Commits rapides

```bash
# Commit simple
git cm "mon message"

# Add + Commit
git ac "mon message"

# Add + Commit + Push
git pp "mon message"
```

### Gestion des branches

```bash
# Créer une nouvelle branche et push
git br "feature/ma-nouvelle-feature"

# Créer branche de ticket (format: feature/Eric/Ticket-XXX/description)
git new-br 123 "description du ticket"
git new-br-dev 123 "description"          # depuis develop
git new-br-fix 456 "correction bug"        # branche fix-ano

# Changer de branche avec pull automatique
git main                    # checkout main + pull
git dev                     # checkout develop + pull
git release 2024.01         # checkout Release_2024.01
git br-c 123 "description"  # checkout feature/Eric/Ticket-123/description

# Supprimer une branche locale et distante
git dl "nom-de-la-branche"
```

### Statut et logs

```bash
git st      # Status condensé
git lg      # Log graphique
git up      # Fetch all + nettoyage branches supprimées
```

### Reset et synchronisation

```bash
git hard                # Reset hard sur origin/main
git hard-dev            # Reset hard sur origin/develop
git hard-release 2024.01  # Reset hard sur Release_2024.01
git hard-origin         # Reset hard sur origin/branche-courante
```

### Gestion du .gitignore

```bash
git pp-ig    # Commit + push changements .gitignore
```

---

## 🔒 Configuration safe.directory (optionnel)

### Qu'est-ce que `safe.directory` ?

Git peut bloquer l'accès à un dépôt si le propriétaire du dossier ne correspond pas à l'utilisateur Git actuel. Cette sécurité évite l'exécution de code malveillant.

### Quand en avez-vous besoin ?

Vous rencontrez l'erreur suivante :

```bash
fatal: detected dubious ownership in repository at 'C:/Users/...'
```

Cela arrive dans ces cas :

- Projets sur un **disque réseau** ou partage SMB
- Utilisation de **WSL** avec des dossiers Windows
- Dossiers créés par un **autre utilisateur**
- Projets clonés avec des **permissions différentes**

### Solutions

#### ✅ Option 1 : Marquer un projet spécifique (recommandé)

```bash
git config --global --add safe.directory "C:/Users/<USERNAME>/Documents/work/mon-projet"
```

#### ⚠️ Option 2 : Marquer tous les dossiers (moins sécurisé)

```bash
git config --global --add safe.directory '*'
```

Cela désactive la vérification de propriété pour tous les dépôts.

#### ❌ Option 3 : Supprimer la directive

Si vous n'avez jamais rencontré ce problème, supprimez la ligne suivante du fichier `~/.gitconfig` :

```properties
[safe]
    directory = <PATH_TO_SAFE_DIRECTORY>
```

### Configuration dans `.gitconfig`

```properties
# Exemple pour un projet spécifique
[safe]
    directory = C:/Users/eric/Documents/work/projet-client

# Ou pour tous les projets (moins sécurisé)
[safe]
    directory = *
```

---

## 📁 Organisation recommandée

```plaintext
C:/Users/<USERNAME>/
├── Documents/
│   ├── projects/           # 👤 Projets personnels (compte HOME)
│   │   ├── mon-site/
│   │   └── mon-app/
│   └── work/              # 💼 Projets professionnels (compte WORK)
│       ├── projet-client/
│       └── app-entreprise/
```

Cette structure permet à Git de basculer automatiquement entre les comptes.

---

## 🔄 Workflow complet exemple

### Projet personnel (nouveau)

```bash
cd ~/Documents/projects/
mkdir mon-nouveau-projet && cd mon-nouveau-projet

# Initialisation
git init
echo "# Mon Projet" > README.md
git add .

# Commit et push (compte HOME automatique)
git pp "Initial commit"

# Lier au dépôt GitHub perso
git remote add origin git@github-home:MonCompte/mon-nouveau-projet.git
git push -u origin main
```

### Projet professionnel (nouveau)

```bash
cd ~/Documents/work/
mkdir projet-client && cd projet-client

# Initialisation
git init
echo "# Projet Client" > README.md
git add .

# Commit et push (compte WORK automatique)
git pp "Initial commit"

# Lier au dépôt GitHub pro
git remote add origin git@github-work:EntrepriseXYZ/projet-client.git
git push -u origin main
```

### Créer une branche de feature

```bash
# Depuis develop
git dev
git new-br-dev 1234 "ajout formulaire contact"

# Travailler sur la feature
# ... modifications ...
git pp "Implementation formulaire"

# Retour sur develop après push
git ps-dev
```

---

## ✅ Bonnes pratiques

- Toujours utiliser `github-home` ou `github-work` (jamais `git@github.com` directement)
- `ssh -T` sert UNIQUEMENT à tester la connexion
- Le message _"does not provide shell access"_ est NORMAL
- Vérifier l'identité Git avant le premier commit : `git config user.email`
- Organiser les projets dans des dossiers séparés (projects/ vs work/)
- Utiliser les alias pour gagner du temps et éviter les erreurs
- Les alias normalisent automatiquement les caractères spéciaux dans les noms de branches

---

📌 **Snippet prêt pour README.md / Wiki / Notion / Obsidian**
