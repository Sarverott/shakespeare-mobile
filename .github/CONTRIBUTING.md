# Contributing to shakespeare-mobile

Thank you for wanting to help! Shakespeare is an app for writers with one simple
goal: **write a book** — easier, better and faster. This repository is its
mobile release (Android and iOS), built with [Capacitor](https://capacitorjs.com).

By taking part you agree to follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## How the project fits together

Shakespeare is split into several repositories that live side by side:

| Repository | Role |
| --- | --- |
| [shakespeare](https://github.com/Sarverott/shakespeare) | Umbrella: vision, docs, shared versioning |
| [shakespeare-gui](https://github.com/Sarverott/shakespeare-gui) | The user interface (Vue), shared by every platform |
| [shakespeare-mobile](https://github.com/Sarverott/shakespeare-mobile) | **This repo**: wraps the GUI into Android and iOS apps |
| [shakespeare-webapp](https://github.com/Sarverott/shakespeare-webapp) | Web client |
| [shakespeare-desktop](https://github.com/Sarverott/shakespeare-desktop) | Desktop client |
| [shakespeare-server](https://github.com/Sarverott/shakespeare-server) | Backend API (Laravel) |

This repo contains only a thin app core (`src/app/`). The interface itself
comes from `shakespeare-gui`, so **changes to screens, components or styles
usually belong there**.

## Setting up

You need:

- Node.js 24 and npm
- [uv](https://docs.astral.sh/uv/) (Python tooling: commitizen, metadata sync)
- [Task](https://taskfile.dev)
- For Android: **JDK 21** and the Android SDK (Android Studio installs it).
  Set `JAVA_HOME` to JDK 21 and `ANDROID_HOME` to the SDK, and in Android Studio
  choose JDK 21 under *Settings → Build, Execution, Deployment → Build Tools →
  Gradle → Gradle JDK*.

Clone `shakespeare-gui` **next to** this repository, because `package.json`
links it from `../shakespeare-gui`:

```sh
git clone https://github.com/Sarverott/shakespeare-gui.git
git clone https://github.com/Sarverott/shakespeare-mobile.git
cd shakespeare-gui && npm install && cd ..
cd shakespeare-mobile && task install
```

Useful tasks (`task --list` shows all of them):

| Task | What it does |
| --- | --- |
| `task dev` | Builds the GUI, then runs the app in the browser with hot reload |
| `task build` | Builds the GUI and the app core into `src/gui` (Capacitor's web directory) |
| `task android` | Builds, syncs and opens the project in Android Studio |
| `task test` | Runs the checks |
| `task lint` | Lints the workflows (actionlint) and the delegated shell scripts (shellcheck) |
| `task gh:loop` | Shows how the craft loop in `.github/bos.config.json` resolves |
| `task commit` | Commits with commitizen |

## Making a change

1. **Open or find an issue** first for anything bigger than a small fix, so we
   can agree on the direction before you spend time on it.
2. **Branch from `development`** and name the branch `feature/<short-name>` or
   `fix/<short-name>`.
3. **Write in English**: code, comments and documentation. The only exception is
   translation (i18n) files. In issues and discussions, Polish and English are
   both welcome.
4. **Commit with `task commit`.** It asks a few questions and writes a
   [Conventional Commits](https://www.conventionalcommits.org) message, such as
   `feat(editor): add chapter word counter` or `fix: keep cursor after save`.
   The git hooks check every message, and these messages build the changelog
   and decide the next version, so please don't skip them.
5. **Push your branch.** A pull request into `development` opens automatically.

### What the hooks do

On every commit, husky runs two hooks:

- **pre-commit** copies the shared project info (name, version, description,
  authors, tags) from `metadata.json` into `package.json`, `pyproject.toml` and
  the lockfiles, then checks that they all match. Edit that info **only in
  `metadata.json`**, and never change the version by hand.
- **commit-msg** rejects messages that don't follow Conventional Commits.

**Routines** are optional steps switched on in `.husky/bos.config.json`;
`task hooks:routines` shows which are on.

- **`auto_gitaddall_before_commit`:** `task commit` stages everything first.
  With a plain `git commit`, the hook adds the rest only when something was
  already staged, because git stops before any hook runs when nothing is staged.
- **`auto_push_after_commit`:** after each commit, the branch is pushed, and
  its upstream is set if needed. It never pushes `master`, a detached HEAD, or
  commits made during a rebase, merge or cherry-pick. A failed push only prints
  a warning, because the commit is already made.

## The craft loop

Work goes around a loop of branches, one pull request per step:

```
feature/*, fix/*  →  development  →  revision  →  testing  →  releasing  →  master
                          ↑                                                    │
                          └────────────────── back-merge ──────────────────────┘
       any stage  →  rejection  →  development
```

- `master` is the canon. Nobody commits to it directly.
- **`.github/bos.config.json` defines the loop:** which branches exist, where
  each one goes next, whether PRs open automatically, and which steps merge on
  their own. To see how it resolves, run `python3 .github/bos/flow.py explain`.
- The PR to the next stage opens automatically. Once its checks pass, it merges
  if the config allows it for that step, and the next step starts. Today
  everything up to `master` merges automatically; the back-merge into
  `development`, `rejection` and your `feature/*`/`fix/*` PRs wait for a person.
- `rejection` is the way back: a maintainer sends work there by hand when a stage
  turns it down, and it returns to `development`.
- The checks are: commit messages, metadata sync, unit tests, Android lint and
  an npm security audit.
- **The workflows stay short.** Every multi-line step lives in
  `scripts/delegated/workflow-gh/<workflow>/<step>.sh`, with a comment on top
  saying what it does, what it reads and what it outputs. The scripts also run
  locally, and `task gh:…` wraps the useful ones.

## Releases

Every pass through `master` is a release, made by CI:

1. The version is bumped once per loop: **Z** (patch) normally, **Y** (minor)
   when the loop contains a breaking change (`feat!: …` or a `BREAKING CHANGE:`
   footer). X only changes by hand. The `versioning` section of
   `bos.config.json` sets this.
2. `metadata.json`, the manifests and `CHANGELOG.md` are updated, then a
   `bump: …` commit and a `vX.Y.Z` tag go to `master`.
3. A signed APK is built and attached to a GitHub Release, with that version's
   notes from `CHANGELOG.md`.
4. The back-merge PR `master → development` opens, carrying the new version
   back to the start of the loop.

Don't run `task bump` yourself, and don't push version tags; CI does both.

## Reporting bugs

Please include:

- what you did, what you expected, and what happened instead
- device or emulator, Android/iOS version, and the app version (the release tag
  you installed)
- screenshots or logs if you have them

Security problems should go privately to **sett@sarverott.com**, not to a public
issue.

## License

Shakespeare is licensed under [CC BY-SA 4.0](../LICENSE). By contributing you
agree that your contributions are licensed under the same terms.
