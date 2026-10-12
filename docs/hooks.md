# Hooks

A hook is a JavaScript script that runs when something happens in the agent's conversation: a
prompt is sent, a tool is about to run, a turn ends. Some hooks watch and react, like running your
linter after an edit. Others decide, like refusing a tool call or answering a permission for you.

A skill or an instruction is advice the agent may or may not follow. A hook is code that runs every
time, so when you need a guarantee, write a hook.

The easiest way to get one is to describe it in the [workshop](workshop.md). To write one yourself:

| Command | What it does |
| --- | --- |
| `/hooks add <name>` | writes a new hook in the editor |
| `/hooks open` | opens one to read or change it |
| `/hooks remove` | deletes one |
| `/hooks enable` | turns one on or off, or `All` or `None` at once |

A hook takes effect from the next prompt after it's saved.

## Writing a hook

A script registers handlers for events with `braney.on(event, handler)`. A handler gets one
argument, the subject, which describes what happened. Handlers may be `async`.

```js
braney.on("turn:after", (turn) => {
	console.log(`the turn took ${turn.ms}ms`)
})
```

`console.log` shows its output in your conversation, one message per call with its line breaks
kept, and so do `console.table` and the rest of `console`. `braney.off(event, handler)` removes a
handler, given the same function.

Scripts run in the order their names sort, so name them to sort where they belong, like
`10-guard.js` and `20-lint.js`. All of them share one `globalThis`.

Every script loads fresh for each prompt, `/compact`, model pick and reopened conversation, and
nothing in a variable lasts from one to the next. Keep
what has to last in `localStorage`, which works as it does in a browser: strings in and out, up to
5 MB per project. Setup that depends on another script belongs in a `braney.on("ready", cb)` handler.

## Events that watch

These handlers read the subject; they can't change what Braney does.

| Event | When | Subject |
| --- | --- | --- |
| `ready` | every script has loaded | none |
| `session` | a conversation starts, on its first prompt | `resumed` |
| `turn:before` | you sent a prompt (steers excluded) | `prompt`, `isSubAgent` |
| `turn:after` | a turn ended, answered or failed, but not stopped | `prompt`, `answer`, `error`, `ms`, `rounds`, `inputTokens`, `outputTokens`, `contextUsed`, `contextSize`, `isSubAgent` |
| `reply` | the model answered, once per step, before that step's tools run | `text`, `thinking`, `isSubAgent` |
| `tool:after` | a tool call finished running | `tool`, `args`, `result`, `error`, `isSubAgent` |
| `model` | a model was loaded | `backend`, `id`, `contextSize`, `vision`, `probed` |
| `compact:before` | the conversation is about to be summarized | `automatic`, `contextUsed`, `isSubAgent` |
| `compact:after` | it was summarized | `automatic`, `contextUsed`, `reclaimed`, `error`, `ms`, `isSubAgent` |

- `contextUsed` is how many tokens of the context window, `contextSize`, the conversation takes up.
- `rounds` is how many times the model was called during the turn, subagents included.
- `inputTokens` and `outputTokens` are the tokens the model read and wrote over those calls. Each
  call reads the whole conversation, so `inputTokens` grows with every round. Both are 0 when your
  backend doesn't report token usage.
- `isSubAgent` is true when a subagent, a helper the agent started, is the one working. Its
  `turn:after` reports the totals of the turn it belongs to, up to that point.
- `resumed` is true when you reopened a saved conversation.
- `automatic` is true when the context window filled on its own, rather than you asking.
- `reclaimed` is how many tokens the summary freed: 0 when it failed, below 0 when it cost more
  than it saved.
- `tool:after` doesn't fire for a call that was refused, declined or stopped.

## Events that decide

| Event | When | Subject |
| --- | --- | --- |
| `tool:before` | a tool call is about to run | `tool`, `args`, `isSubAgent`, and `refuse(reason)` |
| `permission` | Braney is about to ask you to allow something | `key`, `verb`, `subject`, `details`, `ephemeral`, and `allow()` and `deny(reason)` |

- A refused call never runs, and the agent is told your reason.
- A `permission` handler runs before any answer you saved, so it can allow what you once declined,
  or decline what you allowed. A handler that decides nothing leaves the question to you. Once a
  handler denies, a later `allow()` has no effect.
- `ephemeral` is true when an answer would cover only this one call, as for a file git ignores.

## The Braney API

