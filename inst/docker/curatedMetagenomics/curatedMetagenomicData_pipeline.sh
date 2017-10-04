#!/bin/bash

### usage: bash curatedMetagenomicData_pipeline.sh sample_name "SRRxxyxyxx;SRRyyxxyyx"

### before running this script, be sure that these tools are in your path
# fastq-dump
# humann2
# metaphlan2
# python

sample=$1
runs=$2

### before running this script, set these paths and variables
pm=/opt/metaphlan2/biobakery-metaphlan2/metaphlan2.py #metaphlan2 path (like /tools/metaphlan2/bin/metaphlan2.py)
pc=/dbs/humann2/chocophlan # chocophlan database (nucleotide-database for humann2, like /databases/chocophlan
pp=/dbs/humann2/uniref # uniref database (protein-database for humann2, like /databases/uniref)
pmdb=/opt/metaphlan2/biobakery-metaphlan2/db_v20/mpa_v20_m200.pkl #metaphlan2 database (like /tools/metaphlan2/db_v20/mpa_v20_m200.pkl)
ncores=2 #number of cores

mkdir -p $pc
mkdir -p $pp

if [ ! "$(ls -A $pp)" ]; then
    wget https://storage.googleapis.com/curatedmetagenomicdata/dbs/uniref/uniref90_annotated_1_1.tar.gz
    tar -xvz -C /dbs/humann2/uniref/ -f uniref90_annotated_1_1.tar.gz
fi

if [ ! "$(ls -A $pc)" ]; then
    wget https://storage.googleapis.com/curatedmetagenomicdata/dbs/chocophlan/full_chocophlan_plus_viral.v0.1.1.tar.gz  
    tar -xvz -C /dbs/humann2/chocophlan/ -f full_chocophlan_plus_viral.v0.1.1.tar.gz
fi



echo "Working in ${OUTPUT_PATH}"
mkdir -p ${OUTPUT_PATH}

cd ${OUTPUT_PATH}

# while [ "$runs" ] ; do
# 	iter=${runs%%;*}
#         shortyone=$(echo "$iter" | cut -c1-3)
#         shortytwo=$(echo "$iter" | cut -c1-6)
# 	echo 'Starting downloading run '${iter}
#         ${pa}bin/ascp -T -i ${pa}etc/asperaweb_id_dsa.openssh anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/${shortyone}/${shortytwo}/${iter}/${iter}.sra ${sample}/reads/
# 	echo 'Dumping run '${iter}
#         fastq-dump --split-files ${sample}/reads/${iter}.sra --outdir ${sample}/reads/
#         [ "$runs" = "$iter" ] && \
#         runs='' || \
#         runs="${runs#*;}"
# 	echo 'Finished downloading of run '${iter}
# done
fastq-dump --outdir reads $2
echo 'Downloaded.'
echo 'Concatenating runs...'
cat reads/*.fastq > reads/${sample}.fastq

mkdir -p humann2
echo 'Running humann2'
humann2 --input reads/${sample}.fastq --output humann2 --nucleotide-database ${pc} --protein-database ${pp} --threads=${ncores}
echo 'renorm_table runs'
humann2_renorm_table --input humann2/${sample}_genefamilies.tsv --output humann2/${sample}_genefamilies_relab.tsv --units relab
humann2_renorm_table --input humann2/${sample}_pathabundance.tsv --output humann2/${sample}_pathabundance_relab.tsv --units relab
echo 'run_markers2.py'
# NOTE: using absolute path here!!!
python /root/run_markers2.py --input_dir humann2/${sample}_humann2_temp/ --bt2_ext _metaphlan_bowtie2.txt --metaphlan_path ${pm} --metaphlan_db ${pmdb} --output_dir humann2 --nprocs ${ncores}

mkdir genefamilies; mv humann2/${sample}_genefamilies.tsv genefamilies/${sample}.tsv;
mkdir genefamilies_relab; mv humann2/${sample}_genefamilies_relab.tsv genefamilies_relab/${sample}.tsv;
mkdir marker_abundance; mv humann2/${sample}.marker_ab_table marker_abundance/${sample}.tsv;
mkdir marker_presence; mv humann2/${sample}.marker_pres_table marker_presence/${sample}.tsv;
mkdir metaphlan_bugs_list; mv humann2/${sample}_humann2_temp/${sample}_metaphlan_bugs_list.tsv metaphlan_bugs_list/${sample}.tsv;
mkdir pathabundance; mv humann2/${sample}_pathabundance.tsv pathabundance/${sample}.tsv;
mkdir pathabundance_relab; mv humann2/${sample}_pathabundance_relab.tsv pathabundance_relab/${sample}.tsv;
mkdir pathcoverage; mv humann2/${sample}_pathcoverage.tsv pathcoverage/${sample}.tsv;
mkdir humann2_temp; mv humann2/${sample}_humann2_temp/ humann2_temp/ #comment this line if you don't want to keep humann2 temporary files

rm -r reads
