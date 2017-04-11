---
layout: post
title: "Example Analysis"
date:  2017-04-11
---

# Coordinated Color Scheme

{% highlight r %}
blue <- "#3366aa"
blueGreen <- "#11aa99"
green <- "#66aa55"
paleYellow <- "#cccc55"
gray <- "#777777"
purple <- "#992288"
red <- "#ee3333"
orange <- "#ee7722"
yellow <- "#ffee33"
black <- "#000000"
brown <- "#655643"
white <- "#ffffff"
pallet <- c(blue, blueGreen, green, paleYellow, gray, purple, red, orange,
            yellow, black, brown, white)
n <- length(pallet)
image(1:n, 1, as.matrix(1:n), col = pallet, xlab = "", ylab = "", xaxt = "n",
      yaxt = "n", bty = "n")
{% endhighlight %}

![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/color_scheme-1.png)

# Figure 1, Example 1: Classification


{% highlight r %}
dataset_list <- c("KarlssonFH_2013 (T2D)", "LeChatelierE_2013 (Obesity)", "NielsenHB_2014 (IBD)", "QinJ_2012 (T2D)", "QinN_2014 (Cirrhosis)", "ZellerG_2014 (CRC)")
class_list <- c("t2d", "obesity", "ibd", "t2d", "cirrhosis", "cancer")
data_list <- matrix(nrow = 5, ncol = length(dataset_list))
data_list[1, ] <- c("EH277", "EH283", "EH301", "EH319", "EH325", "EH361")  # Species abundance
data_list[2, ] <- c("EH278", "EH284", "EH302", "EH320", "EH326", "EH362")  # Pathway abundance
data_list[3, ] <- c("EH279", "EH285", "EH303", "EH321", "EH327", "EH363")  # Pathway coverage
data_list[4, ] <- c("EH275", "EH281", "EH299", "EH317", "EH323", "EH359")  # Maker abundance
data_list[5, ] <- c("EH276", "EH282", "EH300", "EH318", "EH324", "EH360")  # Marker presence

eh <- ExperimentHub()

for (j in 1:length(data_list[, 1])) {
    for (i in 1:length(dataset_list)) {
        taxabund <- eh[[data_list[j, i]]]

        feat <- t(exprs(taxabund))
        if (j == 1) {
            feat <- feat[, grep("(s__|unclassified)", colnames(feat))]
            feat <- feat[, -grep("t__", colnames(feat))]
        }
        meta <- pData(taxabund)["disease"]
        all <- cbind(feat, meta)
        if (i == 1) {
            all <- subset(all, disease != "impaired_glucose_tolerance")
        }
        if (i == 2) {
            all <- subset(all, disease != "n")
        }
        if (i == 3) {
            all$disease[all$disease == "ibd_ulcerative_colitis"] <- "ibd"
            all$disease[all$disease == "ibd_crohn_disease"] <- "ibd"
            all$disease[all$disease == "n_relative"] <- "n"
        }
        if (i == 4) {
            all <- subset(all, disease != "na")
        }
        if (i == 6) {
            all <- subset(all, disease != "large_adenoma")
            all$disease[all$disease == "small_adenoma"] <- "n"
        }

        assign(paste("rf", j, i, sep = "_"), train(disease ~ ., data = all, preProc = c("zv", "scale", "center"), method = "rf", ntree = 500, tuneGrid = expand.grid(.mtry = c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 125, 150, 175, 200, 300, 400, 500)), trControl = trainControl(method = "repeatedcv", number = 10, search = "grid", summaryFunction = twoClassSummary, classProbs = TRUE, savePredictions = TRUE)))
    }
}

ci_bugs <- c()
ci_pab <- c()
ci_pcov <- c()
ci_mab <- c()
ci_mpr <- c()

for (i in 1:length(dataset_list)) {
    rf <- get(paste("rf", 1, i, sep = "_"))
    ci_bugs <- c(ci_bugs, auc(rf$pred$obs[rf$pred$mtry == rf$bestTune$mtry], rf$pred[, class_list[i]][rf$pred$mtry == rf$bestTune$mtry]))

    rf <- get(paste("rf", 2, i, sep = "_"))
    ci_pab <- c(ci_pab, auc(rf$pred$obs[rf$pred$mtry == rf$bestTune$mtry], rf$pred[, class_list[i]][rf$pred$mtry == rf$bestTune$mtry]))

    rf <- get(paste("rf", 3, i, sep = "_"))
    ci_pcov <- c(ci_pcov, auc(rf$pred$obs[rf$pred$mtry == rf$bestTune$mtry], rf$pred[, class_list[i]][rf$pred$mtry == rf$bestTune$mtry]))

    rf <- get(paste("rf", 4, i, sep = "_"))
    ci_mab <- c(ci_mab, auc(rf$pred$obs[rf$pred$mtry == rf$bestTune$mtry], rf$pred[, class_list[i]][rf$pred$mtry == rf$bestTune$mtry]))

    rf <- get(paste("rf", 5, i, sep = "_"))
    ci_mpr <- c(ci_mpr, auc(rf$pred$obs[rf$pred$mtry == rf$bestTune$mtry], rf$pred[, class_list[i]][rf$pred$mtry == rf$bestTune$mtry]))
}

