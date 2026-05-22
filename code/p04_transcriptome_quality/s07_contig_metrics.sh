#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

###################

#input transcriptome fasta file:
TR="$1"
echo 'Transcriptome Name:' $(basename $1)

#total number of contigs
TOT_CONTIG=$(grep '>' $1 | wc -l)

echo 'Total Number of Contigs:' $TOT_CONTIG

#largest contig length
MAX=$(awk '{print $2}' $1 | grep 'len=' |  sed 's/^....//' | sort -n | tail -n 1)

echo 'Largest Contig Length:' $MAX

#smallest contig length

MIN=$(awk '{print $2}' $1 | grep 'len=' |  sed 's/^....//' | sort -r -n | tail -n 1)

echo 'Smallest Contig Length:' $MIN

#no. of contigs over 10k
GR=$(awk '{print $2}' $1 | grep 'len=' |  sed 's/^....//' | awk '$1 > 10000' | wc -l)

echo 'Number of Contigs Greater than 10K:' $GR

#no.of contigs over 1k
G=$(awk '{print $2}' $1 | grep 'len=' |  sed 's/^....//' | awk '$1 > 1000' | wc -l)

echo 'Number of Contigs Greater than 1K:' $G

#total number of bases

BASE=$(grep -v '>' $1 | tr --delete '\n' | wc -c)

echo 'Total Number of Assembled Bases:' $BASE

# % GC content

C=$(grep -v '>' $1 | tr --delete '\n' | tr -cd 'C' | wc -c)
G=$(grep -v '>' $1 | tr --delete '\n' | tr -cd 'G' | wc -c)

GC=$(expr $G + $C)

GC1=$(bc <<<"scale=4; $GC / $BASE *100")

#alternative
#awk -v var1=$GC -v var2=$BASE 'BEGIN { print  ( var1 / var2 * 100) }'

echo 'percent GC content:' $GC1 '%'

#Mean contig length

awk '{print $2}' $1 | grep 'len=' |  sed 's/^....//' | awk 'NR == 1 { sum=0 } { sum+=$1;} END {printf "Mean Contig Length: %f\n", sum/NR}'

#N50

N50=$(awk '{print $2}' | grep 'len=' |  sed 's/^....//' | sort -n | awk 'BEGIN {sum=0} {sum += $1; print $1, sum}' | tac - | awk 'NR==1 {halftot=$2/2} lastsize>halftot && $2<halftot {print} {lastsize=$2}')

echo Contig N50: ${N50% *}
