#!/bin/bash

# Determine VERSION
if [ -n "$INPUT_VERSION" ]
then
  VERSION=$INPUT_VERSION &&
    echo "INPUT_VERSION detected..."
elif [ -f package.json ]
then
  VERSION=$(cat package.json | jq -r .version) &&
    echo "Node detected..."
elif [ -f  ./lib/*/version.rb ]
then
  VERSION=$(cat ./lib/*/version.rb | grep -oP "(?<=VERSION).*" | grep -oE "[a-zA-Z.0-9]+") &&
    echo "Ruby detected..."
else
  echo "VERSION unable to be detected..."
  echo "Set INPUT_VERSION, or submit a PR to support your language/framework!"
  echo "Exiting."
  exit 1
fi
GIT_TAG_NAME=${INPUT_GIT_TAG_PREFIX}${VERSION}
echo "Tag detected: ${GIT_TAG_NAME}"

# Check if current tag matches detected tag
current_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
if [ "$current_tag" = "$GIT_TAG_NAME" ]; then
  echo "Current tag matches detected tag!!\nExiting."
  exit 1
fi

# Check tag on GitHub
GET_API_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/git/ref/tags/${GIT_TAG_NAME}"
echo "Checking for tag on GitHub..."
http_status_code=$(curl -LI $GET_API_URL -o /dev/null -w '%{http_code}\n' -s \
  -H "Authorization: token ${GITHUB_TOKEN}")
echo "GitHub returned with a ${http_status_code}."

# Exit if tag exists
if [ "$http_status_code" -e "404" ]
then
  echo "Tag does NOT exist. You may continue!"
elif [ "$http_status_code" -e "200" ]
then
  echo "Tag already exists.\nExiting."
  exit 1
else
  echo "Tag unable to be determined.\nExiting."
  exit 1
fi
