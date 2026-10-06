# Memories

A memory is a note the agent recalls when a request makes it relevant: a fact about you or your
project, like "deploys go through fly.io, from main only". For a rule that applies everywhere, use
a [standing instruction](instructions.md). For how to do a kind of work, use a [skill](skills.md).

## How they work

A memory has a summary, one line, and an optional body for detail the agent needs only sometimes.

Before each turn, the agent is reminded of the memories that look relevant to the request, by their
summary, and reads a body only when the summary tells it there's more. So make the summary the
fact itself, "Deploys go through fly.io, from main only", not a title like "Deployment notes".

A pinned memory goes with every prompt, instead of waiting to be recalled.

## Managing memories

| Command | What it does |
| --- | --- |
| `/remember <what>` | asks the agent to save something from the conversation |
| `/forget <description>` | asks the agent to remove the memories that match |
| `/memory add <summary>` | writes a new memory in the editor |
| `/memory open` | opens one to read or change it |
| `/memory pin` | pins or unpins one |
| `/memory remove` | deletes one |

The agent can also save memories on its own, when it learns something worth keeping.
