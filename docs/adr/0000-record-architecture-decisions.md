# 0000. Record architecture decisions

- **Status:** Accepted
- **Date:** 2026-06-03
- **Deciders:** Sean Davis

## Context

This pipeline has accumulated a number of significant, non-obvious decisions —
why HUMAnN is disabled, why a single container image is used, why outputs are
laid out the way they are. Until now these lived in GitHub issue threads, pull
request discussions, and terse config comments. That makes them hard to find,
easy to lose when an issue is closed, and impossible to grep. New contributors
(human or agent) repeatedly re-derive or, worse, unknowingly contradict earlier
reasoning.

## Decision

We will record architecturally significant decisions as **Architecture Decision
Records (ADRs)** stored in `docs/adr/`, using a lightweight Nygard-style format
(context / decision / alternatives / consequences). The process and index live
in `docs/adr/README.md`. ADRs are immutable once accepted; a changed decision is
captured by a new ADR that supersedes the old one.

## Alternatives considered

- **Keep decisions in issues/PRs** — the status quo. Rejected: not discoverable,
  not versioned with the code, and lost when issues are closed or repos move.
- **A single `DECISIONS.md` log** — simpler, but grows into an unsearchable wall
  of text and offers no stable per-decision anchor to link to.
- **A heavier ADR tool (MADR + tooling)** — more structure than a small project
  needs right now; the format can grow later if warranted.

## Consequences

- Each substantive decision gets a durable, linkable home that travels with the
  code and shows up in `git blame`/`grep`.
- Small added ceremony: contributors must spend a few minutes writing an ADR for
  significant changes. This is intentional friction, scoped to decisions that
  are hard to reverse or non-obvious.
- The existing body of decisions is being seeded retroactively (ADRs 0001–0007),
  including historical ones that still shape current work.

## References

- Michael Nygard, "Documenting Architecture Decisions" (2011).
- `docs/adr/README.md` for the process and index.
