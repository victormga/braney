# Standing instructions

Standing instructions are rules the agent carries into every conversation, like "always use pnpm"
or "never edit generated files". They're part of the system prompt, so keep each rule short.

## Your part of the prompt

Braney's system prompt has two halves. The first describes how braney itself works, and is what
makes a small model usable here; it isn't editable. The second is yours: it ships with guidance you
might reasonably want to overrule, like how to verify a change, or how to handle comments, tests
and dependencies.

Until you save an edit, you follow braney's default as it improves with each release. Your first
save makes the text yours; `/prompt reset` hands it back.

| Command | What it does |
| --- | --- |
| `/prompt open` | opens your instructions in the editor |
| `/prompt history` | lists your saved revisions |
| `/prompt restore <revision>` | brings one back |
| `/prompt reset` | goes back to braney's default |

The last 20 revisions are kept.

An edit applies at once, even in the middle of a conversation: the agent sees only the new text,
never two versions to weigh against each other. The turn after an edit can be a little slower, as
the server reads the whole prompt again.

## Filled in for you

These names, written in capitals inside square brackets, are replaced wherever they appear:

| | |
| --- | --- |
| `[SYSTEM_OS]` | your operating system |
| `[SYSTEM_ARCH]` | your machine's architecture |
| `[DATE_TODAY]` | today's date |
