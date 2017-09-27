#! /bin/bash
#$ -S /bin/bash
#$ -N lamp
#$ -q imppc
#$ -V
#$ -o /imppc/labs/dnalab/xduran/fim/output/heritability/assoc.log
#$ -e /imppc/labs/dnalab/xduran/fim/output/heritability/assoc.err
#$ -m be
#$ -M xduran@igtp.cat

python /imppc/labs/dnalab/xduran/fim/bin/lamp/lamp.py -p fisher /imppc/labs/dnalab/xduran/fim/data/heritability/data_$1.csv /imppc/labs/dnalab/xduran/fim/data/heritability/values_$1.csv 0.05 -e /imppc/labs/dnalab/xduran/fim/output/heritability/lamp_$1.log > /imppc/labs/dnalab/xduran/fim/output/heritability/lamp_$1.csv
python /imppc/labs/dnalab/xduran/fim/bin/lamp/eliminate_comb.py /imppc/labs/dnalab/xduran/fim/output/heritability/lamp_$1.csv > /imppc/labs/dnalab/xduran/fim/output/heritability/lamp_clean_$1.csv