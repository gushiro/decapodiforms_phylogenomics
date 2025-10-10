library(macrosyntR)
library(ggplot2)
library(RColorBrewer)
library(stringr)



orthologs_file <- load_orthologs(
    orthologs_table = "single_copy_orthologous_species_target.tab",
    bedfiles = c(
        "bed_dory.bed",
        "bed_eberryi.bed",
        "bed_idiosep.bed", 
        "bed_sepEsculen.bed",
        "bed_spiru.bed",
        "bed_tod.bed" 
    )
)

# Clean chromosome names
levels(orthologs_file$sp1.Chr) <- str_replace(levels(orthologs_file$sp1.Chr), "Dpe", "")
levels(orthologs_file$sp2.Chr) <- str_replace(levels(orthologs_file$sp2.Chr), "chr", "")
levels(orthologs_file$sp3.Chr) <- str_replace(levels(orthologs_file$sp3.Chr), "Scaffold", "")
levels(orthologs_file$sp4.Chr) <- str_replace(levels(orthologs_file$sp4.Chr), ".*_SCAFFOLD_(\\d+)$", "\\1")
levels(orthologs_file$sp4.Chr) <- str_replace(levels(orthologs_file$sp4.Chr), ".*_chrom_(\\d+|Z)$", "\\1")
levels(orthologs_file$sp5.Chr) <- str_replace(levels(orthologs_file$sp5.Chr), "Scaffold", "")
levels(orthologs_file$sp6.Chr) <- str_replace(levels(orthologs_file$sp6.Chr), "Scaffold", "")

# Reoder:

prefix_mapping <- c(
    "sp3" = "sp1",  # Idiosepiida
    "sp2" = "sp2",  # Sepiolida
    "sp1" = "sp3",  # Myopsida
    "sp4" = "sp4",  # Sepiida
    "sp6" = "sp5",  # Oegopsida
    "sp5" = "sp6"   # Spirulida
)

new_orthologs <- orthologs_file
colnames(new_orthologs) <- sapply(colnames(new_orthologs), function(col) {
    pr <- sub("\\..*", "", col)
    if (pr %in% names(prefix_mapping)) sub(pr, prefix_mapping[[pr]], col) else col
})

# 4. Reorder by macrosynteny
msy <- reorder_macrosynteny(new_orthologs)

# Define new chromosome orders
# sp1 (Idiosepiida)
levels_sp1 <- c(
    "2","7","6","18","21","5","12","15","11","17","37","24","27","9","14",
    "47","34","13","30","16","22","19","35","46",
    "8", "20","29","41","3","33","10","23","28","1","4",
    "39","26","44","25","40","43","45","36","42","32","31","38"
)

# sp2  (Sepiolida) 
levels_sp2 <- c(
    "7","5","29","33","6","3","12","14","15","23","17","18","8","30","2","22",
    "13","21","1","27","35","19","37", "25","20", "46", "4","38","11","16","32",
    "9", "10","34","26","42","39","43","44","40","31","45","36","24","28"
)

# sp3  (Myopsida) 
levels_sp3 <- c(
    "06","03","25","31","11","02","16","14","12","27","20","17","08","30","01","28",
    "10","21","24","40","19","35","13","34","23",
    "15","42","04","33","05","18","32","07", "09","37","29","46","44","45","43","39","22","41","38","26","36"
)

# sp4  (Sepiida) 
levels_sp4 <- c(
    "9","1","19","28","11","4","16","14","13","27","20","24","7","29","2","30","8","23",
    "25","36","21","34","15","37","22",
    "5","43","3","31","10","18","33","6","12","39","32","35","44","40","Z","42","17","45","41","26","38"
)

# sp5  (Oegopsida) 
levels_sp5 <- c(
    "5","4","23","31","8","1","17","15","11","26","24","16","12","30","2","28","13","22",
    "19","42","20","34","10","35","27","14","45","3","38","6","18","29","9","7",
    "33","21","41","36","43","46","40","32","44","39","25","37"
)

# sp6  (Spirulida)
levels_sp6 <- c(
    "10","8","3","30","16","6","14","12","50","24","11","19","4","26","7","18","21","15",
    "20","41","27","44","28","23","35","2","39","5","37","17","22","33","13","9",
    "29","34","38","32","42","45","40","31","43","36","25","123"
)

# new chromosome factor levels
msy$sp1.Chr <- factor(msy$sp1.Chr, levels = levels_sp1)
msy$sp2.Chr <- factor(msy$sp2.Chr, levels = levels_sp2)
msy$sp3.Chr <- factor(msy$sp3.Chr, levels = levels_sp3)
msy$sp4.Chr <- factor(msy$sp4.Chr, levels = levels_sp4)
msy$sp5.Chr <- factor(msy$sp5.Chr, levels = levels_sp5)
msy$sp6.Chr <- factor(msy$sp6.Chr, levels = levels_sp6)

#custom color palette
first_set  <- colorRampPalette(brewer.pal(8,  "Dark2"))(18)
second_set <- colorRampPalette(c(brewer.pal(8,"Set1"), brewer.pal(12,"Paired")))(28)
custom_color_palette <- c(first_set, second_set)

# Plotting:
plot_chord_diagram(
    msy,
    species_labels = c(
        "  Idiosepiida\nI. pygmaeus",
        "  Sepiolida\nE. berryi",
        "  Myopsida\nD. pealeii",
        "  Sepiida\nS. esculenta",
        "  Oegopsida\nT. pacificus",
        "  Spirulida\nS. spirula"
    ),
    reorder_chromosomes    = FALSE,
    species_labels_hpos    = -150,
    ideogram_height        = 2,
    label_size             = 4,
    ribbons_curvature      = 0.05,
    ribbons_alpha          = 0.5,
    color_by = "sp3.Chr",
    custom_color_palette   = custom_color_palette
) + theme(
    legend.title    = element_text(size = 14),
    legend.position = c(1, 0.5),
    plot.margin     = margin(0, 80, 0, 0),
    legend.text     = element_text(size = 12)
)