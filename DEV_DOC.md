# Developer documentation

## Setup

To set up the environment from scratch, there are some prerequisites first
to be able to run some commands:
- Need to install the [Docker engine](https://docs.docker.com/engine/install/)
- Then you need to install [GNU Make](https://www.gnu.org/software/make/) for script automatization.
Here is an example for installing tha package on Ubuntu distribution:

```sh
sudo apt-get update -y && sudo apt-get install make
```

- Need to install **Docker plugins(docker-buildx & docker-compose)**:
	- **docker buildx**: [Github official repository](https://github.com/docker/buildx)
	- **docker compose**: [Docker official manuals](https://docs.docker.com/compose/install/linux/)

After installing all required packages and tools, now need to
put some requirement for services i.e **secrets** and **environment variables**.
To do so, you have 2 options:

### Option 1

Installing secrets and environment variable automatically by running the following command:

```sh
make setup
```

So that those requirement are filled automatically and you can change their value on:
- **secrets**: secrets/ directory
- **environment variables**: srcs/.env file

### Option 2

You can set up those requirements manually by creating:
- **secrets**:
	- create the file secrets/db_pass.txt and put in there the password for the user
	- create the file secrets/db_root_pass.txt and put in there the password for the root/admin user

- **environment variables**: create the file srcs/.env and put in there:

```sh
DB_USER=the_user_name
DB_NAME=the_database_name
```

# Build and launch

After full filled the requirement setup, you may build and laucnh the project now.
Just run the following command:

```sh
# Show the help for several commands
make

# Directly run the project and build
make up

# Just building the project Docker images
make build
```

# Containers and volumes management

Containers and volumes can be managed by just running some commands with **Make**

```sh
# Start all Containers
make up

# Stop all containers
make down

# Restart all containers
make restart

# View containers state
make ps

# Clean containers and volumes
make clean
```

# Where the project data is ?

The project data is stored on **/home/nfararan/data** of the Virtual Machines.
The data persistence is due by mounting the directory with appropriate
service on the docker container.
