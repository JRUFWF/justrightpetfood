#!/bin/bash

# Script to set up just right pet food development environment
# pull src from bitbucket
echo "*********  pull magento core code from bitbucket, make sure you have ssh access. *********  "
if [ -e "src/auth.json" ]; then
  echo "done"
  else
  git clone ssh://git@52.166.71.39:7999/npujr/purina-us-justright-platform.git src
fi

echo "*********  create code and design folder under src/app. *********  "
cd src/app
if [ -d "code" ]; then
  echo "done"
  else
  mkdir code
fi
if [ -d "design" ]; then
  echo "done"
  else
  mkdir design
fi

echo "*********   pull most recent magento from master *********  "
cd ../
git pull
cd ../

echo "*********  Copy the conf and env file to the src directory  ********* "
cp config/nginx.conf.sample src/
cp config/env.php.sample src/app/etc/env.php

echo "********* pull react core repo from bitbucket  ********* "
if [ -d "react/purina-us-justright-module-react-app" ]; then
  echo "done"
  else
  git clone ssh://git@52.166.71.39:7999/npujr/purina-us-justright-module-react-app.git react/purina-us-justright-module-react-app
fi
echo
echo "********* pull react addon repo from bitbucket  ********* "
if [ -d "react/purina-us-justright-react-addons" ]; then
  echo "done"
  else
  git clone ssh://git@52.166.71.39:7999/npujr/purina-us-justright-react-addons.git react/purina-us-justright-react-addons
fi

echo "********* set up react core  ********* "
cd react/purina-us-justright-module-react-app
if [ -f ".env.development" ]; then
  echo "done"
  else
  cp .env.sample .env.development
fi

echo "*********  pull most recent react core from master  ********* "
git pull

read -p "react core: run npm install? [Yn] " -r
	if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
		npm install
	fi
	echo

echo "********* create react core build folder  ********* "
if [ -d "build" ]; then
  echo "done"
  else
  npm run build
fi
cd ../../

echo "********* set up react add on  ********* "
cd react/purina-us-justright-react-addons
if [ -f ".env.local" ]; then
  echo "done"
  else
  cp .env.sample .env.local
fi

echo "*********  pull most recent react addon from master.  ********* "
git pull

read -p "react addon: run npm install? [Yn] " -r
	if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
		npm install
	fi
	echo
echo "*********  create react addon dist-addons-bdp folder  ********* "
if [ -d "dist-addons-bdp" ]; then
  echo "done"
  else
  npm run build-bdp-view
fi

echo "*********  create react addon dist-addons-tab folder  ********* "
if [ -d "dist-addons-tab" ]; then
  echo "done"
  else
  npm run build-tab-view
fi


cd ../../

echo "*********  start the docker container   *********  "
bin/start
echo "*********  Initial copy will take a few minutes...  ********* "
bin/copytocontainer --all

echo "*********  build and test ********* "
bin/composer install
bin/copytocontainer --all
cd src
composer build-and-test
cd ../

echo "********* set up magento db *********"
bin/seed-magento-db
bin/magento setup:upgrade

echo "*********  sync magento master data (est 5 mins)  ********* "
bin/clinotty mysql -hdatabase -umagento -pmagento magentodb < src/master-data.sql


if [ -d "src/app/code/PurinaJustRight/Core/ViewModel" ]; then
            echo "********* magento ready ********* "
          else
             bin/stop
 	     echo "********* magento NOT ready, rm vendor ********* "
             bin/delete-vendor-folder
             echo "install again"
             bin/composer install
             bin/composer update
          fi

echo " ********  sync master data done   ********* "
bin/magento app:config:import

echo "***restart to enable react project in docker container"
bin/restart

echo ">>>> set up local domain to justrightpetfood.local<<<<"
bin/setup-domain justrightpetfood.local

read -p "do you want to open local test site [Yn] " -r
	if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
		open https://justrightpetfood.local
	fi
	echo
