# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a personal fish shell configuration. The structure follows fish conventions:

- **`config.fish`** — Scratch area for quick edits and tool-generated config. Anything here should be refactored into a `conf.d/` file before committing.
- **`conf.d/`** — Auto-sourced startup scripts. Each guards itself with `status is-interactive` and `command -q` checks so features degrade gracefully when tools aren't installed.
- **`functions/`** — Lazy-loaded function files (one function per file). Internal helpers use `__` prefix (e.g., `__gh_reviews_display`).
- **`completions/`** — Tab completion definitions (all gitignored, installed by tools/plugins).
- **`fish_plugins`** — Fisher plugin manifest (fisher + z).

## Key Patterns

- **Background caching**: Heavy operations (brew outdated, gh search) run async on startup and write results to `~/.cache/fish/`. The greeting reads from cache so it never blocks.
- **Cache invalidation**: `functions/brew.fish` wraps `brew` to delete the outdated-packages cache when packages are installed/upgraded/removed, keeping the greeting accurate between the 4-hour refresh cycle.
- **Change detection**: `conf.d/gh_reviews.fish` uses MD5 hashing to detect when PR review requests change, then displays via a `fish_postexec` hook.

## What's Tracked vs Ignored

Only user-authored files are committed. Fisher-installed plugins (`fisher.fish`, `__z*.fish`, `z.fish`), generated files (`fish_variables`, `completions/`), and tool-generated config (`conf.d/rustup.fish`) are gitignored.

## Testing Changes

- Test greeting: `fish -c "fish_greeting"`
- Test a single function: `source ~/.config/fish/functions/<name>.fish` then call it
- Or just open a new terminal
