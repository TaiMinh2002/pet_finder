# Pet Finder Codex Instructions

## Required reading

Before implementing any task in this repository, always read:

1. `rule.md` — project rules, coding conventions, architecture rules, UI rules, naming conventions, and restrictions.
2. `plan.md` — implementation roadmap and current development plan.

## Working rules

- Follow `rule.md` strictly.
- Use `plan.md` as the implementation source of truth.
- Do not invent features outside `plan.md`.
- Do not change architecture unless explicitly allowed by `rule.md`.
- Do not implement multiple phases at once.
- Before editing code, summarize the relevant section from `plan.md` and `rule.md`.
- Before editing code, list the files that will be created or modified.
- After editing code, run:
  - `dart format .`
  - `flutter analyze`
- Fix only issues related to files changed in the current task.

## Flutter UI implementation rules

- Use reusable widgets.
- Do not hardcode repeated colors, text styles, spacing, radius, or shadows.
- Use the app theme/design system.
- Use mock data until backend integration is explicitly requested.
- Keep UI close to the Pencil design.