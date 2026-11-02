# Agent Logs

English | [Tiếng Việt](README.vi.md)

This is the project’s append-only operational record.

- `current/` contains live role assignments only.
- `phases/<phase>/tasks/` contains one canonical Markdown file per task.
- `phases/<phase>/reviews/` and `tests/` contain separate evidence.
- Handover history is stored with the task or in the phase log and is append-only.
- `archive/` preserves completed task and phase records; do not delete evidence.
