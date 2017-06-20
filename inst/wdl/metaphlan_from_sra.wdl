#  WDL file for running bioBakery's MetaPhlAn
#
#  Metaphlan Tutorial Files (metaphlan_cfg*)
#  https://bitbucket.org/nsegata/metaphlan/wiki/MetaPhlAn_Pipelines_Tutorial
#
#  To run multiple samples (batch processing) in FireCloud -
#  Upload *sample_set.tsv and then *sample_set_membership.tsv
#  Under "Method Configuration" tab, select the method config (metaphlan)
#  Confirm root entity is "sample" and Click "Launch Analysis..."
#  Click "sample_set" button and select the sample set (set1)
#  In the textbox "define expression," type "this.samples"
#  Click "Launch"

task sratofastq {
  Array[String] accessions

  command <<<
    fastq-dump --stdout ${sep=' ' accessions} | gzip > out.fastq.gz
  >>>

  runtime {
    docker : "seandavi/sratoolkit"
  }

  output {
    File gzippedFASTQ = "out.fastq.gz"
  }
}

task metaphlan_task {

  File gzippedFASTQ

  command <<<
    gunzip -c ${gzippedFASTQ} | /metaphlan/metaphlan.py --bowtie2db /metaphlan/bowtie2db/mpa --bowtie2_exe /bowtie2-2.2.5/bowtie2 --bt2_ps very-sensitive --input_type multifastq --bowtie2out BM_input_fastq-1.bt2out > profile_out.txt
    /metaphlan/plotting_scripts/metaphlan2graphlan.py profile_out.txt --tree_file tree.txt --annot_file annot.txt
    /graphlan/graphlan_annotate.py --annot annot.txt  tree.txt  annot_out.xml
    /graphlan/graphlan.py --dpi 200  annot_out.xml final.png

  >>>

  runtime {
    docker : "stevetsa/metaphlan:2"
  }

  output {
    File outpng = "final.png"
  }
}



workflow metaphlan_wfl {

  Array[String] accessions

  call sratofastq {
    input:
      accessions=accessions
  }
 
  call metaphlan_task {
    input:
      gzippedFASTQ=sratofastq.gzippedFASTQ	
  }
}
