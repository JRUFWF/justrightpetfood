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

## Setup Steps
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
10. `bin/copytocontainer --all`
11. `bin/composer build-and-test`
12. `bin/sync-master-data`
13. `bin/setup-domain justrightpetfood.local`
