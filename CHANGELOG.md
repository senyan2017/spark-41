# changes

## 1.1.0

A round of features aimed at using spark inside health-check and report scripts:

- `--label TEXT` prefixes the sparkline so a line says which metric it is.
- `--ascii` swaps the unicode blocks for a plain `.:-=+*#@` ramp, for terminals
  and fonts that mangle the block glyphs.
- `--show-values` prints the numbers next to the graph, and `--sep` controls how
  they're joined (handy for daily reports).
- Input parsing is now forgiving: spaces, commas, semicolons, tabs and newlines
  all separate values, and blanks/labels/units are skipped instead of breaking
  the whole line.

## 1.0.0

Hey! A 1.0! Now's a decent time as any. Starting to cut versions just for the
sake of things like Homebrew. So, might as well start with 1.0.

1.0 encompasses things that happened during
[the first week](https://zachholman.com/posts/from-hack-to-popular-project/)
of development.