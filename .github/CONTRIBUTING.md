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

## The branch flow

Work moves through the stages one pull request at a time:

```
feature/*, fix/*  →  development  →  revision  →  testing  →  releasing  →  master
```

- `master` is the canon. Nobody commits to it directly.
- A pull request to the next stage opens automatically on every push. Once all
  checks pass, it merges automatically.
- The checks are: commit messages, metadata sync, unit tests, Android lint and
  an npm security audit.

## Releases

Maintainers cut releases from `master`:

```sh
task bump                 # new version from the commit history, CHANGELOG.md, tag vX.Y.Z
git push --follow-tags    # the tag triggers the release workflow
```

The release workflow builds a signed APK and publishes it on GitHub Releases,
with that version's notes from `CHANGELOG.md`.

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
