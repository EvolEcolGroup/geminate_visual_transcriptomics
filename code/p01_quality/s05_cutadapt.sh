##!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

#####

##Script to run preprocessing on reads post SortMeRna.
##Will run FastQC on SortMeRna reads followed by Cutadapt adapter and quality trimming followed by another round of FastQC.
##Takes one pair or read files at a time (full path must be given as input.
##Assumes common directory structure (created by running directories.sh).
##Empty text file created at end of each stage - If one stage fails should pick up where left off.

#####

##MUST GIVE FULL PATH FOR SCRIPT TO WORK
#Path to Reads 1:
READ1="$1"
#Path to reads 2:
READ2="$2"

###

#Directory path of read files:
BASE=${READ1%/0*}
#File identifier(Ge3_29_S5_L001):
BASENAME=$(basename ${READ1%%_sortmerna_R1.fastq.gz})
#R1 file name wihtout path:
R1FILE=$(basename ${READ1})
#R2 file name without path:
R2FILE=$(basename ${READ2})

###

##SETTINGS FOR CUTADAPT
#Minimum quality cutoff:
QUALITY=20
#Minimum length cutoff:
LENGTH=30
#Adapter sequsece for read 1:
R1_ADAP="AGATCGGAAGAGCACACGTCTGAACTCCAGTCA"
#Adapter sequsece for read 2:
R2_ADAP="AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"
#Outdirectory/filename:
OUTFILE1=$(echo ${READ1} | sed "s/s03_sortmerna/s05_cutadapt/" | sed "s/_R1.fastq.gz/_cutadapt_R1.fastq.gz/")
OUTFILE2=$(echo ${READ2} | sed "s/s03_sortmerna/s05_cutadapt/" | sed "s/_R2.fastq.gz/_cutadapt_R2.fastq.gz/")

###

#Colours for messages:
R="\033[0;31m" #Red
G="\033[0;32m" #Green
NC="\033[0m" #No Color

###


#Check correct number of arguments given and print error message if an incorrect number of arguments is provided

usage() {
  echo -e ${R}"SCRIPT RUNS BASIC PREPROCESSING ON ONE SAMPLE PAIR\n$(basename $0) </full/path/to/Read1> </full/path/to/Read2>"${NC}
  exit
}

#Check no. of aguments equals 2

