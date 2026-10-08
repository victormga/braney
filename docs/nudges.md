# Nudges

Small models fail in familiar ways: they repeat themselves, loop over the same tool, give up
halfway, or say a job is done when it isn't. Braney watches for these while the model works, and
when it spots one, it tells the model what went wrong so it can recover.

| Nudge | Steps in when the model… |
| --- | --- |
| Repetition in thinking | goes around in circles while reasoning |
| Repetition in the answer | repeats itself while answering |
| Runaway call arguments | repeats itself inside a tool call |
| Repetition in tool calls | makes the same calls again and again |
| Indecision | keeps second-guessing itself instead of acting |
| Stopped before finishing | says what it will do next, then stops |
| No answer | ends a turn without an answer |
| Invalid tool calls | sends tool calls that can't be run |
| Tool calls failing repeatedly | keeps making calls that fail |
| Tool calls declined repeatedly | keeps asking for what you declined |
| False claim on work done | says it changed files it never touched |

`ctrl+o` opens the details of the last run, including what Braney caught.

## Turning them off

`/nudges` turns each one on or off, and `All` or `None` turns them all at once. Turn one off for a
model that doesn't need it. With a nudge off, the model is left to it: a loop the nudge would have
caught runs until you press `esc`.
