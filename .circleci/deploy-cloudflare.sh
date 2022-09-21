#!/usr/bin/env bash

apt update
apt -y install curl

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts

branch=$(git rev-parse --abbrev-ref HEAD)
name=$(basename $(git config remote.origin.url |sed "s/\.git$//") | sed "s/ /-/g" | tr '[:upper:]' '[:lower:]')
npx wrangler pages project create "$name" --production-branch "$branch" || true
npx wrangler pages publish build/html --project-name "$name"
