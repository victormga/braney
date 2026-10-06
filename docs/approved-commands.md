# Approved commands

An approved command lets the agent run one specific program, like your test runner or linter, as
one of its own tools. It's the safe middle ground between the sandbox, which can't start programs,
and a full shell, which can run anything.

Once approved, the agent runs it without asking again.

| Command | What it does |
| --- | --- |
| `/command add` | approves a new command |
| `/command open` | opens one to change it |
| `/command remove` | removes one |

Or ask the [workshop](workshop.md), or let [onboarding](onboarding.md) find the ones your project
declares.

## Writing one

A command is a template and a description. The template becomes a tool named `execute_` followed by
its fixed words: `npm run test` becomes `execute_npm_run_test`.

The description is all the agent has to decide when to run the command and what to fill in, so
write it for the agent: what the command does, when to run it, and what each placeholder takes.

> Runs the unit tests. Pass a test file to run only that one.

## Placeholders

Words in angle brackets are filled in by the agent each time it runs the command:

| Placeholder | Takes |
| --- | --- |
| `<file>`, `<dir>`, `<path>` | a path inside the project; one outside is refused |
| `<string>` | one value, with no spaces |
| `<int>`, `<float>` | a number |
| `<enum(dev\|prod)>` | one of the listed choices |

A name before a colon names the argument, as in `<target:file>`, and a placeholder can sit inside a
word, as in `--config=<file>`.

```
npm test -- <file>
pytest <file>
go test ./<dir>
cargo test <name:string>
```

## No shell in between

The command runs directly, in the project folder, without a shell. Each word of the template is
exactly one argument, so pipes, `&&`, redirects, globs and `$VARIABLES` have no effect. When you
need those, write a script and approve the command that runs it.