ci <- data.frame(ci_bugs, ci_pab, ci_pcov, ci_mab, ci_mpr)
colnames(ci) <- c("Taxonomic abundance", "Pathway abundance", "Pathway coverage", "Marker abundance", "Marker presence")
ci.r <- abs(cor(ci))
ci.col <- dmat.color(ci.r)
ci.o <- order.single(ci.r)

par(oma = c(4, 1, 1, 1))

cpairs(ci, ci.o, panel.colors = ci.col, col = alpha(pallet, 0.75), pch = 16, cex = 2, gap = 0.5, main = "AUC")

par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
legend("bottom", xpd = TRUE, horiz = TRUE, inset = c(0, 0), bty = "n", pch = 16, cex = 0.6, dataset_list, col = pallet)
{% endhighlight %}

# Figure 1, Example 2: Clustering


{% highlight r %}
eh <- ExperimentHub()
myquery <- query(eh, "curatedMetagenomicData")

myquery.stool <- myquery[grepl("stool", myquery$title) & grepl("bugs", myquery$title), ]

eset.list <- lapply(names(myquery.stool), function(x) myquery.stool[[x]])

names(eset.list) <- myquery.stool$title
names(eset.list) <- gsub("\\..+", "", myquery.stool$title)

for (i in 1:length(eset.list)) {
    colnames(eset.list[[i]]) <- paste(names(eset.list)[[i]], colnames(eset.list[[i]]), sep = ".")
    pData(eset.list[[i]]) <- pData(eset.list[[i]])[, !sapply(pData(eset.list[[i]]), function(x) all(is.na(x)))]
    eset.list[[i]]$subjectID <- as.character(eset.list[[i]]$subjectID)
}

for (i in seq_along(eset.list)) {
    eset.list[[i]] <- eset.list[[i]][grep("t__", rownames(eset.list[[i]]), invert = TRUE), ]
    eset.list[[i]] <- eset.list[[i]][grep("s__|_unclassified\t", rownames(eset.list[[i]]), perl = TRUE), ]
}

joinWithRnames <- function(obj, FUN = I) {
    mylist <- lapply(obj, function(x) {
        df <- data.frame(FUN(x))
        df$rnames28591436107 <- rownames(df)
        return(df)
    })
    bigdf <- Reduce(full_join, mylist)
    rownames(bigdf) <- make.names(bigdf$rnames28591436107)
    bigdf <- bigdf[, !grepl("^rnames28591436107$", colnames(bigdf))]
    return(bigdf)
}

pdat <- joinWithRnames(eset.list, FUN = pData)
pdat$study <- sub("\\..+", "", rownames(pdat))
ab <- joinWithRnames(eset.list, FUN = exprs)
ab[is.na(ab)] <- 0
eset <- ExpressionSet(assayData = as.matrix(ab), phenoData = AnnotatedDataFrame(pdat))

source("https://raw.githubusercontent.com/waldronlab/presentations/master/Waldron_2016-06-07_EPIC/metaphlanToPhyloseq.R")
pseq <- metaphlanToPhyloseq(tax = exprs(eset), metadat = pData(eset), split = ".")

samp <- data.frame(sample_data(pseq))

dist_bray <- distance(pseq, method = "bray")

ord_bray <- ordinate(pseq, method = "PCoA", distance = dist_bray)

samp$bray_cluster_2 <- factor(pam(dist_bray, k = 2, cluster.only = TRUE))
sample_data(pseq) <- samp

Prev <- as.numeric(otu_table(pseq)["s__Prevotella_copri", ])
samp$Prevotella_copri <- Prev
sample_data(pseq) <- samp

pc1 <- ord_bray$vectors[, 1]
pc2 <- ord_bray$vectors[, 2]

otu_tax <- attr(otu_table(pseq), "dimnames")[[1]]
otu_bacteroides <- otu_table(pseq)[grep("s__Bacteroides", otu_tax), ]
sum_bacteroides <- apply(otu_bacteroides, 2, sum)

df_ordinate <- data.frame(pc1, pc2, bact = sum_bacteroides, prev = Prev, bray2 = as.numeric(samp$bray_cluster_2) + 20)
df_bact <- df_ordinate[df_ordinate$bray2 == 21, ]
df_prev <- df_ordinate[df_ordinate$bray2 == 22, ]

