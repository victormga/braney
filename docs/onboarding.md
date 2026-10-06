# Onboarding

A new agent shouldn't mean starting over. Braney takes in what you already have: the rules you wrote
for other agents, your project's commands, your skills, and other braney projects' setups.

## Setting up from your project

`/onboard` reads the project and sets braney up from it:

- **Rules written for other agents**, in `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursorrules`,
  `.cursor/rules/`, `.windsurfrules` and `.github/copilot-instructions.md`, and the `AGENTS.md`
  and `CLAUDE.md` files in subfolders. Rules become [standing instructions](instructions.md), facts about the project become
  [memories](memory.md), and whatever was about the other agent itself stays behind.
- **The project's own commands**: the tests, linters, type checks, formatters and builds declared
  in `package.json`, a `Makefile` or `Justfile`, `pyproject.toml`, `composer.json`, `Cargo.toml`
  or `go.mod`. They become [approved commands](approved-commands.md), so the agent can check its
  own work. Dev servers, watchers and deploys are left out.
- **Skills** in the project's `.claude/skills/` or `.agents/skills/` folder.
- **A few memories** on what the project is built with, where it starts and where its tests live.

It asks before approving a command or importing a skill. When it's done, it lists what it set up,
and asks you about anything it was unsure of, like two files that disagree.

## Importing skills

`/skill import` brings in skills from a file, a folder, a web page, or a GitHub file, folder or
repository. See [Skills](skills.md#importing-skills).

## Share a setup

`/project export` writes the project's instructions, memories, skills, hooks, approved commands and
MCP servers to one file, `.brn` in the project folder by default. Commit it, and your team brings
it into their own braney with `/project import`.

Both take an optional path. Before an import, braney shows what's in the file:

- Hooks arrive turned off. Read them with `/hooks open` before turning them on.
- MCP servers are listed with what they run.
- The file's instructions replace yours, which stay in `/prompt history`.

An MCP config travels as written, so a key typed into it, rather than read from a `${VAR}`, goes
into the file. Braney warns you before exporting one.
