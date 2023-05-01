include common_parameters.env
export


SHELL = /bin/sh
CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)
export CURRENT_UID
export CURRENT_GID


## help	:	Print help info
help : Makefile
	@sed -n 's/^##//p' $<

## clean	:	Clean temporary files, INCLUDES DELETING THE NEXTFLOW TEMPORY WORK DIRECTORY
clean:
	find . -name ".nextflow.log.*" -exec rm -r {} +
	find . -type d -name ".nextflow" -exec rm -r {} +
	find . -name ".nextflow.log" -exec rm {} +
	find . -type d -name "work" -exec rm -r {} +




## create_conda :	Create the socialgene conda enviornment
create_conda:
	conda env create --file dockerfiles/socialgene/environment.yaml

## install_python :	Install the socialgene python package
install_python:
	pip3 install -e ./socialgene

##
## NEXTFLOW SPECIFIC TASKS
##

## chai  : This is a specific Nextflow pipeline made to run on Chase's work computer
chai:
	nextflow run nextflow -profile chicago --build_database true --mode dev -resume --enable_conda true

# sudo chown -R $(id -u):$(id -g) '/home/chase/Documents/socialgene_outdir/neo4j'

## nextflow_example: Run the example nextflow pipeline
run_nextflow_example:
	nextflow run nextflow -profile conda,example --outdir_per_run "./nextflow_example/outdir_per_run" --outdir_neo4j "./nextflow_example/outdir_neo4j" --outdir_long_cache "./nextflow_example/outdir_long_cache" -resume --fasta_splits 3


##
## DJANGO SPECIFIC TASKS
##

##
# https://github.com/pydanny/cookiecutter-django/pull/1879#issuecomment-516251029

PROJECT_NAME=socialgeneweb
export COMPOSE_FILE=local.yml

.PHONY: up down stop prune ps shell logs

default: up

# necessary so docker won't create these as root
make_django_dirs:
	mkdir -p django/local_postgres_data
	mkdir -p django/local_postgres_data_backups
	mkdir -p django/redis-data

django_build:
	@echo "Building containers for for ${PROJECT_NAME}..."
	CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose -f ${COMPOSE_FILE} --env-file ./socialgene/src/socialgene/common_parameters.env build --parallel


## django_up	:	Start up containers.
django_up: make_django_dirs django_build
	@echo "Starting up containers for for ${PROJECT_NAME}..."
	# @see:https://github.com/docker/compose/issues/6464
	#docker-compose pull
	CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose -f ${COMPOSE_FILE} --env-file ./socialgene/src/socialgene/common_parameters.env up --remove-orphans

upq: make_django_dirs
	CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose -f ${COMPOSE_FILE} --env-file ./socialgene/src/socialgene/common_parameters.env up --remove-orphans

## build	:	Build python image.
build:
	@echo "Building python image for for ${PROJECT_NAME}..."
	docker-compose build

## down	:	Stop containers.
down: stop

## start	:	Start containers without updating.
start: make_django_dirs
	@echo "Starting containers for $(PROJECT_NAME) from where you left off..."
	@docker-compose start

## stop	:	Stop containers.
stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose -f ${COMPOSE_FILE} down

## prune	:	Remove containers and their volumes.
##		You can optionally pass an argument with the service name to prune single container
##		prune mariadb	: Prune `mariadb` container and remove its volumes.
##		prune mariadb solr	: Prune `mariadb` and `solr` containers and remove their volumes.
prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose down -v $(filter-out $@,$(MAKECMDGOALS))

## ps	:	List running containers.
ps:
	@docker ps --filter name='$(PROJECT_NAME)*'

## manage	:	Executes `manage.py` command.
##		To use "--flag" arguments include them in quotation marks.
##		For example: make manage "makemessages --locale=pl"
.PHONY: manage
manage: make_django_dirs
	CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose -f $(COMPOSE_FILE) run --rm django python manage.py $(filter-out $@,$(MAKECMDGOALS)) $(subst \,,$(MAKEFLAGS))

manage2:
	CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose -f $(COMPOSE_FILE) run --rm django python manage.py list_model_info

migrate:
	CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose -f $(COMPOSE_FILE) run --rm django python manage.py migrate

makemigrations:
	docker-compose -f local.yml run --rm django python3 manage.py makemigrations

show_urls:
	CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose -f local.yml run --rm django python manage.py show_urls

createsuperuser: make_django_dirs
	CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose -f $(COMPOSE_FILE) run --rm django python manage.py  createsuperuser

## django_logs: print the django docker compose logs
django_logs:
	@docker-compose logs -f $(filter-out $@,$(MAKECMDGOALS))

##
## NEO4J SPECIFIC TASKS
##

## memrec:	Get an estimate of the Neo4j memory settings your machine is capable of
memrec:
	docker run \
		--user="$(id -u)":"$(id -g)" \
		--env NEO4J_AUTH=neo4j/test \
		--interactive \
		--tty \
		neo4j:4.3.7 \
		neo4j-admin \
		memrec \
		--memory=60G \
		--verbose \
		--docker

##
## DEVELOPMENT TASKS
##

## testnf: Run the test nextflow pipeline
testnf:
	nextflow run nextflow -profile test --outdir_per_run "/home/chase/temp/socialgene/outdir_per_run" --outdir_neo4j "/home/chase/temp/socialgene/outdir_neo4j" --outdir_long_cache "/home/chase/temp/socialgene/outdir_long_cache" -resume --fasta_splits 100

## pytest	:	Run Python pacakge unit tests
pytest:
	coverage run --omit="*/tests*" --source=./socialgene --module pytest ./socialgene/tests/python --cov=./socialgene/src/socialgene --failed-first  --cov-report=html
## pytestnf :	Run Nextflow pytest tests (first runs clean, install python and  nextflow test run)
pytestnf: clean install_python testnf
	coverage run --source=./socialgene --module pytest ./socialgene/tests/nextflow --neo4j_outdir $(neo4j_outdir)

## django_test :	Run pytest for the Django code
django_test:
	CURRENT_UID=$(shell id -u):$(shell id -g) docker-compose -f $(COMPOSE_FILE) run --rm django pytest

## run_ci :	Run the Python continuous integration tests locally
run_ci: clean install_python pytest
	@echo "TESTING WITH FLAKE8"
	flake8 . --exclude temp_scripts,old_tests,old_act --ignore E203,E501,W503 --count --show-source
	@echo "TESTING WITH BLACK"
	black --check . --extend-exclude temp_scripts

## run_ci_full :	Run the Python and nf-core continuous integration tests locally
ci:
	nf-core -l lint_log.txt lint --dir .
	nf-core modules lint --all --local
	nf-core schema lint .
	markdownlint ./docs ./nextflow --disable MD013 MD033 MD041

parameter_documentation:
	nf-core schema docs > parameters.md




# https://stackoverflow.com/a/6273809/1826109
%:
	@:
###########################################################################################################
###########################################################################################################


