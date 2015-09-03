cp /usr/local/bioinf/documentation/bio-linux/intro_course/qiime_tutorial_data.tar.xz . 

tar xpfJ qiime_tutorial_data.tar.xz

mkdir working-files
cd working-files

# Generating custom_parameters
# Now delete references to GG files and use the system versions provided as of QIIME 1.8: i.e.
# align_seqs:template_fp	/home/user1/qiime_tutorial_data/data/core_set_aligned.imputed.fasta
# Generating my_custom_parameters.txt
sed -e "\\,/home/[a-z0-9]\+/qiime_tutorial_data/,d" ../custom_parameters.txt > my_custom_parameters.txt

#Enter QIIME
qiime

# Pre-processing
#Check Mapping
validate_mapping_file.py -m ../Fasting_Map.txt -o mapping_output -v

#De-multiplexing
split_libraries.py -m ../Fasting_Map.txt -f ../Fasting_Example.fna -q ../Fasting_Example.qual -o split_library

# Data analysis
#Pick De Novo OTUs (formerly Pick OTUs through OTU table)
#pick_otus_through_otu_table.py -i split_library/seqs.fna -p my_custom_parameters.txt -o out
pick_de_novo_otus.py -i split_library/seqs.fna -p my_custom_parameters.txt -o out

#OTU Heatmap
#OTU Heatmap html is redundant
#make_otu_heatmap_html.py -i out/otu_table.biom -o out/otu_heatmap
make_otu_heatmap.py -i out/otu_table.biom -o out/otu_heatmap

#OTU Network
make_otu_network.py -m ../Fasting_Map.txt -i out/otu_table.biom -o out/otu_network

#Make Taxa Summary Charts
#Summarize taxa
#L3 = taxonomic level 3 = class (counting down from Kingdom)
summarize_taxa.py -i out/otu_table.biom -o out/taxa_summary -L 3

#Make Taxa Summary Charts
plot_taxa_summary.py -i out/taxa_summary/otu_table_L3.txt -l Phylum -o out/taxa_charts -k white

#Alpha rarefaction
#echo 'alpha_diversity:metrics shannon_PD_whole_tree,chao1,observed_species' > alpha_params.txt
alpha_rarefaction.py -i out/otu_table.biom -m ../Fasting_Map.txt -o out/arare -p my_custom_parameters.txt -t out/rep_set.tre

#Beta diversity/3d plots
beta_diversity_through_plots.py -i out/otu_table.biom -m ../Fasting_Map.txt -o out/bdiv_even146/ -p my_custom_parameters.txt -t out/rep_set.tre -e 146

#Making prefs file for old-style plots
make_prefs_file.py -m ../Fasting_Map.txt -a black -d 10 -b "Treatment,DOB" -o out/bdiv_even146/prefs.txt

#Make old-style 2D Plots - Unweighted Unifrac
make_2d_plots.py -i out/bdiv_even146/unweighted_unifrac_pc.txt -m ../Fasting_Map.txt -o out/bdiv_even146/unweighted_unifrac_2d -k white -p out/bdiv_even146/prefs.txt

#Make old-style 3D plots (note: this will give a warning)
make_3d_plots.py -i out/bdiv_even146/unweighted_unifrac_pc.txt -m ../Fasting_Map.txt -o out/bdiv_even146/unweighted_unifrac_3d -p out/bdiv_even146/prefs.txt

#Make Distance Boxplots - Unweighted Unifrac
make_distance_boxplots.py -d out/bdiv_even146/unweighted_unifrac_dm.txt -m ../Fasting_Map.txt -o out/bdiv_even146/distance_histograms -f Treatment

#Jackknifed beta diversity
jackknifed_beta_diversity.py -i out/otu_table.biom -o out/jack -p my_custom_parameters.txt -e 110 -t out/rep_set.tre -m ../Fasting_Map.txt

#Make Bootstrapped Tree
make_bootstrapped_tree.py -m out/jack/unweighted_unifrac/upgma_cmp/master_tree.tre -s out/jack/unweighted_unifrac/upgma_cmp/jackknife_support.txt -o out/jack/unweighted_unifrac/upgma_cmp/jackknife_named_nodes.pdf

#Rarefy OTU table and convert biom format to tab delimited
#Rarefy to depth of 146
single_rarefaction.py -i  out/otu_table.biom -o out/otu_table_rar.biom -d 146
#Exit QIIME
exit
#Convert format
biom convert -i out/otu_table_rar.biom -o out/otu_table_rar_from_biom.txt --table-type "OTU table" --to-tsv --header-key taxonomy

