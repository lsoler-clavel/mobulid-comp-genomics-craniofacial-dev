#### GO ENRICHMENT ANALYSIS ###
library(AnnotationForge)
library(AnnotationDbi)
library(clusterProfiler)
library(tidyverse)



#### Make Hypanus sabinus package usinng AnnotationForge ####
tbl <- read.csv("C:/Users/leaso/OneDrive/Bureau/UoE_MScR/Bioinformatics/RStudio/GCF_030144855.1-RS_2023_09_gene_ontology.gaf.csv", header = TRUE)

gene_info_tbl <- tbl %>%
  dplyr::select(GID=GeneID,SYMBOL=Symbol,GENENAME=Gene_Name) %>% 
  distinct() %>% 
  filter( SYMBOL != "", GENENAME != "")

gene_GO_tbl <-
  tbl %>% 
  distinct(GID=GeneID, GO=GO_ID, EVIDENCE="go_linkage_type") %>% 
  filter( GO != "", EVIDENCE != "")

#gene_chromosome_tbl <-tbl %>% distinct(GID=GeneID, CHROMOSOME=chromosome_name)
AnnotationForge::makeOrgPackage(gene_info=gene_info_tbl, go=gene_GO_tbl,
                                version="0.1",
                                maintainer="Lea Soler <L.P.M.Soler-Clavel@sms.ed.ac.uk>",
                                author="Lea Soler <L.P.M.Soler-Clavel@sms.ed.ac.uk>",
                                outputDir = "E:UoE_MScR/RStudio",
                                tax_id="79690",
                                genus="Hypanus",
                                species="sabinus",
                                goTable="go"# unlink=TRUE
                                ) #(i.e adding unlink=TRUE at the end so it disregards any previous package creations), and then try to load it with library(etc..

#### Install package? ####
install.packages("C:/Users/leaso/OneDrive/Bureau/UoE_MScR/Bioinformatics/RStudio/GO_enrichment/org.Hsabinus.eg.db", repos=NULL,type = "source")
library(org.Hsabinus.eg.db)

#### enrichGO ####
gene_name_table <- read.table("C:/Users/leaso/OneDrive/Bureau/UoE_MScR/Bioinformatics/RStudio/GO_enrichment/anc3_dels_gene_names.txt", header=FALSE, sep = "\t") # header was set to TRUE, so it was naming the column with the first row, since this table has no headers. I changed it to FALSE to avoid this
colnames(gene_name_table) <- c("geneName") # Now we rename the column to geneName to make life easier

# You cannot feed gene_name_table directly to enrichGO because it contains gene names. Instead, we need to grab the GID's from the gene_info_tbl file

IDs_of_interest <- gene_info_tbl %>% # put gene_info_tbl in new dataframe called IDs_of_interest
  select(-GENENAME) %>% # remove GENENAME column
  filter(SYMBOL %in% gene_name_table$geneName) # filter to keep only rows where the value in the SYMBOL column (which contains gene names) is present in our gene_name_table
anc3_dels_go <- enrichGO(
  gene = as.character(IDs_of_interest$GID), # need to make sure GID's are given as character, also make sure to only give a single column (the one with GID's)
  OrgDb = org.Hsabinus.eg.db,
  keyType = "GID",
  ont = "BP",
  pvalueCutoff = 0.1,
  pAdjustMethod = "BH",
  universe = as.character(gene_info_tbl$GID), # same for the universe, in this case we use the full gene list from gene_info_tbl
)

dotplot(anc3_dels_go, showCategory=20)
head(anc3_dels_go)
print(anc3_dels_go)
      
write.table(anc3_dels_go, file="anc3_dels_go_BP_data.txt", sep = "\t")

go_results <- slot(anc3_dels_go, "result")

# Create a mapping table with GID and SYMBOL
mapping_table <- gene_info_tbl %>%
  select(GID, SYMBOL)
mapping_table <- mapping_table %>%
  mutate(GID = as.character(GID))


# Separate the 'geneID' column into individual GIDs
go_results <- go_results %>%
  separate_rows(geneID, sep = "/") # This assumes multiple GIDs are separated by "/"


# Merge with mapping table to add SYMBOLs
go_results_with_genes <- go_results %>%
 left_join(mapping_table, by = c("geneID" = "GID")) %>%
 group_by(ID, Description, geneID) %>%
 summarise(SYMBOL = paste(unique(SYMBOL), collapse = "/"), .groups = "drop")

# Alternatively, if you prefer GENENAME instead of SYMBOL
#go_results_with_genes <- go_results %>%
  #left_join(gene_info_tbl %>% select(GID, GENENAME), by = c("geneID" = "GID")) %>%
  #group_by(ID, Description, geneID) %>%
  #summarise(GENENAME = paste(unique(GENENAME), collapse = "/"), .groups = "drop")

### Mapping but conserving row number
# Add a row number to preserve order
go_results <- go_results %>%
  mutate(row_id = row_number())

# Convert GID to character and select SYMBOL and GENENAME
mapping_table <- gene_info_tbl %>%
  select(GID, SYMBOL, GENENAME) %>%
  mutate(GID = as.character(GID))


# Perform the join
go_results_with_genes <- go_results %>%
  left_join(mapping_table, by = c("geneID" = "GID"))

# Reorder the columns
go_results_with_genes <- go_results_with_genes %>%
  arrange(row_id) %>%
  select(row_id, ID, Description, geneID, SYMBOL, GENENAME, everything()) %>%
  select(-row_id)  # Remove the row_id column if it's no longer needed

# View the results
head(go_results_with_genes)

# Save to a file if needed
write.csv(go_results_with_genes, "C:/Users/leaso/OneDrive/Bureau/UoE_MScR/Bioinformatics/RStudio/GO_enrichment2/GO2/anc3_dels_GO_BP_01cutoff_with_gene_names.csv", row.names = FALSE)

#### Redundancy clustering #####
simplified_anc3go <- clusterProfiler::simplify(anc3_dels_go, cutoff = 0.6, by = "p.adjust", select_fun = min)
dotplot(simplified_anc3go, showCategory=15)
barplot(simplified_anc3go, showCategory = 20)

 #### using GoSemSim
#go_sim <- godata(OrgDb='org.Hsabinus.eg.db', keytype = "GO", ont="BP")  # 'BP' for Biological Process ontology
#similarity_matrix <- mgoSim(anc3_dels_go$ID, anc3_dels_go$ID, semData=go_sim, measure="Wang")
