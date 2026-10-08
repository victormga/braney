# BRANEY

<p align="center">
  <img src="assets/hero.gif" alt="The Braney logo over falling green characters">
</p>

**The agent that takes local models seriously.**

Braney is a **batteries included** agent for your terminal, built to get real work out of the model running on
your own hardware. It can read your project, edit files, run code, search the web and check its
own work, with everything it needs already in the box.

## Why Braney

Small models aren't frontier models, and Braney doesn't pretend they are. But they aren't toys
either. A 4B model on a laptop can read code, reason about it and write it. What it can't do is
survive a harness built for a model a hundred times its size.

Most coding agents are made for frontier models. They hand the model a shell, a set of flexible
tools and the full output of everything it runs, and a frontier model copes. A small one quotes a
command wrong, floods its context with a build log, calls a tool almost right, and the session
falls apart. Braney was born from watching that happen.

So Braney goes the other way: **it makes the model more capable by making it more constrained.**

- **Ambiguity is a bug.** Every tool is narrow and hard to call wrong. If a model can misuse one,
  that's Braney's bug to fix, not the model's.
- **Context is scarce.** Big results never flood the conversation; the model pages through them
  when it needs to. Side tasks go to a separate worker that comes back with a paragraph. Long
  conversations compact themselves.
- **Mistakes get caught.** When the model loops, stops halfway, or says it did something it
  didn't, Braney steps in and puts it back on track.

Small models don't need replacing. They need a push, and with one they do a lot.

