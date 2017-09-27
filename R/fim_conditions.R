library(data.table)
library(tidyr)
library(dplyr)

get_all <- function() {
  
  directory <- '/home/labs/dnalab/share/lims/R/gcat-cleaning-data'
  
  conditions <- fread(file.path(directory, 'output/conditions/icd9.csv'))
  medication <- fread(file.path(directory, 'output/medications/atc.csv'))
  
  as.data.frame(table(conditions$Codi_3)) %>%
    arrange(desc(Freq)) %>%
    View()
  
  gcat <- fread(file.path(directory, 'output/data.csv'), stringsAsFactors = TRUE)
  
  conditions_transaction <- conditions %>%
    transform(
      id=entity_id,
      value=sprintf("ICD_%s", Codi_3),
      count=1
    ) %>%
    select(
      id,
      value,
      count
    ) %>%
    unique()
  
  medication_transaction <- medication %>%
    transform(
      value=substring(sprintf("ATC_%s", value), 1, 7),
      count = 1
    ) %>%
    select(
      id,
      value,
      count
    ) %>%
    unique()
  
  data_wide <- conditions_transaction %>%
    rbind(medication_transaction) %>%
    spread(value, count, fill = 0)
  
  data_wide
}

lamp_icd <- function(ds, icd) {
  
  file.dat <- sprintf('data/conditions/data_%s.csv', icd)
  file.val <- sprintf('data/conditions/values_%s.csv', icd)
  file.log <- sprintf('output/conditions/lamp_%s.log', icd)
  file.out <- sprintf('output/conditions/lamp_%s.csv', icd)
  file.eut <- sprintf('output/conditions/lamp_%s-purged.csv', icd)
  
  ds %>%
    select(-matches(icd)) %>%
    write.table(file.dat, row.names = FALSE, quote = FALSE, sep = ',')
    
  ds %>%
    select(id, matches(icd)) %>%
    write.table(file.val, row.names = FALSE, quote = FALSE, sep = ',')

  system(sprintf("sed -i '1s/^/#/' %s", file.val))
  
  system(sprintf('python bin/lamp/lamp.py -p fisher %s %s 0.05 -e %s > %s',
    file.dat,
    file.val,
    file.log,
    file.out
  ))
  
  system(sprintf('python bin/lamp/eliminate_comb.py %s > %s',
    file.out,
    file.eut
  ))
}

run <- function(icd) {
  ds <- get_all()
  lamp_icd(icd)
}