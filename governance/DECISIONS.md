# Decisions

## DEC-0001: Single Skill for New and Existing Projects

Use one skill instead of splitting new project initialization and existing project upgrades.

Reason:

- The same README, assets, graphify, AGENTS, and CLAUDE rules apply to both paths.
- Split skills would drift and increase maintenance cost.

## DEC-0002: Keep omni-platform as Bundled Template

Store the current mother template under `assets/templates/omni-platform/`.

Reason:

- New project creation should copy a known-good baseline instead of reconstructing from memory.
- Template sync can be handled explicitly with `scripts/sync-omni-template.sh`.

## DEC-0003: Non-Invasive Existing Project Upgrade

Default old project upgrades must not change source structure, business naming, build tools, or technology stack.

Reason:

- Existing projects often carry historical constraints.
- The skill's goal is AI handoff enablement, not business refactoring.