No magic, though. Braney raises what a model can do, but a better model still does better work.
We validate it on [models from 2B up to 35B parameters](#tested-models), and the bigger ones get
everything here too.

<p>
  <img src="assets/example1.gif" alt="Braney answering how to compare dates in JavaScript" width="400" align="left">
  <img src="assets/example2.gif" alt="Braney reading a project's files to review its code" width="400" align="right">
  <br clear="both">
</p>

## What makes it different

### A sandbox instead of a shell

Small models struggle with shells. Bash on Linux mostly works, then come PowerShell and cmd,
different quoting rules, different flags on every OS, programs that aren't installed, sandboxes
that only half work. Each one is another way for a small model to fail.

So by default, the agent gets no shell. It gets a sandboxed JavaScript engine instead, with Node's
APIs and the npm packages it asks for, installed once you approve them. That trade wins twice:

- **It's safer.** The engine is sealed to your project folder. There's no shell running as you
  for the model to get loose in.
- **It's stronger.** Models learn to code mostly from code, and JavaScript is the most common
  language there is. A small model writes a loop over files far more reliably than it chains
  `find | xargs | sed`, and it handles real logic in a way a one-line command never will.

A script either lands or it doesn't: nothing it writes reaches your files until it finishes, so
one that fails halfway leaves your project as it was. And it behaves the same on Windows, macOS
and Linux.

When the agent does need a real program, like your test runner, you can approve that one command
as a tool, or hand it a full shell.

### Safe to leave alone

Braney asks before the agent changes anything, and yolo mode stops asking. Because the agent's
files and code stay inside the project folder, yolo is safe whenever the project is in git or in
a folder you don't mind changing: the model can't reach the rest of your computer, let alone
break it. Files git can't restore, the ones it ignores, are still asked about every time.

The exceptions are the ones you plug in yourself. A shell, approved commands and MCP servers
reach outside the project, and yolo runs those without asking too.

### Each model at its best

How a model picks its next word matters almost as much as which model it is. Publishers tune
their models for specific sampling settings, temperature, top-p, top-k and the rest, often one set
for thinking and another for plain answers, and some warn outright that the wrong ones end in
endless repetition. Small models have the least room to spare. Yet those numbers sit in a model
card few people read, quantized copies often leave them out, and a server that doesn't know them
runs the model on generic defaults.

Braney finds them for you. When you pick a model, it looks the model up on Hugging Face and reads
the recommendation from its card. When a quantized copy doesn't carry one, it follows the copy
back to the original model, and failing that, takes the defaults the model ships with. It offers
every set the publisher wrote, and remembers your choice for that model. Nothing is overridden
until you choose: until then, your server's own settings stand.

### Nudges

Small models fail in familiar ways. They repeat themselves until the context runs out, call the
same tool over and over, second-guess every step, stop halfway through with "next, I'll…", or
report work as done that never happened. Most harnesses let that play out, and you find out
later. The false "done" is the worst of them, because you believe it.

Braney watches for these while the model works, and steps in when it spots one: it tells the model
what went wrong, so it recovers instead of wasting the turn. It catches:

- repetition, in its thinking, its answer or its tool calls;
- indecision, when reasoning turns into a spiral of second thoughts;
- stopping before the work is done;
- claiming to have changed files it never touched;
- tool calls that keep failing or come out malformed;
- and more.

Each nudge can be turned off, for a model that doesn't need it.

### Batteries included

No plugin hunt. Braney ships with what a coding agent needs: file editing, search, git, web
search, browser integration, images, subagents, memories, skills, hooks, MCP, a web server to
preview what you build.

### Onboarding

A new agent shouldn't mean starting over: rewriting your rules, hunting down your skills again,
explaining the project from scratch. Whatever you built for another harness, Braney takes in.

**Skills from anywhere.** Point Braney at a skill and it imports it, along with the files it
refers to: a `SKILL.md` on disk, a folder of them, a page on the web, or a GitHub file, folder or
whole repository. Skills written for Claude Code, or any agent that uses the same format, work as
they are. You can also hand the workshop a link and let it bring the skill in.

**Your project, read for you.** Braney can set itself up from what the project already has:

- Rules written for other agents, in `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, Cursor, Windsurf and
  Copilot files. Rules become standing instructions, facts about the project become memories, and
  whatever was about the other agent itself stays behind.
- The tests, linters, type checks, formatters and builds the project declares, in `package.json`,
  a `Makefile`, `pyproject.toml`, `Cargo.toml`, `go.mod` and the like. They become approved
  commands, so the agent can safely check its own work from the first prompt.
- The skills already in the project's `.claude/skills` or `.agents/skills` folder.
- A few memories on what the project is built with, where it starts and where its tests live.

It asks before approving a command or importing a skill, and where two sources disagree, it asks
you instead of guessing.

**Another Braney project.** One project's skills, hooks, commands and memories travel to the next
as a single file.

**MCP servers.** The same `mcpServers` config every other client uses, pasted as it is.

### The workshop

Customizing an agent usually means learning its formats: where rules go, how a plugin is written,
which hook fires when. Braney's workshop does that part for you. It's a separate conversation
about the agent itself: you say what you want the agent to do differently, and the workshop works
out which piece does it and builds it with you.

| You say | You get |
| --- | --- |
| "Run the linter every time the agent edits a file" | a **hook**, JavaScript that runs when something happens |
| "Never let it touch `vendor/`" | a hook that refuses the call: a guarantee, not a request |
| "This is how we cut a release: …" | a **skill**, steps the agent follows when that task comes up |
| "Always use pnpm, never npm" | a **standing instruction**, part of every conversation |
| "Let the agent run our tests" | an **approved command**, a tool that runs exactly that and nothing else |
| "We deploy with fly.io, from main only" | a **memory**, recalled when it's relevant |

Nothing it builds is saved until you've read it and said yes, and it leaves your code alone.
Hooks are the one piece that reaches past the sandbox: they run as you, with your own programs at
hand, which is why each one goes through your hands first.

### One file per project

Everything Braney keeps about a project, its settings, conversations, memories, skills, hooks and
instructions, lives in a single `.Braney` file in the project folder. No markdown rules for an AI
scattered through your repo, mixed in with the code they're about.

One file to keep out of git, and a project's setup can still be exported for your team.

### One binary

Braney is written in Go and ships as a single executable. No Node, no Python, no virtual
environment, no dependency tree pulled onto your machine: the whole program is the file you
downloaded. Go keeps it fast and light, and it runs the same on Windows, macOS and Linux, on x64
and ARM.

## Install

**macOS and Linux**

```sh
curl -fsSL https://raw.githubusercontent.com/victormga/braney/main/scripts/install.sh | sh
```

**Windows** (PowerShell)

```powershell
irm https://raw.githubusercontent.com/victormga/braney/main/scripts/install.ps1 | iex
```

The [scripts](scripts) check the download against the release's checksums and install Braney
into a folder you own, `~/.local/bin` or `%LOCALAPPDATA%\Programs\Braney`, so it can update
itself there.

**By hand**

Download the archive for your system from
[Releases](https://github.com/victormga/braney/releases/latest) and put `Braney` on your `PATH`,
in a folder you own: Braney updates itself in place. On macOS, a browser download is quarantined;
`xattr -d com.apple.quarantine Braney` clears it.

## Supported backends

Braney runs on the model server you already use:

- [LM Studio](https://lmstudio.ai)
- [llama.cpp](https://github.com/ggml-org/llama.cpp)
- [Ollama](https://ollama.com)
- [vLLM](https://github.com/vllm-project/vllm)
- [SGLang](https://github.com/sgl-project/sglang)
- exllama, through [TabbyAPI](https://github.com/theroyallab/tabbyAPI)

Any server with an API compatible with one of these works too: pick the backend it's compatible
with. ninfer, for example, speaks llama.cpp's API, so choosing llama.cpp runs it.

Need another one? [Open a feature request](https://github.com/victormga/braney/issues/new).

**Remote servers are supported**. Point Braney to it using `/configure agent.base_url <url>`

## Tested models

Every model below works cleanly in Braney: no leaked thinking, no broken tool calls. How good the
work is still depends on the model, and grows with its size. All of them were tested with a 32k
context window, the minimum Braney needs.

| Model | Parameters | Quantization | Size |
| --- | --- | --- | --- |
| `minicpm5-2b` | 2B | Q4_K_M | 1.6 GB |
| `qwen3-4b-instruct-2507` | 4B | Q4_K_M | 2.5 GB |
| `nanbeige4.2-3b` | 3B | Q4_K_M | 2.6 GB |
| `spark-x2.5-4b` | 4B | Q4_K_M | 2.6 GB |
| `neohorse-1-4b` | 4B | Q4_K_M | 2.7 GB |
| `qwen3.5-4b` | 4B | UD-Q4_K_XL | 2.9 GB |
| `bonsai-27b` | 27B, 1-bit | Q1_0 | 3.8 GB |
| `gemma-4-e4b` | 4B effective | Q4_K_M | 5.0 GB |
| `qwen3.5-9b` | 9B | Q4_K_M | 5.7 GB |
| `gemma-4-12b` | 12B | Q4_K_M | 7.1 GB |
| `ternary-bonsai-27b` | 27B, ternary | Q2_0 | 7.2 GB |
| `qwen3.8-27b` | 27B | UD-Q4_K_M | 16.5 GB |
| `qwen3.6-27b` | 27B | Q4_K_M | 16.8 GB |
| `thinkingcap-qwen3.6-27b` | 27B | Q4_K_M | 16.8 GB |
| `gemma-4-31b` | 31B | Q4_K_M | 18.3 GB |
| `grug-35b-qat` | 35B | Q4_K_M | 21.2 GB |
| `ornith-1.5-35b` | 35B, 3B active | Q4_K_M | 21.7 GB |
| `qwen3.6-35b` | 35B, 3B active | UD-Q4_K_M | 22.1 GB |

Running one that isn't here, or one that misbehaves?
[Tell us](https://github.com/victormga/braney/issues/new), with the model, its quantization and the
backend.

## Quick start

1. Start one of the servers above, and load the model with a context window of at least 32k
   tokens. It may run with less, but that isn't tested or recommended.
2. Open a terminal in your project and run `Braney`.
3. Pick the server and the model.
4. Ask for something.

`/help` shows the rest.

## What leaves your machine

- Your prompts and code go to the model server you set, and nowhere else.
- Web searches go to DuckDuckGo, only when the agent searches.
- Anything else the agent's code reaches on the web asks you first, unless you're in yolo mode.
- When you pick a model, Braney looks up its recommended settings on Hugging Face.
- At startup, Braney asks GitHub whether there's a new version.
- Shells, approved commands and MCP servers reach whatever you set them up to reach.

Web search and the update check can both be turned off. No account, no telemetry.

## What's in the box

- Tools shaped for small models: narrow, hard to call wrong, with large results paged instead of
  dumped into the conversation.
- A sandboxed JavaScript engine with Node's APIs and npm packages, where a script's changes land
  all at once or not at all.
- Nudges that catch the model looping, stopping early or claiming work it didn't do.
- Context that looks after itself: conversations compact on their own, and subagents take noisy
  side tasks away.
- The workshop, where hooks, skills, standing instructions, approved commands and memories are
  built by talking.
- Onboarding from what you already have: other agents' rules, the project's commands, skills
  from a file or a URL, another Braney project's setup.
- A yolo mode you can trust, scoped to the project and still guarding what git can't restore.
- One `.Braney` binary file per project, instead of rules scattered through your repo.
- Web search, and a headless browser for the pages that need one.
- MCP servers, from the same config every other client uses.
- Sampling tuned to each model, found on its card and remembered per model.

## Documentation

How to use all of it is in the [docs](docs/README.md). Good places to start:

- [Getting started](docs/getting-started.md)
- [The workshop](docs/workshop.md)
- [Hooks](docs/hooks.md)
- [Safety and permissions](docs/safety.md)

## How Braney is built

Braney is made with the help of AI, but it **isn't vibe-coded**. I've been programming for 15
years, and every line of Braney was reviewed, tested and approved by me before it went in.

Codex and Claude Code helped with the safety-heavy parts and the architectural decisions, where a
mistake costs the most. Once the basics worked, Braney was mostly built with Braney, running
Qwen3.8-27B locally.

## Feedback

Braney gets better from real use on real hardware, so tell us what you run into.

- **Found a bug?** [Report it](https://github.com/victormga/braney/issues/new), with the model,
  the backend and your OS. With local models, the same request can go differently from one model
  to the next, and those three are what let us reproduce it.
- **A model keeps getting something wrong?** That's a bug too. If a model can misuse a tool,
  the tool is what should change.
- **Missing something?** [Ask for it](https://github.com/victormga/braney/issues/new): a backend,
  a tool, a nudge for a mistake your model keeps making.

Every issue here gets read.

## Source code

Braney isn't open source, at least not yet. The code is closed for now, and that may change in
the future. Until then, this repository is its home: the releases, the docs, and the issues where
it gets shaped.

The binaries are free for personal and commercial use, under the terms in [LICENSE](LICENSE).
