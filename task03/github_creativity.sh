#!/bin/bash

# List all pull requests
echo "Give me your GitHub repo url"
read URL
USER_REPO=$("$URL" | sed -E 's/[^\/]*\/\/[^\/]*\/(.*)\..*/\1/')


GIT_PULL () {


curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/Chelbsik/andersen/pulls
}

GIT_PULL $1