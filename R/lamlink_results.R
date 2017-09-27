library(data.table)
library(seq2pathway)
library(qqman)
library(dplyr)
library(xlsx)

analyze <- function(threshold=4, maf=0.4) {
  
  directory <- sprintf('output/lung/assoc_10_%s_%s', threshold, maf)
  lamp <- fread(file.path(directory, 'assoc.ld.lamp'))
  lamplink <- fread(file.path(directory, 'assoc.ld.lamplink'))
  
  lamplink.comb <- lamplink %>%
    transform(COMB=rowSums(lamplink[, 10:ncol(lamplink)])) %>%
    filter(COMB > 0) %>%
    select(CHR, SNP, A1, A2, TEST, AFF, UNAFF, P, OR, COMB)
  
  write.csv2(lamplink.comb, file.path(directory, 'assoc.ld.lamp.comb.csv'), row.names = FALSE)
  
  lung_bim <- fread('data/lung/assoc_10_4/lung.bim')
  colnames(lung_bim) <- c('CHR', 'SNP', 'V3', 'BP', 'A1', 'A2')
  lamplink.comb.bim <- lamplink.comb %>% merge(lung_bim, all.x = TRUE)
  manhattan(lamplink.comb.bim)
  
  assoc.ld.lamp.comb <- fread('data/lung/assoc_10_4/assoc_results_whole_genome_impute_07.txt') %>%
    select(
      CHR, BP, all_maf, P_adjusted
    ) %>%
    merge(
      lamplink.comb.bim, all.y=TRUE
    ) %>%
    select(
      CHR, BP, SNP,  A1, A2, all_maf, AFF, UNAFF, P, P_adjusted, OR, COMB
    ) %>%
    rename(
      P_GWAS=P_adjusted,
      P_FISHER=P,
      MAF=all_maf
    )
  
    assoc.ld.lamp.comb %>% write.csv2(file.path(directory, 'assoc.ld.lamp.comb.csv'), row.names = FALSE)

  lamplink.comb.bim.snp <- lamplink.comb.bim %>%
    rename(
      name=SNP,
      chrom=CHR,
      chromStart=BP
    ) %>%
    transform(
      chromEnd=chromStart+1
    ) %>%
    select(
      name,
      chrom,
      chromStart,
      chromEnd,
      A1,
      A2,
      P
    )

  path_dat <- runseq2pathway(
    inputfile = lamplink.comb.bim.snp,
    genome = "hg19",
    adjacent = FALSE,
    SNP = FALSE,
    search_radius = 150000,
    PromoterStop = FALSE,
    NearestTwoDirection = TRUE
  )
  
  genes <- path_dat$seq2gene_result$seq2gene_FullResult
  gene_list <- as.data.frame(table(genes$gene_name))
  genes$gene_name <- as.character(genes$gene_name)
  
  pathways <- path_dat$gene2pathway_result.FET %>%
    with(
      rbind(
        GO_BP,
        GO_CC,
        GO_MF
      )
    ) %>%
    arrange(
      FDR
    )
  
  directory <- 'output/lung/assoc_10_4_0.4_pathway'
  
  write.csv2(genes, file.path(directory, 'genes.csv'), row.names = FALSE, quote = TRUE)
  write.csv2(gene_list, file.path(directory, 'gene_list.csv'), row.names = FALSE, quote = TRUE)
  write.xlsx2(pathways, file.path(directory, 'pathways.xlsx'))
  
  bibliography <- read.xlsx2(file.path(directory, 'Bibiografia candidates HUGO.xlsx'), sheetName = 'Bio mart Ensembl hg38')
  a <- genes %>% filter(gene_name %in% bibliography$HGNC.symbol)
}


gene_list.gwas <- fread('output/lung/hf_45/gene_list.csv')
genes.hf45.lamp <- genes %>% filter(gene_name %in% gene_list.gwas$Var1)





date/datetime format 'yyyy-MM-dd'T'HH:mm:ss.SSSZ' fails to parse: '2014-10-07T18:11:09.000+02'