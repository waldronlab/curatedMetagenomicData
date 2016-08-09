# Script to extract the Pheno Data information from MetaPhlAn2 output file.

pheno.dat <- fread("merge_abundance.metadata_NV.txt", data.table=FALSE, header=FALSE, na.strings=c("NA", "nd", "-", " -"), nrow=211)
pheno.dat[4, is.na(pheno.dat[4, ])] <- "stool"

pheno.dat <- t(pheno.dat)
colnames(pheno.dat) <- pheno.dat[1, ]
pheno.dat <- pheno.dat[-1, ]

rownames(pheno.dat) <- make.unique(paste(pheno.dat[, 2]))
pheno.dat <- data.frame(pheno.dat, stringsAsFactors=FALSE)
write.table(pheno.dat, file="Pheno_Data.txt", quote=FALSE, sep ='\t', row.names = FALSE)



