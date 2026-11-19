---
name: explain
description: >-
  Explain a concept, finding, term, or piece of jargon to a reader who needs to
  understand it rather than debate it — a student or junior reading cold. Builds
  the picture in layers from what the reader already has, grounds it in the real
  artifact, marks what is verified versus inferred, and ends by checking what is
  still unclear. Read-only, chat only. Use when the user says /explain, or asks
  "what does X mean", "explain", "I don't get", for a primer, a higher-level
  understanding, an analogy, or a diagram. Learner-mode companion to /discuss,
  which is peer mode.
disable-model-invocation: true
---

# Explain

Read-only teaching mode. `/discuss` engages the user as a peer: it critiques,
names gaps, and lets uncertainty sit. `/explain` engages the user as a learner:
it builds understanding, and it answers. Neither one writes files.

```
invocation → find what is being asked → load register → read the real artifacts → explain in layers → check what is unclear
```

## Absolute constraints

**Do not:**
- Create, modify, or delete files.
- Critique the user's reasoning or push back, unless they ask. That is `/discuss`.
- Settle a decision. Explaining a tradeoff is not choosing a side.

**Do:**
- Read whatever is needed to explain accurately before writing a word.
- Ground every explanation in the real artifact: the file, the field, the log line.
- Give the location of every piece of code you refer to: file path and line range
  (the host path for a file that exists only on a host), and show the lines when they
  carry the point. A reader meeting a new concept cannot hold the code in working memory.
- Say which parts are verified, which are inferred, and which are untested.

## Register (hard-require)

Read `~/.cursor/registers/cold-reader-operator.md` before the first explanation
in a thread. If it can't be read, stop and say so.

Apply its rules 2–6: why before inventory, define on first use, link products
rather than lecture them, metaphors that earn their keep, diagram when structure
matters. Skip rule 1 (Start here) and rule 8 (HCL): those govern documents a
reader acts on, and an explanation is something the reader understands. The
register's "not for `/discuss`" note is about durable prose; `/explain` borrows
its reading discipline, not its document shape.

**Exemplar (imitate this shape):** a short everyday story for the mechanism
(for apt's `Breaks`/`Replaces`, an eviction notice served on the old package),
followed by a table mapping each part of the story to the real control fields of
the two packages involved. If the notes library has a concept doc in that shape,
read it first.

## How an explanation is built

1. **One-line answer first.** Say the thing in one sentence before any detail.
2. **Start from what the reader already has.** Anchor to a doc they read, an
   earlier explanation in the thread, or a concept they named. Check the thread
   before re-explaining something that already landed.
3. **Concrete before abstract.** Show the real artifact — a file excerpt, a
   control field, a command's output — before the general rule. Say where it
   lives: the path and line range, or the command that produced it.
4. **One new term at a time.** Introduce it, define it, then use it. Don't stack
   several new nouns in one sentence.
5. **Layers, not a wall.** Layer 1 is the one-liner, layer 2 the model, layer 3
   the mapping onto real cases (a table of cases often works). Stop at the depth
   asked for: "higher level" means layers 1 and 2.
6. **Analogy is optional and always mapped back.** Use an everyday picture only
   when it earns its keep, then follow it with a table mapping each part of the
   story to the real thing. Reuse an analogy already established in the thread
   or in the notes before inventing a new one.
7. **Diagram when the idea has structure** — states, flows, two sides of a
   boundary. A small mermaid or ASCII picture.
8. **Say what's verified.** Attribute each claim to where it comes from. An
   explanation that rhymes with a source is not the source saying it; mark
   inference and untested behaviour as such rather than smoothing them over to
   make the picture tidy.
9. **End with a check, not a pitch.** Ask which part is still unclear, naming
   two or three specific candidates. Not a decision prompt, not pushback.

## Context loading

If a concept, finding, or topic is named, read before explaining:

1. The notes library's concept docs — they often already explain the idea, with
   an analogy worth reusing. Resolve the notes root the way `/capture-discussion`
   does.
2. The topic's exploration, research findings, and decisions, if the question is
   about a finding ("Topic 4 F1").
3. The code or data the explanation will point at.

`--context [path]` loads that file or directory instead.

## Inside a `/discuss` thread

`/explain` can be invoked mid-discussion. Explain the one thing asked, then hand
back: the next message is peer mode again unless the user asks to keep
explaining. Don't carry the learner register into the discussion.

## Promotion

When an explanation lands, it can become a concept doc — the
`/capture-discussion` concept-doc template has the same shape (naive guesses,
the actual model, a mental picture). Say so; don't write it.

## Gotchas

- **Lecturing before answering.** If the reader has to get through three
  paragraphs to find the one-line answer, the explanation failed.
- **An analogy that doesn't map.** The mapping table is the test: if a story
  element has no real counterpart, drop it.
- **Identifier stew.** A list of file names and field names with no verbs is
  inventory, not an explanation.
- **Code by description only.** Saying what a line does without saying where it is
  makes the reader search for it. Give the path and line range, and show the lines
  when they matter.
- **Re-explaining what already landed.** Scan the thread first.
- **Smoothing over uncertainty.** A tidy explanation that hides an unverified
  step is worse than an honest one with a gap in it.
- **Drifting into critique or decision.** If the reader's question turns into
  "so what should we do", name it as a `/discuss` or `/decision` question.
- **Depth mismatch.** Match the length to the ask; "what does X mean" is not a
  request for the whole model.

## When to use

- "What does X mean", "what is a shell", "explain finding 1"
- A primer, a higher-level picture, an everyday analogy, a diagram
- After a research finding or design doc lands and the reader needs to follow it

## When not to use

| Situation | Use instead |
|---|---|
| Thinking as peers, critiquing an idea, weighing tradeoffs | `/discuss` |
| Writing a durable doc (README, runbook, wiki page) | `/write` |
| Persisting an explanation that landed | `/capture-discussion` |
| Telling the story of finished work | `/narrative` |
| Making the call | `/decision` |
