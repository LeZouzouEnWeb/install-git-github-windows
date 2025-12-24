###############################################
# .bashrc optimisé Windows 10/11 + Git Bash
# Auteur : Eric (optimisé via ChatGPT)
###############################################

# --------------------------------------------------------------------
# 1. Chargement du ssh-agent Windows (le plus stable)
# --------------------------------------------------------------------
# Vérifie si l'agent Windows tourne
pgrep ssh-agent.exe >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "⏳ Démarrage du SSH agent Windows..."
    powershell.exe -NoProfile -Command "Start-Service ssh-agent" >/dev/null 2>&1
fi

# --------------------------------------------------------------------
# 2. Ajout automatique des clés SSH si pas encore chargées
# --------------------------------------------------------------------
ssh-add -l 2>/dev/null | grep "The agent has no identities" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "🔑 Chargement automatique des clés SSH..."

    # Clé perso
    if [ -f ~/.ssh/home ]; then
        ssh-add ~/.ssh/home >/dev/null 2>&1
        echo "  ✔ Clé 'home' ajoutée"
    fi

    # Clé pro
    if [ -f ~/.ssh/work ]; then
        ssh-add ~/.ssh/work >/dev/null 2>&1
        echo "  ✔ Clé 'work' ajoutée"
    fi
else
    echo "🔐 Clés SSH déjà chargées"
fi

# --------------------------------------------------------------------
# 3. Amélioration du prompt Git (couleurs + info branche)
# --------------------------------------------------------------------
# Fonction pour afficher la branche git
parse_git_branch() {
  git branch 2>/dev/null | sed -n '/\* /s///p'
}

# Prompt coloré
# PS1="\[\e[1;34m\]\u@\h \[\e[1;32m\]\w\[\e[1;33m\]\$(if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then printf ' [%s]' \"\$(parse_git_branch)\"; fi)\[\e[0m\]\n$ "



# --------------------------------------------------------------------
# 4. Alias pratiques pour Git
# --------------------------------------------------------------------
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'

# --------------------------------------------------------------------
# 5. Alias confort
# --------------------------------------------------------------------
alias ll='ls -la'
alias la='ls -a'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'

# --------------------------------------------------------------------
# 6. Correction pour Nano sous Git Bash
# --------------------------------------------------------------------
export TERM=xterm-256color

# --------------------------------------------------------------------
# 7. PATH supplémentaire si besoin (reconnaissance node, php, etc.)
# --------------------------------------------------------------------
# Exemple (décommente si utile)
# export PATH="$PATH:/c/Program Files/nodejs"
# export PATH="$PATH:/c/xampp/php"

###############################################
# FIN DU .bashrc optimisé
###############################################
