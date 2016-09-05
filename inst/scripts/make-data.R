make_data <- function(tar_gz_file) {
    create_dir("./data")
    untar(tar_gz_file, exdir = "./tmp", compressed = "gzip")
    dataset_dir <- dataset_dir(tar_gz_file)
    pheno_data <- metadata(dataset_dir)
    genefamilies_relab(pheno_data, dataset_dir)
    marker_abundance(pheno_data, dataset_dir)
    marker_presence(pheno_data, dataset_dir)
    metaphlan_bugs_list(pheno_data, dataset_dir)
    pathabundance_relab(pheno_data, dataset_dir)
    pathcoverage(pheno_data, dataset_dir)
}
