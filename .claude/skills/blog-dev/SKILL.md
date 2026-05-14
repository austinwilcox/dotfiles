---
name: blog-dev
description: >
  Surfaces dev wisdom distilled from a curated technical blog library — TKDodo (React Query),
  React/TypeScript craft, refactoring, architecture, testing. Use when working in React/RQ/TS code,
  reviewing changes in these areas, or when the user invokes /blog-dev. Voice: third-person advisor
  citing the rule + its source article when relevant.
---

# blog-dev

Curated dev rules from ~134 technical articles. Skill = pattern catalog. When user works in these areas, surface the relevant rule + reasoning. Don't dump the whole catalog — pull the 1–3 rules that apply.

## How to behave

**Trigger.** Auto-surface when:
- Editing/reviewing React, React Query/TanStack Query, TypeScript, or refactoring tasks.
- User asks "is this right?", "any anti-patterns here?", "how would [TKDodo / good engineer] do this?"
- `/blog-dev` invoked explicitly.

**Don't auto-fire** on unrelated work (devops, SQL-only, Python, etc.). No relevance → stay silent.

**Voice.** Cite rule + reason + source article when known. Format: `Rule. Reason. Source: <Article Name>.`

**Conflict with existing code.** Match repo conventions for immediate task. Flag rule violation as one-line callout, don't block.

**Conflict with team/personal preference skills.** If another loaded skill encodes team or personal stack prefs that contradict a rule here, that skill wins for its scope. Flag the divergence one-line.

**Push intensity.** Firm on anti-patterns that cause bugs (stale closures, props-to-state, `any` leak). Soft on stylistic prefs.

---

## 1. React Query / TanStack Query

**Principles:**
- React Query = async state manager, not data fetcher. You bring the Promise (fetch/axios/whatever).
- Treat `queryKey` like `useEffect` dep array. Every param in key → auto-refetch on change.
- Server state ≠ client state. Don't copy RQ data into `useState`.
- `staleTime` controls fresh vs stale. Default `0` = aggressive refetch. Tune per feature.
- Mutations imperative (`mutate()`), queries declarative (auto-run on key).

**Anti-patterns:**
- `useState(query.data)` → stale copy, breaks background updates. Use RQ data directly or derive.
- Ignore `exhaustive-deps` on queryKey → silent stale data.
- `onError` on `useQuery` for global toasts → fires per observer. Use `QueryCache` callback (once per request).
- `mutateAsync().then()` without `.catch()` → unhandled rejection. Prefer `mutate(vars, { onSuccess, onError })`.
- Object rest destructure on `useQuery` result → breaks `notifyOnChangeProps` tracking.

**Patterns:**
- Custom hook per feature wrapping `useQuery`. Co-locate keys + fns in `queries.ts`.
- Query Key Factory: `todoKeys = { all: ['todos'], list: (f) => [...todoKeys.all, 'list', f] }`. Enables hierarchical invalidation.
- Mutation: invalidate in `useMutation` callbacks (always run). UI side-effects in `mutate()` callbacks (skip on unmount).
- Dependent queries: `enabled: !!id`. Don't fire until deps ready.
- Optimistic update: `onMutate` patch cache → revert in `onError`. Only when mutation rarely fails.
- Seed cache with `initialData` from related queries (e.g., list → detail).
- `notifyOnChangeProps: 'tracked'` → auto re-render optimization.

**Canonical sources:** `Practical React Query.md`, `Thinking in React Query.md`, `Mastering Mutations in React Query.md`, `Effective React Query Keys.md`.

---

## 2. React (hooks, components, state)

**Principles:**
- Code for re-renders. They're cheap. Optimize only when measured.
- `useEffect` = escape hatch for external systems (DOM, timers, sockets). Not syncing externally → probably don't need it.
- Composition > memoization. Move state down, lift content up before reaching for `React.memo`.
- Early returns for mutually exclusive states (loading/empty/error/success). Not nested ternaries.

**Anti-patterns:**
- `useEffect` + `setState` syncing props → double render. Use `key` prop to remount, or lift state up.
- `useCallback`/`useMemo` without concrete reason (memoized child / expensive calc / dep of another hook) → noise.
- Non-primitive props to `React.memo` child without memoizing at call site → memo broken silently.
- Nested ternaries in JSX → cognitive load. Early return instead.
- Stale closures from empty deps + memoization → use ref pattern.

**Patterns:**
- Custom hooks with descriptive names (`useTitle`, `useTrackVisit`) for effect logic.
- `key={id}` remounts component on identity change. Cleanest "reset state from props".
- Ref pattern for latest-value access without re-creating: update ref every render, read in event handler.
- Lift children to avoid memo prop drilling: `<Memoized>{expensive}</Memoized>`.

**Canonical sources:** `Simplifying useEffect.md`, `You really, really, really don't need an effect! I swear!.md`, `Hooks, Dependencies and Stale Closures.md`, `The Uphill Battle of Memoization.md`, `The Useless useCallback.md`, `Putting props to useState.md`.

---

## 3. TypeScript

**Principles:**
- Let TS infer. Explicit generics only when compiler can't figure it out. Strong return types > generic params.
- Discriminated unions + exhaustive switch → compile-time branch checking.
- `unknown` over `any`. `any` disables checking and leaks.
- `as const` underused. Locks literals, enables `(typeof x)[number]` extraction.
- `never` for exhaustiveness: assert in `default` case to catch unhandled branches at compile.

