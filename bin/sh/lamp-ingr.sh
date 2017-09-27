#! /bin/bash
#$ -S /bin/bash
#$ -N lamp
#$ -q imppc
#$ -V
#$ -o /imppc/labs/dnalab/xduran/fim/output/ingr/assoc.log
#$ -e /imppc/labs/dnalab/xduran/fim/output/ingr/assoc.err
#$ -m be
#$ -M xduran@igtp.cat

python /imppc/labs/dnalab/xduran/fim/bin/lamp/lamp.py -p fisher /imppc/labs/dnalab/xduran/fim/data/ingr/data.csv /imppc/labs/dnalab/xduran/fim/data/ingr/values.csv 0.05 -e /imppc/labs/dnalab/xduran/fim/output/ingr/lamp.log --max_comb=4 > /imppc/labs/dnalab/xduran/fim/output/ingr/lamp.csv
python /imppc/labs/dnalab/xduran/fim/bin/lamp/eliminate_comb.py /imppc/labs/dnalab/xduran/fim/output/ingr/lamp.csv > /imppc/labs/dnalab/xduran/fim/output/ingr/lamp_clean.csv