#!/usr/bin/env roundup

describe "spark integration: end-to-end CLI behavior"

spark="./spark"

# ── Help / Usage ──────────────────────────────────────────────────────

# NOTE: "no args + tty stdin shows help" is a convenience feature that
# can only be verified in an interactive terminal.  Under CI / non-tty
# runners the script reads stdin (which is empty), so we test the
# reliable flag-based paths here instead.
it_shows_help_with_h_flag() {
  $spark -h | grep USAGE
}

it_shows_help_with_help_flag() {
  $spark --help | grep USAGE
}

# ── Argument Input ────────────────────────────────────────────────────

it_graphs_comma_separated_argv() {
  graph="$($spark 1,5,22,13,5)"
  test "$graph" = '▁▂█▅▂'
}

it_graphs_space_separated_argv() {
  graph="$($spark 1 5 22 13 5)"
  test "$graph" = '▁▂█▅▂'
}

it_charts_100_lt_300() {
  graph="$($spark 1,2,3,4,100,5,10,20,50,300)"
  test "$graph" = '▁▁▁▁▃▁▁▁▂█'
}

it_charts_50_lt_100() {
  graph="$($spark 1,50,100)"
  test "$graph" = '▁▄█'
}

it_charts_4_lt_8() {
  graph="$($spark 2,4,8)"
  test "$graph" = '▁▃█'
}

it_charts_no_tier_0() {
  graph="$($spark 1,2,3,4,5)"
  test "$graph" = '▁▂▄▆█'
}

# ── Stdin Input ───────────────────────────────────────────────────────

it_charts_piped_comma_data() {
  graph="$(echo "0,30,55,80,33,150" | $spark)"
  test "$graph" = '▁▂▃▄▂█'
}

it_charts_piped_space_data() {
  graph="$(echo "0 30 55 80 33 150" | $spark)"
  test "$graph" = '▁▂▃▄▂█'
}

it_charts_spaced_data() {
  data="0 30 55 80 33 150"
  graph="$($spark $data)"
  test "$graph" = '▁▂▃▄▂█'
}

it_charts_way_spaced_data() {
  data="0 30               55 80 33     150"
  graph="$($spark $data)"
  test "$graph" = '▁▂▃▄▂█'
}

# ── Edge Cases ────────────────────────────────────────────────────────

it_handles_decimals() {
  graph="$($spark 5.5,20)"
  test "$graph" = '▁█'
}

it_equalizes_at_midtier_on_same_data() {
  graph="$($spark 1,1,1,1)"
  test "$graph" = '▅▅▅▅'
}
