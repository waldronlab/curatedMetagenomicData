# Testing and Documentation


## Development and Checking Commands

```bash
# Build and check
R CMD build .
R CMD check curatedMetagenomicData_*.tar.gz

# Documentation
R -e "roxygen2::roxygenize()"

# Tests
R -e "devtools::test()"
```

## Package-Specific Considerations

Requires internet connection for full data access tests due to DuckDB catalog.

## Package-Specific Testing

### Test Organization

Tests are organized under tests/testthat/ with standard testthat conventions.

### Test Data

- **Location**: No inst/extdata/ found, uses sysdata.rda and remote DuckDB resources.
- **File types**: [To be documented]
- **Purpose**: [To be documented]

### Remote Data Testing

Tests queries against the remote cMD4 DuckDB catalog.

### Running Tests

```bash
R -e "devtools::test()"
```

## Package-Specific Documentation Patterns

### Function Categories

Functions are documented using roxygen2.

### Common Parameters

- dryrun: TRUE to list resources, FALSE to return them.
- rownames: Specifies type of rownames ("long", "short", "NCBI").
- counts: TRUE to multiply relative abundance by read depth.

## Common Testing Patterns

[To be documented]
