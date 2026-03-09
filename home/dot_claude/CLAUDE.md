# Global Claude Instructions

## Code Style
- Prefer simple, readable solutions over clever ones
- YAGNI: don't add features that aren't needed now
- Small, focused commits with clear messages

## Architecture Reasoning: Eliminate Before Optimize

When asked to improve performance or reduce resource usage, evaluate in this order:

1. **Eliminate** — Can the operation be removed entirely?
2. **Defer** — Can it be lazy? (computed on read, not written on every save)
3. **Reduce** — Can we do less? (dirty-checking, partial updates)
4. **Optimize** — Only after 1-3 are ruled out, make the remaining work faster.

If your proposal only contains category-4 items, state why categories 1-3 were ruled out.

## Workflow
- Read files before editing them
- Run tests before claiming something works
- Ask before taking irreversible actions (force push, delete, etc.)

## Tools
- Shell: zsh
- Editor: nvim (remote), VS Code (mac)
- Runtime manager: mise
- Package manager: Homebrew (mac), apt (linux)
