## Installation

1. Clone this directory and PanPhlAn into a local folder:
  ```bash
  git clone https://github.com/zhaoc1/pangenome-snakemake.git my_pangenome_project
  cd my_pangenome_project
  hg clone https://bitbucket.org/CibioCM/panphlan local/panphlan
  ```

2. Creat a new Conda environment (assumes you have Miniconda)
  ```bash
  conda create -n my_pan --file=conda-requirements.txt --quiet --yes
  ```

## Annotating genomes

1. Manually doanload reference genomes and clean up names
  ```bash
  snakemake clean_names
  ```
 
2. Run Prokka to get Roary compatible features files
  ```bash
  snakemake _all_prokka
  ```
 
3. Collect GFF files into gffs/
  ```bash
  mkdir prokka_gffs
  cp fnas/prokka_*/*.gff prokka_gffs
  ```
 
## Creating the pangenome using Roary
  ```bash
  snakemake run_roary
  ```
  
## Visualizing Roary results
  ```bash
  snakemake visualize_roary
  ```
 
