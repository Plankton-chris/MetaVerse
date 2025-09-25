#!/usr/bin/env bash

# Download the Singularity image for `fastp` from Galaxy
wget "https://depot.galaxyproject.org/singularity/fastp%3A1.0.1--heae3180_0" -O fastp_1.0.1--heae3180_0.sif

# Declare paths and variables
SIF=fastp_1.0.1--heae3180_0.sif
FASTQ=/path/to/fastq
N_WORKERS=8

for file in $(ls ${FASTQ}/*_R1.fastq.gz)
do
	fwd_file=$(basename $file)
	rev_file=$(basename $file | sed 's/R1.fastq.gz/R2.fastq.gz/')
	sample_name=$(basename $file | sed 's/_R1.fastq.gz//')
	singularity exec --bind ${FASTQ}:/mnt/ $SIF fastp \
        -i /mnt/${fwd_file} \
        -I /mnt/${rev_file} \
        -o /mnt/${sample_name}_R1.fastp.fastq.gz \
        -O /mnt/${sample_name}_R2.fastp.fastq.gz \
        -j /mnt/${sample_name}.fastp.json \
        -h /mnt/${sample_name}.fastp.html \
        --thread $N_WORKERS \
        --detect_adapter_for_pe
done
