#!/bin/sh

if [ -z "$HEROKU_TOKEN" ]; then
  echo "Can't deploy to Heroku without a Heroku Token. Exiting...";
  exit 1;
fi

echo "machine api.heroku.com" > ~/.netrc
echo "  login greenca6@gmail.com" >> ~/.netrc
echo "  password $HEROKU_TOKEN" >> ~/.netrc
echo "machine git.heroku.com" >> ~/.netrc
echo "  login greenca6@gmail.com" >> ~/.netrc
echo "  password $HEROKU_TOKEN" >> ~/.netrc

# Login to the Heroku docker registry
docker login --username=_ --password=$HEROKU_TOKEN registry.heroku.com

# API and UI app
REPO_ROOT=$(pwd)
API_DIR="$REPO_ROOT/api"
UI_DIR="$REPO_ROOT/ui"
API_APP_NAME="debug-mafia-api"
UI_APP_NAME="debug-mafia-ui"

# Deploy the API
echo "Deploying API..."
cd $API_DIR
heroku container:push web -a $API_APP_NAME
heroku container:release web -a $API_APP_NAME

# Deploy the UI
echo "Deploying UI..."
cd $UI_DIR
heroku container:push web -a $UI_APP_NAME
heroku config:set -a $UI_APP_NAME REACT_APP_API="https://$API_APP_NAME.herokuapp.com"
heroku container:release web -a $UI_APP_NAME

echo "Deploy Script Complete"