**Anti-patterns:**
- `as Type` to silence compiler → disables safety. Use `: Type` annotation.
- `any` anywhere → contaminates. Confine to smallest scope or use `unknown`.
- Multiple generics passed to `useQuery<A, B, C>` → no partial inference. Type the `queryFn` return instead.
- Destructure RQ result before status narrowing → `data` won't narrow in `if (isSuccess)`. Use `query.data` after guard.
- Index signatures carelessly → widen types, lose info.

**Patterns:**
- `{ kind: 'circle', radius } | { kind: 'rect', w, h }` → switch on `kind`.
- Nullable dep queries: accept `id: string | undefined`, reject Promise inside `queryFn` if missing.
- Explicit return types on exported fns/hooks → block `any` leak.
- `readonly` by default on params. Plays well with `as const`.

**Canonical sources:** `React Query and TypeScript.md`, `The power of const assertions.md`, `Beware the leaking any.md`, `Exhaustive matching in TypeScript.md`.

---

## 4. Refactoring & naming

**Principles:**
- Write code easy to delete, not easy to extend. Reversibility > reuse.
- Name what it *represents/means*, not what it *is*. `SALES_TAX` > `TWENTY`. `isInitializing` > `showLoading`.
- Avoid abbreviations unless universal. Hard to search, hard to read.
- Single Responsibility for effects. One concern per `useEffect`.

**Anti-patterns:**
- Over-abstraction for hypothetical reuse → leaks impl details. Duplication often cheaper.
- `isLoadingAndHasNoData` / "and"/"or" names → coupled to impl, rots when impl changes.
- Extract constant just because value repeats → only extract if same logical domain. `20ms timeout` ≠ `20% tax`.
- `handleClick` → couples to event. Prefer `loginUser` / intent name.

**Patterns:**
- Abstract at seams (interface boundaries), not middle.
- Inline if you can't name well. Naming hard → inline often clearer.
- Early returns + guard clauses → flatten nesting.
- Feature flags / adapters → isolate for deletion.

**Canonical sources:** `On naming things.md`, `Write Code That's Easy to Delete The Art of Impermanent Software.md`, `Refactor impactfully.md`.

---

## 5. Architecture & project structure

**Principles:**
- Vertical by feature, not horizontal by type. `src/widgets/` (components+hooks+types+utils) beats `src/components/` + `src/hooks/` + `src/types/`.
- Cognitive load is the metric. Code that changes together → lives together.
- Barrel files (`index.ts` re-exports) in app code → bad. Circular import risk, breaks tree-shaking. Library entry points only.
- Boundaries explicit: monorepo packages or `eslint-plugin-boundaries`.

**Anti-patterns:**
- Horizontal folders (`components/`, `hooks/`, `utils/`, `types/`) → related code scattered.
- App-code barrels → bundler can't optimize, circular import landmines.
- Catch-all `utils/` dir → grows into junk drawer.

**Patterns:**
- Each feature gets its own dir. Promote to own vertical when large (e.g., `PageFilters` → `src/pageFilters/`).
- `package.json` `exports` field defines public API. Enforce with eslint-plugin-boundaries.
- pnpm workspaces for monorepos.

**Canonical sources:** `The Vertical Codebase.md`, `Please Stop Using Barrel Files.md`.

---

## 6. Component composition

- Composition is React's superpower. Design hierarchy early.
- Layout components accept `children`. Separates layout from content.
- Prop drilling deep → use composition with `children` instead.
- Many conditional branches in one component → split into per-state components + parent dispatcher.

**Canonical source:** `Component Composition is great btw.md`.

---

## 7. Arrays & FP

- Avoid `Array.reduce` in app code. Powerful but hard to read.
- When reduce truly needed (array → keyed object), wrap in named util with tests.
- `map` / `filter` / `find` / `some` / `every` / `Object.fromEntries` first.
- Spreading into accumulator each iter → O(n²). Mutate the accumulator (small scope is fine).

**Canonical source:** `Why I don't like reduce.md`.

---

## 8. JS / async

- Closures capture lexical scope at definition. Empty-dep memoization → stale closures.
- Respect `exhaustive-deps`. Want to break it → ref pattern, document why.
- Ref pattern: store latest in ref, update every render, read imperatively in handler/effect.

**Canonical source:** `Hooks, Dependencies and Stale Closures.md`.

---

## Golden rules (apply broadly)

1. **Measure before optimizing.** No memoization / architecture for hypothetical perf.
2. **Render resiliency.** Re-renders cheap. Optimize when proven slow.
3. **Single source of truth.** Don't sync state across layers. Derive.
4. **Composition > inheritance / props bloat.**
5. **Explicit > clever.** Duplication often beats abstraction.
6. **Cohesion + boundaries.** Co-locate change, isolate concerns.
7. **Compiler-driven.** TS + lint catch at build, not prod.

---

## Quick "do not" list

- `any` in TypeScript
- Barrel files in app code
- RQ data → `useState`
- Nested ternaries for mutually-exclusive states in JSX
- `reduce` outside named utils
- Magic numbers (use named consts)
- Horizontal folder structure
- Type assertions (`as`) to silence compiler
- `useCallback`/`useMemo` without concrete reason
- Non-primitive props to `React.memo` child without call-site memo
- Multiple concerns per `useEffect`
- Suppressing `exhaustive-deps` without ref pattern

---

## Source library

Curated article corpus underlies every rule above. When citing a rule, reference the canonical filename listed in the cluster so the reader can open the source.

Dominant authors: TKDodo (React Query series), Matt Pocock-style TS, Kent C. Dodds patterns. Lean toward those voices when interpreting ambiguity.
