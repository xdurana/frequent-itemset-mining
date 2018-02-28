#! /bin/bash
#$ -S /bin/bash
#$ -N lamp
#$ -q imppc
#$ -V
#$ -o /imppc/labs/dnalab/xduran/fim/output/padris/assoc.log
#$ -e /imppc/labs/dnalab/xduran/fim/output/padris/assoc.err
#$ -m be
#$ -M xduran@igtp.cat

python /imppc/labs/dnalab/xduran/fim/bin/lamp/lamp.py -p fisher /imppc/labs/dnalab/xduran/fim/data/padris/gcat_fpm.csv /imppc/labs/dnalab/xduran/fim/data/padris/gcat_fpm_values_$1.csv 0.05 -e /imppc/labs/dnalab/xduran/fim/output/padris/lamp_$1.log --max_comb=1 > /imppc/labs/dnalab/xduran/fim/output/padris/lamp_$1.csv
#python /imppc/labs/dnalab/xduran/fim/bin/lamp/eliminate_comb.py /imppc/labs/dnalab/xduran/fim/output/padris/lamp_$1.csv > /imppc/labs/dnalab/xduran/fim/output/padris/lamp_clean_$1.csv