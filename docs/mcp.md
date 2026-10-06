# MCP servers

An MCP server gives the agent tools from another program: your issue tracker, a database, a
browser. Braney reads the same `mcpServers` config every other client uses, so the snippet in a
server's README works as it stands.

## Adding a server

`/mcp add` opens the editor. Paste the config:

```json
{
	"mcpServers": {
		"jira": {
			"command": "uvx",
			"args": ["mcp-atlassian"],
			"env": {
				"JIRA_URL": "https://acme.atlassian.net",
				"JIRA_API_TOKEN": "${JIRA_API_TOKEN}"
			}
		}
	}
}
```

`${VAR}` is read from your environment when the server starts, so a token stays where you keep it
rather than in braney. A literal value works too.

A remote server takes a `url` instead of a `command`, with `headers` for its authentication. OAuth
isn't supported yet.

One config can add several servers. Fields braney doesn't use, like another client's settings, are
kept as you wrote them.

## Using its tools

Every tool a server offers becomes one of the agent's tools, named `mcp_<server>__<tool>`. They're
all on when you add the server, and braney tells you how much of the context window their
descriptions take. `/tools` turns any of them off, which keeps a small context window from filling
up with tools you don't need.

Calling a tool asks you the first time, and your answer is remembered for that tool. Braney asks
regardless of what the server says about the tool.

## Managing servers

| Command | What it does |
| --- | --- |
| `/mcp add` | adds servers from a config |
| `/mcp open` | opens a server's config to change it |
| `/mcp refresh` | asks a server what it offers now, after it changed |
| `/mcp remove` | removes a server |

A server's name is a label and the prefix of its tools. Renaming it in the editor renames the
server, and two servers can't share a name.

Braney doesn't contact a server on its own. If one couldn't be reached when you added it, it has
no tools until you refresh it, and braney says so at startup, naming the missing variable when
that's the reason.

`mcp.timeout` sets how long a server has to answer; see [Configuration](configuration.md).
