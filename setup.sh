#!/bin/bash

################ 1: General stuff
######## Script to set up just right pet food development environment
root_dir=$(pwd)

######## Ask about resetting containers and volumes
read -p "Remove any existing containers for this Docker application? [yN] " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	read -p "Reset persistent storage for this Docker application? [yN] " -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		docker-compose down -v
	else
		docker-compose down
	fi
else
	docker-compose stop
fi
echo


################ 2: Get all the repos from bitbucket 
######## pull src from bitbucket
echo "********* pull magento core code from bitbucket, make sure you have ssh access *********  "
[ -e "src/auth.json" ] || git clone ssh://git@52.166.71.39:7999/npujr/purina-us-justright-platform.git src

echo "********* Copy the conf and env file to the src directory ********* "
cp config/nginx.conf.sample src/
cp config/env.php.sample src/app/etc/env.php

echo "********* create code and design folder under src/app *********  "
cd src/app
[ -d code ] || mkdir code
[ -d design ] || mkdir design

echo "**** Set up magento branch you want to pull from (maybe the most recent release branch)"
git branch -r
read -p "Magento branch name you want to pull: " MAGENTO_BRANCH_NAME
echo "********* pull most recent magento from ${MAGENTO_BRANCH_NAME} *********  "
cd "${root_dir}/src"

magento_branch_name=$(git branch --show-current)
echo "you current magento repo branch is ${magento_branch_name}"
if [[ "${magento_branch_name}" == ${MAGENTO_BRANCH_NAME} ]]; then
  echo
else
  read -p "magento: do you want checkout to ${MAGENTO_BRANCH_NAME}? [Yn] " -r
  if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
    git checkout origin ${MAGENTO_BRANCH_NAME}
  fi
  echo
fi
git pull origin ${MAGENTO_BRANCH_NAME}
cd "${root_dir}"


######## pull all the react repos to local
echo "********* pull react core repo from bitbucket ********* "
[ -d "react/purina-us-justright-module-react-app" ] || git clone ssh://git@52.166.71.39:7999/npujr/purina-us-justright-module-react-app.git react/purina-us-justright-module-react-app
echo

echo "********* pull react addon repo from bitbucket ********* "
[ -d "react/purina-us-justright-react-addons" ] || git clone ssh://git@52.166.71.39:7999/npujr/purina-us-justright-react-addons.git react/purina-us-justright-react-addons
echo

echo "********* pull react blend tab from bitbucket ********* "
[ -d "react/purina-us-justright-module-react-blend-tab" ] || git clone ssh://git@52.166.71.39:7999/npujr/purina-us-justright-module-react-blend-tab.git react/purina-us-justright-module-react-blend-tab
echo

######## a: react core
echo "********* set up react core env ********* "
cd react/purina-us-justright-module-react-app
[ -f ".env.development" ] || cp .env.sample .env.development

echo "********* pull most recent react core from your current branch ********* "
react_core_branch_name=$(git branch --show-current)
echo "you current react core repo branch is ${react_core_branch_name}"
if [[ "${react_core_branch_name}" == "master" ]]; then
  echo
else
  read -p "react core: do you want checkout to master? [Yn] " -r
  if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
    git checkout origin master
  fi
  echo
fi

git pull origin

read -p "react core: run npm install? [Yn] " -r
if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
  npm install
fi
echo

echo "********* create react core build folder ********* "
if [ -d "build" ]; then
  read -p "react core:  run build again? [Yn] " -r
  if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
    npm run build
  fi
else
  npm run build
fi
cd "${root_dir}"

######## b: react blend tab
echo "********* set up blend tab env ********* "
cd react/purina-us-justright-module-react-blend-tab

echo "********* pull most recent react blend tab from current branch ********* "
react_blend_tab_branch_name=$(git branch --show-current)
echo "you current react blend tab repo branch is ${react_blend_tab_branch_name}"
if [[ "${react_blend_tab_branch_name}" == "master" ]]; then
  echo
