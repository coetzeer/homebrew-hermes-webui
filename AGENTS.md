# AGENTS.md — Homebrew Tap: `coetzeer/hermes-webui`

This is a **Homebrew tap** (third-party formula repository), not the application source code. The actual `hermes-webui` project lives at [github.com/nesquena/hermes-webui](https://github.com/nesquena/hermes-webui).

## What this repo does

Provides a Homebrew formula so users can install Hermes WebUI via:

```bash
brew install coetzeer/hermes-webui/hermes-webui
```

## Repository structure

```text
Formula/
  hermes-webui.rb       # Single formula definition
.github/
  workflows/
    tests.yml           # CI: brew test-bot on push/PR
    autobump.yml        # Daily auto-bump formula version
  dependabot.yml        # Weekly GitHub Actions updates
  removed/
    publish.yml         # Disabled bottle-publish workflow (manual dispatch)
```

## Formula details (`Formula/hermes-webui.rb`)

- **Language**: Python 3.12 (depends on `python@3.12`)
- **Install**: `pip3 install` via Homebrew's `std_pip_args` (handles virtualenv and linking)
- **Service**: Runs `hermes-webui serve --port 8787` via `brew services`
- **State dirs**: `/usr/local/var/lib/hermes-webui` and `/usr/local/var/log/hermes-webui` (created via `post_install_steps`)
- **Upstream repo**: `nesquena/hermes-webui` (branch: `master`)
- **License**: MIT

## Commands

| Command | Purpose |
|---|---|
| `brew test-bot --only-tap-syntax` | Validate formula syntax (no Homebrew needed) |
| `brew test-bot --only-formulae` | Full formula test (install + test block) |
| `brew tests --only hermes-webui` | Run just the formula's test block |
| `brew bump --open-pr --formulae --tap=coetzeer/hermes-webui` | Bump formula version (auto-bump runs daily via CI) |
| `brew style coetzeer/hermes-webui/hermes-webui` | Lint style of the formula |

## CI/CD

- **tests.yml**: Runs on macOS (latest) and Linux (Homebrew Docker container). Triggers on push to `main` and PRs. Runs `brew test-bot --only-cleanup-before`, `--only-setup`, `--only-tap-syntax`, and `--only-formulae` (PR only). Uploads bottles as artifacts.
- **autobump.yml**: Runs daily at 14:10 UTC. Auto-detects new upstream releases and opens a PR via `brew bump --no-fork --open-pr`.
- **publish.yml** (disabled/removed): Was for merging bottles after PR merge. Uses `brew pr-pull` then pushes to `main`.

## Conventions & gotchas

- **Formula inherits from `Formula` class** (standard Homebrew DSL). All methods like `std_pip_args`, `var`, `opt_bin`, `service` are Homebrew DSL methods — they will appear as "undefined" to Ruby LSP/typeprof but are valid at runtime.
- **Version scheme**: Uses `exp-v0.52.264` tag format from upstream. Bumps happen via the autobump workflow.
- **No local source code**: The formula downloads from a GitHub release archive. Do not look for `setup.py`, `pyproject.toml`, or Python source files here — they live in the upstream repo.
- **Bottle publishing is disabled**: The `publish.yml` workflow was removed. Bottles are generated but not currently published to a bottle bucket.
- **Dependabot**: Only updates GitHub Actions, not the formula itself. Formula version bumps are handled by the autobump workflow.
- **When editing the formula**: The `sha256` must match the uploaded archive. Use `brew fetch` to get the correct hash after changing the `url`.
- **Test block**: Runs `hermes-webui --help` and checks the output contains `hermes-webui`. Keep it lightweight since it runs in CI for every PR.

## Updating the formula

1. Find the new release tag on [github.com/nesquena/hermes-webui/releases](https://github.com/nesquena/hermes-webui/releases)
2. Update `url` to point to the new archive URL
3. Update `sha256` (use `brew fetch path/to/Formula/hermes-webui.rb` to get the new hash)
4. Run `brew test-bot --only-tap-syntax` to verify