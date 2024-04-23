#!/bin/bash -ue
skesa --fastq ERR103405_1.fastq.gz,ERR103405_2.fastq.gz --cores 4 --memory 64 > assembly.fasta
