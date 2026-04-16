#!/bin/bash
# BY: MAUVADAO
# VER: 2.1.0

set -euo pipefail

BASE="$(basename "$(pwd)")"
USUARIO="mauvadao4g"
REPO_SSH="git@github.com:${USUARIO}/${BASE}.git"

echo "[+] Repo: $BASE"

# =========================
# Teste SSH confiável
# =========================
echo "[+] Testando SSH..."

SSH_OUT=$(ssh -T git@github.com 2>&1 || true)

if ! echo "$SSH_OUT" | grep -q "Hi ${USUARIO}"; then
    echo "[ERRO] SSH falhou ou não pertence ao usuário correto"
    echo "Saída:"
    echo "$SSH_OUT"
    exit 1
fi

echo "[✔] SSH OK"

# =========================
# Config Git
# =========================
git config --global --add safe.directory "$(pwd)"

# README
[[ ! -f README.md ]] && echo "# $BASE" > README.md

# Init repo
[[ ! -d .git ]] && git init

# Add tudo
git add .

# Commit se necessário
if ! git diff --cached --quiet; then
    git commit -m "init"
else
    echo "[i] Nada pra commitar"
fi

# Branch main
git branch -M main

# Remote
if git remote get-url origin &>/dev/null; then
    echo "[+] Ajustando remote para SSH"
    git remote set-url origin "$REPO_SSH"
else
    echo "[+] Adicionando remote SSH"
    git remote add origin "$REPO_SSH"
fi

# Mostrar remote
echo "[+] Remote atual:"
git remote -v

# =========================
# Push
# =========================
echo "[+] Enviando para GitHub..."
git push -u origin main

echo "[✔] Concluído"