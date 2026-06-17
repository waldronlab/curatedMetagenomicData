# Data Access Patterns

## Overview

Sample-level profiling data is served from a published cMD4 DuckDB catalog over Hive-partitioned Parquet files produced by the curatedMetagenomicDataETL pipeline. Legacy sampleMetadata object has been replaced by harmonized_meta and all_meta datasets.

## Primary Data Access Functions

### High-Level Functions

- `curatedMetagenomicData()`: Query or return resources based on study name and data type.
- `returnSamples()`: Get data for specific samples across studies.

### Low-Level Functions

[To be documented]

## Data Sources

- Default DuckDB Catalog URL: https://minio.cancerdatasci.org/cmgd-export/cmgd.duckdb

## Access Patterns

### Basic Retrieval

```R
# Search for resources
curatedMetagenomicData("AsnicarF_20.+")

# Retrieve a specific resource
curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE)
```

### Filtered Retrieval

```R
library(dplyr)
harmonized_meta |>
    filter(age_years >= 18, !is.na(bmi), body_site == "feces") |>
    returnSamples("relative_abundance", rownames = "short")
```

### Advanced Queries

[To be documented]

## Large File Handling

Hive-partitioning allows the catalog to skip files that do not match filters. Parquet's columnar layout reads only the requested features. This lets users load only samples/features of interest without downloading full studies.

## Testing with Data

- **Production data**: Accessed remotely via DuckDB.
- **Test/example data**: [To be documented]
- **Running tests**: [To be documented]
