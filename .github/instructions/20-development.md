# Development Patterns


## Package-Specific Patterns

### Function Organization

Organized by function (e.g., cmd4.R, curatedMetagenomicData.R, mergeData.R, returnSamples.R)

### Naming Conventions

CamelCase for key functions (curatedMetagenomicData, returnSamples, mergeData).

## S4 Classes and Methods

No new exported S4 classes; returns imported (Tree)SummarizedExperiment.

## Key Dependencies

- SummarizedExperiment, TreeSummarizedExperiment
- DBI, duckdb, dplyr, tidyr, purrr
- mia

## Code Style Notes

[To be documented]
