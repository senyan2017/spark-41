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
a different, fallback font.

## usage

Just run `spark` and pass it a list of numbers (comma-delimited, spaces,
whatever you'd like). It's designed to be used in conjunction with other
scripts that can output in that format.

    spark 0 30 55 80 33 150
    ▁▂▃▅▂▇

Invoke help with `spark -h`.

### input format

spark accepts both integers and decimal (floating-point) numbers, and
fully supports negative values:

    spark -5 -3 -1 0 2
    ▁▃▅▆█

    spark 0.1 0.5 0.9
    ▁▄█

Decimal precision is preserved during normalization, so small variations
in monitoring data (e.g. temperature offsets, latency deltas) remain
visible in the sparkline rather than being flattened to zero.

Values may be separated by commas, spaces, or a mix of both. Empty
fields produced by consecutive delimiters (`1,,3`), leading/trailing
delimiters (`,1,5,`), or extra whitespace are silently skipped.
Non-numeric tokens are skipped with a warning on stderr. If no valid
numeric data is found, spark prints an error and exits with a non-zero
status.

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
