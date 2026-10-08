# Commands and shortcuts

Type `/` in the input box and the matching commands appear as you type. `/help` lists them all.

## Slash commands

**Conversations**

| Command | What it does |
| --- | --- |
| `/reset`, `/new` | starts a new conversation |
| `/rollback <turns>` | drops the last turns |
| `/history`, `/resume` | reopens or deletes conversations |
| `/compact` | summarizes the conversation to free the context window |
| `/context` | shows what's filling the context window |
| `/find <text>` | searches the transcript |
| `/clear` | clears the screen, and keeps the conversation |
| `/alias` | prompts you send with `#name` |

**Models**

| Command | What it does |
| --- | --- |
| `/model` | picks the server and the model |
| `/thinking <level>` | how long the model may think |
| `/sampling` | sampling settings for the current model |

**Safety**

| Command | What it does |
| --- | --- |
| `/permission` | forgets saved permission answers |
| `/yolo on`, `/yolo off` | accepts every permission without asking, or goes back to asking |
| `/tools` | turns the agent's tools on or off |
| `/shell` | gives the agent a real shell, or takes it away |
| `/nudges` | turns nudges on or off |

**Making it yours**

| Command | What it does |
| --- | --- |
| `/workshop <request>` | opens the workshop |
| `/hooks` | hook scripts |
| `/skill` | skills |
| `/prompt` | standing instructions |
| `/memory` | memories |
| `/remember <what>` | asks the agent to remember something |
| `/forget <description>` | asks the agent to forget something |
| `/command` | approved commands |
| `/mcp` | MCP servers |
| `/onboard` | sets Braney up from the project |
| `/project export`, `/project import` | shares a project's setup |

**Braney**

| Command | What it does |
| --- | --- |
| `/configure` | settings |
| `/theme` | colours |
| `/serve start <folder>`, `/serve stop` | serves a folder over HTTP, to preview a site |
| `/update` | checks for and installs updates |
| `/about` | shows the version, the author and the license |
| `/help` | lists commands, or asks the workshop a question |
| `/exit`, `/quit` | quits, or leaves the workshop |

## Shortcuts

| Key | What it does |
| --- | --- |
| `enter` | sends the prompt |
| `shift+enter` | starts a new line |
| `up` / `down` | earlier prompts |
| `esc` | stops the agent mid-turn |
| `ctrl+v` | pastes text and images |
| `ctrl+r` | starts a new conversation |
| `ctrl+l` | clears the screen |
| `ctrl+f` | searches the transcript |
| `ctrl+o` | opens or closes the last run's details |
| `shift+tab` | steps through the thinking levels |
| `F2` | opens or leaves the workshop |
| `ctrl+shift+backspace` | clears the input |
| `pgup` / `pgdown` | scrolls |
| `ctrl+c` | quits, or leaves the workshop |

## The editor

Hooks, skills, memories, instructions, approved commands and MCP configs open in Braney's editor.

| Key | What it does |
| --- | --- |
| `ctrl+s` | saves |
| `esc` | closes without saving |
| `ctrl+z` / `ctrl+y` | undo and redo |
| `ctrl+a` | selects everything |
| `ctrl+c` | copies the selection |
| `ctrl+v` | pastes |

## Command line

`braney --licenses` prints Braney's license, then those of the open-source software it is built with.
