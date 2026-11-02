# Agent Governance Rules

## Roles

Planner, Executor, Reviewer, and Tester are responsibilities, not identities. Record the actual agent/model identity as metadata when known; identity never grants permission.

## Non-negotiable behavior

- The Owner alone may set a task to `ACCEPTED`.
- `SELF_REVIEW` never satisfies Independent Review.
- SOLO does not waive mandatory Review or Testing.
- Explicit Owner fallback choices in CONTROL.md can permit labeled SELF_REVIEW; record the exception and residual review limitation. Never describe it as independent.
- One agent may hold multiple roles but cannot independently review its own execution.
- Every task has one canonical Markdown record.
- Review evidence, test evidence, and handover history are separate records.
- Handover history is append-only. Archives preserve records and evidence.
- Phase closure requires approved exit criteria and Owner approval.

## Task lifecycle

Valid statuses: `PROPOSED`, `READY`, `IN_PROGRESS`, `AWAITING_REVIEW`, `CHANGES_REQUESTED`, `BLOCKED`, `DONE`, `ACCEPTED`, `CANCELLED`, `SUPERSEDED`.

Record the reason, actor, and timestamp for every transition. `DONE` is not `ACCEPTED`.

## Normal progression and correction loop

PROPOSED → READY after scope and acceptance criteria are defined and the current approval policy is satisfied. READY → IN_PROGRESS on assignment. IN_PROGRESS → AWAITING_REVIEW when implementation is ready. Failed review/testing → CHANGES_REQUESTED → IN_PROGRESS after updating the plan. Passed required review and tests → DONE. Only Owner moves DONE → ACCEPTED.

Any active task may become BLOCKED with a reason and recorded resume status; resume there when resolved. CANCELLED and SUPERSEDED require a reason and authority under CONTROL.md; supersession links the replacement task. Retain history for all terminal states. Reopening a DONE or ACCEPTED task requires Owner direction; otherwise create a linked follow-up task.

Before each loop, re-read CONTROL.md. Check its scope and unsuccessful-loop limit. Record findings, revised plan, evidence, and next action before another agent continues.

## Handover and quota takeover

Checkpoint before delegating or ending a work unit: record exact work/revision, changed files, completed checks, pending checks, unresolved findings, and next action in the canonical task. Append outgoing/incoming identity and role, timestamp, and acknowledgement. Never erase earlier handovers.

If an agent disappears without handover, the receiver reconstructs state from the task, role files, evidence, and working tree. Record unknowns and verify incomplete work before continuing. Acknowledge takeover before editing; update affected current role files. A takeover does not retroactively invalidate independent evidence for an unchanged revision. Changes by the new executor need new review under the current fallback policy.

Return roles to IDLE when no longer assigned; preserve task and evidence links in the task history.

Live role statuses are IDLE, ASSIGNED, ACTIVE, or UNAVAILABLE. Record actor identity, task path, timestamp and intended write scope when claiming work. Peer agents check current assignments before writing; hand off conflicting files rather than edit them concurrently. Markdown assignments are coordination records, not atomic locks. Unavailable actors retain their attribution in history but do not retain an active assignment after acknowledged takeover.

## Archive

Move a task and its evidence as a bundle after closure; update inbound links and leave a location pointer at its former path rather than a second editable task. Archive a phase only after its approved exit criteria and Owner closure decision are recorded. Preserve handovers, review limitations, and tests in either archive.