These act on the conversation the event is about, a subagent's included.

`braney.send`, `braney.compact` and `braney.abort` work only inside a handler. A script's top level
and its `ready` handler run again each time the scripts load, so an action there would repeat; it
throws instead. To act on every prompt, call it from `turn:before`. Reading `model`, `usage` and
`session` works anywhere, and at the top level it answers for your conversation.

| | |
| --- | --- |
| `braney.send(text)` | adds a note to the conversation; sent as the model finishes its answer, it keeps the turn going; sent while no turn of yours is running, as from `turn:after`, it starts the next one, unless the turn was stopped. A handler that always sends keeps Braney going until you stop it |
| `braney.compact()` | summarizes the conversation once the current turn is over |
| `braney.abort(reason)` | stops the current turn, as `esc` would; the reason is optional and shown to you |
| `braney.model()` | `{ backend, id, contextSize, vision, probed }` for the active model |
| `braney.usage()` | `{ contextUsed, contextSize }` for the conversation, read fresh each call |
| `braney.session()` | `{ key, title, startedAt }`, with `startedAt` in milliseconds |

## What a hook can use

Unlike the agent, a hook runs as you, with your permissions, on your machine.

- `require` gives Node's `fs`, `path`, `os`, `crypto`, `child_process`, `http`, `https`, `url`,
  `util`, `events`, `assert`, `buffer`, `timers` and `querystring`. `fetch` and `process` are
  global.
- A path, as in `require("./helper.js")`, loads that file, and one written with `import` and
  `export`, TypeScript or JSX loads too.
- Any other name is an npm package, installed the first time a hook requires it, **without
  asking**. `require("name@1.2.3")` pins a version.
- `child_process` runs commands synchronously only: `execSync`, `execFileSync` and `spawnSync`.
  Braney waits while a command runs, so keep them short.
- Relative paths start from the folder Braney was started in.
- Commands differ between systems; `process.platform` is `"win32"`, `"darwin"` or `"linux"`.

## Limits

- All the handlers of one event get 30 seconds and 256 MB between them. Going over stops every
  script until the next turn.
- A handler that throws is reported to you with the script's name, and the turn carries on. Every
  handler of an event runs, even after one throws or decides.
- A script that throws while it loads, or takes longer than 30 seconds to load, is switched off.
  Saving it again switches it back on.

## Tool names

`tool:before` and `tool:after` name the tool that ran. The agent's own:

| Tool | What it does |
| --- | --- |
| `read_file`, `write_file`, `edit_file`, `delete_file` | read and change files |
| `list_directory`, `glob`, `grep` | find files and search them |
| `nodejs` | runs JavaScript in the sandbox |
| `read_document`, `search_document` | page through a large result kept aside |
| `web_search` | searches the web |
| `git` | reads the repository's status, diffs and history |
| `serve` | serves a folder over HTTP for a preview |
| `read_memory`, `write_memory`, `remove_memory` | memories |
| `read_skill`, `read_skill_file` | skills |
| `read_image` | looks at an image |
| `subagent` | hands a side task to a helper |
| `wait` | pauses while something keeps running |

An approved command is `execute_` followed by its fixed words, like `execute_npm_run_test`. An MCP
server's tool is `mcp_<server>__<tool>`, and the shell is `shell`. To see a tool's arguments, log
them from a `tool:before` handler and try it.

## Examples

Keep the agent out of a folder:

```js
braney.on("tool:before", (call) => {
	if (call.args.filepath?.startsWith("vendor/")) {
		call.refuse("vendor/ is generated; change the source instead")
	}
})
```

Run the linter after every edit, and hand its complaints to the agent:

```js
const { execSync } = require("child_process")

braney.on("tool:after", (call) => {
	if (call.tool !== "edit_file" && call.tool !== "write_file") return
	if (!call.args.filepath.endsWith(".ts")) return

	try {
		execSync(`npx eslint "${call.args.filepath}"`)
	} catch (err) {
		braney.send(`eslint found problems in ${call.args.filepath}:\n${err.stdout}`)
	}
})
```

Keep a running count of the tokens the model has written across prompts:

```js
braney.on("turn:after", (turn) => {
	if (turn.isSubAgent) return // already counted in the turn it belongs to
	const total = Number(localStorage.getItem("tokens") ?? 0) + turn.outputTokens
	localStorage.setItem("tokens", String(total))
	console.log(`${total} tokens written so far`)
})
```
