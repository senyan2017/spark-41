# changes

## 1.1.0

New features for ops and scripting workflows:

- **Labels**: `-l` / `--label` prefixes the sparkline with a metric name
- **ASCII fallback**: `-a` / `--ascii` renders with plain ASCII characters
  (`_. : - = / \ # @`) for terminals or fonts that don't support Unicode blocks
- **Values display**: `-v` / `--values` appends raw numbers after the sparkline,
  with a customizable separator via `-s` / `--separator`
- **Dirty data handling**: non-numeric tokens are silently skipped; mixed
  delimiters (commas, spaces, tabs, newlines) all work
- **Version flag**: `--version` prints the spark version

## 1.0.0

Hey! A 1.0! Now's a decent time as any. Starting to cut versions just for the
sake of things like Homebrew. So, might as well start with 1.0.

1.0 encompasses things that happened during
[the first week](https://zachholman.com/posts/from-hack-to-popular-project/)
of development.
