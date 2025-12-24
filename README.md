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
ssh-keygen -t ed25519 -C "<email du dépôt>" -f ~/.ssh/id_ed25519_home

# Compte professionnel
ssh-keygen -t ed25519 -C "<email du dépôt>" -f ~/.ssh/id_ed25519_work
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
ssh-add $env:USERPROFILE\.ssh\id_ed25519_home
ssh-add $env:USERPROFILE\.ssh\id_ed25519_work

# Vérification
ssh-add -l
```

---

## 3️⃣ Configuration SSH (`~/.ssh/config`)

```ssh
# ===============================
# GitHub – Compte personnel
# ===============================
Host github-home
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_home
    IdentitiesOnly yes

# ===============================
# GitHub – Compte professionnel
# ===============================
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes
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

## ✅ Bonnes pratiques

- Toujours utiliser `github-home` ou `github-work` (jamais `git@github.com` directement)
- `ssh -T` sert UNIQUEMENT à tester la connexion
- Le message _"does not provide shell access"_ est NORMAL

---

📌 **Snippet prêt pour README.md / Wiki / Notion / Obsidian**
