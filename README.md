# Fish Shell Configuration

Custom fish shell setup with an informational greeting and quality-of-life wrappers.

## Greeting

`functions/fish_greeting.fish` — on each new terminal, displays:

- Outdated Homebrew packages (with a `brew upgrade` hint)
- GitHub PRs awaiting your review (with links)

Both data sources are cached in `~/.cache/fish/` and refreshed in the background by startup scripts (see below).

## Startup Scripts (`conf.d/`)

### `brew_update.fish`

Background-checks for outdated Homebrew packages every 4 hours. Writes the list to `~/.cache/fish/brew_outdated` so the greeting can display it without blocking shell startup.

### `gh_reviews.fish`

Background-fetches open PRs where your review is requested via `gh search prs`. Writes to `~/.cache/fish/gh_review_requests`.

### `mise.fish`

Activates [mise](https://mise.run) (polyglot version manager) in interactive shells.

### `starship.fish`

Initializes [starship](https://starship.rs) prompt in interactive shells.

## Custom Functions (`functions/`)

### `brew.fish`

Wraps `brew` so that `brew upgrade`, `install`, `uninstall`, and `reinstall` automatically invalidate the outdated-packages cache. This way the greeting stays accurate without waiting for the 4-hour refresh.

## Fisher Plugins

Managed with [fisher](https://github.com/jorgebucaran/fisher). Current plugins (`fish_plugins`):

- **jorgebucaran/fisher** — plugin manager
- **jethrokuan/z** — directory jumping (tracks frecency of visited directories)

### Restoring plugins

```sh
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher update
```

## Setting Up on a New Machine

1. Install fish: `brew install fish`
2. Clone this repo to `~/.config/fish/`
3. Install fisher and plugins (see above)
4. `brew install mise starship gh`
5. `gh auth login`
6. Open a new terminal — the greeting should appear after the first background refresh
