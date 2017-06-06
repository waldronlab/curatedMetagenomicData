#!/bin/bash

### usage: bash curatedMetagenomicData_pipeline.sh sample_name "SRRxxyxyxx;SRRyyxxyyx"

### before running this script, be sure that these tools are in your path
# fastq-dump
# humann2
# metaphlan2
# python

### before running this script, set these paths and variables
pa=/tools/aspera/connect/ #aspera path (like /tools/aspera/connect/)
pm=/tools/metaphlan2/metaphlan2.py #metaphlan2 path (like /tools/metaphlan2/bin/metaphlan2.py)
pc=/databases/chocophlan # chocophlan database (nucleotide-database for humann2, like /databases/chocophlan
pp=/databases/uniref/ # uniref database (protein-database for humann2, like /databases/uniref)
pmdb=/tools/metaphlan2/db_v20/mpa_v20_m200.pkl #metaphlan2 database (like /tools/metaphlan2/db_v20/mpa_v20_m200.pkl)
ncores=16 #number of cores

sample=$1
runs=$2

mkdir -p ${sample}/reads

while [ "$runs" ] ; do
	iter=${runs%%;*}
        shortyone=$(echo "$iter" | cut -c1-3)
        shortytwo=$(echo "$iter" | cut -c1-6)
	echo 'Starting downloading run '${iter}
        ${pa}bin/ascp -T -i ${pa}etc/asperaweb_id_dsa.openssh anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/${shortyone}/${shortytwo}/${iter}/${iter}.sra ${sample}/reads/
	echo 'Dumping run '${iter}
        fastq-dump --split-files ${sample}/reads/${iter}.sra --outdir ${sample}/reads/
        [ "$runs" = "$iter" ] && \
        runs='' || \
        runs="${runs#*;}"
	echo 'Finished downloading of run '${iter}
done
echo 'Downloaded.'
echo 'Concatenating runs...'
cat ${sample}/reads/*.fastq > ${sample}/reads/${sample}.fastq

mkdir -p ${sample}/humann2
humann2 --input ${sample}/reads/${sample}.fastq --output ${sample}/humann2 --nucleotide-database ${pc} --protein-database ${pp} --threads=${ncores}
humann2_renorm_table --input ${sample}/humann2/${sample}_genefamilies.tsv --output ${sample}/humann2/${sample}_genefamilies_relab.tsv --units relab
humann2_renorm_table --input ${sample}/humann2/${sample}_pathabundance.tsv --output ${sample}/humann2/${sample}_pathabundance_relab.tsv --units relab
python run_markers2.py --input_dir ${sample}/humann2/${sample}_humann2_temp/ --bt2_ext _metaphlan_bowtie2.txt --metaphlan_path ${pm} --metaphlan_db ${pmdb} --output_dir ${sample}/humann2 --nprocs ${ncores}

mkdir genefamilies; mv ${sample}/humann2/${sample}_genefamilies.tsv genefamilies/${sample}.tsv;
mkdir genefamilies_relab; mv ${sample}/humann2/${sample}_genefamilies_relab.tsv genefamilies_relab/${sample}.tsv;
mkdir marker_abundance; mv ${sample}/humann2/${sample}.marker_ab_table marker_abundance/${sample}.tsv;
mkdir marker_presence; mv ${sample}/humann2/${sample}.marker_pres_table marker_presence/${sample}.tsv;
mkdir metaphlan_bugs_list; mv ${sample}/humann2/${sample}_humann2_temp/${sample}_metaphlan_bugs_list.tsv metaphlan_bugs_list/${sample}.tsv;
mkdir pathabundance; mv ${sample}/humann2/${sample}_pathabundance.tsv pathabundance/${sample}.tsv;
mkdir pathabundance_relab; mv ${sample}/humann2/${sample}_pathabundance_relab.tsv pathabundance_relab/${sample}.tsv;
mkdir pathcoverage; mv ${sample}/humann2/${sample}_pathcoverage.tsv pathcoverage/${sample}.tsv;
mkdir humann2_temp; mv ${sample}/humann2/${sample}_humann2_temp/ humann2_temp/ #comment this line if you don't want to keep humann2 temporary files

rm -r ${sample}
