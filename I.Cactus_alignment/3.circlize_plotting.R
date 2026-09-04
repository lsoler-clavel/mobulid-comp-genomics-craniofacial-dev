# Packages needed
install.packages("circlize")
install.packages("lifecycle")
install.packages("tidyverse")
install.packages("openxlsx")
install.packages("readxl")
install.packages("scales")


library("circlize")
library("lifecycle")
library("tidyverse")
library("openxlsx")
library("readxl")
library("scales")


## set working directory
getwd()
setwd("Z:/LSC/cactus")

# Define the cytoband data. Track is the sheet with gpos50 data
cytoband.df = read.xlsx("hypostoma_manta_newsynteny.psl.xlsx", sheet = "track", colNames = F) # replace spreadsheet name with whichever pair you're working with
cytoband.df$X1 <- as.character(cytoband.df$X1)
cytoband.df$X1 <- factor(cytoband.df$X1, levels = c(cytoband.df$X1))

cytoband.df$X1 <- factor(cytoband.df$X1)

beda <- read.xlsx("hypostoma_manta_newsynteny.psl.xlsx", sheet = "beda",colNames = F) # make sure bed a and bed b have the same nb of rows; erase unplaced scaffolds from the matches sheet for that

bedb <- read.xlsx("hypostoma_manta_newsynteny.psl.xlsx", sheet = "bedb",colNames = F)

## Add colours for each chromosome
chromosomes <- c( "CM057523.1", "CM057524.1", "CM057525.1", "CM057526.1", "CM057527.1",
                  "CM057528.1", "CM057529.1", "CM057530.1", "CM057531.1", "CM057532.1",
                  "CM057533.1", "CM057534.1", "CM057535.1", "CM057536.1", "CM057537.1",
                  "CM057538.1", "CM057539.1", "CM057540.1", "CM057541.1", "CM057542.1",
                  "CM057543.1", "CM057544.1", "CM057545.1", "CM057546.1", "CM057547.1",
                  "CM057548.1", "CM057549.1", "CM057550.1", "CM057551.1", "CM057552.1",
                  "CM057553.1", "CM057554.1", "CM057555.1")
                 
                 


colours <- scales::alpha(c("#FF5733", "#FFC300", "#FF6347", "#FF1493", "#FF00FF", "#FF00CC", "#800080", "#8A2BE2", "#4B0082", "#0000FF", "#00BFFF", 
                           "#00FFFF", "#00FF00", "#7CFC00", 
                           "#32CD32", "#ADFF2F", "#FFFF00", "#FFD700", "#FFA500", "#FF4500", "#FF6347", 
                           "#DC143C", "#8B0000", "#FF69B4", "#FFB6C1", "#00FA9A", "#20B2AA", "#00CED1", 
                           "#00BFFF", "#1E90FF", "#4682B4", "#87CEEB", "#40E0D0"
), alpha = 0.7)


## Define a data frame with chromosomes and colours 
df <- data.frame(chromosome = chromosomes, color = colours)

# view resulting data frame
beda <- beda %>% left_join(df, by = c(X1="chromosome")) # whyyy does it need this beda pipe otherwise it gives an error? make it make sense
col.colours <- as.character(beda$color)

##plot
circos.clear()
circos.par(start.degree = 90,  gap.degree = 2, cell.padding = c(0.001, 0, 0.001, 0), canvas.xlim = c (-1.2,1.2), canvas.ylim = c(-1.2,1.2))
circos.initializeWithIdeogram(cytoband.df, plotType = NULL, chromosome.index = cytoband.df$X1) #initialises without adding anything, for full customisation

######
circos.genomicTrack(cytoband.df, ylim = c(0, 2), panel.fun = function(region, value, ...){circos.genomicText(region, value, y = 2, labels.column = 1, cex = 0.15, niceFacing = T, ...) }, track.height = 0.09, track.margin = c(0,0), bg.border = NA)

#####
circos.track(ylim=c(0,1),panel.fun = function(x, y) {
  circos.axis(h = "top" ,major.at = seq(0, round(CELL_META$xlim[2], digits = 2), by = 20000000), labels.cex = 0.20,
              labels = seq(0,280, by=20), minor.ticks = 0.5,labels.facing = "clockwise",lwd = 0.45,major.tick.length = 1.5, labels.pos.adjust = F)
  #circos.text(CELL_META$xcenter,CELL_META$cell.ylim[1] + uy(3.5, "mm"),CELL_META$sector.index, cex = 0.5, col = "black",
  #facing = "outside", niceFacing = TRUE, labels = CELL_META$sector.numeric.index )
},track.height = 0.01, track.margin = c(0,0), bg.border = NA)

#####
circos.genomicIdeogram(cytoband = cytoband.df, track.height = 0.06)

circos.genomicLink(beda, bedb, col=col.colours)

####

circos.info()
