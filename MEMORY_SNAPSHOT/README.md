# Memory snapshot (for re-installation after machine reset)

The Claude Code auto-memory files for this project live at:

```
C:\Users\baian\.claude\projects\C--Users-baian-Math-Research-Knuth-124\memory\
```

These are stored LOCALLY on the user's machine, NOT in the git repo.
After a machine reset, recreate them by copying the four files in this
directory to that location:

- `MEMORY.md` — index of feedback memories
- `feedback_meta_review.md`
- `feedback_cas_delegation.md`
- `feedback_cpp_over_python.md`
- `feedback_use_library_not_standalone.md` (NEW from session ending 2026-05-22)

After re-installation, future Claude Code sessions will auto-load these
on every turn, restoring the project-specific feedback context.
