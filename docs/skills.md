# Skills

A skill is written guidance the agent is handed when a task calls for it. It comes in two kinds,
or both at once:

- **A procedure**: steps to follow in order, like releasing a version or setting up a new service.
- **Know-how**: the choices and standards to bring to a kind of work, like how you build a web
  front-end or what a good code review covers.

A skill is advice: it runs nothing. When you need something enforced, use a [hook](hooks.md).

## How the agent uses them

Before each turn, the agent sees every skill's summary and picks the ones the task needs, reading a
skill in full only when it opens it. So the summary decides whether a skill is ever used. Write it
as the situation it applies to, "Releasing a new version of the CLI", rather than a title,
"Release notes".

Write the body for a capable stranger with none of your context. For a procedure, give the steps in
order, with the real paths, commands and checks. For know-how, give the choices you want made and
the reason behind each, concrete enough to act on.

A skill can point to other files, like a reference sheet or a template, and the agent reads them
when the skill tells it to.

## Managing skills

| Command | What it does |
| --- | --- |
| `/skill add <summary>` | writes a new skill in the editor |
| `/skill open` | opens one to read or change it |
| `/skill import <path or url>` | imports skills from elsewhere |
| `/skill remove` | deletes one |

Or describe what you want in the [workshop](workshop.md), and it writes the skill with you.

## Importing skills

Skills written for other agents in the `SKILL.md` format work as they are. `/skill import` takes:

- a `SKILL.md`, or any markdown file
- a folder of skills
- a web page that links to them
- a GitHub file, folder or whole repository, like `https://github.com/anthropics/skills`

Each skill comes with the files it refers to, and Braney asks before importing. You can also hand
the workshop a link and let it bring the skill in.
