# 0001. Adopt CMD v4 schema and uncurated metadata pattern

- **Status:** Accepted
- **Date:** 2026-06-17
- **Deciders:** Levi Waldron, Sean Davis, Sehyun Oh, cMD/pMD Team

## Context

The metadata schemas of `curatedMetagenomicData` (cMD) and `parkinsonsMetagenomicData` (pMD) have diverged. cMD v4.0.0 represents a significant cleanup and improvement over v3.x, featuring rigorous ontology integration (EFO, NCIT, UBERON) via OLS, explicit unit specifications, and clean field naming conventions. 

However, original study metadata often contains valuable condition-specific information that is not present in the core schema. The fear of losing valuable dataset-specific data leads to schema explosion, as curators expand the central schema to accommodate data found only in a single dataset. Uncurated data is valuable because it can always be transformed by a user script later.

Additionally, to balance universal requirements with project-specific flexibility without creating schema fragmentation, a robust schema architecture is needed.

## Decision

We will use the CMD v4.0.0 schema as the foundation for the project. This means cMD v4.0.0's schema structure will be the base for standardizing metadata, gaining its ontology-backed validation.

We will also adopt pMD's "uncurated metadata" pattern. Both cMD and pMD will support a dual-layer metadata architecture:
- **Layer 1 (Curated)**: Validated against the unified schema.
- **Layer 2 (Uncurated)**: Original study fields preserved with an `uncurated_*` prefix.

To organize this, the metadata dictionary will be structured into a four-tier architecture:
1. **Universal Core**: Required for ALL projects (e.g., `study_name`, `sample_id`, `age`).
2. **Extended Common**: Optional shared fields (e.g., `disease`, `country`).
3. **Project-Specific**: Tagged with `project.scope` (e.g., clinical intervention fields for cMD).
4. **Uncurated**: Preserved as-is from original studies, no validation applied.

## Alternatives considered

- **Option A** — Force all data into a single, massive schema. We rejected this because it leads to schema explosion and makes the schema unwieldy and hard to maintain.
- **Option B** — Discard original study fields not present in the curated schema. We rejected this because it destroys valuable, dataset-specific information that users might need for custom analyses.

## Consequences

- **Easier:** Curators no longer need to debate whether a niche field should be added to the core schema; it can simply remain as an `uncurated_*` field.
- **Easier:** Cross-study analyses are enabled by the controlled vocabularies and unified core/common fields.
- **Harder:** Users looking for niche variables will have to parse `uncurated_*` fields themselves using custom scripts.
- **Follow-up work:** We need to adapt the data ingestion process to preserve uncurated metadata and format it with the `uncurated_*` prefix.

## References

- [curatedMetagenomicData.wiki/UNIFICATION_DECISIONS.md](https://github.com/waldronlab/curatedMetagenomicData/wiki/UNIFICATION_DECISIONS)
- [curatedMetagenomicData.wiki/UNIFICATION_PLAN.md](https://github.com/waldronlab/curatedMetagenomicData/wiki/UNIFICATION_PLAN)
