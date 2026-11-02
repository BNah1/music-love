# Workflow Modes

## SOLO

One agent may plan, execute, review as `SELF_REVIEW`, and test. Required Independent Review, Testing, and Owner acceptance remain required.

## Peer-agent

Agents use the same plans and logs. Keep scopes distinct. A Reviewer must be independent of the Executor for the task under review.

## Sub-agent

The parent assigns a bounded task, allowed scope, expected evidence, and return format. The sub-agent cannot broaden scope, claim Owner approval, or replace the parent’s integration and handover.

## Dynamic switching

Owner selects the initial mode and may change it through CONTROL.md. Availability changes and quota fallback follow that file. On takeover, record the previous mode, new staffing, agent identity, affected task revision, and applicable review exception. Preserve separate execution/review/test evidence even when one agent performs several roles.
