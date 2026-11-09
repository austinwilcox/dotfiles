---
name: trunkline
description: >-
  Use when working with Git worktrees via the `tl` (Trunkline) CLI: creating,
  switching, listing, or removing worktrees by branch name; managing stacked
  branches; pruning merged worktrees; configuring or debugging lifecycle hooks
  (pre/post start, switch, remove); shell integration; or updating the tool.
  Also answers general Trunkline/`tl` questions.
---

# Trunkline (`tl`) — Git worktree manager

Trunkline makes Git worktrees as easy as branches. You address everything by
**branch name**; `tl` computes the worktree path, shows status relative to the
main branch, runs lifecycle hooks, and can manage stacked branches.

Binary: **`tl`**. Runtime: Deno + TypeScript. Config: `.config/tl.toml` in the
repo (committed) and `~/.config/trunkline/config.toml` (per user).

## When to use this skill

- Creating/switching/removing Git worktrees by branch name.
- Checking out a teammate's remote branch into its own worktree.
- Managing **stacked branches** (dependent branch chains) and navigating them.
- Cleaning up worktrees whose branches already merged into main.
- Adding or debugging **hooks** (`pre-start`, `post-start`, `pre-switch`, etc.).
- Installing shell integration / tab completion, or updating `tl`.

## Core commands

```bash
tl list                      # worktrees + status vs main (@ current, ^ main)
tl list --stack              # same, indented by stack depth
tl list --json               # machine-readable

tl switch <branch>           # switch to a worktree (aliases: sw, s)
tl switch <remote-branch>    # fetch a remote-only branch + make a worktree
tl switch -c <branch>        # create branch + worktree
tl switch -c <b> --base main # create from a specific base
tl switch -c <b> -x <cmd>    # create, switch, then run <cmd> in the worktree
tl switch -c <b> --stack     # create on top of the current branch (tracked)

tl remove [branch]           # remove worktree (+ branch); --keep-branch, --force
tl prune                     # remove worktrees whose branch is merged + clean
                             #   --dry-run, --yes, --keep-branch

tl init                      # scaffold .config/tl.toml
tl hook show                 # show configured hooks
tl hook <type> [names]       # run hooks on demand; --foreground, --dry-run
tl config show|path          # inspect config / resolved paths
tl config approvals list|clear [--repo]
tl config shell install      # cd-wrapper + tab completion (bash/zsh/fish)
tl update                    # self-update to the latest release; --check, --yes
```

### Stacks (git-spice-style, worktree-centric)

```bash
tl stack                     # show the stack tree (@ current, ^ trunk)
tl stack track [--base <b>]  # track current branch (base auto-detected)
tl stack untrack [branch]    # forget a branch (retargets children onto its base)
tl up [n] / tl down [n]      # move upstack / downstack (switches worktrees)
tl top / tl bottom / tl trunk
```

Navigation switches you to the target branch's worktree, creating it lazily.
When a branch has multiple children, `tl up`/`tl top` list candidates instead of
guessing — pick one with `tl switch <branch>`.

## Configuration (`.config/tl.toml`)

```toml
# main-branch = "main"            # auto-detected if omitted
worktree-path = "{{ repo_path }}/../{{ repo }}.{{ branch | sanitize }}"

pre-start = "npm install"          # blocking hook on create

[post-start]                       # background hooks on create
server = "npm run dev -- --port {{ branch | hash_port }}"
```

## Hooks

Events × timing: `pre-`/`post-` for **switch**, **start** (create), **remove**.

- `pre-*` block the operation on failure; JSON context on stdin.
- `post-*` run detached in the background; output logged under
  `<gitCommonDir>/tl/logs/`; JSON context via `$TL_HOOK_CONTEXT`.
- Three forms: string (one command), table (concurrent named commands),
  `[[hook]]` array (ordered pipeline).
- Template vars: `{{ branch }}`, `{{ worktree_path }}`, `{{ commit }}`,
  `{{ base }}`, `{{ repo }}`, `{{ repo_path }}`, `{{ default_branch }}`, …
- Filters: `sanitize`, `hash`, `hash_port`, `dirname`, `basename`.
- **Project hooks require one-time approval** (`Allow and remember?`), stored
  per machine. `--yes` bypasses; `--no-hooks` skips hooks.

## Notes for agents

- Prefer branch names over paths; `tl` resolves paths from the template.
- `tl switch` changes the shell's directory only when shell integration is
  installed; otherwise it prints the path to `cd` to. In scripts, read the
  resulting path or run non-interactively.
- Destructive commands (`remove`, `prune`) refuse the primary worktree and dirty
  worktrees unless `--force`; prefer `--dry-run` first for `prune`.
- Use `tl list --json` for reliable machine parsing.
- `tl --help` lists every command and flag; `tl <cmd> --help` is not per-command
  yet, so consult `tl --help` or this skill.

