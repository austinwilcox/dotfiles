---
name: stacked-prs
description: Build and manage stacked pull requests with the `gh stack` CLI extension — splitting a large change into a chain of dependent PRs, linking PRs that already exist into a stack, navigating and merging one. Use whenever the user mentions stacking, a stack, stacked PRs, "break this PR up", "split this PR", or asks for smaller reviewable chunks of a large change.
requires:
  bins: ["gh", "git"]
  auth: true
---

# Stacked PRs

GitHub supports stacks natively. `gh stack` is the CLI for them — it ships as a `gh`
extension and is the right tool, not hand-rolled base chaining plus a Markdown table.

Verify what is installed before relying on any detail here: `gh stack --help`. The
feature is newer than most model training data, so **check the CLI rather than assuming
it does not exist.**

## The one gotcha that will bite first

`gh stack` resolves the GitHub host from the git remote. A remote using a custom SSH
alias (`git@github-work:Org/Repo.git`, common with multiple GitHub accounts) fails with:

```
✗ failed to create GitHub client: determining repository: unable to determine current
  repository, none of the git remotes configured for this repository point to a known GitHub host
```

Plain `gh pr ...` commands work fine on the same repo, so this looks confusing. Fix by
naming the repo explicitly:

```bash
GH_REPO=Org/Repo gh stack link 101 102 103
```

Export `GH_REPO` for the whole session when working in such a repo.

## Two ways in

### A. PRs already exist, with correct base chaining

`gh stack link` registers them as a real stack without adopting local tracking. Arguments
are **bottom to top**, and may be PR numbers, PR URLs or branch names.

```bash
GH_REPO=Org/Repo gh stack link 905 906 907 908 909 910
# ✓ Created stack with 6 PRs (stack #911)
```

Branch arguments are pushed automatically, and branches with no PR get one created with
the right base. To adopt local tracking afterwards so `gh stack view` and the navigation
commands work:

```bash
GH_REPO=Org/Repo gh stack checkout 911
GH_REPO=Org/Repo gh stack view
```

Growing an existing stack: pass the stack number first, then only the new PRs —
`gh stack link 911 912`.

### B. Building a stack from scratch

```bash
gh stack init                      # start a stack on the default branch
gh stack init branch1 branch2      # or adopt existing branches, bottom to top
gh stack add branch4               # add a branch on top of the current stack
gh stack submit                    # push branches, create/update the PRs
gh stack sync                      # reconcile local with remote
```

`submit` takes `--auto` (skip title prompts) and `--open` (mark ready for review).

## Navigating and landing

```bash
gh stack view                      # render the chain with PR links
gh stack up / down / top / bottom / trunk / switch
gh stack rebase                    # restack after the trunk moves
gh stack merge --squash -y         # land the whole chain in order
gh stack modify                    # interactively restructure
gh stack unstack                   # dissolve the stack, locally and on GitHub
```

Merge **bottom-up**. GitHub retargets each PR's base to the trunk automatically as its
parent lands, so a partially merged stack stays coherent.

## Do not hand-roll the stack UI

Once a stack is registered, GitHub renders the chain and each PR's position itself.
Adding a Markdown "here is the stack" table to every description duplicates that and goes
stale as soon as the stack changes. Descriptions should carry what changed and why; the
ordering is the stack's job.

## Slicing one large change into a stack

Worked approach when an existing branch has everything on it:

1. **Record the tip.** `git rev-parse HEAD` — this is the target the stack must reproduce.
2. **Group by concern, not by commit.** The existing commits usually do not match the
   slices you want. Slice by what a reviewer can judge in isolation: pre-existing bug
   fixes first (they stand alone and often unblock later chunks), then the core change,
   then follow-on surfaces, then mirrored ports, then tests.
3. **Build each branch from the tip, file by file.**
   ```bash
   git checkout -b stack/1-foo <trunk>
   git checkout <tip> -- path/to/file ...      # exact final content, no rework
   ```
4. **Split shared files by hand.** A file touched by two slices needs the earlier branch to
   hold an intermediate version. If an existing commit already isolates one half, take it
   from there: `git checkout <that-commit> -- path/to/file`.
5. **Verify each branch on its own** — build, typecheck, and the relevant tests — not just
   the tip. A stack whose middle does not compile is worse than one big PR.
6. **Prove parity at the top:** `git diff <tip> HEAD` must print nothing. If it does not,
   the re-slicing dropped or altered something.
7. `gh stack link` the resulting PRs bottom to top.

Sizing: aim for slices a reviewer can hold in their head. A 5-file, 25-line PR of
unrelated small fixes is a feature of the stack, not a waste of a PR.

## Repository etiquette

- Many repos forbid running git commands, committing or pushing without explicit
  approval. Ask first; the stack tooling pushes branches and opens PRs as a side effect.
- A pre-commit hook ending in `git add -u` will sweep **every** modified tracked file into
  each commit, including unrelated ones already dirty in the working tree. When that
  matters, run the hook's checks manually (formatter, secret scan) and commit with
  `--no-verify`, then say so.
- Follow the repo's commit convention on every branch in the stack; if PRs are squash
  merged, the PR title becomes the commit subject, so keep titles conventional rather than
  prefixing them `[1/6]`.
