#!/bin/bash
# BY: MAUVADAO
# VER: 2.0.0

set -euo pipefail

BASE="$(basename "$(pwd)")"
USUARIO="mauvadao4g"
REPO_SSH="git@github.com:${USUARIO}/${BASE}.git"

echo "[+] Repo: $BASE"

# Verifica SSH com GitHub
echo "[+] Testando SSH..."
if  ssh -T git@github.com 2>&1 | grep -qi "successfully authenticated"; then
    echo "[ERRO] SSH não configurado ou chave não adicionada no GitHub"
    exit 1
fi

# Marcar diretório como seguro
git config --global --add safe.directory "$(pwd)"

# Criar README se não existir
[[ ! -f README.md ]] && echo "# $BASE" > README.md

# Iniciar repo se não existir
[[ ! -d .git ]] && git init

# Add arquivos
git add .

# Commit se houver mudança
if ! git diff --cached --quiet; then
    git commit -m "init"
else
    echo "[i] Nada pra commitar"
fi

# Branch main
git branch -M main

# Corrigir ou adicionar remote
if git remote get-url origin &>/dev/null; then
    echo "[+] Ajustando remote para SSH"
    git remote set-url origin "$REPO_SSH"
else
    echo "[+] Adicionando remote SSH"
    git remote add origin "$REPO_SSH"
fi

# Mostrar remote atual
echo "[+] Remote atual:"
git remote -v

# Push
echo "[+] Enviando para GitHub..."
git push -u origin main

echo "[✔] Concluído"