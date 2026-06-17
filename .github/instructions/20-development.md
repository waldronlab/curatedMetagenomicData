# Development Patterns

For complete Bioconductor and waldronlab standards, see:
- [Core Bioconductor standards](../../templates/bioconductor-development.md)
- [Waldronlab conventions](../../templates/waldronlab-standards.md)

## Package-Specific Patterns

### Function Organization

Organized by function (e.g., cmd4.R, curatedMetagenomicData.R, mergeData.R, returnSamples.R)

### Naming Conventions

CamelCase for key functions (curatedMetagenomicData, returnSamples, mergeData).

## S4 Classes and Methods

No new exported S4 classes; returns imported (Tree)SummarizedExperiment.

## Key Dependencies

- SummarizedExperiment, TreeSummarizedExperiment
- curatedCore, DBI, duckdb, dplyr, tidyr, purrr
- mia

## Code Style Notes

[To be documented]