ggplot() +
    geom_point(data = df_prev, aes(x = pc1, y = pc2, shape = factor(bray2), fill = prev), shape = 21, size = 4) +
    scale_fill_gradient(low = "white", high = purple, guide = guide_colorbar(title = "Prevotella copri \n(cluster 2)")) +
    geom_point(data = df_bact, aes(x = pc1, y = pc2, shape = factor(bray2), color = bact), shape = 22, size = 4) +
    scale_color_gradient(low = gray, high = blueGreen, guide = guide_colorbar(title = "Bacteroides \n(cluster 1)")) +
    labs(x = "Axis 1", y = "Axis 2", title = "PCoA on species abundance, displaying 2 clusters") +
    theme(legend.direction = "vertical", legend.position = c(0.4, 0.1))
{% endhighlight %}

![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/unnamed-chunk-2-1.png)

# Figure 1, Example 3: Abundance across samples


{% highlight r %}
eh <- ExperimentHub()
myquery <- query(eh, "curatedMetagenomicData")

myquery.stool <- myquery[grepl("stool", myquery$title) & grepl("pathabundance", myquery$title), ]

eset.list <- lapply(names(myquery.stool), function(x) myquery.stool[[x]])

names(eset.list) <- myquery.stool$title
names(eset.list) <- gsub("\\..+", "", myquery.stool$title)

for (i in 1:length(eset.list)) {
    colnames(eset.list[[i]]) <- paste(names(eset.list)[[i]], colnames(eset.list[[i]]), sep = ".")
    pData(eset.list[[i]]) <- pData(eset.list[[i]])[, !sapply(pData(eset.list[[i]]), function(x) all(is.na(x)))]
    eset.list[[i]]$subjectID <- as.character(eset.list[[i]]$subjectID)
}

for (i in seq_along(eset.list)) {
    eset.list[[i]] <- eset.list[[i]][!grepl("\\|", rownames(eset.list[[i]])), ]
}

pdat <- joinWithRnames(eset.list, FUN = pData)
pdat$study <- sub("\\..+", "", rownames(pdat))
ab <- joinWithRnames(eset.list, FUN = exprs)
ab[is.na(ab)] <- 0
eset_pathway <- ExpressionSet(assayData = as.matrix(ab), phenoData = AnnotatedDataFrame(pdat))

myquery.stool <- myquery[grepl("stool", myquery$title) & grepl("bugs", myquery$title), ]

eset.list <- lapply(names(myquery.stool), function(x) myquery.stool[[x]])

names(eset.list) <- myquery.stool$title
names(eset.list) <- gsub("\\..+", "", myquery.stool$title)

for (i in 1:length(eset.list)) {
    colnames(eset.list[[i]]) <- paste(names(eset.list)[[i]], colnames(eset.list[[i]]), sep = ".")
    pData(eset.list[[i]]) <- pData(eset.list[[i]])[, !sapply(pData(eset.list[[i]]), function(x) all(is.na(x)))]
    eset.list[[i]]$subjectID <- as.character(eset.list[[i]]$subjectID)
}

for (i in seq_along(eset.list)) {
    eset.list[[i]] <- eset.list[[i]][grep("t__", rownames(eset.list[[i]]), invert = TRUE), ]
    eset.list[[i]] <- eset.list[[i]][grep("s__|_unclassified\t", rownames(eset.list[[i]]), perl = TRUE), ]
}

pdat <- joinWithRnames(eset.list, FUN = pData)
pdat$study <- sub("\\..+", "", rownames(pdat))
ab <- joinWithRnames(eset.list, FUN = exprs)
ab[is.na(ab)] <- 0
eset_bugs <- ExpressionSet(assayData = as.matrix(ab), phenoData = AnnotatedDataFrame(pdat))

pseq <- metaphlanToPhyloseq(tax = exprs(eset_bugs), metadat = pData(eset_bugs), split = ".")

glom <- tax_glom(pseq, taxrank = "Phylum")

top8phyla <- names(sort(taxa_sums(glom), TRUE)[1:8])
phyla8_subset <- prune_taxa(top8phyla, glom)

phyla_to_sort <- data.frame(id = 1:8, phyla = as.character(tax_table(phyla8_subset)[, "Phylum"]), otu = as.character(taxa_names(phyla8_subset)))
rownames(phyla_to_sort) <- phyla_to_sort$otu

phylum_ranks <-
    phyla8_subset %>%
    otu_table %>%
    rowSums %>%
    sort(TRUE) %>%
    names

phyla_to_sort <- phyla_to_sort[phylum_ranks, ]

prop <- transform_sample_counts(phyla8_subset, function(i) i/sum(i))

bardat <-
    psmelt(prop) %>%
    select(OTU, Sample, Abundance) %>%
    mutate(Sample = as.numeric(factor(Sample)), OTU = factor(OTU, levels = phyla_to_sort$otu, labels = phyla_to_sort$phyla))

