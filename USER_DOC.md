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

### Nginx + TLS/SSL

Nginx is a service that provides a webserver for the website and that serves the web content.
The TLS/SSL consists of the security module through the nginx webserver.
That means that users can visits the website with the secure protocol HTTPS.

### Wordpress + PHP-FPM

Wordpress is a popular, free and open-source Content Management System used to
build and manage websites without needing to code.
PHP-FPM (PHP-FastCGI Process Manager) is a high-performance, efficient 
implementation of PHP's FastCGI protocol that acts as a separate process manager for PHP,
allowing web servers to handle manu concurrent users and high traffic by managing pools of
PHP worker processes.

### MariaDB

MariaDB is a popular, open-source relational databas management system created
as a community-driven fork of MySQL by its original developers, offering enhanced
performancem security, and features for modern applications, supporting various workloads
from web apps to big data and AI.


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

- to go to the main website preview: [Main preview](https://nfararan.42.fr) on https://nfararan.42.fr
- to go to the administration panel: [Administration panel](https://nfararan.42.fr/wp-admin) on https://nfararan.42.fr/wp-admin

## Locate and manage credentials

All credentials are located at:

- Secrets (sensible data): **secrets/** directory
- Environment variables (non sensible data): **srcs/.env** file

## Check that the services are running correctly

You can view the services logs by running the following command:

```sh
make ps
```

You can also check services logs by running the command:
```sh
make logs
```
