#!/usr/bin/env bash

# Download the `chopper` executable from Github
wget "https://github.com/wdecoster/chopper/releases/download/v0.11.0/chopper-linux"

# Make it executable
chmod +x chopper-linux

# Declare paths and variables
FASTQ=/path/to/ont/fastq
N_WORKERS=8

for file in $(ls ${FASTQ}/*porechopped.fastq.gz)
do
    sample_name=$(basename $file | sed 's/.porechopped.fastq.gz//')
    zcat $file \
      | ./chopper-linux -l 500 \
      | ./chopper-linux -q 10 \
      | gzip > "${sample_name}.porechopped.choppered.fastq.gz"
done
