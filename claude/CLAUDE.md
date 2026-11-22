# Global instructions

- If a project has an `AGENTS.md` in its root and no `CLAUDE.md`, read `AGENTS.md` at the start of the session and follow it as project instructions, the same as you would a `CLAUDE.md`.

## Development Flow

### Tools and Commands

- NEVER use git stash or other commands that touch the index without asking.
- When using the Bash tool, ALWAYS give an explanation before the tool call of what will be done
  - Use Read/Write tools over Bash unless there is a specific reason for Bash
- Use `--no-tui` with NX commands
- Keep summaries short and concise unless asked for more detail

### Workflow

- When given instructions to write code, only write was explicitly asked. Wait for review and further instr$
- The developer my specify that a session is for a specific "workstream"; ALWAYS follow this workflow for w$
  - when a workstream is specified, first check for an existing workstream log (/workstreams)
  - maintain key facts, plans, open tasks and issues, and quirks in the workstream log
  - keep direct output in the session terse
  - DO NOT report content from the workstream log nor how it was changed/updated
  - the dev may update the workstream log in between commands
  - this process is a work in progress
