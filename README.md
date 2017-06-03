SnakeWhale
===================
**Whole Annotated and Labelled Exome - SnakeMake**
![version](https://img.shields.io/badge/version-0.0.1-yellow.svg?style=flat)

This is the SnakeMake bioinformatic pipeline for Targeted and Exome Sequencing from MoBiDiC.


Requirements
-------------

> - Ubuntu 16.04 Xenial LTS
> - SnakeMake 3.5.5
> - FastQC 0.11.5
> - MultiQC 1.0
> - bwa 0.7.15
> - sambamba 0.6.6
> - GATK 3.7
> - Queue 3.7
> - Picard 2.9.2
> - freebayes 1.1.0
> - Cmake
.
Install Requirements
-------------

- SnakeMake 3.5.5

```bash
sudo apt-get install snakemake
```

- FastQC 0.11.5

Download the application [here](https://www.bioinformatics.babraham.ac.uk/projects/download.html#fastqc) and export it to the PATH.

```bash
unzip fastqc_vXX.XX.XX.zip
export PATH=$PATH:/path/to/fastqc/
chmod 755 /path/to/fastqc/fastqc
```

- MultiQC 1.0

```bash
pip install multiqc
```

- sambamba

Download the application [here](https://github.com/lomereiter/sambamba/releases) and export it to the PATH.
```bash
tar xvjf sambamba-vX.X.X.tar.bz2
export PATH=$PATH:/path/to/sambamba/
```

- bwa

Download the application [here](https://sourceforge.net/projects/bio-bwa/files/) and export it to the PATH.
```bash
tar xvjf bwa-X.X.X.tar.bz2
make
sudo make install
export PATH=$PATH:/path/to/bwa/
```

- GATK

After registration, download the application [here](https://software.broadinstitute.org/gatk/download/) and save the path.
```bash
tar xvjf GenomeAnalysisTK-3.7-0.tar.bz2
GATK="/path/to/GATK/GenomeAnalysisTK.jar"
```
- Queue

After registration, download the application [here](https://software.broadinstitute.org/gatk/download/queue) and save the path.
```bash
tar xvjf Queue-3.7-0.tar.bz2
QUEUE="/path/to/Queue/Queue.jar"
```
- Picard

Download the application [here](https://github.com/broadinstitute/picard/releases) and save the path.
```bash
PICARD="/path/to/Picard/picard.jar"
```
- Cmake

```bash
sudo apt-get install cmake
```

- freebayes

Git clone the application and export it to the PATH.

```bash
git clone --recursive git://github.com/ekg/freebayes.git
make
sudo make install
export PATH=$PATH:/path/to/freebayes/
```
