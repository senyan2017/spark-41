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

it_charts_all_negative_data() {
  data="-5 -3 -8 -1"
  graph="$($spark $data)"

  test $graph = '▄▆▁█'
}

it_charts_mixed_sign_data() {
  data="-2 0 2"
  graph="$($spark $data)"

  test $graph = '▁▄█'
}

it_keeps_decimals_distinct() {
  data="0.4 0.9"
  graph="$($spark $data)"

  test $graph = '▁█'
}

it_charts_pure_decimal_series() {
  data="0.1,0.4,0.5,0.9"
  graph="$($spark $data)"

  test $graph = '▁▃▄█'
}

it_ignores_empty_fields() {
  graph="$($spark '1,,2,')"

  test $graph = '▁█'
}

it_ignores_surrounding_whitespace() {
  graph="$($spark ' 1  2 ')"

  test $graph = '▁█'
}

it_rejects_non_numeric_input() {
  if out="$($spark 1 2 foo 4 2>/dev/null)"; then
    return 1
  fi

  test -z "$out"
}

it_rejects_input_with_no_numbers() {
  if out="$($spark ' , , ' 2>/dev/null)"; then
    return 1
  fi

  test -z "$out"
}
