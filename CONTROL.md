# Owner Control Panel

Edit this file to change how agents work. Agents re-read it before assigning work, modifying files, advancing a task, or starting another loop. Changes apply prospectively; record the applied settings in the task history.

| Setting | Current value | Choices |
|---|---|---|
| Execution mode | SOLO | SOLO / PEER / SUBAGENT |
| Autonomy | PHASE | CONFIRM / PHASE / AUTO |
| Run state | RUN | RUN / PAUSE |
| Scope | phase-00 / framework adoption | Task IDs, phase, or explicit scope |
| Available agents | codex: Planner, Executor, Reviewer, Tester | Agent identities and available roles |
| Quota fallback | TAKEOVER | TAKEOVER / PAUSE |
| Review after fallback | REQUIRE_INDEPENDENT | REQUIRE_INDEPENDENT / ALLOW_SELF_REVIEW |
| Consecutive unsuccessful loops | 3 | Owner-adjustable limit |
| External actions | ASK | ASK / explicit listed environments and actions below |

Authorized external environments/actions: `None configured`. Record any delegated authority here; AUTO is limited to the approved scope and does not itself authorize production changes, deployments, messages or publication.

## What the settings mean

- CONFIRM: ask before starting a plan and before implementing it. Review, tests, and corrections stay within the approved scope.
- PHASE: Owner approves the phase scope and exit criteria; agents execute its tasks and verification without per-task confirmation.
- AUTO: agents plan, implement, review, test, and advance within the configured scope. Scope expansion still needs Owner direction.
- PAUSE: do not start further work; record current state and any unfinished operation.
- TAKEOVER: an available agent resumes the interrupted work from logs. It may hold several roles. Do not wait for quota recovery.
- REQUIRE_INDEPENDENT: takeover can continue implementation and testing, but dependent progression waits for an independent review when required.
- ALLOW_SELF_REVIEW: Owner explicitly permits continuation with a labeled SELF_REVIEW after fallback. This is a recorded exception, never Independent Review. Testing remains required.

Owner alone sets ACCEPTED and approves phase closure in every mode. AUTO may advance dependent tasks after their configured review/test gates pass, before final Owner acceptance, unless a task explicitly requires acceptance first. A phase stays open pending Owner closure.

Agents cannot edit these control choices to grant themselves authority. After the unsuccessful-loop limit, record findings and request direction rather than repeating the same attempt. Settings do not grant access to unavailable tools, accounts, or resources.
