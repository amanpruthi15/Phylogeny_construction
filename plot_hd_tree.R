library(ape)

# --------------------------
# Input / Output
# --------------------------
input_tree <- "consensus_tree.nwk"                # FastME tree
output_png <- "consensus_tree_HD.png"            # HD PNG output
output_tree <- "consensus_tree_clean.nwk"        # clean Newick with % bootstrap

# --------------------------
# Read tree
# --------------------------
tree <- read.tree(input_tree)

# --------------------------
# Normalize bootstrap to % (0-100)
# --------------------------
tree$node.label <- as.numeric(tree$node.label)
tree$node.label <- round(tree$node.label / max(tree$node.label) * 100, 1)

# --------------------------
# Set tip label parameters
# --------------------------
n_tips <- length(tree$tip.label)

tip_cex <- 1.2       # tip label size
tip_font <- 2        # bold tip labels
boot_cex <- 0.8      # bootstrap label size
label_offset <- 1     # distance from branch to tip label

# --------------------------
# Set PNG resolution
# --------------------------
# Width and height in pixels, res in DPI
png(output_png,
    width = 6000,                 # HD width
    height = n_tips * 35,         # vertical space proportional to number of tips
    res = 300)                     # 300 DPI for print-quality

# --------------------------
# Plot horizontal tree
# --------------------------
plot(tree,
     cex = tip_cex,
     font = tip_font,
     direction = "rightwards",    # labels pointing right
     label.offset = label_offset,
     edge.width = 1,
     tip.color = "black"
)

# --------------------------
# Add bootstrap labels
# --------------------------
nodelabels(tree$node.label,
           frame = "n",
           cex = boot_cex,
           adj = c(1.2, -0.5),
           col = "red")

dev.off()

# --------------------------
# Save cleaned Newick
# --------------------------
write.tree(tree, output_tree)

cat("✅ HD tree generated!\n")
cat("PNG:", output_png, "\n")
cat("Clean Newick:", output_tree, "\n")
