make_data <- function(tar_gz_file) {
    create_dir("./data")
    untar(tar_gz_file, exdir = "./tmp", compressed = "gzip")
    dataset_dir <- dataset_dir(tar_gz_file)
    metadata <- metadata(dataset_dir)
    pheno_data <- pheno_data(metadata)
    experiment_data <- experiment_data(metadata)
    genefamilies_relab(pheno_data, experiment_data, dataset_dir)
    marker_abundance(pheno_data, experiment_data, dataset_dir)
    marker_presence(pheno_data, experiment_data, dataset_dir)
    metaphlan_bugs_list(pheno_data, experiment_data, dataset_dir)
    pathabundance_relab(pheno_data, experiment_data, dataset_dir)
    pathcoverage(pheno_data, experiment_data, dataset_dir)
}
