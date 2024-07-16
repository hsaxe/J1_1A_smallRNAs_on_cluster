#!/bin/bash

#SBATCH --job-name=bwa_index_J1_1A_Jr2.0_C58_pDE00.0201_resequenced # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=9
#SBATCH --time=200 # 200 minutes. Only used 00:10:31
#SBATCH --mem=5000 # (30 GB) Memory pool for all cores (see also --mem-per-cpu). Only used 25790
#SBATCH --partition=production
#SBATCH --account=adandekar
#SBATCH --output=slurmout/index/bwa/Jr2.0_C58_pDE00.0201_resequenced/%A.out # File to which STDOUT will be written
#SBATCH --error=slurmout/index/bwa/Jr2.0_C58_pDE00.0201_resequenced/%A.err # File to which STDERR will be written
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hsaxe@ucdavis.edu

start=`date +%T`
echo $start

echo "Start Time: $(date +%T), Date: $(date +%F)"


startS=`date +%s`

echo $HOSTNAME

outpath="References"

mkdir -p ${outpath}

cd ${outpath}

wd="Jr_2.0_C58_pDE00.0201_resequenced"

mkdir -p ${wd}

cd ${wd}

GENOME="Jr_2.0_C58_pDE00.0201_resequenced_genomic.fna"

# GTF not applicable for bwa
# GTF="../J1_1A_TDNA.gtf"

module load bwa

call="bwa index ${GENOME}"

echo $call
eval $call

end=`date +%T`
echo $end

echo "End Time: $(date +%T), Date: $(date +%F)"

endS=`date +%s`

runtime=$((endS-startS))
echo "Run Time: $runtime"