#!/usr/bin/env bash

apt-get update
apt-get install -y curl gnupg2
wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh

cat > ~/.netrc << EOF
machine api.heroku.com
  login $HEROKU_LOGIN
  password $HEROKU_API_KEY
machine git.heroku.com
  login $HEROKU_LOGIN
  password $HEROKU_API_KEY
EOF

git clone https://git.heroku.com/$HEROKU_APP_NAME.git build/html
