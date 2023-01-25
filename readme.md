# Genome-wide DNA methylation and smoking status

Download and normalize DNA methylation data from 4 datasets
(accessions GSE50660, GSE85210, GSE87648, GSE42861)
with smoking status (current, former, never)
from the Gene Expression Omnibus (https://www.ncbi.nlm.nih.gov/geo).

All datasets except GSE50660 have IDAT files.
Consequently, the datasets are normalised
using a quantile-based method that only requires
the methylated and unmethylated signals for each probe:

> N Touleimat and J Tost. Complete pipeline for Infinium Human Methylation 450K
> BeadChip data processing using subset quantile normalization for accurate DNA
> methylation estimation. Epigenomics (2012) 4:325-341.

To download and normalize the dataset:

1. Edit `config.yml` to provide the base directory in which to generate the dataset

2. Then run the 'prepare-dataset.r' script
```
Rscript prepare-dataset.r
```
