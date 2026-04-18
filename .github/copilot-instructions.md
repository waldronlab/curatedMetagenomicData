# AI Coding Agent Instructions for curatedMetagenomicData

## Project Overview
**curatedMetagenomicData** is a Bioconductor R package providing standardized, curated human microbiome data. It curates metagenomic abundance data (gene families, marker presence/abundance, pathway coverage/abundance, relative abundance) processed through MetaPhlAn3 and HUMAnN3, returning data as SummarizedExperiment or TreeSummarizedExperiment objects.

## Architecture & Data Flow

### Three-Function User API
The package exports three main functions (`R/`):
1. **`curatedMetagenomicData(pattern, dryrun=TRUE, counts=FALSE, rownames="long")`** - Query & retrieve data by regex pattern against ExperimentHub resource titles
   - Returns invisibly when `dryrun=TRUE` (resource list), or a named `list` of SE/TSE objects when `FALSE`
   - Handles date selection (picks most recent resource when multiple dates exist)
   - Special handling for `relative_abundance`: can convert proportions to counts via `read_depth` multiplication

2. **`mergeData(mergeList)`** - Merge returned list elements across studies (same dataType only)
   - Returns TreeSummarizedExperiment for `relative_abundance`, SummarizedExperiment otherwise
   - Uses dplyr joins on assays/rowData; memory-intensive for many elements

3. **`returnSamples(sampleMetadata, dataType, counts, rownames)`** - Convenience wrapper: filters samples using a subset of `harmonized_meta` (or `all_meta`), retrieves resources, merges, and subsets result

### Data Structure
- **Resource Titles** (`R/sysdata.rda`): Embedded vector of all available resource names matching pattern `YYYY-MM-DD.StudyName.dataType`
- **Sample Metadata** (`data/harmonized_meta.rda`, `data/all_meta.rda`): Two user-facing data.frames for browsing/filtering. `harmonized_meta` is the schema-only release; `all_meta` adds study-specific columns still under harmonization. Both are staged copies of `curatedMetagenomicDataCuration::makeCombinedMetadata()` so the runtime package has no dependency on `curatedMetagenomicDataCuration`.
- **ExperimentHub**: Sparse matrices stored here; package queries via `ExperimentHub::ExperimentHub()` + pattern matching

#### Sparse Matrix Storage Optimization
Only `gene_families` dataType is stored as sparse matrices in ExperimentHub to reduce cloud storage footprint. Other datatypes are dense matrices. When `curatedMetagenomicData()` retrieves resources, it constructs SummarizedExperiment objects on-the-fly by wrapping these matrices with corresponding sample metadata from `colData` and feature annotations from `rowData`. This lazy-loading approach means minimal local disk space is consumed until users explicitly load data.

