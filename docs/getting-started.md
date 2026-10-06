# Getting started

## Install

**macOS and Linux**

```sh
curl -fsSL https://raw.githubusercontent.com/victormga/braney/main/scripts/install.sh | sh
```

**Windows** (PowerShell)

```powershell
irm https://raw.githubusercontent.com/victormga/braney/main/scripts/install.ps1 | iex
```

The script downloads the latest release for your system, checks it against the release's
checksums, and installs braney into a folder you own:

| System | Folder |
| --- | --- |
| macOS, Linux | `~/.local/bin` |
| Windows | `%LOCALAPPDATA%\Programs\braney` |

On Windows, the folder is added to your `PATH`. On macOS and Linux, the script tells you how to add
it if it isn't there yet.

### By hand

Download the archive for your system from
[Releases](https://github.com/victormga/braney/releases/latest) and put `braney` (`braney.exe` on
Windows) in a folder on your `PATH`. Pick a folder you own: braney updates itself in place, so a
folder that needs `sudo` or an administrator, like `/usr/local/bin` or `Program Files`, keeps it
from updating.

On macOS, a file downloaded with a browser is quarantined. Clear it with:

```sh
xattr -d com.apple.quarantine braney
```

## Connect to a model server

Braney works with the model server you already run. Start one with a model available:

| Server | Looked for at |
| --- | --- |
| [LM Studio](https://lmstudio.ai) | `http://localhost:1234` |
| [llama.cpp](https://github.com/ggml-org/llama.cpp) | `http://localhost:8080` |
| [Ollama](https://ollama.com) | `http://localhost:11434` |
| [vLLM](https://github.com/vllm-project/vllm) | `http://localhost:8000` |
| [SGLang](https://github.com/sgl-project/sglang) | `http://localhost:30000` |
| exllama, through [TabbyAPI](https://github.com/theroyallab/tabbyAPI) | `http://localhost:5000` |

A server with an API compatible with one of these works too: pick the one it's compatible with.

**Remote servers are supported**. Point braney to it using `/configure agent.base_url <url>`

## First run

Open a terminal in your project folder and run:

```sh
braney
```

If your server runs somewhere other than its usual address, on another port or another machine,
point braney at it first. Give the server's root, without `/v1`:

```
/configure agent.base_url http://192.168.1.20:8080
```

If it needs a key, set that too with `/configure agent.api_key <key>`.

Then pick the server and the model with `/model`. The first time you pick a model, braney offers
the sampling settings its publisher recommends; see [Models](models.md#sampling).

Now type what you want done, and press `enter`.

## The .braney file

Braney keeps everything about a project in one `.braney` binary file, in the folder you start it from:
its settings, the model you picked, conversations, memories, skills, hooks, instructions, approved
commands and permissions. Each project has its own, so what you set up in one doesn't carry over to
another.

Add `.braney` to your `.gitignore`: it holds your conversations, and can hold an API key. To share
a project's setup with your team, [export it](onboarding.md#share-a-setup) instead.

Deleting `.braney` starts the project over from scratch.

## Coming from another agent

`/onboard` reads what your project already has, like `AGENTS.md` or `CLAUDE.md`, its test and
build commands, and its skills, and sets braney up from it. See [Onboarding](onboarding.md).

## Updates

Braney checks for a new version every time it starts, and asks before installing it. `/update`
changes that:

| Command | What it does |
| --- | --- |
| `/update ask` | asks before installing a new version (the default) |
| `/update auto` | installs new versions without asking |
| `/update off` | stops checking at startup |
| `/update check` | checks right now |

While an update downloads, braney shows its progress; `esc` or `ctrl+c` cancels it and carries on
with the version you have. Once it's installed, braney restarts into the new version and reopens
your conversation.

## Uninstall

Delete braney from the folder it was installed in, and the `.braney` file from your projects. On
Windows, also remove `%LOCALAPPDATA%\Programs\braney` from your user `PATH`.
