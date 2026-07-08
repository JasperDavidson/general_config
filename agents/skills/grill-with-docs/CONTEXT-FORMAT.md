# CONTEXT.md Format

Use `CONTEXT.md` as glossary only. No implementation details, decisions, task notes, or specs.

Recommended structure:

```markdown
# Context

## Glossary

### Term

Definition in domain language. Include boundaries and contrast with nearby terms when useful.
```

Rules:
- One canonical term per heading.
- Define what term means in business/domain language.
- Mention aliases only to redirect to canonical term.
- If term conflicts with code or user language, ask before writing.
- Keep entries short and stable.
