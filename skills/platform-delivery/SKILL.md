---
name: platform-delivery
description: Plan and verify server, backend, mobile, web, data and CI/CD changes using project-specific rules.
---

# platform-delivery

Read the project's AGENTS.md, CONTROL.md, applicable governance, and canonical task first. Follow Owner authority and current gates. Use project-root-relative artifact paths; update the existing task rather than creating a parallel registry. Load only relevant context. This skill is portable Markdown and requires no BMAD runtime.

Read only relevant handle_rules modules and task context. For APIs inspect contracts and compatibility; for web/mobile inspect UI states and platform constraints; for data inspect schemas, lineage, validation and rerun behavior; for servers and CI/CD inspect environment, deployment, observability and rollback. Prefer dry runs or local verification before authorized external execution. Separate code completion from deployment completion. Record exact environment and evidence; identify tests that could not run. Production or external actions require the authority configured in CONTROL and project rules; AUTO alone is not blanket permission.