firmicutes_order <-
    bardat %>%
    filter(OTU == "Firmicutes") %>%
    arrange(Abundance) %>%
    select(Sample)

bardat %<>%
    mutate(Sample = as.numeric(factor(Sample, levels = factor(firmicutes_order$Sample)))) %>%
    arrange(desc(OTU), Abundance)

set.seed(14)

bardat %>%
    ggplot(aes(x = Sample, y = Abundance, fill = OTU)) +
    geom_area() +
    scale_fill_manual(values = sample(pallet, size = 8, replace = FALSE)) +
    labs(fill = "Phylum") +
    theme(axis.text.x = element_blank(), legend.position = c(0.4, 0.9))
{% endhighlight %}

![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/unnamed-chunk-3-1.png)

# Figure 1, Example 4: Species-pathway correlation


{% highlight r %}
eset_pathway$prev <- as.numeric(exprs(eset_bugs)[grep("s__Prevotella_copri", rownames(exprs(eset_bugs))), ])

cor_est_p <- function(x1, x2) {
    cor <- cor.test(x1, x2)
    c(r = cor$estimate, p = cor$p.value)
}

cors <- t(sapply(featureNames(eset_pathway), function(i) cor_est_p(exprs(eset_pathway)[i, ], eset_pathway$prev)))

feature <- rownames(cors)

cors <- as.data.frame(cors)
cors$feature <- feature
cors <- na.omit(cors)

par(mar = c(10, 10, 10, 10))
qplot(x = eset_pathway$prev, y = exprs(eset_pathway)[cors$feature[cors$r.cor == max(cors$r.cor)], ], xlab = "Prevotella copri", ylab = "Pathway abundance", main = "PWY 7291: Adenosine ribonucleotides \nde novo biosynthesis ", colour = I(black), shape = I(1))
{% endhighlight %}

![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/unnamed-chunk-4-1.png)

# Supplemental Figure 1: Health status classification from species abundance.

{% highlight r %}
dataset_list <- c("KarlssonFH_2013 (T2D)", "LeChatelierE_2013 (Obesity)", "NielsenHB_2014 (IBD)", "QinJ_2012 (T2D)", "QinN_2014 (Cirrhosis)", "ZellerG_2014 (CRC)")
class_list <- c("t2d", "obesity", "ibd", "t2d", "cirrhosis", "cancer")
data_list <- c("EH277", "EH283", "EH301", "EH319", "EH325", "EH361")

eh <- ExperimentHub()

for (i in 1:length(dataset_list)) {
    taxabund <- eh[[data_list[i]]]

    feat <- t(exprs(taxabund))
    feat <- feat[, grep("(s__|unclassified)", colnames(feat))]
    feat <- feat[, -grep("t__", colnames(feat))]
    meta <- pData(taxabund)["disease"]
    all <- cbind(feat, meta)
    if (i == 1) {
        all <- subset(all, disease != "impaired_glucose_tolerance")
    }
    if (i == 2) {
        all <- subset(all, disease != "n")
    }
    if (i == 3) {
        all$disease[all$disease == "ibd_ulcerative_colitis"] <- "ibd"
        all$disease[all$disease == "ibd_crohn_disease"] <- "ibd"
        all$disease[all$disease == "n_relative"] <- "n"
    }
    if (i == 4) {
        all <- subset(all, disease != "na")
    }
    if (i == 6) {
        all <- subset(all, disease != "large_adenoma")
        all$disease[all$disease == "small_adenoma"] <- "n"
    }

    assign(paste("rf", i, sep = "_"), train(disease ~ ., data = all, preProc = c("zv", "scale", "center"), method = "rf", ntree = 500, tuneGrid = expand.grid(.mtry = c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 125, 150, 175, 200, 300, 400, 500)), trControl = trainControl(method = "repeatedcv", number = 10, search = "grid", summaryFunction = twoClassSummary, classProbs = TRUE, savePredictions = TRUE)))
}

pallet_reduced <- c(blue, green, gray, purple, red, black)

for (i in 1:length(dataset_list)) {
    rf <- get(paste("rf", i, sep = "_"))

    if (i == 1) {
        plot.roc(rf$pred$obs[rf$pred$mtry == rf$bestTune$mtry], rf$pred[, class_list[i]][rf$pred$mtry == rf$bestTune$mtry], grid = TRUE, ci = TRUE, xaxs = "i", yaxs = "i", col = pallet_reduced[i], lty = 1)
    } else {
        plot.roc(rf$pred$obs[rf$pred$mtry == rf$bestTune$mtry], rf$pred[, class_list[i]][rf$pred$mtry == rf$bestTune$mtry], grid = TRUE, ci = TRUE, xaxs = "i", yaxs = "i", col = pallet_reduced[i], lty = 1, add = TRUE)
    }
}

legend("bottomright", box.lwd = 0, box.col = "white", bg = "white", lwd = 2, legend = dataset_list, col = pallet_reduced)
{% endhighlight %}

