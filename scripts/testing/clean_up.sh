docker rm -f $(docker ps -q -a)
docker volume prune -f
docker network prune -f