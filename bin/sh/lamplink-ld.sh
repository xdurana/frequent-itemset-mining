#! /bin/bash
#$ -S /bin/bash
#$ -N lamplink
## -q imppc@curri7
#$ -q imppc
#$ -V
## -l exclusive
#$ -o /imppc/labs/dnalab/xduran/fim/output/lung/assoc_10_4_0.4/assoc.ld.log
#$ -e /imppc/labs/dnalab/xduran/fim/output/lung/assoc_10_4_0.4/assoc.ld.err
#$ -m be
#$ -M xduran@igtp.cat

/imppc/labs/dnalab/xduran/fim/bin/lamplink/lamplink-linux-1.11 --allow-no-sex --bfile /imppc/labs/dnalab/xduran/fim/data/lung/assoc_10_4/lung --comb /imppc/labs/dnalab/xduran/fim/output/lung/assoc_10_4_0.4/assoc --lamp-ld-remove --out /imppc/labs/dnalab/xduran/fim/output/lung/assoc_10_4_0.4/assoc.ld --lamp-r2 0.2