![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/unnamed-chunk-5-1.png)

# Supplemental Figure 2: PCoA plots colored for dataset + disease states.

{% highlight r %}
eset.list <- curatedMetagenomicData("*metaphlan_bugs_list.stool", dryrun = FALSE)

names(eset.list) <- gsub("\\..+", "", names(eset.list))

for (i in 1:length(eset.list)) {
    colnames(eset.list[[i]]) <- paste(names(eset.list)[[i]], colnames(eset.list[[i]]), sep = ".")
    pData(eset.list[[i]]) <- pData(eset.list[[i]])[, !sapply(pData(eset.list[[i]]), function(x) all(is.na(x)))]
    eset.list[[i]]$subjectID <- as.character(eset.list[[i]]$subjectID)
}

for (i in seq_along(eset.list)) {
    eset.list[[i]] <- eset.list[[i]][grep("t__", rownames(eset.list[[i]]), invert = TRUE), ]
    eset.list[[i]] <- eset.list[[i]][grep("s__|_unclassified\t", rownames(eset.list[[i]]), perl = TRUE), ]
}

pdat <- joinWithRnames(eset.list, FUN = pData)
pdat$study <- sub("\\..+", "", rownames(pdat))

ab <- joinWithRnames(eset.list, FUN = exprs)
ab[is.na(ab)] <- 0

eset <- ExpressionSet(assayData = as.matrix(ab), phenoData = AnnotatedDataFrame(pdat))

metaphlanToPhyloseq <- function(tax, metadat = NULL, simplenames = TRUE, roundtointeger = FALSE, split = "|") {
    xnames <- rownames(tax)
    shortnames <- gsub(paste0(".+\\", split), "", xnames)
    if (simplenames) {
        rownames(tax) <- shortnames
    }
    if (roundtointeger) {
        tax <- round(tax * 10000)
    }
    x2 <- strsplit(xnames, split = split, fixed = TRUE)
    taxmat <- matrix(NA, ncol = max(sapply(x2, length)), nrow = length(x2))
    colnames(taxmat) <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species", "Strain")[1:ncol(taxmat)]
    rownames(taxmat) <- rownames(tax)
    for (i in 1:nrow(taxmat)) {
        taxmat[i, 1:length(x2[[i]])] <- x2[[i]]
    }
    taxmat <- gsub("[a-z]__", "", taxmat)
    taxmat <- tax_table(taxmat)
    otutab <- otu_table(tax, taxa_are_rows = TRUE)
    if (is.null(metadat)) {
        res <- phyloseq(taxmat, otutab)
    } else {
        res <- phyloseq(taxmat, otutab, sample_data(metadat))
    }
    return(res)
}

pseq <- metaphlanToPhyloseq(tax = exprs(eset), metadat = pData(eset), split = ".")

samp <- data.frame(sample_data(pseq))
samp$source <- factor(samp$study == "HMP_2012", levels = c(T, F), labels = c("HMP", "Community"))
sample_data(pseq) <- samp

dist_bray <- distance(pseq, method = "bray")
dist_js <- distance(pseq, method = "jsd")
dist_rjs <- sqrt(dist_js)

ord_bray <- ordinate(pseq, method = "PCoA", distance = dist_bray)
ord_JS <- ordinate(pseq, method = "PCoA", distance = dist_js)
ord_RJS <- ordinate(pseq, method = "PCoA", distance = dist_rjs)

samp$bray_cluster_2 <- factor(pam(dist_bray, k = 2, cluster.only = T))
samp$bray_cluster_3 <- factor(pam(dist_bray, k = 3, cluster.only = T))
samp$bray_cluster_4 <- factor(pam(dist_bray, k = 4, cluster.only = T))
sample_data(pseq) <- samp

Prev <- as.numeric(otu_table(pseq)["s__Prevotella_copri", ])
samp$Prevotella_copri <- Prev
sample_data(pseq) <- samp

pc1 <- ord_bray$vectors[, 1]
pc2 <- ord_bray$vectors[, 2]

otu_tax <- attr(otu_table(pseq), "dimnames")[[1]]
otu_bacteroides <- otu_table(pseq)[grep("s__Bacteroides", otu_tax), ]
sum_bacteroides <- apply(otu_bacteroides, 2, sum)

df_ordinate <- data.frame(pc1, pc2, bact = sum_bacteroides, prev = Prev, bray2 = as.numeric(samp$bray_cluster_2) + 20)
df_bact <- df_ordinate[df_ordinate$bray2 == 21, ]
df_prev <- df_ordinate[df_ordinate$bray2 == 22, ]

