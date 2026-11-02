---
name: delivery-coordination
description: Dispatch bounded tasks and coordinate review/test/correction loops under Owner controls.
---

# delivery-coordination

Read the project's AGENTS.md, CONTROL.md, applicable governance, and canonical task first. Follow Owner authority and current gates. Use project-root-relative artifact paths; update the existing task rather than creating a parallel registry. Load only relevant context. This skill is portable Markdown and requires no BMAD runtime.

Use Planner responsibility, not a new permission role. Read CONTROL, phase dependencies and current assignments. Dispatch only tasks whose prerequisites and scope allow work; include context links, allowed files, target outputs and gates. Avoid concurrent writers to the same files; agree integration boundaries before parallel work. Workers return task status, revision, evidence, findings and next action. Verify results before advancing dependencies. On failed checks route to code, plan or requirements as appropriate; honor loop limit and quota fallback. If the host cannot dispatch agents automatically, record the next assignment for manual launch rather than pretending it started.

