# Models

## Picking a model

`/model` picks the kind of server and the model, from the ones the server offers. Braney reads the
model's context window and whether it can see images from the server, and each project remembers
its own model.

To connect to a server, see [Getting started](getting-started.md#connect-to-a-model-server).

## Sampling

Sampling settings decide how a model picks its next word, and they matter almost as much as the
model itself. Publishers tune their models for specific values, often one set for thinking and
another for plain answers, and the wrong ones can leave a model repeating itself or drifting off
task.

The first time you pick a model, braney looks it up on Hugging Face, reads the recommendation from
its model card, and offers it. When a card has several sets, pick the one that fits how you use the
model. When a quantized copy's card doesn't carry a recommendation, braney follows it back to the
original model, and failing that, offers the defaults the model ships with.

What you pick is saved for that model, and applied every time you pick it again. Until you choose,
braney sends no sampling settings at all, and your server's own settings stand.

| Command | What it does |
| --- | --- |
| `/sampling reload` | looks up the recommendation again and offers it |
| `/sampling temperature` | shows the current value |
| `/sampling temperature 0.2` | sets it |
| `/sampling temperature auto` | hands it back to the server |

The settings are `temperature`, `top_p`, `top_k`, `min_p`, `frequency_penalty`,
`presence_penalty` and `repetition_penalty`.

### If a model repeats itself

Try a lower temperature first. If it still loops, raise a penalty, and only a little: 0.1 to 0.2 is
usually enough, and past about 0.5 it visibly hurts code, which repeats names and boilerplate on
purpose. Prefer `frequency_penalty`: it grows with how often a word has appeared, where
`presence_penalty` weighs the first repeat the same as the tenth.

## Thinking

For models that reason before they answer, `/thinking` sets how long they may think. `shift+tab`
steps through the levels.

| Level | How long |
| --- | --- |
| `none` | no thinking |
| `xlow` | shortest |
| `low` | short |
| `mid` | balanced |
| `high` | long |
| `xhigh` | longest |
| `auto` | as long as the model likes (the default) |

`/thinking budget 3k` sets an exact number of tokens instead. A level only ever cuts a thought
short; it never makes a model think longer than it would on its own.

## Context window

Braney reads the size of the context window from the server. If the server reports it wrong, set
it yourself:

```
/configure model.context_size 32k
```

`/configure unset model.context_size` goes back to what the server reports.

## Images

When the model can see images, paste one into your prompt with `ctrl+v`, or point the agent at an
image in the project.
