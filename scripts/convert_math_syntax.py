"""One-shot conversion of LaTeX-style math delimiters to GitHub MathJax syntax.

Converts:
  - inline   \( ... \)   ->   $ ... $
  - display  \[ ... \]   ->   $$ ... $$

Skips fenced code blocks (``` ... ```) to avoid corrupting examples.

Usage:  python scripts/convert_math_syntax.py [paths...]
        (defaults to README.md, PROOF_STATE.md, RESEARCH_JOURNAL.md, notes/*.md)
"""

from __future__ import annotations

import re
import sys
from pathlib import Path


CODE_FENCE_RE = re.compile(r"(```[\s\S]*?```)")
# Do not consume whitespace around the inner content; preserves blockquote
# prefixes ("> ") and line breaks correctly.  Idempotent on already-converted
# files (only matches the LaTeX delimiters).
INLINE_MATH_RE = re.compile(r"\\\(([\s\S]+?)\\\)")
DISPLAY_MATH_RE = re.compile(r"\\\[([\s\S]+?)\\\]")


def convert_math(text: str) -> str:
    parts = CODE_FENCE_RE.split(text)
    converted: list[str] = []
    for i, part in enumerate(parts):
        if i % 2 == 1:
            converted.append(part)  # code fence, leave alone
            continue
        # display math first (greedier delimiter)
        part = DISPLAY_MATH_RE.sub(r"$$\1$$", part)
        # inline math
        part = INLINE_MATH_RE.sub(r"$\1$", part)
        converted.append(part)
    return "".join(converted)


def fix_blockquoted_display_math(text: str) -> str:
    """If the previous run produced `> $$> ...` glued sequences, repair them.

    The original-style display math inside blockquotes had the pattern:
      > \[
      > content
      > \]
    which a too-eager regex collapsed to `> $$> content\n>$$`.  Restore
    proper formatting by detecting and re-splitting.
    """
    # Detect malformed pattern: "> $$> " preceded by no newline.
    text = re.sub(r"> \$\$>\s*", "> $$\n> ", text)
    # And the closing ">$$" with no space before.
    text = re.sub(r"\n>\$\$", "\n> $$", text)
    return text


def gather_paths(args: list[str]) -> list[Path]:
    if args:
        return [Path(a) for a in args]
    root = Path(".")
    paths: list[Path] = []
    for top in ("README.md", "PROOF_STATE.md", "RESEARCH_JOURNAL.md"):
        if Path(top).exists():
            paths.append(Path(top))
    paths.extend(sorted(root.glob("notes/*.md")))
    if Path("erdos_124_researcher_handout_current_state.md").exists():
        paths.append(Path("erdos_124_researcher_handout_current_state.md"))
    return paths


def main() -> int:
    paths = gather_paths(sys.argv[1:])
    changed = 0
    for path in paths:
        text = path.read_text(encoding="utf-8")
        new_text = convert_math(text)
        new_text = fix_blockquoted_display_math(new_text)
        if new_text != text:
            path.write_text(new_text, encoding="utf-8")
            print(f"updated {path}")
            changed += 1
    print(f"\nfiles changed: {changed}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
