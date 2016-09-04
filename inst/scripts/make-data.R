make_data <- function(tar_gz_file) {
    untar(tar_gz_file, exdir = "./tmp", compressed = "gzip")
    set_wd(tar_gz_file)
    pheno_data <- metadata()
    genefamilies_relab()
    marker_abundance()
    marker_presence()
    metaphlan_bugs_list()
    pathabundance_relab()
    pathcoverage()
}
