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

it_handles_all_negative_data() {
  graph="$($spark -5,-3,-1)"

  test $graph = '▁▄█'
}

it_handles_all_negative_spread() {
  graph="$($spark -10,-7,-5,-3,-1)"

  test $graph = '▁▃▄▆█'
}

it_handles_mixed_positive_negative() {
  graph="$($spark -10,0,10)"

  test $graph = '▁▄█'
}

it_handles_negative_and_positive_spread() {
  graph="$($spark -5,-3,-1,0,2)"

  test $graph = '▁▃▅▆█'
}

it_handles_decimals_with_precision() {
  graph="$($spark 0.1,0.5,0.9)"

  test $graph = '▁▄█'
}

it_handles_small_decimal_variations() {
  graph="$($spark 0.4,0.6,0.9)"

  test $graph = '▁▃█'
}

it_handles_negative_decimals() {
  graph="$($spark -2.5,-1.0,0.5)"

  test $graph = '▁▄█'
}

it_handles_all_negative_constant() {
  graph="$($spark -3,-3,-3)"

  test $graph = '▅▅▅'
}

it_handles_all_zeros() {
  graph="$($spark 0,0,0)"

  test $graph = '▅▅▅'
}

it_handles_single_value() {
  graph="$($spark 42)"

  test $graph = '▅'
}

it_skips_empty_fields() {
  graph="$($spark 1,,3,5)"

  test $graph = '▁▄█'
}

it_handles_consecutive_commas() {
  graph="$($spark 1,,,5)"

  test $graph = '▁█'
}

it_handles_trailing_comma() {
  graph="$($spark 1,5,)"

  test $graph = '▁█'
}

it_handles_leading_comma() {
  graph="$($spark ,1,5)"

  test $graph = '▁█'
}

it_warns_on_non_numeric_input() {
  graph="$($spark 1,abc,3 2>/dev/null)"

  test $graph = '▁█'
}

it_fails_on_no_valid_data() {
  $spark abc,def 2>/dev/null
  test $? -ne 0
}

it_fails_on_empty_input() {
  $spark ,,, 2>/dev/null
  test $? -ne 0
}
