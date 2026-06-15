#!/usr/bin/env roundup

describe "spark: Generates sparklines for a set of data."

spark="./spark"

it_shows_help_with_no_argv() {
  $spark | grep USAGE
}

it_graphs_argv_data() {
  graph="$($spark 1,5,22,13,5)"

  test $graph = '▁▂█▅▂'
}

it_charts_pipe_data() {
  data="0,30,55,80,33,150"
  graph="$(echo $data | $spark)"

  test $graph = '▁▂▃▄▂█'
}

it_charts_spaced_data() {
  data="0 30 55 80 33 150"
  graph="$($spark $data)"

  test $graph = '▁▂▃▄▂█'
}

it_charts_way_spaced_data() {
  data="0 30               55 80 33     150"
  graph="$($spark $data)"

  test $graph = '▁▂▃▄▂█'
}

it_handles_decimals() {
  data="5.5,20"
  graph="$($spark $data)"

  test $graph = '▁█'
}

it_charts_100_lt_300() {
  data="1,2,3,4,100,5,10,20,50,300"
  graph="$($spark $data)"

  test $graph = '▁▁▁▁▃▁▁▁▂█'
}

it_charts_50_lt_100() {
  data="1,50,100"
  graph="$($spark $data)"

  test $graph = '▁▄█'
}

it_charts_4_lt_8() {
  data="2,4,8"
  graph="$($spark $data)"

  test $graph = '▁▃█'
}

it_charts_no_tier_0() {
  data="1,2,3,4,5"
  graph="$($spark $data)"

  test $graph = '▁▂▄▆█'
}

it_equalizes_at_midtier_on_same_data() {
  data="1,1,1,1"
  graph="$($spark $data)"

  test $graph = '▅▅▅▅'
}

# --- labels -----------------------------------------------------------------

it_prefixes_a_label() {
  graph="$($spark --label cpu 1 2 3)"

  test "$graph" = 'cpu  ▁▄█'
}

it_supports_label_equals_form() {
  graph="$($spark --label=cpu 1 2 3)"

  test "$graph" = 'cpu  ▁▄█'
}

it_ignores_an_empty_label() {
  graph="$($spark --label '' 1 2 3)"

  test "$graph" = '▁▄█'
}

# --- ascii fallback for terminals/fonts that mangle the block glyphs --------

it_renders_an_ascii_fallback() {
  graph="$($spark --ascii 1 2 3)"

  test "$graph" = '.=@'
}

it_renders_ascii_for_constant_data() {
  graph="$($spark --ascii 5 5 5)"

  test "$graph" = '==='
}

# --- configurable output: raw values and separators -------------------------

it_shows_raw_values() {
  graph="$($spark --show-values 1 2 3)"

  test "$graph" = '▁▄█  1 2 3'
}

it_joins_values_with_a_custom_sep() {
  graph="$($spark --show-values --sep , 1 2 3)"

  test "$graph" = '▁▄█  1,2,3'
}

it_truncates_decimals_in_shown_values() {
  graph="$($spark --show-values 5.5 20)"

  test "$graph" = '▁█  5 20'
}

# --- forgiving parsing of dirty / piped data --------------------------------

it_skips_non_numeric_tokens() {
  graph="$($spark 1 foo 2 bar 3)"

  test "$graph" = '▁▄█'
}

it_skips_values_carrying_units() {
  graph="$($spark 1 99% 2 n/a 3)"

  test "$graph" = '▁▄█'
}

it_treats_semicolons_as_separators() {
  graph="$($spark '1;2;3')"

  test "$graph" = '▁▄█'
}

it_survives_blanks_between_commas() {
  graph="$($spark '1,,2,,3')"

  test "$graph" = '▁▄█'
}

it_returns_empty_for_all_dirty_data() {
  graph="$($spark foo bar baz)"

  test -z "$graph"
}

# --- combinations and pipes -------------------------------------------------

it_combines_label_ascii_and_values() {
  graph="$($spark --label net --ascii --show-values 1 2 3)"

  test "$graph" = 'net  .=@  1 2 3'
}

it_charts_piped_data_with_flags() {
  graph="$(echo '1 2 3' | $spark --ascii)"

  test "$graph" = '.=@'
}
