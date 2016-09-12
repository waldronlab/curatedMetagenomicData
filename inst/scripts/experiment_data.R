experiment_data <- function(metadata) {
    pubmed_query <- pubmed_query(metadata)
    miame_name <- miame_name(pubmed_query)
    miame_lab <- miame_lab(pubmed_query)
    miame_title <- ArticleTitle(pubmed_query)
    miame_abstract <- AbstractText(pubmed_query)
    miame_pubMedIds <- PMID(pubmed_query)
    miame_other <- miame_other(metadata)
    MIAME(name = miame_name, lab = miame_lab, title = miame_title,
          abstract = miame_abstract, pubMedIds = miame_pubMedIds,
          other = miame_other)
}
