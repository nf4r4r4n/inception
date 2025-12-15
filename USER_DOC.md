# User documentation

- [User documentation](#user-documentation)
  - [Services provided by the stack](#services-provided-by-the-stack)
  - [Start and stop the project](#start-and-stop-the-project)
  - [Access the website and the administration panel](#access-the-website-and-the-administration-panel)
  - [Locate and manage credentials](#locate-and-manage-credentials)
  - [Check that the services are running correctly](#check-that-the-services-are-running-correctly)

## Services provided by the stack

The stack provide some service:

- **Nginx + TLS/SSL**: service that consists of webserver,
- **Wordpress + PHP-FPM**: service for the website content management,
- **MariaDB**: service for the database.

## Start and stop the project

To start the project or to stop it, you can run the following commands:

```sh
# starting the project
make up

# stopping the project
make down
```

## Access the website and the administration panel

The website is made with _wordpress_ then you can directly go check the website preview.
By the way you can go to the administration panel for website change.
So:

- to go to the main website preview: [Main preview](https://nfararan.42.fr)
- to go to the administration panel: [Administration panel](https://nfararan.42.fr/wp-admin)

## Locate and manage credentials

All credentials are located at:

- Secrets (sensible data): **secrets/**
- Environment variables (non sensible data): **srcs/.env**

## Check that the services are running correctly

You can view the services logs by running the following command:

```sh
make ps
```
