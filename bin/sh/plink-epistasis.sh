#! /bin/bash
#$ -S /bin/bash
#$ -N lamplink
#$ -q imppc
#$ -V
#$ -o /imppc/labs/dnalab/xduran/fim/output/lung/assoc_0.5_plink_epistasis/assoc.log
#$ -e /imppc/labs/dnalab/xduran/fim/output/lung/assoc_0.5_plink_epistasis/assoc.err
#$ -m be
#$ -M xduran@igtp.cat

plink --allow-no-sex --bfile /imppc/labs/dnalab/xduran/fim/data/lung/assoc_10_4/lung --pheno /imppc/labs/dnalab/xduran/fim/data/lung/phenol.txt --pheno-name progres --epistasis --model-dom --out /imppc/labs/dnalab/xduran/fim/output/lung/assoc_0.4_plink_epistasis/assoc --noweb
