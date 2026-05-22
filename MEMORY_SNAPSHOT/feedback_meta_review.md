---
name: end-of-session meta-review
description: At the end of every working session on the Knuth_124 / Erdős 124 project, run a short meta-review checking strategic direction before stopping.
type: feedback
originSessionId: 5599ce40-2544-40b3-bf40-5abf9975f171
---
At the end of every working session on this project, before finishing,
explicitly answer:

- Are we on the right track?
- Are our methods and techniques the best available?
- Can we do better?
- Would I change anything?

If any answer is "no" / "not really", write a short strategic note (or
extend `notes/45_strategy_revision.md`) and surface it to the user.

**Why:** The user asked this meta-question after a session of six commits
in which all open obligations in `GlobalProofAudit.hs` stayed Open while
the project gained lots of peripheral infrastructure.  A meta-review prompt
caught it.  The user wants this surfaced *proactively*, not only when
asked.  See `notes/45_strategy_revision.md` for the worked example.

**How to apply:** Trigger when the user signals end of session
("good for now", "stop here", "let's pause"), or when the working set
naturally winds down (commits made, certificates passing, no clear next
target).  Do not trigger after every single response — this is a session
boundary check, not a per-turn check.

The review takes about 100–300 words of honest text.  It is allowed to
conclude "yes, on track" — but it must be a real review, not a rubber
stamp.  Specific failure modes to watch for:

- many commits, no Open obligation closed;
- the "next cuts" in the boss tree have not changed across several
  commits;
- new building blocks orbit a central open problem without touching it;
- framing in audits / README implies we're closer than we are.

If the review says we are off track, propose 1–3 concrete redirections,
not just "do better".  Reference the relevant note or literature.