samp$disease[samp$disease %in% c("obesity", "obese")] <- "obesity"
samp$disease[samp$disease %in% c("underweight", "leaness")] <- "underweight"
samp$disease_simplified[samp$disease == "cancer"] <- "cancer"
samp$disease_simplified[samp$disease %in% c("small_adenoma", "large_adenoma")] <- "adenoma"
samp$disease_simplified[samp$disease == "cirrhosis"] <- "cirrhosis"
samp$disease_simplified[samp$disease %in% c("t2d", "impaired_glucose_tolerance")] <- "t2d / impaired glucose tolerance"
samp$disease_simplified[samp$disease %in% c("ibd_crohn_disease", "ibd_ulcerative_colitis")] <- "ibd"
samp$disease_simplified[samp$disease %in% c("obesity", "overweight")] <- "obese or overweight"
df_ord_dataset_disease <- data.frame(pc1, pc2, disease_bin = factor(samp$disease == "n", levels = c(T, F), labels = c("diseased", "healthy")), disease = samp$disease_simplified, study = samp$study, prev = df_ordinate$prev)

df_ord_dataset_disease %>%
    ggplot(aes(x=pc1, y=pc2, shape=disease, color=study, size=prev)) +
    geom_point() +
    labs(x="Axis 1", y="Axis 2", title="PCoA by dataset and disease") +
    scale_shape_manual(values = 19:25) +
    guides(color=guide_legend(ncol=2), shape=guide_legend(ncol=2), size=guide_legend(ncol=2, title="Prevotella copri"))
{% endhighlight %}

![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/unnamed-chunk-6-1.png)

# Supplemental Figure 3. Clustering scores for enterotypes in gut WGS samples.

{% highlight r %}
pam_bray <- sapply(2:10, function(i) pam(dist_bray, k = i, cluster.only = T))
pam_js <- sapply(2:10, function(i) pam(dist_js, k = i, cluster.only = T))
pam_rjs <- sapply(2:10, function(i) pam(dist_rjs, k = i, cluster.only = T))

plot_cluster_validation = function(bray, js, rjs, legend = T, ...) {
    plot(2:10, bray, type = "b", pch = 1, xlab = "Number of Clusters", ...)
    lines(2:10, js, type = "b", pch = 2, lty = 2)
    lines(2:10, rjs, type = "b", pch = 22, lty = 3)
    if (legend) {
        legend("topright", legend = c("Bray-Curtis", "Jensen-Shannon", "Root Jensen-Shannon"), pch = c(1, 2, 22), lty = 1:3)
    }
}

ch_bray <- apply(pam_bray, 2, function(i) cluster.stats(dist_bray, i)$ch)
ch_js <- apply(pam_js, 2, function(i) cluster.stats(dist_js, i)$ch)
ch_rjs <- apply(pam_rjs, 2, function(i) cluster.stats(dist_rjs, i)$ch)

plot_cluster_validation(ch_bray, ch_js, ch_rjs, legend = T, ylab = "Calinski-Harabasz score", ylim = c(0, 300))

si_bray <- apply(pam_bray, 2, function(i) mean(silhouette(i, dist_bray)[, 3]))
si_js <- apply(pam_js, 2, function(i) mean(silhouette(i, dist_js)[, 3]))
si_rjs <- apply(pam_rjs, 2, function(i) mean(silhouette(i, dist_rjs)[, 3]))

plot_cluster_validation(si_bray, si_js, si_rjs, legend = F, ylab = "Average silhouette width", ylim = c(0, 1))
abline(0.75, 0, lty = 5, col = "grey70")
abline(0.5, 0, lty = 5, col = "grey70")
abline(0.25, 0, lty = 5, col = "grey70")
text("Strong support", x = 9, y = 0.8, col = "grey70")
text("Moderate support", x = 9, y = 0.6, col = "grey70")
text("Weak and could be artificial", x = 8.5, y = 0.4, col = "grey70")
text("No substantial structure", x = 8.5, y = 0.2, col = "grey70")

ps_bray <- prediction.strength(dist_bray, Gmin = 2, Gmax = 10, clustermethod = pamkCBI)
ps_js <- prediction.strength(dist_js, Gmin = 2, Gmax = 10, clustermethod = pamkCBI)
ps_rjs <- prediction.strength(dist_rjs, Gmin = 2, Gmax = 10, clustermethod = pamkCBI)

plot_cluster_validation(ps_bray$mean.pred[2:10], ps_js$mean.pred[2:10], ps_rjs$mean.pred[2:10], ylab = "Prediction Strength", ylim = c(0, 1.1), legend = F)
abline(0.9, 0, lty = 5, col = "grey70")
abline(0.8, 0, lty = 8, col = "grey70")
text("Strong support", x = 9, y = 1, col = "grey70")
text("Moderate support", x = 9, y = 0.85, col = "grey70")
text("Little or no support", x = 9, y = 0.6, col = "grey70")
{% endhighlight %}

![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/unnamed-chunk-7-1.png)![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/unnamed-chunk-7-2.png)![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/unnamed-chunk-7-3.png)

