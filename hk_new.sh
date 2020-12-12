#!/usr/bin/env bash

set -euo pipefail

git remote show heroku \
  && >&2 echo -e "\nERROR: Found an existing git remote named 'heroku'. Aborting." \
  && exit 1

heroku create

heroku buildpacks:add https://github.com/heroku/heroku-buildpack-apt
heroku buildpacks:add https://github.com/niteoweb/heroku-buildpack-shell
heroku addons:create heroku-postgresql:hobby-dev

git push heroku master:main
