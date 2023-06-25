
docker run --name rust-dev -v `pwd`:/simon -d simonfucn/centos-7.9-rust /bin/sh -c "while true; do sleep 1000; done"
docker exec -it rust-dev bash
