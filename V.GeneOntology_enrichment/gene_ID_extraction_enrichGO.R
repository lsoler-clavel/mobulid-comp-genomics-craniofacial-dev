# Load necessary library
library(openxlsx)

# Define the input and output file paths
input_file <- "C:/Users/leaso/OneDrive/Bureau/UoE_MScR/Bioinformatics/RStudio/GO_enrichment2/mh_dels_conserved_manta_stingray_annotated.bed.xlsx"
output_file <- "mh_dels_manta-stingrays_conserved_gene_names.txt"

# Read the BED file into a data.table
bed_data <- read.xlsx("C:/Users/leaso/OneDrive/Bureau/UoE_MScR/Bioinformatics/RStudio/GO_enrichment2/mh_dels_conserved_batoids_annotated.bed.xlsx", sep = "\t")

# Extract the annotation field (assuming it's the fourth column)
annotations <- bed_data$
  
  # Initialize an empty vector to store gene names
  gene_names <- c()

# Loop through each annotation
for (annotation in annotations) {
  # Split the annotation by pipe character
  parts <- strsplit(annotation, "\\|")[[1]]
  
  # Loop through each part and look for the 'Gene' tag
  for (part in parts) {
    if (grepl("^Gene:", part)) {
      # Extract the gene name (assuming the format is Gene:gene_name:additional_info)
      gene_name <- strsplit(part, ":")[[1]][2]
      gene_names <- c(gene_names, gene_name)
    }
  }
}

# Remove duplicates and sort the gene names
unique_gene_names <- sort(unique(gene_names))

# Write the gene names to the output file
write(unique_gene_names, file = output_file, ncolumns = 1)

# Print a message indicating completion
cat("Gene names have been extracted and saved to", output_file, "\n")
