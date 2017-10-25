echo "Checking git status"
if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi


echo "Deleting old publication"
rm -rf public
mkdir public

echo "Generating site in public/2018"
hugo -d public/2018
