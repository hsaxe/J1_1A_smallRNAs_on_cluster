#!/bin/bash

#SBATCH --job-name=bwa_alignment_J1_1A_Jr2.0_C58_pDE00.0201_resequenced # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=1000 # 
#SBATCH --mem=100000 # (16 GB) Memory pool for all cores (see also --mem-per-cpu). Only used 12330.
#SBATCH --partition=production
#SBATCH --account=adandekar
#SBATCH --array=1-18
#SBATCH --output=slurmout/alignment/bwa/Jr2.0_C58_pDE00.0201_resequenced/%A_%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/alignment/bwa/Jr2.0_C58_pDE00.0201_resequenced/%A_%a.err # File to which STR will be written
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hsaxe@ucdavis.edu

start=`date +%s`
echo $HOSTNAME
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

echo "Start: $(date +%T), $(date +%F)"

sample=`sed "${SLURM_ARRAY_TASK_ID}q;d" samples.txt`

# REF="References/bwa.overlap49.pDE00.0201"

outpath="02-bwa_alignment"
[[ -d ${outpath} ]] || mkdir ${outpath}
[[ -d ${outpath}/${sample} ]] || mkdir ${outpath}/${sample}

echo "SAMPLE: ${sample}"

module load bwa
module load samtools
module load subread

# These bwa parameters led to almost 100% read assignment vs ~50-60% with the ones in the call now
#-t $SLURM_NTASKS \
#  -k 6 \
#  -B 1 \
#  -w 100 \
#  -O 2 \
#  -E 1 \
#  -L 3 \
#  -T 10 \

call="
bwa mem References/Jr_2.0_C58_pDE00.0201_resequenced/Jr_2.0_C58_pDE00.0201_resequenced_genomic.fna 01-HTS_Preproc/${sample}/${sample}_SE.fastq.gz \
  -t $SLURM_NTASKS \
  -k 10 \
  -B 1 \
  -w 100 \
  -O 2 \
  -E 1 \
  -T 15 \
  > ${outpath}/${sample}/${sample}_aligned_reads.sam

  samtools sort -o ${outpath}/${sample}/${sample}_aligned_reads.bam \
   ${outpath}/${sample}/${sample}_aligned_reads.sam

  samtools index ${outpath}/${sample}/${sample}_aligned_reads.bam

  featureCounts -a References/Jr_2.0_C58_pDE00.0201_resequenced/Jr_2.0_C58_pDE00.0201_resequenced_genomic.gtf \
   -F GTF \
   -t gene \
   -M \
   -O \
   -C \
   -B \
   -J \
   -o ${outpath}/${sample}/${sample}_counts.txt \
   ${outpath}/${sample}/${sample}_aligned_reads.bam 
"

echo "$call"
eval "$call"
echo $?

echo "End: $(date +%T), $(date +%F)"
end=`date +%s`
runtime=$((end-start))
echo $runtime
