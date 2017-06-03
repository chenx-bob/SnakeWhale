SnakeWhale
===================
**Whole Annotated and Labelled Exome - SnakeMake**
![version](https://img.shields.io/badge/version-0.0.1-yellow.svg?style=flat)

Requirements
-------------

> - Ubuntu 16.04 Xenial LTS
> - SnakeMake 3.5.5
> - FastQC 0.11.5
> - MultiQC 1.0
> - bwa 0.7.15
> - sambamba 0.6.6
> - GATK

Install Requirements
-------------

- SnakeMake 3.5.5

```bash
sudo apt-get install snakemake
```

- FastQC 0.11.5
Download the application [here](https://www.bioinformatics.babraham.ac.uk/projects/download.html#fastqc) and export it to the PATH.

```bash
gunzip -d fastqc_vXX.XX.XX.zip
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
export PATH=$PATH:/path/to/bwa/
```
