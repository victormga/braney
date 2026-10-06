# The workshop

The workshop is a separate conversation about the agent itself. Instead of learning where rules go
or how a hook is written, you say what you want the agent to do differently, and the workshop
works out what to build and builds it with you.

## Opening it

| | |
| --- | --- |
| `F2` | opens the workshop, and leaves it (`fn+F2` on many laptops) |
| `/workshop` | starts a fresh workshop, even from inside one |
| `/workshop <request>` | starts one with your request already in |
| `/help <question>` | asks the workshop a question about braney |
| `ctrl+c`, `/exit` | leave the workshop |

Leaving takes you back to your conversation, where you left it. What you said in the workshop
isn't kept; what you saved is.

## What it builds

| You say | You get |
| --- | --- |
| "Run the linter every time the agent edits a file" | a [hook](hooks.md), JavaScript that runs when something happens |
| "Never let it touch `vendor/`" | a hook that refuses the call: a guarantee, not a request |
| "This is how we cut a release: …" | a [skill](skills.md), steps the agent follows when that task comes up |
| "Always use pnpm, never npm" | a [standing instruction](instructions.md), part of every conversation |
| "Let the agent run our tests" | an [approved command](approved-commands.md), a tool that runs exactly that |
| "We deploy with fly.io, from main only" | a [memory](memory.md), recalled when it's relevant |

Some requests fit two. A skill is advice the agent reads; a hook is code that runs. When you need a
guarantee, the workshop builds a hook.

It asks before it builds: what should happen, when, and on what, until the result fits in one
sentence. Then it makes the smallest change that does it.

## Saving

Nothing is saved without you:

- A hook, a skill or the standing instructions open in the editor with the workshop's draft. Read
  it, change what you like, and save with `ctrl+s`, or close it with `esc` to keep things as they
  were. The workshop sees what you did, including your own changes.
- An approved command asks for your approval.
- A memory is saved at once. The workshop tells you what it saved, and `/memory open` changes it.

Hooks, skills and memories apply from the agent's next turn. Standing instructions and approved
commands apply as soon as you're back in your conversation.

## What it won't do

The workshop reads your project, but never changes its code, tests or docs: that's the agent's
job. It writes only what it builds, like the script behind an approved command.

Every permission is asked inside the workshop, even with yolo on, and an answer covers only that
one call. Hooks don't run inside it, so to see a new hook fire, leave the workshop and try it.

## Asking about braney

The workshop knows braney. Ask it which command does what, how to set something up, or where a
setting lives. Settings, the model, MCP servers and which tools the agent may use are changed with
slash commands, and the workshop tells you which one.
