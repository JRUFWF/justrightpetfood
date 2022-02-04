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

## Setup Steps
1. Clone this project to your desired location
2. Get the provided magento sql dump file (ask any of the devs) and save it in `db/` as `magento.sql`
3. run
    ```sh
    ./setup.sh
    ```
## Setup Launch Darkly
go to https://app.launchdarkly.com/settings/projects and find the keys for dev, put them to
go to https://justrightpetfood.local/admin stores -> setting/configuration -> purina global -> Launch Darkly -> general

After magento update masterdata or switch to new branch and error detected, run
```sh
./magento-update.sh
```
