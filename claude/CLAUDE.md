# Global instructions

- Write to me 80% of the way to ASD-STE100 (Simplified Technical English, the plain English used in aircraft manuals)
- If a project has an `AGENTS.md` in its root and no `CLAUDE.md`, read `AGENTS.md` at the start of the session and follow it as project instructions, the same as you would a `CLAUDE.md`.

## Development Flow

### Tools and Commands

- NEVER use git stash or other commands that touch the index without asking.
- When using the Bash tool, ALWAYS give an explanation before the tool call of what will be done
  - Use Read/Write tools over Bash unless there is a specific reason for Bash
- Use `--no-tui` with NX commands
- Keep summaries short and concise unless asked for more detail

### Workflow

- When given instructions to write code, only write was explicitly asked. Wait for review and further instructions

#### Workstreams

The developer my specify that a session is for a specific "workstream"; ALWAYS follow this workflow for workstreams
- when a workstream is specified, first check for an existing workstream log (/workstreams)
  - maintain goals/requirements, design alternatives, context, plans, open tasks and issues and quirks in the workstream log
  - keep direct output in the session terse
  - DO NOT report content from the workstream log nor how it was changed/updated
  - the dev may update the workstream log in between commands; always Read the log in full immediately before every edit
  - log entries are short summaries; put detail in a PoC branch or a repo file
  - after an answer is logged, the chat reply is one line
- PoCs
  - each PoC lives on its own branch
  - the log has one section per PoC with the same four parts: Approach (with branch link), Result, Learned, Gaps
  - do not verify a PoC (tests, builds, browser) unless asked
- Style
  - structure content in ordered lists with short statements
  - nest additional information for each point in nested list items
  - use tables and Mermaid diagrams to organize content and illustrate concepts
  - link to existing documentation or files in the repo where relevant
  - link each design option to the PoC section that tests it
  - mark open questions `[ ]` and answered ones `[x]`; nest the answer or a link under the item
- retain only the most relevant details in the log; revise existing content as needed
- this process is a work in progress
