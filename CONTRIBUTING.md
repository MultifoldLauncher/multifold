# Contributing to Multifold

## Style Guides

### Git Commits

Try to stick to one feature/fix/etc. per commit. If you need to use the word "and" in the subject line, then it should
probably be split into multiple commits.

- Subject line should be formatted as `<type>(area): <short summary>`. Area can be omitted if it applies to all areas, e.g. project build update. Type must be one of the following:
  - build: changes that affect the build system.
  - docs: documentation changes.
  - feat: feature addition.
  - fix: bug fix.
  - perf: performance improvements.
  - refactor: refactoring sections of the codebase.
  - revert: revert a previous commit.
  - style: changes to the code style.
  - test: testing-related.
  - wip: work-in-progress.
- Separate the subject line from the body with a new line (`\n`).
- Do not end the subject line with a period.
- Do not capitalize the first letter of the subject line.
- All body lines should be in sentence case.

> Here is a template you can follow:
> ```
> feat(core): a new feature
> 
> More detailed explanatory text, if necessary. Wrap it to about 72
> characters or so. In some contexts, the first line is treated as
> the subject of the commit and the rest of the text as the body.
> 
> Resolves: #1337
> ```

### Code

TODO

## Coding Practices

TODO

## Misc

This guide was inspired by [Terra's](https://github.com/PolyhedralDev/Terra/blob/master/CONTRIBUTING.md) contribution
guideline.
