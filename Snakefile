import sys
from os.path import join

################################################################################
################################################################################

def message(mes):
  sys.stderr.write("|--- " + mes + "\n")

################################################################################
################################################################################

INPUT="input/test/"
GENOME="/media/charles/Datas/refData/genome/hg19/hg19.fa"
SAMPLES, = glob_wildcards(INPUT.join(("","{smp}_R1.fq")))
GENOME="/media/charles/Datas/refData/genome/hg19/hg19.fa"

################################################################################
################################################################################

for smp in SAMPLES:
    message("Sample " + smp + " will be processed")

################################################################################
################################################################################


rule final:
    input:
        expand("output/{smp}/Quality/02-multiqc/multiqc_report.html", smp=SAMPLES)

################################################################################
################################################################################

rule fastqc:
    input:
        fwd=INPUT + "{smp}_R1.fq",
        rev=INPUT + "{smp}_R2.fq",
    output:
        fastQC_fwd="output/{smp}/Quality/01-fastqc/{smp}_R1_fastqc.zip",
        fastQC_rev="output/{smp}/Quality/01-fastqc/{smp}_R2_fastqc.zip",
        fastqc="output/{smp}/Quality/01-fastqc"
    priority:
        10
    log:
        "output/{smp}/logs/01-fastqc.log"
    message:
        """--- Quality check of raw data with Fastqc."""
    shell:
        "fastqc "
        "--outdir  output/{wildcards.smp}/Quality/01-fastqc/ "
        "{input.fwd} "
        "{input.rev} "
        "2> {log}"

rule multiQC:
    input:
        fastqc="output/{smp}/Quality/01-fastqc"
    output:
        multiqc="output/{smp}/Quality/02-multiqc/multiqc_report.html"
    priority:
        10
    log:
        "output/{smp}/logs/02-fastqc.log"
    message:
        """--- Quality check of raw data with Fastqc."""
    shell:
        """
            multiqc --outdir {output.multiqc} {input.fastqc} -v 2> {log}
        """