# Supplemental Figure 4: Top correlations between metabolic pathways and genera.

{% highlight r %}
eset.list <- curatedMetagenomicData("*pathabundance_relab.stool", dryrun = FALSE)

names(eset.list) <- gsub("\\..+", "", names(eset.list))

for (i in 1:length(eset.list)) {
    colnames(eset.list[[i]]) <- paste(names(eset.list)[[i]], colnames(eset.list[[i]]), sep = ".")
    pData(eset.list[[i]]) <- pData(eset.list[[i]])[, !sapply(pData(eset.list[[i]]), function(x) all(is.na(x)))]
    eset.list[[i]]$subjectID <- as.character(eset.list[[i]]$subjectID)
}

for (i in seq_along(eset.list)) {
    eset.list[[i]] <- eset.list[[i]][!grepl("\\|", rownames(eset.list[[i]])), ]
}

pdat <- joinWithRnames(eset.list, FUN = pData)
pdat$study <- sub("\\..+", "", rownames(pdat))
ab <- joinWithRnames(eset.list, FUN = exprs)
ab[is.na(ab)] <- 0
eset_pathway <- ExpressionSet(assayData = as.matrix(ab), phenoData = AnnotatedDataFrame(pdat))

eset.list <- curatedMetagenomicData("*metaphlan_bugs_list.stool", dryrun = FALSE)

names(eset.list) <- gsub("\\..+", "", names(eset.list))

for (i in 1:length(eset.list)) {
    colnames(eset.list[[i]]) <- paste(names(eset.list)[[i]], colnames(eset.list[[i]]), sep = ".")
    pData(eset.list[[i]]) <- pData(eset.list[[i]])[, !sapply(pData(eset.list[[i]]), function(x) all(is.na(x)))]
    eset.list[[i]]$subjectID <- as.character(eset.list[[i]]$subjectID)
}

for (i in seq_along(eset.list)) {
    eset.list[[i]] <- eset.list[[i]][grep("t__", rownames(eset.list[[i]]), invert = TRUE), ]
    eset.list[[i]] <- eset.list[[i]][grep("s__|_unclassified\t", rownames(eset.list[[i]]), perl = TRUE), ]
}

pdat <- joinWithRnames(eset.list, FUN = pData)
pdat$study <- sub("\\..+", "", rownames(pdat))
ab <- joinWithRnames(eset.list, FUN = exprs)
ab[is.na(ab)] <- 0
eset_bugs <- ExpressionSet(assayData = as.matrix(ab), phenoData = AnnotatedDataFrame(pdat))

pseq <- metaphlanToPhyloseq(tax = exprs(eset_bugs), metadat = pData(eset_bugs), split = ".")

glom_genus <- tax_glom(pseq, taxrank = "Genus")
top20_genus_otu_names = names(sort(taxa_sums(glom_genus), TRUE)[1:20])
top20_genus <- tax_table(glom_genus)[top20_genus_otu_names,"Genus"]
subset_genus <- prune_taxa(top20_genus_otu_names, glom_genus)

max_cor_pathway <- function(y, X, margin=1) {
  cors = apply(X, margin, function(x) cor.test(as.numeric(y), as.numeric(x))$estimate)
  rownames(X)[cors==max(cors, na.rm=TRUE)]
}

exprs_pwy <- exprs(eset_pathway)
exprs_pwy <- exprs_pwy[apply(exprs_pwy, 1, function(i) max(i) != 0), ]

max_pathways <- apply(otu_table(subset_genus), 1,  function(y) max_cor_pathway(y, X=exprs_pwy))

cor_matrix <- cor(t(otu_table(subset_genus)), t(exprs(eset_pathway)[max_pathways,]))
rownames(cor_matrix) = top20_genus[rownames(cor_matrix), 1]

melted_cors <- melt(cor_matrix)
melted_cors %>%
    ggplot(aes(x=Var1, y=Var2, fill=value)) +
    geom_tile() +
    scale_fill_gradient2(low = blueGreen, high = purple, mid = 'gray90',
     midpoint = 0, space = "Lab",
     name="Pearson\nCorrelation") +
    theme(axis.text.x = element_text(angle = 45, vjust=1, hjust = 1, size=9), axis.text.y=element_text(size=9)) +
    labs(x = "Genus", y = "Pathway")
{% endhighlight %}

![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/unnamed-chunk-8-1.png)

# Supplemental Figure 5: Alpha diversity of taxa from 11 studies of the gut microbiome.

{% highlight r %}
alpha <- estimate_richness(pseq, measures = "Shannon")
alpha$study <- sample_data(pseq)$study

alpha %<>%
    group_by(study) %>%
    mutate(median = median(Shannon)) %>%
    arrange(desc(median)) %>%
    ungroup %>%
    mutate(study_num = as.numeric(as.factor(alpha$study)))

