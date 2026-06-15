#!/usr/bin/env roundup
#
# Tests for spark, organised in two tiers:
#
#   * unit        - source spark and exercise each pipeline layer
#                   (_spark_tokenize / _spark_normalize / _spark_charset) and
#                   the boundary behaviour of the renderer in isolation, so a
#                   change to one layer fails close to its cause.
#   * integration - run ./spark as a subprocess to cover the CLI: help, the
#                   stdin/argv fallback, and the full pipeline end to end.
#

describe "spark: Generates sparklines for a set of data."

# Sourcing defines the spark() pipeline and its _spark_* helpers WITHOUT
# running the CLI (BASH_SOURCE != $0), which is exactly what the unit tier
# relies on. $spark_bin is the executable, used by the integration tier.
. ./spark
spark_bin="./spark"

# --- unit: input parsing ---------------------------------------------------

it_tokenize_treats_commas_as_spaces() {
  test "$(_spark_tokenize 1,2,3)" = "1 2 3"
}

it_tokenize_handles_mixed_separators() {
  test "$(_spark_tokenize "1,2 3")" = "1 2 3"
}

it_tokenize_joins_multiple_args() {
  test "$(_spark_tokenize 1 2 3)" = "1 2 3"
}

# --- unit: numeric normalisation -------------------------------------------

it_normalize_passes_integers_through() {
  test "$(_spark_normalize 1 2 3)" = "1 2 3"
}

it_normalize_truncates_decimals() {
  test "$(_spark_normalize 5.5 20.1)" = "5 20"
}

# truncation, not rounding: 9.99 must become 9 (would be 10 if rounded)
it_normalize_truncates_rather_than_rounds() {
  test "$(_spark_normalize 9.99)" = "9"
}

# --- unit: charset selection -----------------------------------------------

it_charset_uses_constant_pair_when_flat() {
  test "$(_spark_charset 7 7)" = "▅ ▆"
}

it_charset_uses_full_ramp_when_varied() {
  test "$(_spark_charset 0 9)" = "▁ ▂ ▃ ▄ ▅ ▆ ▇ █"
}

# --- unit: rendering boundaries --------------------------------------------

# a single value has no range, so it is a "constant" series -> mid-height glyph
it_render_single_value_is_midtier() {
  test "$(spark 5)" = '▅'
}

# a flat series stays mid-height rather than collapsing to a row of ▁
it_render_flat_series_is_midtier() {
  test "$(spark 1 1 1 1)" = '▅▅▅▅'
}

# the minimum always maps to the lowest glyph and the maximum to the highest
it_render_min_and_max_hit_the_ends() {
  test "$(spark 1 2)" = '▁█'
}

# --- integration: CLI / help -----------------------------------------------

it_shows_help_with_dash_h() {
  $spark_bin -h | grep -q USAGE
}

it_shows_help_with_long_help_flag() {
  $spark_bin --help | grep -q USAGE
}

# --- integration: full pipeline --------------------------------------------

it_graphs_argv_data() {
  test "$($spark_bin 1,5,22,13,5)" = '▁▂█▅▂'
}

it_charts_pipe_data() {
  test "$(echo 0,30,55,80,33,150 | $spark_bin)" = '▁▂▃▄▂█'
}

it_charts_spaced_data() {
  test "$($spark_bin 0 30 55 80 33 150)" = '▁▂▃▄▂█'
}

it_charts_way_spaced_data() {
  test "$($spark_bin 0 30               55 80 33     150)" = '▁▂▃▄▂█'
}

it_handles_decimals() {
  test "$($spark_bin 5.5,20)" = '▁█'
}

it_charts_100_lt_300() {
  test "$($spark_bin 1,2,3,4,100,5,10,20,50,300)" = '▁▁▁▁▃▁▁▁▂█'
}

it_charts_50_lt_100() {
  test "$($spark_bin 1,50,100)" = '▁▄█'
}

it_charts_4_lt_8() {
  test "$($spark_bin 2,4,8)" = '▁▃█'
}

it_charts_no_tier_0() {
  test "$($spark_bin 1,2,3,4,5)" = '▁▂▄▆█'
}

it_equalizes_at_midtier_on_same_data() {
  test "$($spark_bin 1,1,1,1)" = '▅▅▅▅'
}
