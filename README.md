# eget-all

[Eget][] is a tool for installing binary packages from GitHub. Eget-all is a thin wrapper around `eget` that allows you to drive it with a configuration file.

## Prerequisites

- You must have [`eget`][eget] installed somewhere in your `$PATH`.

## Configuration

By default, `eget-alll` will read a list of packages from `$XDG_CONFIG_HOME/eget/packages` (aka `$HOME/.config/eget/packages`). The format of the `packages` file is one package name per line, optionally followed by `eget` command line options. For example:

```
kubernetes-sigs/kind
twpayne/chezmoi -a chezmoi-linux-amd64
argoproj/argo-cd --to argocd
ogham/exa -a ^musl
sharkdp/fd -a ^musl
```

See [`packages.example`](packages.example) for an extended example.

## Usage

To install all of the packages in your configuration file, run:

```
eget-all
```

This will place binaries into `$HOME/lib/eget/bin`. You will need to ensure that your `$PATH` includes that directory. You can override the destination directory by setting the `EGET_TARGET_DIR` environment variable, or by providing the `-t <target_dir>` command line option.

You may provide a single argument which is a regular expression that will be matched against the contents of your `packages` file. Only matching lines will be processed. For example, given the sample `packages` file presented earlier in this document, the following command would install just the `kind` binary:

```
eget-all kind
```

## Authentication

By default, `eget` interacts with GitHub anonymously. If you are installing a large number of packages or just playing with it a bunch you will eventually run into GitHub's API rate limits. You can resolve this by providing `eget` with a GitHub authentication token (PAT). You can either:

- Set the `GITHUB_TOKEN` or `EGET_GITHUB_TOKEN` environment variable to the value of your token, or
- Create a file `$XDG_CONFIG_HOME/eget/github_token` with your token. You can use an alternate file by setting the `EGET_TOKEN_FILE` environment variable or by passing the `-T <token_file>` command line option.

[eget]: https://github.com/zyedidia/eget
