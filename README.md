# spark
### sparklines for your shell

See? Here's a graph of your productivity gains after using spark: ▁▂▃▅▇

## install

spark is a [shell script][bin], so drop it somewhere and make sure it's added
to your `$PATH`. It's helpful if you have a super-neat collection of dotfiles,
[like mine][dotfiles]. Or you can use the following one-liner:

```sh
sudo sh -c "curl https://raw.githubusercontent.com/holman/spark/master/spark -o /usr/local/bin/spark && chmod +x /usr/local/bin/spark"
```

If you're on OS X, spark is also on [Homebrew][brew]:

    brew install spark

Depending on the fonts you have in your system and you use in the
terminal, you might end up with irregular blocks. This is due to some
fonts providing only part of the blocks, while the others are taken from
a different, fallback font. If that happens (or you're piping into a log
that can't render the blocks at all), use `--ascii` for a plain fallback
ramp — see [ops usage](#ops-usage).

## usage

Just run `spark` and pass it a list of numbers (comma-delimited, spaces,
whatever you'd like). It's designed to be used in conjunction with other
scripts that can output in that format.

    spark 0 30 55 80 33 150
    ▁▂▃▅▂▇

Input is forgiving: spaces, commas, semicolons, tabs and newlines all work as
separators, and stray tokens (blanks, labels, units like `99%` or `n/a`) are
skipped rather than breaking the whole line.

A few options let you dress the output up for inspection scripts and reports:

| option | what it does |
| ------ | ------------ |
| `-l, --label TEXT`  | prefix the sparkline with a label |
| `-a, --ascii`       | use a plain ASCII ramp (`.:-=+*#@`) for terminals/fonts that mangle the blocks |
| `-v, --show-values` | print the (cleaned) numbers after the graph |
| `-s, --sep SEP`     | separator used to join values with `--show-values` (default: a space) |

Invoke help with `spark -h`.

## cooler usage

There's a lot of stuff you can do.

Number of commits to the github/github Git repository, by author:

```sh
› git shortlog -s |
      cut -f1 |
      spark
  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▃▁▁▁▁▁▁▁▁▂▁▁▅▁▂▁▁▁▂▁▁▁▁▁▁▁▁▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁
```

Magnitude of earthquakes worldwide 2.5 and above in the last 24 hours:

```sh
› curl -s https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.csv |
  sed '1d' |
  cut -d, -f5 |
  spark
▃█▅▅█▅▃▃▅█▃▃▁▅▅▃▃▅▁▁▃▃▃▃▃▅▃█▅▁▃▅▃█▃▁
```

Code visualization. The number of characters of `spark` itself, by line, ignoring empty lines:

```sh
› awk '{ print length($0) }' spark |
  grep -Ev 0 |
  spark
  ▁▁▁▁▅▁▇▁▁▅▁▁▁▁▁▂▂▁▃▃▁▁▃▁▃▁▂▁▁▂▂▅▂▃▂▃▃▁▆▃▃▃▁▇▁▁▂▂▂▇▅▁▂▂▁▇▁▃▁▇▁▂▁▇▁▁▆▂▁▇▁▂▁▁▂▅▁▂▁▆▇▇▂▁▂▁▁▁▂▂▁▅▁▂▁▁▃▁▃▁▁▁▃▂▂▂▁▁▅▂▁▁▁▁▂▂▁▁▁▂▂
```

Since it's just a shell script, you could pop it in your prompt, too:

```
ruby-1.8.7-p334 in spark/ on master with history: ▂▅▇▂
›
```

## ops usage

spark is handy inside health-check and daily-report scripts, where you want a
metric's shape inline with its name.

Label a single metric so a line is self-explanatory in a noisy log:

```sh
› spark --label cpu 10 20 5 40
cpu  ▂▄▁█
```

Build an inspection summary, one metric per line, and let `column -t` line the
sparklines up (the graph has no internal spaces, so it stays a single column):

```sh
› while read name values; do
      echo "$name $(spark $values)"
  done <<'METRICS' | column -t
  cpu 10 20 5 40
  mem 30 45 60 80
  disk 90 70 50 10
  METRICS
cpu   ▂▄▁█
mem   ▁▃▅█
disk  █▆▄▁
```

On a box whose font mangles the block glyphs — or when piping into something
that can't render them — fall back to a plain ASCII ramp instead of explaining
to everyone that "it's the font, not the script":

```sh
› spark --ascii 1 2 3 4 5
.:=*@
```

For a daily report, show the raw numbers next to the graph and pick a separator
that reads well in the digest. Feed it whatever your monitoring spits out (a
`df` percentage column, say); here it's spelled out so you can reproduce it:

```sh
› printf '45\n62\n88\n30\n' | spark --label disk% --show-values
disk%  ▂▄█▁  45 62 88 30

› spark --show-values --sep , 10 20 5 40
▂▄▁█  10,20,5,40
```

Input from real pipelines is messy, and that's fine — mixed separators, blank
fields and stray tokens are tolerated rather than blowing up the line:

```sh
› printf '10, 20,,5; 40\n' | spark
▂▄▁█
› spark 10 20 n/a 5 99% 40
▂▄▁█
```

## wicked cool usage

Sounds like a wiki is a great place to collect all of your
[wicked cool usage][wiki] for spark.

## contributing

Contributions welcome! Like seriously, I think contributions are real nifty.

Make your changes and be sure the tests all pass:

    ./test

That also means you should probably be adding your own tests as well as changing
the code. Wouldn't want to lose all your good work down the line, after all!

Once everything looks good, open a pull request.

## ▇▁ ⟦⟧ ▇▁

This is a [@holman][holman] joint.

[dotfiles]: https://github.com/holman/dotfiles
[brew]:     https://github.com/mxcl/homebrew
[bin]:      https://github.com/holman/spark/blob/master/spark
[wiki]:     https://github.com/holman/spark/wiki/Wicked-Cool-Usage
[holman]:   https://twitter.com/holman
