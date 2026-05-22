#!/usr/bin/env bash

#set -euxo pipefail
#set -o errtrace

##############

FM=${1}
INDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s03_run_blast"
OUTDIR="../../../data/intermediate/p06_transcriptome_edit/p01_genome/${FM}/s04_blast_table"
ANNOT_DIR="../../../data/intermediate/p05_annotation/s02_format_annotation/${FM}"

# Output file
output_file=${OUTDIR}/${FM}_output.tsv
# Create the output file with headers
echo -e "gene\tquery_name\tspecies\ttrinity_ID_of_blast_hit\tEvalue\tactin_code" > "$output_file"

for hit in ${INDIR}/*hits
do
  blast_hits_file=${hit}
  if [[ $blast_hits_file == *colonus* ]]; then
    annotation_file="${ANNOT_DIR}/colonus.emapper.annotations"
    species="colonus"
  elif [[ $blast_hits_file == *furcifer* ]]; then
    species="furcifer"
    annotation_file="${ANNOT_DIR}/furcifer.emapper.annotations"
  elif [[ $blast_hits_file == *fulva* ]]; then
    annotation_file="${ANNOT_DIR}/fulva.emapper.annotations"
    species="fulva"
  elif [[ $blast_hits_file == *atrilobata* ]]; then
    annotation_file="${ANNOT_DIR}/atrilobata.emapper.annotations"
    species="atrilobata"
  elif [[ $blast_hits_file == *multilineata* ]]; then
    annotation_file="${ANNOT_DIR}/multilineata.emapper.annotations"
    species="multilineata"
  elif [[ $blast_hits_file == *cyanea* ]]; then
    annotation_file="${ANNOT_DIR}/cyanea.emapper.annotations"
    species="cyanea"
fi

gene="$(basename $blast_hits_file | sed 's/_.*//')"

# Process each line in the blast hits file
while read -r line; do
  if [[ $line =~ ^Query= ]]; then
    query_name=$(echo "$line" | awk '{print $2 "_" $3}')
  elif [[ $line =~ ^\s*TRINITY ]]; then
    trinity_id=$(echo "$line" | awk '{print $1}')
    evalue=$(echo "$line" | awk '{print $NF}')

    # Search for trinity_id in the annotation file
    actin_code=$(grep -E  "\<$trinity_id\>" "$annotation_file" | grep -oE ',[[:alnum:]]+@7898\|Actinopterygii' | cut -d',' -f2 | cut -d'@' -f1)

    # Output the result to the output file
    if [[ -z "$actin_code" ]]; then
      echo -e "$gene\t$query_name\t$species\t$trinity_id\t$evalue\tabsent" >> "$output_file"
    else
      echo -e "$gene\t$query_name\t$species\t$trinity_id\t$evalue\t$actin_code" >> "$output_file"
    fi
  fi
done < "$blast_hits_file"
done

echo "Processing complete. Results saved in $output_file"


####################################################

#CHECKS#

# Set paths
report_file="${OUTDIR}/${FM}_report.txt"

# Check that for each gene all the entries have the same actin code
# Create an associative array to store actin codes for each gene
declare -A actin_codes
declare -A gene_warnings

# Read the TSV file and populate the array
while IFS=$'\t' read -r gene query species trinity_id evalue actin_code; do
    # Ignore the header
    if [ "$gene" == "gene" ]; then
        continue
    fi

    # Skip lines where the actin code is "absent"
    if [ "$actin_code" == "absent" ]; then
        continue
    fi

    # If the gene is not in the array, add it
    if [ ! -n "${actin_codes["$gene"]}" ]; then
        actin_codes["$gene"]=$actin_code
    else
        # If the actin code for the gene is different and a warning has not been issued, print a warning
        if [ "${actin_codes["$gene"]}" != "$actin_code" ] && [ ! -n "${gene_warnings["$gene$actin_code"]}" ]; then
            echo "Warning: Gene \"$gene\" has top hits from multiple actin codes: ${actin_codes["$gene"]} and $actin_code" | tee -a "$report_file"
            gene_warnings["$gene$actin_code"]=1
        fi
    fi
done < "$output_file"

# Check that each actin code is unique to one gene

# Extract gene and actin code columns, sort and keep unique lines
sorted_unique=$(awk -F'\t' 'NR>1 && $6 != "absent" {print $1 "\t" $6}' "$output_file" | sort -u)

# Check if any actin code is repeated
duplicate_actin=$(echo "$sorted_unique" | awk '{count[$2]++; genes[$2] = genes[$2] $1 " "} END {for (code in count) if (count[code] > 1) print code, genes[code]}')

# Output warnings if duplicate actin codes are found
if [ -n "$duplicate_actin" ]; then
    echo "Warning: The following actin codes are associated with multiple genes:" | tee -a "$report_file"
    echo "$duplicate_actin" | tee -a "$report_file"
fi
