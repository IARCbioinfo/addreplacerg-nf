#! /usr/bin/env nextflow

// usage : ./addreplacerg.nf --bam_folder BAM/ 

/*  Help section (option --help in input)  */

params.bam_folder = null
params.help = null
params.out_folder = params.bam_folder // if not provided, outputs will be held on the input bam folder

if (params.help) {
    log.info ''
    log.info '------------------------------------------------------------------'
    log.info 'Adds and replaces read group tags in BAM files based on file name'
    log.info '------------------------------------------------------------------'
    log.info 'Copyright (C) 2015 Matthieu Foll'
    log.info 'This program comes with ABSOLUTELY NO WARRANTY; for details see LICENSE.txt'
    log.info 'This is free software, and you are welcome to redistribute it'
    log.info 'under certain conditions; see LICENSE.txt for details.'
    log.info '------------------------------------------------------------------'
    log.info ''
    log.info 'Usage: '
    log.info '    nextflow run iarcbioinfo/addreplacerg --bam_folder BAM/'
    log.info ''
    log.info 'Mandatory arguments:'
    log.info '    --bam_folder   FOLDER                  Folder containing input BAM files'
    log.info 'Options:'   
    log.info '    --out_folder   OUTPUT FOLDER           Output directory, by default input BAM folder.'
    log.info ''
    exit 1
}

try { assert file(params.bam_folder).exists() : "\n WARNING : input BAM folder not located in execution directory" } catch (AssertionError e) { println e.getMessage() }
assert file(params.bam_folder).listFiles().findAll { it.name ==~ /.*bam/ }.size() > 0 : "BAM folder contains no BAM"

log.info '------------------------------------------------------------------'
log.info 'Adds and replaces read group tags in BAM files based on file name'
log.info '------------------------------------------------------------------'
log.info 'Copyright (C) 2015 Matthieu Foll'
log.info 'This program comes with ABSOLUTELY NO WARRANTY; for details see LICENSE.txt'
log.info 'This is free software, and you are welcome to redistribute it'
log.info 'under certain conditions; see LICENSE.txt for details.'
log.info '------------------------------------------------------------------'
log.info "Input BAM folder (--bam_folder)                                 : ${params.bam_folder}"
log.info "Output folder (--out_folder)                                    : ${params.out_folder}"
log.info "\n"

bam = Channel.fromPath( params.bam_folder+'/*.bam' )

process addreplacerg {

	publishDir params.out_folder, mode: 'move'
	
	tag { sample_name }
	
	input:
	file bam
	
	output:
	file "${sample_name}_RG.bam" into bam_rg

	shell:
	sample_name = bam.baseName
	'''
	samtools addreplacerg -r "@RG\tID:!{sample_name}\tPG:samtools addreplacerg\tSM:!{sample_name}" !{bam} -o !{sample_name}_RG.bam
	'''
}
