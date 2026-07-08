# ADR Format

Create ADRs only for decisions that are hard to reverse, surprising without context, and involve real trade-offs.

Use this structure:

```markdown
# ADR NNNN: Title

## Status

Accepted | Proposed | Superseded

## Context

What forced the decision. Include constraints and competing goals.

## Decision

What was chosen.

## Consequences

What improves, what gets worse, and what future work this implies.

## Alternatives considered

- Option: why not chosen.
```

Rules:
- Capture reasoning, not implementation walkthroughs.
- Name alternatives honestly.
- Avoid ADRs for obvious or easily reversible choices.
