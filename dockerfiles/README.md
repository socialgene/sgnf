docker build . -t chasemc2/socialgene-nf:0.0.1
docker push chasemc2/socialgene-nf:0.0.1

docker build . -t chasemc2/socialgene-antismash:6.1.1
docker push chasemc2/socialgene-antismash:6.1.1

docker build . -t chasemc2/socialgene-minimal:0.0.1
docker push chasemc2/socialgene-minimal:0.0.1

docker build . -t chasemc2/socialgene-hmmer:3.3.2
docker push chasemc2/socialgene-hmmer:3.3.2
