docker build . -t chasemc2/sgnf-sgpy:0.0.1
docker push chasemc2/sgnf-sgpy:0.0.1

docker build . -t chasemc2/sgnf-antismash:6.1.1
docker push chasemc2/sgnf-antismash:6.1.1

docker build . -t chasemc2/sgnf-minimal:0.0.1
docker push chasemc2/sgnf-minimal:0.0.1

docker build . -t chasemc2/sgnf-hmmer:3.3.2
docker push chasemc2/sgnf-hmmer:3.3.2
