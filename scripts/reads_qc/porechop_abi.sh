#!/usr/bin/env bash

# Download the Singularity image for `porechop_abi` from Galaxy
wget "https://depot.galaxyproject.org/singularity/porechop_abi%3A0.5.0--py39hdf45acc_3" -O porechop_abi_0.5.0--py39hdf45acc_3.sif

# Declare paths and variables
SIF=porechop_abi_0.5.0--py39hdf45acc_3.sif
FASTQ=/path/to/ont/fastq
N_WORKERS=8


for file in $(ls ${FASTQ}/*.fastq.gz)
do
    sample_name=$(basename $file | sed 's/.fastq.gz//')
    singularity exec --bind ${FASTQ}:/mnt/ $SIF porechop_abi \
        --ab_initio \
        -i /mnt/${file} \
        -o /mnt/${sample_name}.porechopped.fastq.gz -t $N_WORKERS \
        > ${sample_name}.log

done
