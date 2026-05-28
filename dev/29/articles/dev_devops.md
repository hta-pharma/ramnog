# DevOps

This vignette describes the **git actions** and **pre-commit** hooks
that are used to ensure a consistent and high-quality codebase.

These two concepts have different purposes:

- **github actions** are the heart of the CI/CD process for the ramnog
  ecosystem. On each package they run anytime a draft pull-request to
  the main branch is made. They are run using GitHub runners.

- **pre-commit** hooks are run on the developer’s local machine on every
  commit. **NB**. the pre-commit hooks are only run if the pre-commit
  package is installed.

The configuration for both Git-Actions as well as pre-commit hooks is
stored in the ramnog repository and consumed by the remainder of the
ecosystem.

## GitHub Actions

GitHub Actions are a set of automated workflows that are automatically
triggered on specific events in a repository.

In the ramnog ecosystem, the git actions are used to run tests, check
test coverage, check package dependencies and build the documentation
site.

**There are two major flows setup for the ecosystem.**

1.  Check Package 📦
    - Check Package Dependencies
    - License check
    - R-CMD check
    - Test (unittest and their coverage)
    - Git-leaks (Check for secrets)
2.  Release Package 🚀
    - Build and check pkg. tarball
    - Build and deploy documentation site
      - For Pull-requests into `main` a new sub-site is created for
        github pages.
    - Create a release on github
      - Is only run if a tag is created on the `main` branch.

### System setup

The workflows are shared across the {ramnog} ecosystem and the flows are
hosted in the `ramnog` repository and referenced by the {Chef\*}
repositories.

The only logic that is stored in the consumer repositories is the
trigger for the workflows.

*chef\*/.github/workflows/check-package.yaml*

``` yaml
on:
  push:
    branches: [main, stage, dev]
  pull_request:
    branches: [main, stage, dev]
  workflow_dispatch:

name: Check Package 📦

jobs:
  check:
    name: Checks (from ramnog)
    uses: hta-pharma/ramnog/.github/workflows/Check-package.yaml@main
```

The actual workflow is then stored in the `ramnog` repository in the
`.github/workflows` folder. The workflow references multiple subflows
both local and from external repositories.

*ramnog/.github/workflows/Check-package.yaml*

``` yaml
on:
  push:
    branches: [main, stage, dev]
  pull_request:
    branches: [main, stage, dev]
  workflow_dispatch:
  workflow_call:

name: Check Package 📦

jobs:
  audit:
    name: Audit Dependencies 🕵️‍♂️
    uses: insightsengineering/r.pkg.template/.github/workflows/audit.yaml@main

  licenses:
    name: License Check 🃏
    uses: insightsengineering/r.pkg.template/.github/workflows/licenses.yaml@main

  check:
    name: RMD check 📦
    uses: ./.github/workflows/R-CMD-check.yaml

  test:
    name: Test 🧪
    uses: ./.github/workflows/Test.yaml

  gitleaks:
    name: gitleaks 💧
    uses: insightsengineering/r.pkg.template/.github/workflows/gitleaks.yaml@main
    with:
      check-for-pii: false #Currently fails on R packages (not that the test check fails, but that the test fails to run.)
```

#### Updating the workflows

The workflows should be updated in the `ramnog` repository. The
workflows in the consumer repositories simply consume the workflows from
the `ramnog` repository main branch.

If possible, keep any updates to workflows within the two main workflows
(`Check Package` and `Release Package`). Thus, no updates to the
consumer repositories are needed. - Remember that you can use conditions
inside workflows to run different steps based on the event-type.

Note: When testing an update you may want to create a new branch in the
`ramnog` repository and update the workflows in the consumer
repositories to point to the new branch. This will allow you to test the
changes without affecting the main branch.

*chef\*/.github/workflows/check-package.yaml* WHILE TESTING

``` yaml
on:
  push:
    branches: [main, stage, dev]
  pull_request:
    branches: [main, stage, dev]
  workflow_dispatch:

name: Check Package 📦

jobs:
  check:
    name: Checks (from ramnog)
    uses: hta-pharma/ramnog/.github/workflows/Check-package.yaml@feature/new-workflow # <-- new branch
```

## Pre-commit hooks

Pre-commit hooks is a tool that allows you to run a set of checks on
your code before you commit it. These are built on the standard git
hooks, but are easier to manage and share across projects.

The pre-commit hooks are run on every commit. If the hooks fail, the
commit will be aborted. The only downside is that you need to install
the pre-commit package on your machine and activate it for a given
repository.

Individual setup of pre-commit hooks is described in the [pre-commit
documentation](https://pre-commit.com/).

Quickstart

1.  Install pre-commit in the Individual user space (use pip if pipx is
    not installed)

``` yaml
pipx install pre-commit 
```

2.  Install the pre-commit hooks in the repository. **NOTE:** this needs
    to be run in the root of the repository

``` yaml
pre-commit install 
```

3.  Run on all files to check it works:

``` yaml
pre-commit run --all-files 
```

Troubleshooting: `Error: Python not available`

The pre-commit hook requires a python environment. If you do not have
python installed, you can install it using `conda` or `pyenv`.

if you have python3 installed and you get an error that python is not
available you may need to specify that `python3` should be used. This
can be done with either of the following (asumming linux environment):

``` bash
# Create a symlink for python3 in the python bin
sudo ln -s /usr/bin/python3 /usr/bin/python
# Install the python-is-python3 package
sudo apt-get install python-is-python3
```

### Usage

The hooks are run whenever you create a commit. If the hooks fail, the
commit will be aborted. Some of the hooks will automatically fix the
issues, others will only report the issues.

Even if the hooks automatically fix the issues, you will still need to
add the changes to the commit and commit them again.

### System setup

The pre-commits to be run are defined by the `.pre-commit-config.yaml`
file in the root of the repository. Such a file exists in each of the
repositories in the ramnog ecosystem.

For {chef}, {chefStats}, and {chefCriteria} the pre-commit configs are
identical and points to the `org-hook` in ramnog.

*chef\*/.pre-commit-config.yaml*

``` yaml
repos:
-   repo: https://github.com/hta-pharma/ramnog
    rev: v0.1.1
    hooks:
    -   id: org-hook 
```

The `org-hook` is a custom hook that is defined in the ramnog
repository. The hook is defined in the `hooks` folder in the ramnog
repository.

*ramnog/.pre-commit-hooks.yaml*

``` yaml
-   id: org-hook
    name: org-wide hooks
    language: script
    entry: ./run-org-hooks
    verbose: true
    require_serial: true
```

The `org-hook` points to a script that runs pre-commit using a standard
pre-commit config template. The template is likewise stored in the
ramnog repository.

*ramnog/shared-pre-commit-config.yaml*

``` yaml
repos:
-   repo: https://github.com/lorenzwalthert/precommit
    rev: v0.4.0
    hooks: 
    -   id: readme-rmd-rendered
    -   id: parsable-R
    -   id: no-browser-statement
    (...)
```

#### Updating the run hooks:

In order to update the hooks, you need to update the
`shared-pre-commit-config.yaml` file in the ramnog repository.
Furthemore, the hooks in the consumer repos (chef\*) needs to be updated
with the version hosted in ramnog.

You will need to either tag a the ramnog repository following changes
and update the `rev` in the `chef*/.pre-commit-config.yaml` files to the
new tag.

- Updating the rev in the `chef*/.pre-commit-config.yaml` file will
  trigger the pre-commit hooks to update the hooks on the next commit.
- the command `pre-commit auto-update` can be used to update the
  consumer hooks.

Alternatively you can update the consumer `rev` with the latest commit
hash in the ramnog repository.
