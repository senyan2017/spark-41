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
a different, fallback font. See the [ASCII fallback](#ascii-fallback)
section below if this is a problem for you.

## usage

Just run `spark` and pass it a list of numbers (comma-delimited, spaces,
newlines, or any mix of the above). It's designed to be used in conjunction
with other scripts that can output in that format.

    spark 0 30 55 80 33 150
    ▁▂▃▅▂▇

Invoke help with `spark -h`.

## options

| Flag | Description |
|------|-------------|
| `-l, --label LABEL` | Prefix output with a label (e.g. metric name) |
| `-a, --ascii` | Use ASCII characters instead of Unicode blocks |
| `-v, --values` | Append raw numeric values after the sparkline |
| `-s, --separator SEP` | Custom separator between sparkline and values (default: ` \| `) |
| `-h, --help` | Show help text |
| `--version` | Show version |

## labeled metrics

Use `-l` / `--label` to prefix the sparkline with a metric name. This is
useful in inspection reports and dashboards where you display multiple
metrics together:

```sh
spark -l CPU 10 20 50 80 95
CPU ▁▂▄▆█

spark -l MEM 1024 2048 512 4096 2048
MEM ▂▄▁█▄
```

## showing raw values

Use `-v` / `--values` to display the raw numbers alongside the sparkline.
Customize the separator with `-s`:

```sh
spark -l MEM -v 1024 2048 512 4096
MEM ▂▄▁█ | 1024 2048 512 4096

spark -v -s " :: " 10 20 30
▁▄█ :: 10 20 30
```

## ASCII fallback

Some terminals and fonts do not render Unicode block characters (`▁▂▃▄▅▆▇█`)
correctly. Use `--ascii` / `-a` to fall back to a plain ASCII character set
(`_. : - = / \ # @`):

```sh
spark --ascii 0 30 55 80 33 150
_.:=.@

spark -l DISK --ascii -v 80 90 70 95
DISK -\_@ | 80 90 70 95
```

This is particularly useful when:
- Running on servers with limited font support (e.g. older Linux consoles)
- Piping output to log files or email where Unicode may be mangled
- Working inside `screen` or `tmux` sessions with broken UTF-8

## dirty data handling

spark is resilient to messy input. Non-numeric values are silently skipped,
and mixed delimiters (commas, spaces, tabs, newlines) are all accepted:

```sh
# Mixed delimiters
echo "1,2 3,4 5" | spark
▁▂▄▆█

# Non-numeric values are skipped
echo "1,N/A,3,--,5" | spark
▁▄█

# Multi-line input (e.g. from another command)
printf "10\n20\n30\n" | spark
▁▄█

# All-garbage input produces a clear message
echo "abc,def" | spark
(no data)
```

## shell pipeline examples

### inspection report

Generate a multi-metric summary for a host inspection script:

```sh
#!/bin/sh
for metric in "CPU:10,20,50,80,95" "MEM:1024,2048,512,4096,2048" "DISK:80,82,85,90,88"; do
  name=${metric%%:*}
  data=${metric#*:}
  spark -l "$name" "$data"
done
```

Output:
```
CPU ▁▂▄▆█
MEM ▂▄▁█▄
DISK ▁▂▄█▆
```

### daily report with values

```sh
spark -l "Daily Users" -v 1200 1350 980 1500 1420
Daily Users ▃▅▁█▆ | 1200 1350 980 1500 1420
```

### git commit activity

```sh
git shortlog -s | cut -f1 | spark
▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▃▁▁▁▁▁▁▁▁▂▁▁▅▁▂▁▁▁▂▁▁▁▁▁▁▁▁▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁
```

### server load averages

```sh
uptime | awk -F'load average:' '{print $2}' | tr ',' '\n' | spark -l LOAD
LOAD ▁▄█
```

### earthquake magnitudes

```sh
curl -s https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.csv |
  sed '1d' |
  cut -d, -f5 |
  spark
▃█▅▅█▅▃▃▅█▃▃▁▅▅▃▃▅▁▁▃▃▃▃▃▅▃█▅▁▃▅▃█▃▁
```

### ASCII mode in log files

```sh
# Safe for log files and email
spark -l "Hourly Requests" --ascii 100 250 180 420 310 500 >> /var/log/report.txt
```

### code visualization

The number of characters of `spark` itself, by line, ignoring empty lines:

```sh
awk '{ print length($0) }' spark | grep -Ev 0 | spark
▁▁▁▁▅▁▇▁▁▅▁▁▁▁▁▂▂▁▃▃▁▁▃▁▃▁▂▁▁▂▂▅▂▃▂▃▃▁▆▃▃▃▁▇▁▁▂▂▂▇▅▁▂▂▁▇▁▃▁▇▁▂▁▇▁▁▆▂▁▇▂▁▁▂▅▁▂▂▁▆▇▇▂▁▂▁▁▁▂▂▁▅▂▁▁▁▃▃▁▁▁▃▂▂▂▁▁▅▂▁▁▁▁▂▂▁▁▁▂▂
```

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
