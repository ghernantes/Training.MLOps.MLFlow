echo "--> Containers: --------------------------------------------------------------------------------"
docker container ls -a

echo "--> Networks: ----------------------------------------------------------------------------------"
docker network ls

echo "--> Volumes: -----------------------------------------------------------------------------------"
docker volume ls

# sudo chmod u+x show_all.sh
# watch -n 1 ./show_all.sh