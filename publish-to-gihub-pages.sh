#!/bin/bash

npm install
MESSAGE=$(git log -1 HEAD --pretty=format:%s)
cd web
git add --all .
git commit -m "$MESSAGE"
git push origin gh-pages
cd ..