#### metadata.csv and resourceTitles Relationship
- **[inst/extdata/metadata.csv](inst/extdata/metadata.csv)** is the single source of truth for all available resources. Each row represents one ExperimentHub resource with columns: `Title` (resource name), `Description`, `BiocVersion`, etc.
- **resourceTitles** (embedded in `R/sysdata.rda`) is a character vector of all `Title` values extracted from metadata.csv. Used for fast in-memory pattern matching when users call `curatedMetagenomicData(pattern)`.
- **Generation pipeline**: Dated CSVs in `inst/extdata/` (one per metadata update) → combined into metadata.csv via [inst/scripts/make-metadata.R](inst/scripts/make-metadata.R) → resourceTitles regenerated from metadata.csv via [data-raw/resourceTitles.R](data-raw/resourceTitles.R).
- Tests validate consistency: [test-curatedMetagenomicData.R](tests/testthat/test-curatedMetagenomicData.R#L10-L30) asserts that all titles in metadata.csv match returned resourceTitles.

### Key Dependencies
- **SummarizedExperiment/TreeSummarizedExperiment**: S4 container classes for assay data + metadata
- **dplyr/tidyr**: Heavy use for joining assays/metadata (see NAMESPACE for 20+ imports)
- **ExperimentHub/AnnotationHub**: Cloud data access via pattern queries
- **MetaPhlan3/HUMAnN3**: External tools that preprocessed the data (not in package)

## Developer Workflows

### Test Execution
Run tests with `R CMD check` or in R console:
```R
devtools::test()  # or testthat::test_dir("tests/testthat")
```
Key test files:
- [tests/testthat/test-curatedMetagenomicData.R](tests/testthat/test-curatedMetagenomicData.R): Tests pattern matching, resource existence, return types
- [tests/testthat/test-mergeData.R](tests/testthat/test-mergeData.R): Tests merging logic
- Asserts against [inst/extdata/metadata.csv](inst/extdata/metadata.csv) (single source of truth)

### Data Update Workflow
When adding new studies (uncommon):
1. **Generate metadata CSV**: [inst/scripts/make-metadata.R](inst/scripts/make-metadata.R) - Combines dated CSVs in `inst/extdata/` into single metadata.csv
2. **Update sample metadata**: [data-raw/harmonized_meta.R](data-raw/harmonized_meta.R) - Reads staged copies from `inst/extdata/{harmonized_meta,all_meta}.csv` (regenerated upstream from `curatedMetagenomicDataCuration::makeCombinedMetadata()`), saves as `data/harmonized_meta.rda` and `data/all_meta.rda`
3. **Regenerate resource titles**: [data-raw/resourceTitles.R](data-raw/resourceTitles.R) - Extracts from metadata.csv, saved to sysdata.rda
4. **Rebuild documentation**: Run `roxygen2::roxygenise()` to regenerate NAMESPACE & .Rd files

### Documentation
- **Roxygen2** driven: Exported functions have `@export` tags; examples use `@examples` (code-checked on build)
- **README.Rmd** → **README.md** via rmarkdown (edit .Rmd, not .md)
- **Vignettes** in `vignettes/`: Main tutorial + 3 article vignettes (see articles/ folder for available studies docs)
- **Suggests in vignettes**: Wrap code that requires optional Suggests packages in conditional blocks using `eval = require("package", quietly = TRUE)` to allow vignette building in environments where those packages aren't installed. See [curatedMetagenomicData.Rmd](vignettes/curatedMetagenomicData.Rmd) for examples with OmicsMLRepoR and lefser.

## Code Patterns & Conventions

### S4 Methods & Pipes
- Package uses native `|>` pipe heavily (not `%>%`)
- Extractors: `assay(se)`, `colData(se)`, `rowData(se)`, `assayNames(se)` from SummarizedExperiment
- TreeSummarizedExperiment adds `rowLinks()` for phylogenetic tree access

### Data Type Handling
- Six datatypes enforced: `gene_families`, `marker_abundance`, `marker_presence`, `pathway_abundance`, `pathway_coverage`, `relative_abundance`
- `relative_abundance` special: stored sparse in ExperimentHub, can use rownames as `"long"` (full taxonomy), `"short"` (species), or `"NCBI"` (ID)
- **Count conversion**: `relative_abundance × read_depth` → rounded integer counts

### Regex Patterns for Resource Queries
- Users query via regex against titles like `"AsnicarF_20.+"` to get all AsnicarF studies; `"HMP_2012.marker_presence"` for specifics
- Pattern matching happens in-memory against resourceTitles vector

### Error Handling
- Explicit `stop()` calls for missing pattern, non-existent resources; no silent failures
- Test coverage validates error conditions (see test-curatedMetagenomicData.R line 1-6)

## Integration Points

### External: ExperimentHub Service
- Queries ExperimentHub for actual data files; connection required
- Local caching handled by ExperimentHub (users rarely see this)

### Internal: curatedMetagenomicDataCuration Package
- Required only for refreshing the staged `inst/extdata/harmonized_meta.csv` and `inst/extdata/all_meta.csv` files (upstream of the data-raw step). The runtime package itself does not depend on it.
- Contains curated source .tsv files; not needed for users

## Common Tasks

- **Add new test**: Place in [tests/testthat/](tests/testthat/) following `test_that("description", {expect_*(...)})`  pattern
- **Update function docs**: Edit roxygen comments in [R/*.R](R/) files, run `roxygen2::roxygenise()`
- **Fix typo in vignette**: Edit [vignettes/](vignettes/) .Rmd directly
- **Debug data merging**: Check [R/mergeData.R](R/mergeData.R) ~line 50-100 for join logic; test with small subset of `harmonized_meta`