box_order <- factor(unique(alpha$study[order(alpha$median)]))

alpha$study <- factor(alpha$study, levels = box_order)

alpha %>%
    ggplot(aes(x = study, y = Shannon, fill = study)) +
    stat_boxplot(geom = "errorbar") +
    geom_boxplot() +
    theme(axis.text.x = element_blank()) +
    ylab("Shannon Alpha Diversity") +
    xlab("")
{% endhighlight %}

![](/curatedMetagenomicData/assets/PaperFigures_files/figure-html/unnamed-chunk-9-1.png)

# Session Info

{% highlight r %}
sessionInfo()
{% endhighlight %}

{% highlight r %}
## R version 3.3.3 (2017-03-06)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 16.04.2 LTS
##
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
##
## attached base packages:
## [1] parallel  stats     graphics  grDevices utils     datasets  methods  
## [8] base     
##
## other attached packages:
##  [1] reshape2_1.4.2               RColorBrewer_1.1-2          
##  [3] fpc_2.1-10                   cluster_2.0.6               
##  [5] pROC_1.9.1                   caret_6.0-73                
##  [7] ggplot2_2.2.1                lattice_0.20-35             
##  [9] randomForest_4.6-12          curatedMetagenomicData_1.1.8
## [11] magrittr_1.5                 ExperimentHub_1.0.0         
## [13] AnnotationHub_2.6.5          Biobase_2.34.0              
## [15] BiocGenerics_0.20.0          phyloseq_1.19.1             
## [17] dplyr_0.5.0                  BiocStyle_2.2.1             
##
## loaded via a namespace (and not attached):
##  [1] nlme_3.1-131                  bitops_1.0-6                 
##  [3] matrixStats_0.51.0            pbkrtest_0.4-7               
##  [5] httr_1.2.1                    prabclus_2.2-6               
##  [7] rprojroot_1.2                 tools_3.3.3                  
##  [9] backports_1.0.5               R6_2.2.0                     
## [11] vegan_2.4-2                   KernSmooth_2.23-15           
## [13] DBI_0.6-1                     lazyeval_0.2.0               
## [15] mgcv_1.8-17                   colorspace_1.3-2             
## [17] trimcluster_0.1-2             permute_0.9-4                
## [19] ade4_1.7-6                    nnet_7.3-12                  
## [21] compiler_3.3.3                curl_2.4                     
## [23] glmnet_2.0-5                  quantreg_5.29                
## [25] SparseM_1.76                  labeling_0.3                 
## [27] diptest_0.75-7                caTools_1.17.1               
## [29] scales_0.4.1                  DEoptimR_1.0-8               
## [31] robustbase_0.92-7             mvtnorm_1.0-6                
## [33] stringr_1.2.0                 digest_0.6.12                
## [35] minqa_1.2.4                   rmarkdown_1.4                
## [37] XVector_0.14.1                htmltools_0.3.5              
## [39] lme4_1.1-12                   limma_3.30.13                
## [41] RSQLite_1.1-2                 BiocInstaller_1.24.0         
## [43] shiny_1.0.1                   jsonlite_1.3                 
## [45] mclust_5.2.3                  gtools_3.5.0                 
## [47] ModelMetrics_1.1.0            car_2.1-4                    
## [49] modeltools_0.2-21             biomformat_1.2.0             
## [51] Matrix_1.2-8                  Rcpp_0.12.10                 
## [53] munsell_0.4.3                 S4Vectors_0.12.2             
## [55] ape_4.1                       stringi_1.1.3                
## [57] yaml_2.1.14                   MASS_7.3-45                  
## [59] zlibbioc_1.20.0               flexmix_2.3-13               
## [61] rhdf5_2.18.0                  gplots_3.0.1                 
## [63] plyr_1.8.4                    grid_3.3.3                   
## [65] gdata_2.17.0                  Biostrings_2.42.1            
## [67] splines_3.3.3                 multtest_2.30.0              
## [69] knitr_1.15.1                  igraph_1.0.1                 
## [71] codetools_0.2-15              stats4_3.3.3                 
## [73] evaluate_0.10                 data.table_1.10.4            
## [75] nloptr_1.0.4                  httpuv_1.3.3                 
## [77] foreach_1.4.3                 MatrixModels_0.4-1           
## [79] gtable_0.2.0                  tidyr_0.6.1                  
## [81] kernlab_0.9-25                assertthat_0.1               
## [83] mime_0.5                      xtable_1.8-2                 
## [85] metagenomeSeq_1.16.0          class_7.3-14                 
## [87] survival_2.41-3               tibble_1.3.0                 
## [89] iterators_1.0.8               AnnotationDbi_1.36.2         
## [91] memoise_1.0.0                 IRanges_2.8.2                
## [93] interactiveDisplayBase_1.12.0
{% endhighlight %}
