# Trakt.or Docker
Docker container for the following standalone script:

- https://github.com/h1f0x/trakt-plex-tracker

It is based on the latest CentOS docker image:
- https://hub.docker.com/_/centos

## What does this image?
It provides you with a simple web application to manage and track your progress of your tv-show Plex library. You library will be verified against the free API of trakt.tv, all you need to do is create a free account and issue yourself an API key. 
> Your database will be refreshed every 15 minutes.

![Upcoming Shows](https://github.com/h1f0x/docker-trackt-plex-tracker/blob/master/images/1.png?raw=true) 
![Detail Show](https://github.com/h1f0x/docker-trackt-plex-tracker/blob/master/images/2.png?raw=true)

## Install instructions

### trakt.tv API keys
Visit https://trakt.tv/oauth/applications and create a new application.

You will get the following API keys:
- Client ID
- Client Secret

Note it down.

### Deploy the docker container
To get the docker up and running execute fhe following command:

```
docker run -it --name traktor -v /path/to/config-folder:/config:rw -v /path/to/plex-database-folder:/plex:ro -d -p 8000:80 --privileged h1f0x/docker-traktor
```

The default location for your Plex database file depends on your OS:

- Windows
> %LOCALAPPDATA%\Plex Media Server\Plug-in Support\Databases\

- Linux
> $PLEX_HOME/Library/Application Support/Plex Media Server/Plug-in Support/Databases/


## Configure Trakt.or

After the first run, you will find the template for the configuration located at:

> /path/to/config-folder/config.ini

Modify the following lines in the configuration file:

```
[trakt.tv]
client_id = <CLIENT_ID>
client_secret = <CLIENT_SECRET>

[Plex]
database_location = /plex/com.plexapp.plugins.library.db

# language codes examples > de, fr, it, es and so on.. (https://trakt.docs.apiary.io/#reference/languages/get-languages)
# script default language is "en"
library_language = en
```

Please restart the docker container for instant data refresh. Otherwise the data will be refreshes every 15 minutes automatically.

## Enjoy!

Open the browser and go to:

> http://localhost:8000
