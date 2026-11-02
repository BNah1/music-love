---
name: verification
description: Plan and execute task verification across software stacks and record reproducible evidence.
---

# verification

Read the project's AGENTS.md, CONTROL.md, applicable governance, and canonical task first. Follow Owner authority and current gates. Use project-root-relative artifact paths; update the existing task rather than creating a parallel registry. Load only relevant context. This skill is portable Markdown and requires no BMAD runtime.

Use Tester responsibility. Map acceptance criteria to checks and identify gaps. Choose unit, integration, contract, E2E, data-quality, infrastructure or manual checks based on changed behavior. Use actual configured commands and environment; never invent passing results. Record revision, command, environment, result, concise output and artifact links in the task's tests folder. Distinguish PASS, FAIL, NOT_RUN and NOT_APPLICABLE with reasons; absent tools or credentials are limitations. For generated tests exercise observable behavior and failure cases rather than matching implementation text. Compare actual evidence to required gates; do not count NOT_RUN as PASS.

