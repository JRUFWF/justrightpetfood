#!/bin/bash

################ 1: Restart no sync
echo ""******** rm generated folder ********* "
bin/delete-vendor-folder

echo "********* 1/5 Restart no sync ********* "
bin/stop "$@"
bin/start-no-sync "$@"

################ 2: Copy file from host to container
echo "********* 2/5 Copy file from host to container  ********* "
bin/copytocontainer --all

################ 3: start container
echo "******** 3/5 Start container ********* "
bin/restart

################ 4: sync master data
echo "********* 4/5 Sync magento master data  ********* "
bin/sync-master-data

################ 5: build again
echo "******** 5/5 Composer install and build ********* "
bin/composer build-and-test


echo "******** copy vendor and generate folder to local ********"
bin/copyfromcontainer vendor
bin/copyfromcontainer generated


