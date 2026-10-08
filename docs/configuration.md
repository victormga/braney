# Configuration

`/configure` lists every setting with its current value.

| Command | What it does |
| --- | --- |
| `/configure <setting> <value>` | changes a setting |
| `/configure unset <setting>` | puts it back to its default |

Settings belong to the project, in its `.braney` file. Sizes can be written as `512mb` or `2g`, and
token counts as `32k`.

## Settings

| Setting | Default | What it sets |
| --- | --- | --- |
| `agent.base_url` | the server's usual address | where the model backend is, its root without `/v1` |
| `agent.api_key` | none | the key the server needs, if any |
| `agent.tool_result_limit` | 4 KB | how large a tool result can be before it's kept aside for the model to page through |
| `model.context_size` | what the server reports | the model's context window, for a server that reports it wrong |
| `web.timeout` | 30 seconds | how long a web search or page read may take |
| `web.max_bytes` | 5 MB | the most a page read may download |
| `sandbox.memory_limit` | 512 MB | memory a sandboxed script may use |
| `sandbox.timeout` | 300 seconds | how long a sandboxed script may run |
| `sandbox.disk_limit` | 10 GB | how much a sandboxed script may write |
| `mcp.timeout` | 60 seconds | how long an MCP server has to answer |
| `browser.path` | an installed browser | the browser the agent uses for pages that need one |
| `alerts.sound` | `default` | the sound Braney plays when it needs you |
| `alerts.volume` | 0.5 | how loud, from 0 to 1 |

When no browser is installed and the agent needs one, Braney offers to download one, and asks
first.

### Sounds

| Sound | |
| --- | --- |
| `off` | stay silent |
| `default` | your terminal's own bell |
| `chime` | a soft rising fourth |
| `knock` | one short percussive note |
| `rise` | a three-note rise |
| `drop` | a falling fifth |
| `pulse` | the same note twice |
| `glass` | one high ring, the one that carries through noise |

## Set elsewhere

A few things have commands of their own:

| | |
| --- | --- |
| the model | `/model`; see [Models](models.md) |
| sampling | `/sampling`; see [Models](models.md#sampling) |
| thinking | `/thinking`; see [Models](models.md#thinking) |
| permissions and yolo | `/permission`, `/yolo`; see [Safety](safety.md) |
| the shell | `/shell`; see [Safety](safety.md#reaching-outside-the-project) |
| tools | `/tools` turns any of the agent's tools on or off |
| nudges | `/nudges`; see [Nudges](nudges.md) |
| updates | `/update`; see [Getting started](getting-started.md#updates) |
| colors | `/theme` |

## Themes

`/theme` changes Braney's colors: `green` (the default), `amber`, `violet`, `amethyst`,
`lavender`, `orchid`, `indigo`, `teal` and `steel` for terminals with a dark background, and
`light` for ones with a light background.
