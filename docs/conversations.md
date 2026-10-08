# Conversations

## Writing prompts

| Key | What it does |
| --- | --- |
| `enter` | sends the prompt |
| `shift+enter` | starts a new line |
| `up` / `down` | walks back through earlier prompts |
| `@` | completes a file path from the project |
| `ctrl+v` | pastes text, or an image when the model can see images |
| `esc` | stops the agent in the middle of a turn |

A prompt sent while the agent is still working waits its turn, and runs once the current one is
done.

### Aliases

An alias is a prompt you save once and send by name. `/alias add review` opens the editor for the
prompt, and typing `#review` sends it. `/alias open` changes one, and `/alias remove` deletes it.

## History

Conversations are saved as they go, in the project's `.braney` file.

| Command | What it does |
| --- | --- |
| `/history open` | reopens an earlier conversation |
| `/history delete` | deletes one |
| `/history auto_prune` | keeps only the newest 100, deleting older ones at startup |
| `/reset`, `/new`, `ctrl+r` | starts a new conversation |
| `/rollback 2` | drops the last two turns, for when the agent went the wrong way |

## The screen

| Command | What it does |
| --- | --- |
| `/find`, `ctrl+f` | searches the transcript |
| `/clear`, `ctrl+l` | clears the screen, and keeps the conversation |
| `ctrl+o` | opens the details of the last run: what the agent did, and what Braney caught |

## The context window

A model can only hold so much at once, and a small one holds little. Braney keeps the conversation
lean on its own:

- A large tool result isn't dumped into the conversation. Braney keeps it aside, and the model
  reads or searches only the part it needs. `agent.tool_result_limit` sets how large a result can
  be before that happens.
- Side tasks that would fill the conversation with noise, like digging through a large codebase
  for one answer, go to a subagent that reports back in a paragraph.
- When the window fills up, Braney summarizes the conversation to make room, and carries on.

`/context` shows what's filling the window, and `/compact` summarizes the conversation right away.
