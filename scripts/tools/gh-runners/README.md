# gh-runners

Self-hosted GitHub Actions runners for the Shakespeare repositories, as docker compose services.
Not used by any workflow yet. To use them, a job switches from `runs-on: ubuntu-latest` to
`runs-on: [self-hosted, shakespeare]`.

## How it works

- **One job per container.** Each runner is *ephemeral*: it registers, runs exactly one job,
  deregisters, and the container restarts clean for the next one. Workspaces never survive a job.
  The caches (`toolcache`, `gradle`, `npm` volumes) do, so repeated builds stay fast.
- **The token stays out of the jobs.** `entrypoint.sh` runs as root and is the only process that
  sees `ACCESS_TOKEN`. It uses the token to get a short-lived registration token, then starts the
  runner as the unprivileged `runner` user with a clean environment.
- **Same tools as GitHub's ubuntu-latest, as far as our workflows need:** git, curl, jq, Python,
  JDK 21 and the Android SDK (`platforms;android-36`, `build-tools;35.0.0`). Node.js, uv and the
  JDK for Gradle still come from the `setup-*` actions.
- **Versions are pinned and checksummed** in the `Dockerfile`. GitHub stops sending jobs to
  runners that are too old, so run `task bump-versions` now and then, update the `ARG`s, and
  rebuild.

## Use

Docker must be usable without sudo (`sudo usermod -aG docker $USER`, then log in again).

```sh
task -d scripts/tools/gh-runners up              # build and start (1 runner)
RUNNERS=3 task -d scripts/tools/gh-runners up    # or more
task -d scripts/tools/gh-runners status          # what GitHub sees
task -d scripts/tools/gh-runners logs
task -d scripts/tools/gh-runners down            # stop; runners deregister themselves
```

`up` takes the token from `gh auth token`. That works, but it is your full GitHub login. A
fine-grained token limited to this repository with **Administration: read and write** is the
least privilege. Put it in `.env` as `ACCESS_TOKEN` (see `.env.example`; `.env` is git-ignored).

## Before a workflow uses them

The Shakespeare repositories are public. A self-hosted runner executes whatever a pull request's
code tells it to, on your machine. So:

- never route `pull_request` jobs from **forks** to these runners;
- in the repo settings, under *Actions → General → Fork pull request workflows*, require approval
  for all outside contributors;
- prefer them for trusted jobs first: `release.yml`, `bos-flow.yml`, and checks of the loop's own PRs.
