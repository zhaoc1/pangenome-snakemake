import glob
import os
import shutil

## manually download the GenBank assembly, save the clean genome name
with open("genome_names") as f:
 GENOMES = f.read().splitlines()

rule clean_names:
 input:
  "fnas/"
 output:
  expand("fnas/{genome}.fna", genome=GENOMES)
 run:
  for file in glob.glob( input[0]+'*.fna' ):
   rawname = os.path.basename(file)
   for genome in GENOMES:
    if rawname.find(genome) == 0 :
     newfile = 'fnas/' + genome + '.fna'
     shutil.copyfile(file, newfile)
     break

rule run_prokka:
 input:
  "fnas/{genome}.fna"
 output:
  "fnas/prokka_{genome}/{genome}.gff"
 params:
  outdir = "fnas/prokka_{genome}",
  genome = "{genome}"
 threads: 8
 shell:
  """
  prokka --kingdom Bacteria --outdir {params.outdir} --prefix {params.genome} \
         --locustag {params.genome} --force {input}
  """ 

rule _all_prokka:
 input:
  expand("fnas/prokka_{genome}/{genome}.gff", genome=GENOMES)

rule run_roary:
 input:
  expand("prokka_gffs/{genome}.gff", genome=GENOMES)
 output:
  "roary.done"
 params:
  outdir = "roary_results"
 shell:
  """
  roary -p 4 -f {params.outdir} -e -n -v {input} && touch {output}
  """

rule fast_tree:
 input:
  aln = "roary_results/core_gene_alignment.aln"
 output:
  tree = "roary_results/core_gene_alignment.newick"
 shell:
  """
  FastTree -nt -gtr < {input.aln} > {output.tree}
  """

rule visualize_roary:
 input:
  tree = "roary_results/core_gene_alignment.newick",
  csv = "roary_results/gene_presence_absence.csv",
  plot_script_fp = "local/roary_plots"
 output:
  "visualize.done"
 shell:
  """
  python {input.plot_script_fp}/roary_plots.py {input.tree} {input.csv} && touch {output}
  """
