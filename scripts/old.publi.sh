#!/bin/sh

DIR=$(dirname "$0")

cd $DIR/..

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo -d public/2018

cp CNAME ./public/
cp -r favi/* ./public/
cp index.redirect ./public/index.html

# add 2016 content to 2016 folder

shopt -s extglob
rm -rf ../bcdata-deployed/!(.git)
mv ./public/* ../bcdata-deployed/

read -erp "Push gh-pages to origin? (y/n): " doPushToRemote

if [[ "$doPushToRemote" == "y" ]]
then
    echo "Pushing to remote..."
    read -erp "Commit Message: " commitMessage
    cd ../bcdata-deployed && git add --all && git commit -m "$commitMessage" && git push origin gh-pages
fi
