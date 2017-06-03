import sys
from os.path import join

################################################################################
################################################################################

def message(mes):
  sys.stderr.write("|--- " + mes + "\n")

################################################################################
################################################################################

R1_SUFFIX="_1.fastq.gz"
R2_SUFFIX="_2.fastq.gz"

INPUT="input/test/"
GENOME="input/test/ref/ref.fa"
DBSNP="input/test/snp/dbsnp11_59570-113631.vcf"

QUEUE="/home/charles/Documents/tools/Queue/current/Queue.jar"
GATK="/home/charles/Documents/tools/GATK/current/GenomeAnalysisTK.jar"

R1_SUFFIX="_1.fastq.gz"
R2_SUFFIX="_2.fastq.gz"

SAMPLES, = glob_wildcards(INPUT.join(("","{smp}_1.fastq.gz")))

################################################################################
################################################################################

for smp in SAMPLES:
    message("Sample " + smp + " will be processed")

################################################################################
################################################################################


rule final:
    input:
        expand("output/{smp}/Quality/02-multiqc/multiqc_report.html", smp=SAMPLES),
        expand("output/{smp}/Quality/02_DoC_{smp}", smp=SAMPLES)

################################################################################
################################################################################

rule fastqc:
    input:
        fwd=INPUT + "{smp}" + R1_SUFFIX,
        rev=INPUT + "{smp}" + R2_SUFFIX
    output:
        fastQC_fwd="output/{smp}/Quality/01-fastqc/{smp}_1_fastqc.zip",
        fastQC_rev="output/{smp}/Quality/01-fastqc/{smp}_2_fastqc.zip",
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

################################################################################
################################################################################

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
        """--- Make multiQC report."""
    shell:
        """
            multiqc --outdir {output.multiqc} {input.fastqc} -v 2> {log}
        """

################################################################################
################################################################################

rule bwa_mem:
    input:
        genome=GENOME,
        fwd=INPUT + "{smp}" + R1_SUFFIX,
        rev=INPUT + "{smp}" + R2_SUFFIX
    output:
        bam_raw="output/{smp}/alignment/{smp}.raw.bam"
    priority:
        9
    log:
        "output/{smp}/logs/03-bwa.log"
    message:
        """--- Alignement with BWA-mem and sambamba view to bam."""
    shell:
        "bwa mem "
        "-M "
        "-t 1 "
        "-R \"@RG\tID:{wildcards.smp}\tSM:{wildcards.smp}\tPL:ILLUMINA\" "
        "{input.genome} "
        "{input.fwd} "
        "{input.rev} "
        "2> {log} | "
        "sambamba view "
        "-p "
        "-S "
        "-f bam "
        "-o {output.bam_raw} "
        "/dev/stdin "
        "2> {log}"

################################################################################
################################################################################

rule sambamba_sort:
    input:
        bam_markdup="output/{smp}/alignment/{smp}.raw.bam"
    output:
        bam_sort="output/{smp}/alignment/{smp}.sorted.bam"
    priority:
        8
    log:
        "output/{smp}/logs/04-sambamba-sort.log"
    message:
        """--- Sort bam and index."""
    shell:
        "sambamba sort "
        "{input.bam_markdup} "
        "-o {output.bam_sort} "
        "-p 2> {log}"

################################################################################
################################################################################

rule sambamba_markdup:
    input:
        bam_raw="output/{smp}/alignment/{smp}.sorted.bam"
    output:
        bam_markdup="output/{smp}/alignment/{smp}.sorted.md.bam"
    priority:
        8
    log:
        "output/{smp}/logs/05-sambamba-markdup.log"
    message:
        """--- Mark duplicates."""
    shell:
        "sambamba markdup "
        "-p {input.bam_raw} "
        "{output.bam_markdup} "
        "2> {log}"

################################################################################
################################################################################

rule sambamba_flagstat:
    input:
        bam_sort="output/{smp}/alignment/{smp}.sorted.md.bam"
    output:
        flagstat="output/{smp}/Quality/02-Bam/flagstat.txt"
    priority:
        9
    log:
        "output/{smp}/logs/06-sambamba-flagstat.log"
    message:
        """--- Flagstat."""
    shell:
        "sambamba flagstat "
        "{input.bam_sort} "
        "> {output.flagstat} "
        "2> {log}"

################################################################################
################################################################################

rule GATK_baseRecalibrator:
    input:
        queue=QUEUE,
        knownSite=DBSNP,
        ref=GENOME,
        bam_sort="output/{smp}/alignment/{smp}.sorted.md.bam"
    output:
        recal="output/{smp}/Quality/02-Bam/recal_data.table",
        recal2="output/{smp}/Quality/02-Bam/post_recal_data.table",
        plots="output/{smp}/Quality/02-Bam/plots.pdf",
        bamrecal="output/{smp}/alignment/{smp}.sorted.md.recal.bam"
    priority:
        8
    log:
        "output/{smp}/logs/07-GATK-BQSR.log"
    threads: 4
    message:
        """--- BaseRecalibrator."""
    shell:
        "java -jar {input.queue} "
        "-S queueScripts/BQSR.scala "
        "-R {input.ref} "
        "-I {input.bam_sort} "
        "-knownSites {input.knownSite} "
        "-O {output.recal} "
        "-B {output.recal2} "
        "-P {output.plots} "
        "-Z {output.bamrecal} "
        "-disableJobReport "
        "-run 2> {log}"

################################################################################
################################################################################

rule GATK_DoC:
    input:
        gatk=GATK,
        genome=GENOME,
        bam_sort="output/{smp}/alignment/{smp}.sorted.md.recal.bam"
    output:
        intervals="output/{smp}/Quality/02_DoC_{smp}"
    priority:
        8
    log:
        "output/{smp}/logs/08-GATK-DoC.log"
    threads: 4
    message:
        """--- DepthOfCoverage."""
    shell:
        "java -jar {input.gatk} -T  DepthOfCoverage "
        "-R {input.genome} "
        "-I {input.bam_sort} "
        "-o {output.intervals} "
        "2> {log}"
