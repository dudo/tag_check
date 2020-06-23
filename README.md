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
jobs:
  tag_check:
    name: Tag Check
    runs-on: ubuntu-latest
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      POST_API_URL: "https://api.github.com/repos/${GITHUB_REPOSITORY}/git/refs"
    steps:
      - uses: actions/checkout@v2 # https://github.com/actions/checkout
      - uses: dudo/tag_check@v1
        with:
          git_tag_prefix: v
      - name: Push Tag to GitHub
        run: |
          curl -s -X POST $POST_API_URL \
            -H "Authorization: token ${GITHUB_TOKEN}" \
            -d @- << EOS
          {
            "ref": "refs/tags/${GIT_TAG_NAME}",
            "sha": "${GITHUB_SHA}"
          }
          EOS
```

Or when you want to ensure you updated your version file.

```yaml
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
