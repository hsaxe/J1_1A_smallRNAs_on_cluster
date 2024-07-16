#! /bin/bash

# Make counts table from alignment

# Make directory for counts then loop through samples to extract the 2nd field (library must have been forward stranded) and everything but the first four rows.

mkdir -p 05-bwa_Counts 

mkdir -p 05-bwa_Counts/tmp

for sample in `cat samples.txt`; do \
    echo ${sample}
    cat 02-bwa_alignment/${sample}/${sample}_counts.txt | tail -n +5 | cut -f7 > 05-bwa_Counts/tmp/${sample}.count 
done

# Get gene ids. Since they are all in the same order, any sample will do.
tail -n +5 02-bwa_alignment/J1-1A-R1/J1-1A-R1_counts.txt | cut -f1 > 05-bwa_Counts/tmp/geneids.txt

# Paste all files together
paste 05-bwa_Counts/tmp/geneids.txt 05-bwa_Counts/tmp/*.count > 05-bwa_Counts/tmp/tmp.out

# Make colnames(including GeneID), didn't sort(so check order of output), then transpose and rbind with tmp counts table
cat <(echo "$(echo "GeneID" | cat - samples.txt)" | paste -s) 05-bwa_Counts/tmp/tmp.out > 05-bwa_Counts/J1_1A_strict_bwa_mapped_to_Jr2.0_C58_pDE00.0201_resequenced_no_rRNAs.txt
