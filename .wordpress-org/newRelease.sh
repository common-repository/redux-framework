#!/bin/bash
cd "`dirname "$0"`"
cd ..
dir=$(pwd)

if [ -n "$1" ]; then
	if [ -d "tags/$1" ]; then
	  echo "That tag $1 already exists. Update your version.";

	else

		# Update trunk
		cd trunk
		git reset --hard
		git pull
		git clean -d -f -f
		
		rm -f .gitignore
		rm -f .travis.yml
		rm -f bootstrap_tests.php
		rm -f kill-travis.php
		rm -f phpunit.xml
		rm -fr grunt-phplint
		rm -fr tests
		rm -fr bin
		rm -fr .tx

		cd ..
		svn add --force trunk
		svn st | grep ! | sed 's/!M/!/' | cut -d! -f2| sed 's/^ *//' | sed 's/^/"/g' | sed 's/$/"/g' | xargs svn --force rm

		# Copy trunk to a new directory to modify
		cp -r trunk temp

		cd temp

		rm -fr .git

		cd ..

		while true; do
		    read -p "Are you ready to create the tag $1 (y/n)? " yn
		    case $yn in
		        [Yy]* ) mv temp tags/$1; svn add --force tags/$1; break;;
		        [Nn]* ) echo "Deleting the temp directory."; rm -fr temp; exit;;
		        * ) echo "Please answer yes or no.";;
		    esac
		done

		echo "Everything has been done. Ready to commit to WordPress. All you need to do is the following:";
		echo "svn ci -m 'YOUR COMMIT MESSAGE HERE'";

	fi

else
    echo "No tag version specified."
fi

