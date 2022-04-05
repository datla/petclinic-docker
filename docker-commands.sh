
# saves in the local directory for volume mounts

# docker run mode for application execution
docker network create pclinicnw
docker run -dp 3306:3306 --network pclinicnw  --network-alias mysqlpclinicnw -v /Users/vanilla/Projects/practise/docker/jdocker/mysqldata:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_DATABASE=pclinic mysql:latest
docker build -t petclinic .
docker run --rm -dp 8888:8080 --name pclinic-server --network pclinicnw -e MYSQL_URL=jdbc:mysql://mysqlpclinicnw/pclinic petclinic

# docker-compose up commands for this app 
docker-compose config
docker-compose up -d --build
docker-compose logs <id> -f
docker-compose up

# saves in the imaginary volume mounts
docker network create pclinicnw
docker run -dp 3306:3306 --name mysql-server --network pclinicnw  --network-alias mysqlpclinicnw -v mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_DATABASE=pclinic mysql:latest
docker build -t petclinic .
docker run --rm -dp 8888:8080 --name pclinic-server --network pclinicnw -e MYSQL_URL=jdbc:mysql://mysqlpclinicnw/pclinic petclinic
# docker run --rm -dp 8888:8080 --name petclinic-prod-image --network pclinicnw -e MYSQL_URL=jdbc:mysql://mysqlpclinicnw/pclinic petclinic
docker tag petclinic datla/reponame
docker push datla/petclinicspring:tagname
## multi stage builds run specifics as below
docker build --target builder -t alexellis2/href-counter:latest .

# run petclinic from docker hub
docker network create pclinicnw
docker run -dp 3306:3306 --name mysql-server --network pclinicnw  --network-alias mysqlpclinicnw -v mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_DATABASE=pclinic mysql:latest
docker run --rm -dp 8888:8080 --name pclinic-server --network pclinicnw -e MYSQL_URL=jdbc:mysql://mysqlpclinicnw/pclinic datla/petclinicspring:latest
docker run --rm -dp 8888:8080 --name pclinic-server --network pclinicnw -e MYSQL_URL=jdbc:mysql://mysqlpclinicnw/pclinic datla/petclinicprod:latest

docker logs pclinic-server -f


# rollback/reset 
docker stop pclinic-server mysql-server
docker rm pclinic-server mysql-server
docker rmi petclinic mysql
docker rmi mysql datla/petclinicspring
docker network rm pclinicnw

#multi stage docker commands // make sure you switch to Dockerfile-MultiStage file which has all these details
docker build -t petclinic-docker --target test . 
docker run -it --rm --name petclinic-test petclinic-docker
docker logs petclinic-docker -f

docker-compose -f docker-compose.dev.yml up --build


# deployment to azure
# create azure access, subscription , resource group before you can do the following
docker login azure
docker context create aci myacicontext
docker context ls
docker context use myacicontext
docker --context myacicontext create test-volume --storage-account mystorageaccount



# app automation and building commands
---------------------------------------
docker build -t todo-app(or tapp) . # use this to build the image and make it available to run container
docker run -dp 3333:3000 todo-app(or tapp) # run the image on a container and expose the api outside the container 3000:3000
docker run -dp 33333:3000 --name tapp tapp # give the container a name so its to refer to
docker push datla/todoapp
docker tag tapp datla/todoapp
https://labs.play-with-docker.com/  #Login with your docker id and try any of your images running for real on this cloud platform 
                                    # Once started you may click on the port number to see the working app
docker run -d ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data.txt && tail -f /dev/null"  #example for trying out persisting information/data during container restarts
docker exec -it <container id or container name> bash # interactive session to get inside a container


# Docker volumes
---------------
docker volume create <name of volume ex : myvolume>
docker volume ls
docker volume rm <volumename>
docker run -dp 3333:3000 -v myvolume:/etc/todos todo-app(or tapp)
# persis db works like below with the volumes mounted so its the same folder that they refer 
docker run -v ubuntuvol:/data -d ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data/data.txt && tail -f /dev/null"
docker run -v ubuntuvol:/data -it ubuntu cat /data/data.txt

#Mapping to a specific directory on the host machine
docker run -v /Users/vanilla/Projects/practise/docker/todo-app/app/data:/data -d ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data/data.txt && tail -f /dev/null"
docker run -v /Users/vanilla/Projects/practise/docker/todo-app/app/data:/data -it ubuntu cat /data/data.txt


docker run -dp 3333:3000 -w /app -v "$(pwd):/app" node:12-alpine sh -c "yarn install && yarn run dev" # make sure you are in the app directory with a package.json file

# Docker networks
-----------------

docker network create todo-app
docker network ls
# latest
docker run -d -p 3366:3306 --network tappnw --network-alias mysqlnw -v /Users/vanilla/Projects/practise/docker/tapp/mysqldata/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=test mysql:latest
# 5.7
docker run -d -p 3366:3306 --network tappnw --network-alias mysql5.7nw -v /Users/vanilla/Projects/practise/docker/tapp/mysqldata/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=test mysql:5.7

docker network create tappnw


# App run commands
------------------
# attach network, mount volume, pass mysql creds, exec shell with yarn install all at one go with the below command

docker run -dp 3316:3000 -w /app -v "$(pwd):/app" --network tappnw -e MYSQL_HOST=mysqlnw -e MYSQL_PORT=3306 -e MYSQL_USER=root -e MYSQL_PASSWORD=secret -e MYSQL_DB=tapp node:12-alpine sh -c "yarn install && yarn run dev"

docker run -dp 3316:3000 -w /app -v "$(pwd):/app" --network tappnw -e MYSQL_HOST=mysql5.7nw -e MYSQL_PORT=3306 -e MYSQL_USER=root -e MYSQL_PASSWORD=secret -e MYSQL_DB=tapp node:12-alpine sh -c "yarn install && yarn run dev"

#compose version
docker-compose up #starts all containers and puts them on the same network
docker-compose down  # stops all the contaienrs and removes them from the network.


# Docker Java commands
----------------------

docker run -dp 3306:3306 --network pclinicnw  --network-alias mysqlpclinicnw -v /Users/vanilla/Projects/practise/docker/tapp/mysqldata/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_DATABASE=pclinic mysql:5.7

docker run -dp 3306:3306 --network pclinicnw  --network-alias mysqlpclinicnw -v /Users/vanilla/Projects/practise/docker/tapp/mysqldata/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=tododb mysql:5.7

docker run --rm -d --name pclinic-server --network pclinicnw -e MYSQL_URL=jdbc:mysql://mysqlserver/petclinic -p 8888:8080 pclinic-docker

./mvnw spring-boot:run -Dspring-boot.run.profiles=mysql


docker run -dp 3306:3306 --network pclinicnw  --network-alias mysqlpclinicnw -v /Users/vanilla/Projects/practise/docker/jdocker/mysqldata:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_DATABASE=pclinic mysql:latest

docker run --rm -dp 8888:8080 --name pclinic-server --network pclinicnw -e MYSQL_URL=jdbc:mysql://mysqlserver/pclinic pclinic-app


# General status commands
------------------------

docker ps
docker ps -a
docker image ls
docker stop <container>
docker rm <container> -f
docker container prune # delete all containers
