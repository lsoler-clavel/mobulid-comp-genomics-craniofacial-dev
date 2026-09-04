###load libraries
library(tidyverse)
library(fuzzyjoin)
library(openxlsx)
library(tidygenomics)
message("loaded libraries")

#####set working directory
setwd(paste("/exports/cmvm/eddie/eb/groups/macqueen_lab/Lea/cactus/rays_plus_skates/maf_anc2AsRef/anc3_dels_plusone_extractions")) ## set this according to your eddie folder containing maf files Lea
getwd()

##### function to read maf as table

MAF2tbl <- function(mafFile){
  x <- readLines(mafFile)

  aLines <- grepl("^a",x)
  sLines <- grepl("^s",x)

  tibble(idx=cumsum(aLines),txt=x) %>%
    filter(sLines) %>%
    separate(txt, into=c("s","src","start","size","strand","srcSize","text"),sep = "[ \t]+") %>%
    select(-s) %>%
    mutate_at(vars(start,size,srcSize),as.integer)
}

###### read maf files using the function above
Files <- list.files(pattern = "*.maf",full.names = TRUE)
maflist <- lapply(Files,MAF2tbl) ### convert all maf files to tables
names(maflist) <- Files
message("maffiles read into table")

###### function to overlay atac peaks on to your maf table data
curate_maf<- function(maftable){
  maftable %>%
    select(c("src","start","size","strand","srcSize"))  %>%
    separate(src, into=c("species", "chromosome"), sep="\\.") %>%
    mutate(end= ifelse(strand=="+", start+size,
                       ifelse(strand=="-",start+size,0))) %>%
    mutate(pos_start=ifelse(strand=="+",start,
                            ifelse(strand=="-",srcSize - end,0))) %>%
    mutate (pos_end=ifelse(strand=="+",end,
                           ifelse(strand=="-",srcSize - start,0))) %>%
    select(c("species","chromosome","strand","pos_start","pos_end","size")) %>%
    filter(size>3) %>%
    genome_cluster(.,by = c("chromosome", "pos_start", "pos_end"),max_distance=1000) %>%
    distinct(pos_start,pos_end, .keep_all = TRUE) %>%
    group_by(species,chromosome,cluster_id) %>%
    summarise(start = min(pos_start, na.rm=TRUE),end = max(pos_end, na.rm=TRUE), size = sum(size)) %>%
    ungroup %>%
    mutate(range = end-start) %>%
    group_by(species,chromosome) %>% top_n(1, size)%>% ungroup %>%
    group_by(species) %>% top_n(1, size) %>% ungroup %>%
    mutate(size_range_ratio=size/range)
}


###run the curate maf function
cur_maf<-lapply(maflist,curate_maf)
message("maffiles curated")

AllDat_maf <- bind_rows(cur_maf, .id = "Origin") %>%
  mutate(Origin = basename(Origin))
message("all maf files curated and combined")

## write output into an excel sheet
#write.xlsx(AllDat_maf,"maf_files_summary_tabular.xlsx")
#message("maffiles overlayed with atac and written to excel file")

# Write the table to a tab-separated text file
write.table(AllDat_maf, "maf_files_anc3dels_summary_tabular.txt", sep = "\t", row.names = FALSE, quote = FALSE)
message("maffiles written to tab-separated text file")
