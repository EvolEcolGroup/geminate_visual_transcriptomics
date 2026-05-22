#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

###################

singularity exec -e ../../../singularity_containers/eggnog-mapper.sif bash eggnog_mapper_test.sh ${1} ${2}
