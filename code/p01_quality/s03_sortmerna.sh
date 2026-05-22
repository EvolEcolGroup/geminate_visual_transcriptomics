#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####################

source /home/eet35/.bashrc
conda activate sortmerna

###

FM=${1}
SP=${2}
INDIR="../../data/raw/${FM}/${SP}"
OUTDIR="../../data/intermediate/p01_quality/${FM}/${SP}/s03_sortmerna"

###

cd ${INDIR}

for i in *_R1_001.fastq
do
  SAMPLE=$(echo ${i} | sed "s/_R1_\001\.fastq//")
  echo ${SAMPLE}_R1.fastq ${SAMPLE}_R2.fastq

  sortmerna \
    --ref /home/eet35/rds/hpc-work/all_sortmerna/data/rRNA_databases/rfam-5.8s-database-id98.fasta \
    --ref /home/eet35/rds/hpc-work/all_sortmerna/data/rRNA_databases/rfam-5s-database-id98.fasta \
    --ref /home/eet35/rds/hpc-work/all_sortmerna/data/rRNA_databases/silva-arc-16s-id95.fasta \
    --ref /home/eet35/rds/hpc-work/all_sortmerna/data/rRNA_databases/silva-arc-23s-id98.fasta \
    --ref /home/eet35/rds/hpc-work/all_sortmerna/data/rRNA_databases/silva-bac-16s-id90.fasta \
    --ref /home/eet35/rds/hpc-work/all_sortmerna/data/rRNA_databases/silva-bac-23s-id98.fasta \
    --ref /home/eet35/rds/hpc-work/all_sortmerna/data/rRNA_databases/silva-euk-18s-id95.fasta \
    --ref /home/eet35/rds/hpc-work/all_sortmerna/data/rRNA_databases/silva-euk-28s-id98.fasta \
    --reads ${SAMPLE}_R1_001.fastq \
    --reads ${SAMPLE}_R2_001.fastq \
    --idx /home/eet35/rds/hpc-work/all_sortmerna/idx \
    --workdir ${OUTDIR} \
    --out2 \
    --fastx \
    --threads 32 \
    --paired_in \
    --other ${OUTDIR}/${SAMPLE}_sortmerna |& tee ${OUTDIR}/${SAMPLE}_sortmerna.log

done
