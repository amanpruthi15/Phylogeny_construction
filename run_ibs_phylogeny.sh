#!/usr/bin/env bash
set -euo pipefail

# ==========================
# User inputs
# ==========================
VCF=$1                     # raw genotyping VCF
OUTPREFIX=ibs_tree
PLINK2=plink2
PLINK1=plink
FASTME=fastme

# ==========================
# Step 1: Compress & index
# ==========================
bgzip -c ${VCF} > ${VCF}.gz
tabix -p vcf ${VCF}.gz

# ==========================
# Step 2: Convert to PLINK2
# ==========================
$PLINK2 \
  --vcf ${VCF}.gz \
  --make-pgen \
  --out step1.plink \
  --allow-extra-chr

# ==========================
# Step 3: Basic filters
# ==========================
$PLINK2 \
  --pfile step1.plink \
  --geno 0.2 \
  --mind 0.2 \
  --maf 0.01 \
  --make-pgen \
  --out step2.filtered

# ==========================
# Step 4: LD pruning
# ==========================
$PLINK2 \
  --pfile step2.filtered \
  --set-all-var-ids '@:#:$r:$a' \
  --indep-pairwise 50 5 0.2 \
  --out step3.ld

$PLINK2 \
  --pfile step2.filtered \
  --extract step3.ld.prune.in \
  --make-bed \
  --allow-extra-chr \
  --out step4.pruned

# ==========================
# Step 5: IBS distance
# ==========================
$PLINK1 \
  --bfile step4.pruned \
  --distance square ibs \
  --allow-extra-chr \
  --out step5.ibs

# ==========================
# Step 6: Convert IBS → PHYLIP
# ==========================
Rscript - << 'EOF'
ids <- read.table("step5.ibs.mibs.id", stringsAsFactors=FALSE)[,2]
m <- as.matrix(read.table("step5.ibs.mibs"))
dist <- 1 - m
write.table(
  cbind(length(ids), ids, dist),
  file="tree.phy",
  quote=FALSE,
  row.names=FALSE,
  col.names=FALSE
)
EOF

# ==========================
# Step 7: Build tree
# ==========================
$FASTME -i tree.phy -o ${OUTPREFIX}.nwk -n 0

echo "Tree written to ${OUTPREFIX}.nwk"
