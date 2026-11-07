# zsh plugins

Third-party oh-my-zsh plugins live in `configs/user/zsh/.zsh/oh-my-zsh/custom/plugins/`. They are **vendored**: the plugin's files are committed directly into this repo, with no nested `.git/` directory.

`encamp-sync pull` only fetches and fast-forwards this repo and does not run any submodule commands. A plugin that is a nested git repository (or a submodule) arrives on other machines as an empty folder.

## Adding a plugin

```sh
cd configs/user/zsh/.zsh/oh-my-zsh/custom/plugins
git clone --depth 1 https://github.com/<owner>/<plugin>
rm -rf <plugin>/.git
```

Delete the `.git/` directory **before** running `git add`. Otherwise git records the folder as a gitlink (a single commit pointer) and none of the files are committed. Then add `<plugin>` to the `plugins=(...)` list in the zshrc, and commit.

## Updating a plugin

The vendored copy does not track upstream, so update it by replacing it with a fresh clone:

```sh
cd configs/user/zsh/.zsh/oh-my-zsh/custom/plugins
git clone --depth 1 https://github.com/<owner>/<plugin> /tmp/<plugin>-new
rm -rf /tmp/<plugin>-new/.git
rm -rf <plugin>
mv /tmp/<plugin>-new <plugin>
git diff --stat   # review what changed upstream
```

Removing the old copy first means files deleted upstream are also deleted here. Commit with the upstream version or commit hash in the message, because this repo doesn't store it anywhere else.

## Vendored plugins

| Plugin | Upstream | Vendored at |
|---|---|---|
| `zsh-nvm` | https://github.com/lukechilds/zsh-nvm | `745291d` (2023-07-13) |
