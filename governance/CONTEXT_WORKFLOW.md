# Context and Delivery Workflow

## Read progressively

Start with AGENTS.md and CONTROL.md, then your current role file and the canonical task. Read governance on first use and again when it changes. Read the active phase objective and applicable project conventions before planning. Load the task's required context and relevant skill instructions; open optional material only when the task needs it.

Search for missing context rather than scanning every file. Archives and unrelated task evidence are not loaded by default. Required repository instructions still apply even if the task manifest omits them. A context manifest is a navigation aid, not a permission boundary.

The canonical task owns its current checkpoint and context manifest. Role files point to it; do not create a second summary that duplicates task state. Use project-root-relative paths in manifest entries and label them accordingly.

## Work in bounded units

One worker invocation handles one assigned task or explicitly bounded part. The coordinating agent selects work and evaluates dependencies using the phase plan and CONTROL.md; it may hold the Planner role and introduces no new permission role. Workers return status, changed revision/files, evidence links, remaining findings, and next action. They do not select unrelated backlog work.

Small changes need a concise scope and acceptance criteria. Larger or cross-system changes may need a linked specification or architecture decision first. Use the detail needed to resolve real uncertainty.

## Review and correction

Provide the reviewer with intent, acceptance criteria, applicable rules, target revision, and relevant code. Each reviewer forms findings independently; several personas voiced by the executor are SELF_REVIEW.

Use the lenses relevant to the change: correctness, security, maintainability, and verification gaps. Multiple lenses do not require multiple agents. For each finding record location, observed consequence, supporting evidence, severity, and disposition:

- FIX: a confirmed problem in this change; resolve and verify it.
- DEFER: a pre-existing or separately scoped problem; link a follow-up. Do not defer a required acceptance criterion merely to pass the task.
- DECISION: alternatives depend on Owner intent or authority; follow CONTROL.md and record the decision.
- DISMISS: unsupported or refuted finding; record why.

If code violates a sound plan, fix code. If the plan is wrong, revise the plan. If requirements conflict or lack a material decision, resolve that requirement before continuing. Update affected evidence after changes. Apply the configured unsuccessful-loop limit.

## Checkpoint and resume

Checkpoint at completed work units, before delegation, and before ending a session when possible. Keep the checkpoint concise: current revision and dirty files, completed and pending checks, decisions, unresolved findings, failed approaches worth avoiding, and next action. Link detailed evidence instead of copying code, chat, reasoning, or terminal output.

On resume verify the checkpoint against the actual working tree and current CONTROL.md. A stale checkpoint is a hint, not evidence that checks passed. Preserve append-only history while updating the current checkpoint. Unexpected quota loss may prevent a final checkpoint; reconstruct and explicitly record uncertainty before proceeding.

## Phase completion

Compare the phase outcome with its approved exit criteria and linked task evidence. Record remaining risks and follow-ups in the phase plan. Submit the closure decision to Owner. Agent review reports do not constitute Owner acceptance.
