# IBS-Based Phylogeny from Raw Genotyping Data

This repository provides a **single-command pipeline** to generate an **IBS-based phylogenetic tree** directly from **unfiltered or minimally filtered SNP genotyping data**.

**Important**  
This pipeline is intended for **exploratory structure visualization**, not population genetics inference or publication-grade phylogeny.

---

## Overview

The pipeline performs:

1. VCF → PLINK conversion  
2. Minimal filtering  
3. LD pruning  
4. IBS distance matrix calculation  
5. Distance-based tree construction (FastME)

---

## Requirements

- `bcftools`
- `plink2`
- `plink 1.9`
- `fastme`
- `R` (base install only)

All tools must be available in `$PATH`.

---

## Usage

```bash
bash run_ibs_phylogeny.sh raw_genotypes.vcf
