#!/bin/bash

#SBATCH --job-name=htstream_J1_1A_C58 # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=9
#SBATCH --time=120 # Apparently only used ~45 minutes of clock time according to seff command (this calls for 120 minutes). The time I recorded went over this time limit.
#SBATCH --mem=5000 # Memory pool for all cores (see also --mem-per-cpu)# Apparently only used ~900 MB accordig to seff command (this calls for 5GB)
#SBATCH --partition=production
#SBATCH --account=adandekar
#SBATCH --array=1-18
#SBATCH --output=slurmout/htstream/htstream_%A_%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/htstream/htstream_%A_%a.err # File to which STDERR will be written
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hsaxe@ucdavis.edu

start=`date +%s`
echo $HOSTNAME
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

sample=`sed "${SLURM_ARRAY_TASK_ID}q;d" samples.txt`

inpath="00-RawData"
outpath="01-HTS_Preproc"
[[ -d ${outpath} ]] || mkdir ${outpath}
[[ -d ${outpath}/${sample} ]] || mkdir ${outpath}/${sample}

echo "SAMPLE: ${sample}"

module load htstream/1.3.3

# Removed this parameter per Nikhil Joshi's suggestion:
# hts_SuperDeduper -A ${outpath}/${sample}/${sample}.json -N 'remove PCR duplicates' | \
# Removed these parameters because we don't want them removed
#      hts_SeqScreener -A ${outpath}/${sample}/${sample}.json -N 'count GUS reads'\
#          -r -s References/GUS.fasta | \
#      hts_SeqScreener -A ${outpath}/${sample}/${sample}.json -N 'count KanR reads'\
#          -r -s References/APH_KanR.fasta | \

call="hts_Stats -L ${outpath}/${sample}/${sample}.json -N 'initial stats' \
          -U ${inpath}/${sample}*R1.fastq.gz |\
      hts_SeqScreener -A ${outpath}/${sample}/${sample}.json -N 'screen phix' | \
      hts_SeqScreener -A ${outpath}/${sample}/${sample}.json -N 'count walnut rRNA reads'\
           -s References/Walnut2.0_rRNA.fasta | \
      hts_SeqScreener -A ${outpath}/${sample}/${sample}.json -N 'count C58 rRNA reads'\
           -s References/C58_rRNA2.fasta | \
      hts_SeqScreener -A ${outpath}/${sample}/${sample}.json -N 'were walnut rRNA reads removed?'\
          -r -s References/Walnut2.0_rRNA.fasta | \
      hts_AdapterTrimmer -A ${outpath}/${sample}/${sample}.json -N 'trim adapters' | \
      hts_PolyATTrim --no-left --skip_polyT -A ${outpath}/${sample}/${sample}.json -N 'remove polyAT tails' | \
      hts_NTrimmer -A ${outpath}/${sample}/${sample}.json -N 'remove any remaining N characters' | \
      hts_QWindowTrim -A ${outpath}/${sample}/${sample}.json -N 'quality trim the ends of reads' | \
      hts_LengthFilter -A ${outpath}/${sample}/${sample}.json -N 'remove reads < 10bp' \
          -n -m 10 | \
      hts_Stats -A ${outpath}/${sample}/${sample}.json -N 'final stats' \
          -f ${outpath}/${sample}/${sample}"

echo $call
eval $call

end=`date +%s`
runtime=$((end-start))
echo $runtime
