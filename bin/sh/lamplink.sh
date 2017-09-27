#! /bin/bash
#$ -S /bin/bash
#$ -N lamplink
#$ -q imppc
#$ -V
#$ -o /imppc/labs/dnalab/xduran/fim/output/lung/assoc_10_3_0.5/assoc.log
#$ -e /imppc/labs/dnalab/xduran/fim/output/lung/assoc_10_3_0.5/assoc.err
#$ -m be
#$ -M xduran@igtp.cat

/imppc/labs/dnalab/xduran/fim/bin/lamplink/lamplink-linux-1.11 --allow-no-sex --bfile /imppc/labs/dnalab/xduran/fim/data/lung/assoc_10_3/lung --pheno /imppc/labs/dnalab/xduran/fim/data/lung/phenol.txt --pheno-name progres --lamp --model-dom --sglev 0.05 --upper 0.02 --out /imppc/labs/dnalab/xduran/fim/output/lung/maf_0.1/lung --fisher