else
  read -p "react blend tab: do you want checkout to master? [Yn] " -r
  if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
    git checkout origin master
  fi
  echo
fi

git pull origin master

read -p "react blend tab: run npm install? [Yn] " -r
if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
  npm install
fi
echo

echo "********* create react blend tab build folder ********* "
if [ -d "build" ]; then
  read -p "react blend tab: run build again? [Yn] " -r
  if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
    npm run build
  fi
else
  npm run build
fi
cd "${root_dir}"

######## c: react add on
echo "********* set up react add on env ********* "
cd react/purina-us-justright-react-addons
if [ -f ".env.local" ]; then
  echo "done"
else
  cp .env.sample .env.local
fi

echo "********* pull most recent react addon from current branch ********* "
react_add_on_branch_name=$(git branch --show-current)
echo "you current react addon repo branch is ${react_add_on_branch_name}"
if [[ "${react_add_on_branch_name}" == "master" ]]; then
  echo
else
  read -p "react addon: do you want checkout to master? [Yn] " -r
  if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
    git checkout origin master
  fi
  echo
fi

git pull origin master

read -p "react addon: run npm install? [Yn] " -r
if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
  npm install
fi
echo

echo "********* create react addon dist-addons-bdp folder ********* "
if [ -d "dist-addons-bdp" ]; then
  read -p "react addon dist-addons-bdp: run build again? [Yn] " -r
  if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
    npm run build-bdp-view
  fi
else
  npm run build-bdp-view
fi

echo "********* create react addon dist-addons-tab folder ********* "
if [ -d "dist-addons-tab" ]; then
  read -p "react addon dist-addons-tab: run build again? [Yn] " -r
  if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
    npm run build-tab-view
  fi
else
  npm run build-tab-view
fi

cd "${root_dir}"


################ 3: start the docker container
######## start the docker container
echo "********* start the docker container *********"
bin/start


################ 4: prepare database
echo "********* set up magento db *********"
FILE=db/magento.sql

if [ -f "$FILE" ]; then
  read -p "Do you wish to seed the magentodb database? [Yn] " -r
  if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
    bin/clinotty mysql -hdatabase -umagento -pmagento magentodb <$FILE
  fi
else
  echo "$FILE is required"
fi

echo "********* Initial copy will take a few minutes... ********* "
bin/copytocontainer --all

echo "********* build and test *********"
bin/cli chmod 777 -R *
bin/composer build-and-test

echo "********* check if vendor_path exit *********"
[ -f 'src/app/etc/vendor_path.php' ] ||
  while true; do
    if [[ -f 'src/app/etc/vendor_path.php' || -d "src/app/code/Ves" ]]; then
      echo "exit, ok"
      break;
    else
      bin/start-no-sync
      bin/restart
      bin/delete-vendor-folder
      bin/composer build-and-test
    fi
  done


################ 5: sync master data, copy generated and vendor folder, and set test admin account
echo "********* sync magento master data, est 5 mins  ********* "
bin/sync-master-data

echo "******** sync master data done ********* "
bin/magento se:up

echo "******** update sql to forbid 404 redirect ********* "
mysql -uroot -proot -hdatabase magentodb -e "update core_config_data set value='https://justrightpetfood.local/' where path like '%/base_url';"
mysql -uroot -proot -hdatabase magentodb -e "delete from core_config_data where path like '%admin/url/%'"
bin/magento setup:upgrade

echo "******** copy generated and vendor folder from container to local ********* "
bin/copyfromcontainer generated
bin/copyfromcontainer vendor

echo "******** create admin account ********* "
bin/cli php bin/magento admin:user:create

echo ">>>> set up local domain to justrightpetfood.local <<<<"
bin/setup-domain justrightpetfood.local


echo ">>>> turn on the xDebug for php <<<<"
bin/xdebug enable

read -p "do you want to open local test site [Yn] " -r
if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
  open https://justrightpetfood.local
fi
echo
