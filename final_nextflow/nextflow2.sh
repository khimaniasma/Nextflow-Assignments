#!/usr/bin/env nextflow

/*
Nextflow script for performing genome assembly using SKESA, quality assessment using QUAST, and genotyping using MLST.

Before running this script, make sure you have the following softwares installed in mamba enviroment:
- Nextflow
- SKESA
- QUAST
- MLST

*/

// Define pipeline parameters 
params.input_R1 = '/Users/asmakhimani/nextflow2/ERR103405_1.fastq.gz' // Path to forward reads
params.input_R2 = '/Users/asmakhimani/nextflow2/ERR103405_2.fastq.gz' // Path to reverse reads

// Channel for SKESA genome assembly
process skesa_ga {
    input:
    file read_R1
    file read_R2 

    output:
    file 'assembly.fasta'

    script:
    """
    skesa --fastq ${read_R1},${read_R2} --cores 4 --memory 64 > assembly.fasta
    """

}
// Channel for QUAST quality assessment
process quast_q {
    input:
    file assembly
    output:
    file 'quast_report'
    script:
    """
    quast ${assembly} -o quast_report
    """

}
// Channel for MLST genotyping
process mlst_g {
    input:
    file assembly
    output:
    file 'mlst_results.tsv'
    script:
    """
    mlst ${assembly} > mlst_results.tsv
    """
}

// Define the workflow
workflow {
    // SKESA inputs 
    data = channel.fromPath(params.input_R1)
    data2 = channel.fromPath(params.input_R2)

    // Run SKESA first
    assembly = skesa_ga(data, data2)

    // QA using QUAST
    quast_report = quast_q(assembly)

    // Genotyping using MLST
    mlst_results = mlst_g(assembly)

    // Emit workflow outputs
    emit:
    assembly
    quast_report
    mlst_results
}
