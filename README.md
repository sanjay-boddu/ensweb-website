# Ensembl website docker

### Pre-requisites

A local mysql instance serving an Ensembl sessions database is required - this must be accessible from your docker container. You'll need to set up a local mysql server, then create a user and database as described below.

##### Create the `ensrw` user and grant required priviledges

```
mysql> CREATE USER 'ensrw'@'%' IDENTIFIED BY 'ensrw';
mysql> GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON `%`.* TO 'ensrw'@'%';
```

##### Create the `ensembl_session` database

```
mysql> CREATE DATABASE `ensembl_session`
```

Now create the table schema using the SQL file here http://ftp.ensembl.org/pub/release-90/mysql/ensembl_accounts/

### Building the docker image

##### Clone this repo and set your CWD

```
git clone https://github.com/nicklangridge/webdocker-website
cd webdocker-website
```

##### Build the image

```
docker build --rm --no-cache --build-arg ENSEMBL_SERVERNAME=<servername> --build-arg SESSION_HOST=<host> --build-arg SESSION_PORT=<port> --build-arg SESSION_USER=<user> --build-arg SESSION_PASS=<password> -t webdocker-website:latest .
```

Arguments
* ENSEMBL_SERVERNAME - (required) this is the domain name of your Ensembl server - if you are not using a domain name you should set this to the external IP of your docker container 
* SESSION_HOST - (required)  host name of the mysql instance serving the sessions db
* SESSION_PORT - (default=3306) port number of the mysql instance serving the sessions db
* SESSION_USER - (default=ensrw) sessions db user name
* SESSION_PASS - (default=ensrw) sessions db user password

##### Run a container

```
docker run -p 80:8080 -dt webdocker-website:latest
```

This runs the container in daemon mode. The website should now be available on port 80 

##### Debugging

For debugging you may want to run a container in interactive mode using

```
docker run -p 80:8080 -t webdocker-website:latest bash
```

Now you can explore the running container from the command line.