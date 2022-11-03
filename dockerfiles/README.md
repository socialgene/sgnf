docker build . -t chasemc2/socialgene_nf:0.0.1
docker push chasemc2/socialgene_nf:0.0.1

docker build . -t chasemc2/antismash_nf:6.1.1
docker push chasemc2/antismash_nf:6.1.1


docker build . -t chasemc2/chasemc2/neo4j:5.1
docker push chasemc2/neo4j:4.4.7
