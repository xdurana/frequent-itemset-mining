#! /bin/bash
#$ -S /bin/bash
#$ -N lamplink
#$ -q imppc
#$ -V
#$ -o /imppc/labs/dnalab/xduran/fim/output/lung/assoc_0.5_plink_fast_epistasis/assoc.log
#$ -e /imppc/labs/dnalab/xduran/fim/output/lung/assoc_0.5_plink_fast_epistasis/assoc.err
#$ -m be
#$ -M xduran@igtp.cat

plink2 --bfile dades --maf 0.01  --indep-pairwise 50 5 0.2  --out  snps_pruned

plink2 --bfile dades --maf 0.01 --extract snps_pruned.prune.in --make-bed  --out dades_2

plink2 --bfile dades --max-maf 0.10 --extract snps_pruned.prune.in --make-bed --out dades_2