#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

###############

singularity exec -e ../../../singularity_containers/trinityrnaseq.v2.13.2.simg bash stats_abund_est.sh ${1} ${2}
