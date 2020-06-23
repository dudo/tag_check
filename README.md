# Github Tag Check

## Supported languages/frameworks

This currently looks for versions in the following files:

- package.json
- ./lib/*/version.rb

## Usage

See action.yml for inputs. The usage is very straightforward:

1. Look for a version within your app.
2. Check if the version was updated appropriately.
3. Check GitHub for a matching tag.
4. Exits if a tag is found, or couldn't reach GitHub.

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
      INPUT_GIT_TAG_PREFIX: v
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      POST_API_URL: "https://api.github.com/repos/${GITHUB_REPOSITORY}/git/refs"
    steps:
      - uses: actions/checkout@v2 # https://github.com/actions/checkout
      - uses: dudo/tag_check@v1
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
