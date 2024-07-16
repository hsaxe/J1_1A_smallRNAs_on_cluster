#!/bin/bash

wd="Jr_2.0_C58_pDE00.0201_resequenced"

mkdir -p ${wd}

# Get genome files (.fna)
# J. regia
# wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/411/555/GCF_001411555.2_Walnut_2.0/GCF_001411555.2_Walnut_2.0_genomic.fna.gz

# gunzip GCF_001411555.2_Walnut_2.0_genomic.fna.gz

# A. fabrum C58 (A. tumefaciens C58)
# wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/092/025/GCF_000092025.1_ASM9202v1/GCF_000092025.1_ASM9202v1_genomic.fna.gz

# gunzip GCF_000092025.1_ASM9202v1_genomic.fna.gz

# Get annotation files (.gtf)
# J. regia
# wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/411/555/GCF_001411555.2_Walnut_2.0/GCF_001411555.2_Walnut_2.0_genomic.gtf.gz

# gunzip GCF_001411555.2_Walnut_2.0_genomic.gtf.gz

# A. fabrum C58 (A. tumefaciens C58)
# wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/092/025/GCF_000092025.1_ASM9202v1/GCF_000092025.1_ASM9202v1_genomic.gtf.gz

# gunzip GCF_000092025.1_ASM9202v1_genomic.gtf.gz

# Row bind genome files together with cat
echo "Row binding genomes together"
cat GCF_001411555.2_Walnut_2.0_genomic.fna GCF_000092025.1_ASM9202v1_genomic.fna pDE00.0201_resequenced.fasta  > $wd/Jr_2.0_C58_pDE00.0201_resequenced_genomic.fna

# Row bind .gtf files together with cat, head, and tail

# Get .gtfs minus the first four lines (header)
echo "Row binding annotations"
tail -n +5 GCF_001411555.2_Walnut_2.0_genomic.gtf > Jr_GTF.tmp

tail -n +5 GCF_000092025.1_ASM9202v1_genomic.gtf > C58_GTF.tmp

# Row bind the files together
cat Jr_GTF.tmp C58_GTF.tmp J1_1A_TDNA_resequenced.gtf > $wd/Jr_2.0_C58_pDE00.0201_resequenced_genomic.gtf