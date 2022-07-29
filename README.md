# Docker Magento Dev Env
## Dockerized Just Right Magento 2 local development setup 
This is a configuration

Built from [Mark Shust's configuration template](https://github.com/markshust/docker-magento)
    
Refer to Mark Shust's github page for more details on the [predefined custom CLI commands](https://github.com/markshust/docker-magento#custom-cli-commands) he created to interact with the containerized services.

For info on Magento Core CLI, refer to [Adobe's CLI Reference Docs](https://devdocs.magento.com/guides/v2.4/reference/cli/magento.html)

## Prerequisites
### Docker-Desktop

recommended resource settings:
- CPUs: 4
- Memory: 8.00 GB
- Swap: 1 GB
- if you are using mac, do not forget to turn allow apps to download from "any"

## Setup Steps (in progress)
1. Clone this project to your desired location
2. Get the provided magento sql dump file (ask any of the devs) and save it in `db/` as `magento.sql` (if permission denied, use LC_CTYPE=C && LANG=C && sed 's/\sDEFINER=`[^`]*`@`[^`]*`//'  -i magento.sql to remove the definer)
3. run
    ```sh
    ./setup.sh
    ```
    
## Manual Setup steps
1. Clone this project to your desired location
2. Inside the project, clone the Just Right platform to the `src/` folder.

    ```sh
    git clone ssh://git@52.166.71.39:7999/npujr/purina-us-justright-platform.git src
    ```
3. Navigate into `src/` and checkout the desired branch for the platform code.
4. Create the `src/app/code` and `src/app/design` folders if they do not exist.
5. Copy the nginx.conf.sample file to the `src/` directory.

    ```sh
    cp config/nginx.conf.sample src/
    ```
6. Copy over the env.php to `src/`

    ```sh
    cp config/env.php.sample src/app/etc/env.php
    ```
7. `bin/start` to start up the containers
8. Get the provided magento sql dump file (ask any of the devs) and save it in `db/` as `magento.sql`
9. `bin/seed-magento-db`
10. `bin/restart-no-sync`
11. `bin/copytocontainer --all`
12. `bin/composer build-and-test`
13. `bin/sync-master-data`
14. `bin/magento app:config:import`
15. `bin/setup-domain justrightpetfood.local`
    
## Setup Launch Darkly
go to https://app.launchdarkly.com/settings/projects and find the keys for dev, put them to
go to https://justrightpetfood.local/admin stores -> setting/configuration -> purina global -> Launch Darkly -> general

## Update Magento
After magento update masterdata or switch to new branch and error detected, run
```sh
./magento-update.sh
```
or 
```
bin/magento setup:di:compile && bin/magento ca:fl
```

hint1: if something went wrong bash into box, rm vendor generates and then composer install, then go inside vendor composer install, then should looks right

hint2: if mac chrome have no process anyway for the unsafe local domain, click the browser then type "thisisunsafe"; https://stackoverflow.com/questions/58802767/no-proceed-anyway-option-on-neterr-cert-invalid-in-chrome-on-macos 