if [[ $# -ne 2 ]]
then
  echo -e ${R}"WRONG NUMBER OF INPUT FILES"${NC}
  usage
fi

#Check files have been given with full path:

if [[ ! ${READ1} =~ /home/ ]] || [[ ! ${READ2} =~ /home/ ]]
then
  echo -e ${R}"MUST GIVE FULL PATH TO READ FILES AS INPUT"${NC}
  usage
  exit
fi

# Check both files exist

if [[ ! -f ${READ1} ]]
then
  echo -e ${R}"READ1 FILE ${NC}${READ1} ${R}DOES NOT EXIST"${NC}
  exit
elif [[ ! -f ${READ2} ]]
then
  echo -e ${R}"READ2 FILE ${NC}${READ2} ${R}DOES NOT EXIST"${NC}
  exit
fi

# Check conda environment for cutadapt has been activated
if [[ $(cutadapt --version) =~ 3.2 ]]
then
  echo -e ${G}"Cutadapt Version 3.2"${NC}
else
  echo -e ${R}"WRONG CUTADAPT VERSION - ACTIVATE CUTADAPTENV ENVIRONMENT"${NC}
  exit
fi

#Print names of file name variables
echo -e ${G}"INPUT FILE INFO:"${NC}
echo -e ${G}"READ1 FILE: ${R1FILE}"${NC}
echo -e ${G}"READ2 FILE: ${R2FILE}"${NC}
echo -e ${G}"PATH TO FILES: ${BASE}"${NC}
echo -e ${G}"FILE IDENTIFIER: ${BASENAME}"${NC}

echo -e ${G}"INPUT FILE CHECKS COMPLETE: STARTING"${NC}

## STEPS 01-FASTQC AND 03-SORTMERNA SHOULD ALREADLY BE COMPLETED

###02-FASTQC

#Runs fastqc on sortmerna reads
#Outputs files to /s03_sotrmerna/fastqc directory
#If already ran will inform you and skip

if [[ ! -f ${BASE}/.${BASENAME}.021.done ]]
then
  fastqc \
    ${READ1} \
    ${READ2} \
    -o ${BASE}/s03_sotrmerna/fastqc \
    -t 6 &&
  touch ${BASE}/.${BASENAME}.021.done
  echo -e ${G}FATSTQC ON SORTMERNA READS DONE${NC}
else
  echo -e ${G}STAGE 02-FASTQC ALREADY COMPLETE, SKIPPING${NC}
fi

##CONVERT FASTQC HTML FILES TO PDF

#Creates PDF version of fastqc HTML output files

if [[ ! -f ${BASE}/.${BASENAME}.022.done ]]
then
  cd ${BASE}/s03_sotrmerna/fastqc &&
  echo -e ${G}changed workdir to $(pwd)${NC}

  for file in $(basename ${READ1/%.fastq.gz/_fastqc.html}) $(basename ${READ2/%.fastq.gz/_fastqc.html})
  do
      wkhtmltopdf ${file} ${file%%.html}.pdf
  done

  touch ${BASE}/.${BASENAME}.022.done
  echo -e ${G}02-FATSTQC HTML TO PDF DONE${NC}
else
  echo -e ${G}STAGE 02-FASTQC HTML TO PDF ALREADY COMPLETE, SKIPPING${NC}
fi



###s05_cutadapt

#Runs Cutadapt on input reads outputs files to s05_cutadapt
#Trims adapters, quality trims and gets rid of reads bellow min length
#All settings given at top of script change there if needed
#Produces run log file
#Runs on 6 threads

if [[ ! -f ${BASE}/.${BASENAME}.03.done ]]
then
  cutadapt -a ${R1_ADAP} \
           -A ${R2_ADAP} \
           -q ${QUALITY} \
           -m ${LENGTH} \
           -j 6 \
           -o ${OUTFILE1} \
           -p ${OUTFILE2} \
           ${READ1} \
           ${READ2} |& tee ${BASE}/s05_cutadapt/${BASENAME}_cutadapt.log

  touch ${BASE}/.${BASENAME}.03.done
  echo -e ${G}s05_cutadapt DONE${NC}
else
  echo -e ${G} STAGE s05_cutadapt ALREADY COMPLETE, SKIPPING${NC}
fi


###04-FASTQC

#Outputted read files from cutadapt:

#READ1:
SRNA_READ1=${BASE}/s05_cutadapt/${BASENAME}_sortmerna_cutadapt_R1.fastq.gz
#READ2:
SRNA_READ2=${BASE}/s05_cutadapt/${BASENAME}_sortmerna_cutadapt_R2.fastq.gz


#Checks expected cutadapt outfiles exist

if [[ ! -f ${SRNA_READ1} ]]
then
  echo "FILE ${SRNA_READ1} DOES NOT EXIST"
  exit 1
elif [[ ! -f ${SRNA_READ2} ]]
then
  echo "FILE ${SRNA_READ2} DOES NOT EXIST"
  exit 1
fi

#Runs fastqc on cutadapt reads
#Outputs files to 05_cutadapt/fastqc directory

if [[ ! -f ${BASE}/.${BASENAME}.041.done ]]
then
  fastqc \
    ${SRNA_READ1} \
    ${SRNA_READ2} \
    -o ${BASE}/s05_cutadapt/fastqc \
    -t 6 &&

  touch ${BASE}/.${BASENAME}.041.done
  echo -e ${G}FATSTQC ON CUTADAPT READS DONE${NC}
else
  echo -e ${G}STAGE s05-FASTQC ALREADY COMPLETE, SKIPPING${NC}
fi

##CONVERT FASTQC HTML FILES TO PDF

#Creates PDF version of fastqc HTML output files

if [[ ! -f ${BASE}/.${BASENAME}.042.done ]]
then
  cd ${BASE}/s05_cutadapt/fastqc &&
  echo -e ${G}changed workdir to $(pwd)${NC}

  for file in $(basename ${SRNA_READ1/%.fastq.gz/_fastqc.html}) $(basename ${SRNA_READ2/%.fastq.gz/_fastqc.html})
  do
      wkhtmltopdf ${file} ${file%%.html}.pdf
  done

  touch ${BASE}/.${BASENAME}.042.done
  echo -e ${G}05-FATSTQC HTML TO PDF DONE${NC}
else
  echo -e ${G}STAGE 05-FASTQC HTML TO PDF ALREADY COMPLETE, SKIPPING${NC}
fi


##################


#Check if number of files produced with input file prefix in each directory matches the number expected and print outcome
#Lists all files produced in each directory so can do quick check you have what you expect

echo -e ${G}OUTFILES CHECK${NC}

#02-fastqc check
if [[ $(ls ${BASE}/s01_fastqc/${BASENAME}* | wc -l) -ne 6 ]]
then
  echo -e ${R}WARNING: NOT ALL sortmerna FASTQC OUTFILES PRODUCED - FOUND $(ls ${BASE}/s01_fastqc/${BASENAME}* | wc -l) EXPECTED 6${NC}
  for DIR in ${BASE}/s01_fastqc
  do
    cd ${DIR}
    echo -e ${G}$(basename ${DIR})${NC}
    ls -1 ${BASENAME}*
   done
else
  echo -e ${G}"CORRECT NUMBER OF sortmerna FASTQC OUTFILES PRESENT"${NC}
  for DIR in ${BASE}/s01_fastqc
  do
    cd ${DIR}
    echo -e ${G}$(basename ${DIR})${NC}
   ls -1 ${BASENAME}*
  done
fi

#s05_cutadapt check
if [[ $(ls ${BASE}/s05_cutadapt/${BASENAME}* | wc -l) -ne 3 ]]
then
  echo -e ${R}WARNING: NOT ALL s05_cutadapt OUTFILES PRODUCED- FOUND $(ls ${BASE}/s05_cutadapt/${BASENAME}* | wc -l) EXPECTED 3${NC}
  for DIR in ${BASE}/s05_cutadapt
  do
    cd ${DIR}
    echo -e ${G}$(basename ${DIR})${NC}
    ls -1 ${BASENAME}*
  done
else
  echo -e ${G}"CORRECT NUMBER OF s05_cutadapt OUTFILES PRESENT"${NC}
  for DIR in ${BASE}/s05_cutadapt
  do
    cd ${DIR}
    echo -e ${G}$(basename ${DIR})${NC}
    ls -1 ${BASENAME}*
  done
fi

#04-fastqc check
if [[ $(ls ${BASE}/s05_cutadapt/fastqc/${BASENAME}* | wc -l) -ne 6 ]]
then
  echo -e ${R}WARNING: NOT ALL cutadapt FASTQC OUTFILES PRODUCED - FOUND $(ls ${BASE}/s05_cutadapt/fastqc/${BASENAME}* | wc -l) EXPECTED 6${NC}
  for DIR in ${BASE}/s05_cutadapt/fastqc/
  do
    cd ${DIR}
    echo -e ${G}$(basename ${DIR})${NC}
    ls -1 ${BASENAME}*
  done
else
  echo -e ${G}"CORRECT NUMBER OF cutadapt FASTQC OUTFILES PRESENT"${NC}
  for DIR in ${BASE}/s05_cutadapt/fastqc/
  do
    cd ${DIR}
    echo -e ${G}$(basename ${DIR})${NC}
    ls -1 ${BASENAME}*
  done
fi


#All done
echo -e ${G}"ALL DONE"${NC}
