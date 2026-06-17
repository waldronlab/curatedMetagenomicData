# curatedMetagenomicData Overview

## Classification
- **Type**: Data Package
- **Version**: 4.0.1

## Purpose

Provides standardized, curated microbiome data for novel analyses. Starting with version 4 ("cMD4"), sample-level profiling data is served from a published DuckDB catalog over Hive-partitioned Parquet files produced by the curatedMetagenomicDataETL pipeline.

## Key Functions

- **Data Access Functions**:
  - `curatedMetagenomicData()`: Main high-level data retrieval function.
  - `returnSamples()`: Assemble datasets across studies on demand.
- **Data Processing Functions**:
  - `mergeData()`: Merge multiple (Tree)SummarizedExperiment objects.

## Quick Start

```R
library(curatedMetagenomicData)
# Retrieve relative abundance for AsnicarF_2017
curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE, rownames = "short")
```

## Key Concepts

- Hive-partitioned Parquet files: Organizing dataset across many files by encoding column values into the directory path itself, allowing skipping files that do not match sample-side filters.
- DuckDB: Coordinates querying the remote parquet files.
- (Tree)SummarizedExperiment: Object returned for sample data and metadata.

## Data Sources

- Remote Parquet files accessed through DuckDB.
- Included metadata: harmonized_meta and all_meta.
