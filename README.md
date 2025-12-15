_This project has been created as part of the 42 curriculum by nfararan._

**Inception guidelines**:

- [Description](#description)
  - [Virtual machines vs Docker](#virtual-machines-vs-docker)
  - [Secrets vs Environments Variables](#secrets-vs-environments-variables)
  - [Docker Network vs Host Network](#docker-network-vs-host-network)
  - [Docker Volumes vs Bind mounts](#docker-volumes-vs-bind-mounts)
- [Instructions](#instructions)
- [Resources](#resources)

# Description

The purpose of the **Inception** project is the make an infrastructure of a website and its server, database.
All this purpose is made by the tool **Docker**. This project aims the master of the containerization concept, so that the project is making the infrastructure to microservice technics.

## Virtual machines vs Docker

| Features | VMs | Docker |
| ------- | --- | ------ |
| **Architecture** | Each runs a full independent guest OS | Share the host OS kernel |
| **Resource Usage** | Higher overhead: require dedicated, pre-allocated resources (GB in size) | Lower overhead: use resources on demand (MB in size) |
| **Performance** | Slower startup due to booting the entire OS | Very fast startup and execution |
| **Isolation/Security** | Hardware-level isolation: a breach in one VM does not affect others | Process-level isolation: a kernel vulnerability can affect all containers |
| **Portability** | Less portable: requires a compatible hypervisor and OS configuration | Highly portable: runs consistently across any system with a [Docker engine](https://docs.docker.com/engine/) |
| **Management** | Managed by hypervisors or cloud platforms | Often managed via orchestration tools like _Kubernetes_ |

## Secrets vs Environments Variables

| Features | Secrets | Env. Variables |
| -------- | ------- | -------------- |
| **Security** | Secure for sensitive data. Values are encrypted at rest and in transit | Insecure for sensitive data. Values are plain text |
| **Visibility** | Not visible via docker inspect. Mounted as files in a tmpfs (in-memory filesystem) | Visible via docker inspect command, process lists, and potentially logs |
| **Access** | Only accessible to explicitly granted services and the specific application routine that reads the file | Accessible to all processes running within the container by default |
| **Usage** | Suitable for passwords, API keys, certificates, and SSH keys | Suitable for non-sensitive configuration data (e.g., DEBUG_MODE=true) |
| **Management** | Managed centrally by the Docker Swarm or Compose system | Often managed via .env files (which should be in .gitignore) |

## Docker Network vs Host Network

| Feature | Docker Network | Host Network |
| ------- | -------------- | ------------ |
| **Isolation** | Yes, container has its own network namespace and IP address | No, container shares the host's network namespace and IP address |
| **Port Access** | Requires explicit port mapping (using -p or -P) to expose services to the host or external network | Ports exposed by the container are directly bound to the host's ports (e.g., container port 80 is host port 80) |
| **Performance** | Slightly lower due to the overhead of Network Address Translation (NAT) and the virtual network layer | Higher, as it bypasses NAT and virtual networking entirely, offering near-native performance |
| **Port Conflicts** | Multiple containers can use the same internal port as they have isolated namespaces; conflicts are avoided | Only one process (container or host) can bind to a specific port at a time, leading to potential conflicts |
| **Default** | The default network mode for standalone containers | Not the default; must be explicitly specified (using --network host flag) |
| **Use Cases** | Ideal for most general-purpose applications, multi-container setups (like Docker Compose), and secure, isolated microservices | Best for performance-critical applications, system-level monitoring tools that need access to the host's network stack, or situations where NAT overhead is undesirable |
| **Platform** | Works across Linux, macOS, and Windows | Primarily functional on Linux hosts; behaves differently or is limited on Docker Desktop for macOS/Windows |

## Docker Volumes vs Bind Mounts

| Feature | Docker Volumes | Bind Mounts |
| ------- | -------------- | ----------- |
| **Management** | Fully managed by the Docker engine | Managed by the host machine's file system |
| **Location** | Stored in a Docker-specific directory (/var/lib/docker/volumes/ on Linux) | Can be stored anywhere on the host file system, specified by an absolute path |
| **Performance** | Optimized performance, especially on Docker Desktop for Windows/Mac (avoids host filesystem translation overhead) | Can have performance penalties on macOS and Windows hosts due to OS translation layers |
| **Portability** | Platform-agnostic and easier to migrate/back up across different operating systems/hosts | Dependent on the host's directory structure and OS, making migration more complex |
| **Initial Content** | Can be pre-populated with content from the container image when created | An empty host directory will hide/overwrite any existing files in the container's mount point |
| **Use Cases** | Databases, production workloads, sharing data safely among multiple containers | Local development (live code updates), sharing host configuration files, accessing log files directly on the host |

# Instructions

The project requires **_GNU Make_** for compiling and running.
First, you need to setup the environment for all the container which need
environment variables and secrets (e.g: database credentials, wordpress
credentials, etc).

```sh
# Setting up the docker secrets
make setup
```

 Then you need to create a **".env"** file at the path: "_srcs/requirements/mariadb_"

```.env
# Environment file content
DB_USER=the_db_username
DB_NAME=the_db_name
```

After all environment setup you can run all the services:

```sh
make up
```

# Resources

There are many documentations for learning **Docker**
on the internet but for master these next are very explicit and user-friendly:

- [Docker tutorials for beginners](https://docker-curriculum.com/)
- [Docker official website](https://docs.docker.com/get-started/)
- [MariaDB Custom image reference](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/creating-a-custom-container-image)
- [Nginx installation](https://nginx.org/en/linux_packages.html#Debian)
- [Wordpress + Nginx setup](https://www.ionos.fr/digitalguide/hebergement/blogs/installer-wordpress-sur-nginx/)

Generative AI also can contribute to your documentation and make conception
comprehension really fast (ChatGPT, QwenChat, Gemini, etc).
