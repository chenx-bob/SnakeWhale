SnakeWhale
===================
**Whole Annotated and Labelled Exome - SnakeMake**
![version](https://img.shields.io/badge/version-0.0.1-yellow.svg?style=flat)

Requirements
-------------

> - Ubuntu 16.04 Xenial LTS
> - SnakeMake 3.5.5
> - FastQC 0.11.5
> - MultiQC

Install Requirements
-------------

- SnakeMake 3.5.5

```bash
sudo apt-get install snakemake
```

- FastQC
Download the application [here](https://www.bioinformatics.babraham.ac.uk/projects/download.html#fastqc) and export it to the PATH.

```bash
gunzip -d fastqc_vXX.XX.XX.zip
export PATH=$PATH:/path/to/fastqc/
```

- MultiQC

```bash
pip install multiqc
```
