---
name: independent-review
description: Review a specified change against intent using evidence and relevant review lenses.
---

# independent-review

Read the project's AGENTS.md, CONTROL.md, applicable governance, and canonical task first. Follow Owner authority and current gates. Use project-root-relative artifact paths; update the existing task rather than creating a parallel registry. Load only relevant context. This skill is portable Markdown and requires no BMAD runtime.

Record Reviewer identity, executor identity, exact revision/dirty-file scope and independence. Read intent plus applicable rules and actual source; do not rely on the executor summary as proof. Choose correctness, security, architecture or verification lenses as relevant. Verify claimed consequences beyond changed lines. Record all findings with stable IDs; group true duplicates while preserving provenance. Triage FIX, DEFER, DECISION or DISMISS with reasons using CONTEXT_WORKFLOW. A review request alone does not authorize editing implementation. After fixes inspect affected behavior and evidence again. Self-review remains labeled SELF_REVIEW; never invent another reviewer.

