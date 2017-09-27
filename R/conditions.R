library(tidyverse)
library(arcdiagram)

run <- function() {
  phenotypes <- read_csv2('/home/labs/dnalab/share/lims/R/gcat-cleaning-data/output/check/conditions/icd9_3/wide.csv') %>%
    rename(
      id=entity_id
    )
  lapply(colnames(phenotypes %>% select(-id)), generate)
}

generate <- function(phenotypes, icd) {
  
  file.dat <- sprintf('data/conditions/data_%s.csv', icd)
  file.val <- sprintf('data/conditions/values_%s.csv', icd)
  
  phenotypes %>%
    select(-matches(icd)) %>%
    write_csv(file.dat)
  
  phenotypes %>%
    select(id, matches(icd)) %>%
    write_csv(file.val)
  
  system(sprintf("sed -i '1s/^/#/' %s", file.dat))
  system(sprintf("sed -i '1s/^/#/' %s", file.val))
  
  sapply(colnames(phenotypes %>% select(-id)), function(icd) {
    sprintf('sh lamp-icd.sh %s', icd)
  }) %>% as.character %>% as.data.frame %>% write_csv('output/conditions/lamp-all.sh', col_names = FALSE)
  
  system('sh output/conditions/lamp-all.sh')
  
  significances <- do.call(rbind, lapply(colnames(phenotypes %>% select(-id)), function(icd) {
    significant(icd)
  }))
  
  significances <- significances %>%
    mutate(
      C1 = substring(Combination,  0,  3),
      C2 = substring(Combination,  4,  6),
      C3 = substring(Combination,  7,  9),
      C4 = substring(Combination, 10, 12)
    )
  
  summary <- read_csv2('/home/labs/dnalab/share/lims/R/gcat-cleaning-data/inst/extdata/conditions/summary-cim9-updated.csv')

  significances <- significances %>% left_join(
    summary %>%
      rename(
        icd = Codi_3
      ) %>%
      select(
        icd,
        Descr_codi_3
      ) %>%
      unique()
  ) %>%
    rename(
      icd_descr = Descr_codi_3
    )
  
  significances <- significances %>% left_join(
    summary %>%
      rename(
        C1 = Codi_3
      ) %>%
      select(
        C1,
        Descr_codi_3
      ) %>%
      unique()
  ) %>%
    rename(
      C1_descr = Descr_codi_3
    )
  
  significances <- significances %>% left_join(
    summary %>%
      rename(
        C2 = Codi_3
      ) %>%
      select(
        C2,
        Descr_codi_3
      ) %>%
      unique()
  ) %>%
    rename(
      C2_descr = Descr_codi_3
    )

  significances <- significances %>% left_join(
    summary %>%
      rename(
        C3 = Codi_3
      ) %>%
      select(
        C3,
        Descr_codi_3
      ) %>%
      unique()
  ) %>%
    rename(
      C3_descr = Descr_codi_3
    )

  significances <- significances %>% left_join(
    summary %>%
      rename(
        C4 = Codi_3
      ) %>%
      select(
        C4,
        Descr_codi_3
      ) %>%
      unique()
  ) %>%
    rename(
      C4_descr = Descr_codi_3
    )
  
  significances <- significances %>%
    select(
      `Raw p-value`,
      `Adjusted p-value`,
      `# of target rows`,
      `# of positives in the targets`,
      icd,
      icd_descr,
      C1,
      C1_descr,
      C2,
      C2_descr,
      C3,
      C3_descr,
      C4,
      C4_descr
    ) %>%
    arrange(
      `Adjusted p-value`
    )
  
  significances %>%
    write_csv('output/conditions/significances.csv')
}

significant <- function(icd) {
  filename <- sprintf('output/conditions/lamp_%s-purged.csv', icd)
  purged <- read_tsv(filename, skip = 9) %>%
    filter(!is.na(Combination)) %>%
    mutate(
      icd=icd
    )
  purged
}