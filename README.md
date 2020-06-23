# Github Tag Check

## Supported languages/frameworks

This currently looks for versions in the following files:

- package.json
- ./lib/*/version.rb

## Usage

See action.yml for inputs. The usage is very straightforward:

1. Look for a version within your app.
2. Check GitHub for a matching tag.
3. Exit if a tag is found, or can't reach GitHub.

Use when you want to tag a commit.

```yaml
# .github/workflows/git_tag.yaml

on:
  push:
    branches:
      - master
name: Git Tag
env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
jobs:
  check_version:
    name: Check Version
    runs-on: ubuntu-latest
    outputs:
      git_tag_name: ${{ steps.tag_check.outputs.git_tag_name }}
    steps:
      - uses: actions/checkout@v2 # https://github.com/actions/checkout
      - uses: dudo/tag_check@v1
        id: tag_check
        with:
          git_tag_prefix: v
  push_tag:
    name: Push Tag
    needs: check_version
    runs-on: ubuntu-latest
    steps:
    - name: Push Tag to GitHub
      run: |
        curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
        -d "{\"ref\": \"refs/tags/${{needs.tag_check.outputs.git_tag_name}}\", \"sha\": \"${GITHUB_SHA}\"}" \
        "https://api.github.com/repos/${GITHUB_REPOSITORY}/git/refs"
```

Or when you want to ensure you updated your version file.

```yaml
# .github/workflows/check_tag.yaml

on:
  pull_request:
    branches:
      - master
name: Check Version
jobs:
  check_version:
    name: Check Version
    runs-on: ubuntu-latest
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    steps:
      - uses: actions/checkout@v2 # https://github.com/actions/checkout
      - uses: dudo/tag_check@v1
        with:
          git_tag_prefix: v
```
