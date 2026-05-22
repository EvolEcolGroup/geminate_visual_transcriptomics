#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

for file1 in *fwd*
do
NEWNAME1=$(echo ${file1} | sed "s/fwd.fastq.gz/R1.fastq.gz/")
mv ${file1} ${NEWNAME1}
done

for file2 in *rev*
do
NEWNAME2=$(echo ${file2} | sed "s/rev.fastq.gz/R2.fastq.gz/")
mv ${file2} ${NEWNAME2}
done
