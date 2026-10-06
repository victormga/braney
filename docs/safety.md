# Safety and permissions

## Permissions

Braney asks before the agent does anything that changes your files or reaches beyond them: changing,
moving or deleting a file, installing a package, sending a request to the web, running a command,
or calling an MCP server's tool.

You can allow it once, allow it always, or decline. An "always" is remembered for the project.

| Command | What it does |
| --- | --- |
| `/permission remove` | forgets one saved answer |
| `/permission reset` | forgets all of them |

## Yolo

`/yolo on` accepts every permission without asking, and `/yolo off` goes back to asking.

Yolo doesn't widen what the agent can reach. Its files and code stay inside the project folder, the
same as without it, so with the project in git, or in a folder you don't mind changing, nothing it
does is beyond undoing. One thing is still asked every time: changing, moving or deleting a file git
ignores, since git couldn't bring it back.

The exceptions are what you plug in yourself. A shell, approved commands and MCP servers reach
outside the project, and yolo runs those without asking too.

## The sandbox

The agent works on your project through its own tools, and through JavaScript it writes and runs in
a sandbox:

- It reaches only the project folder.
- It has Node's APIs under Node's names: files, network, cryptography, encoding, dates and
  locales.
- It can use npm packages, installed the first time it needs one, once you approve.
- It can't start other programs.
- A script's changes land all at once when it finishes. A script that fails halfway leaves your
  files as they were.

How much memory, time and disk space a script may use are settings; see
[Configuration](configuration.md).

## Reaching outside the project

When the agent needs more than the sandbox, you decide how much more:

- **[Approved commands](approved-commands.md)** let it run one specific program, like your test
  runner, and nothing else. This is the safe way to give it your tools.
- **A shell** gives it a real shell through an interpreter you name. It's off by default, and not
  recommended: small models struggle with shells, and a shell runs as you, with no limits.

  ```
  /shell enable bash
  /shell disable
  ```

- **[MCP servers](mcp.md)** give it tools from other programs, each one asked the first time it's
  called.
- **[Hooks](hooks.md)** run as you. They're written by you or with you, and each one is saved only
  once you've read it.

## The workshop

Inside the [workshop](workshop.md), every permission is asked, even with yolo on, and an answer
covers only that one call.

## What leaves your machine

- Your prompts and code go to the model server you set, and nowhere else.
- Web searches go to DuckDuckGo, only when the agent searches.
- Anything else the agent's code reaches on the web asks you first, unless you're in yolo mode.
- When you pick a model, braney looks up its recommended settings on Hugging Face.
- At startup, braney asks GitHub whether there's a new version. `/update off` stops that.
- Shells, approved commands and MCP servers reach whatever you set them up to reach.

No account, no telemetry.
