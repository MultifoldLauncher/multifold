[![License](https://img.shields.io/github/license/MultifoldLauncher/multifold?style=flat-square)](COPYING)
[![Issues](https://img.shields.io/github/issues/MultifoldLauncher/multifold?style=flat-square)](https://github.com/MultifoldLauncher/multifold/issues)
[![Discord](https://img.shields.io/badge/join-discord-blue?style=flat-square)](https://discord.gg/EzutGmRYnw)

# MultiFold

MultiFold is the next-generation cross-platform Minecraft launcher. This project is currently **work-in-progress**.

## Contributing

You are welcome to submit PRs (pull requests) to MultiFold. Please read [contribution guidelines](CONTRIBUTING.md)
before getting started.

## Development

We recommend using [IntelliJ IDEA (Ultimate)](https://www.jetbrains.com/idea/)
with [Dart Support](https://www.jetbrains.com/help/idea/dart.html) or (VS)Code.

First, install [melos](https://github.com/invertase/melos/) (if you haven't already). Ensure that
your [Pub cache](https://dart.dev/tools/pub/glossary#system-cache) is on your system's PATH.

```bash
$ dart pub global activate melos
```

Then, bootstrap the project by running:

```bash
$ melos bootstrap
```

**Generating code:**

Execute code generation by using:

```bash
$ melos run gen
```

## Licensing

MultiFold is a FOSS (free and open-source software), licensed under [GNU General Public License v3.0](COPYING).
