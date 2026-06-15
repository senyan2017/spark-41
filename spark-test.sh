#!/usr/bin/env roundup

describe "spark: Generates sparklines for a set of data."

spark="./spark"

# --- Original backward compatibility tests ---

it_shows_help_with_no_argv() {
  $spark -h | grep USAGE
}

it_graphs_argv_data() {
  graph="$($spark 1,5,22,13,5)"
  test "$graph" = '▁▂█▅▂'
}

it_charts_pipe_data() {
  data="0,30,55,80,33,150"
  graph="$(echo $data | $spark)"
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

it_handles_decimals() {
  data="5.5,20"
  graph="$($spark $data)"
  test "$graph" = '▁█'
}

it_charts_100_lt_300() {
  data="1,2,3,4,100,5,10,20,50,300"
  graph="$($spark $data)"
  test "$graph" = '▁▁▁▁▃▁▁▁▂█'
}

it_charts_50_lt_100() {
  data="1,50,100"
  graph="$($spark $data)"
  test "$graph" = '▁▄█'
}

it_charts_4_lt_8() {
  data="2,4,8"
  graph="$($spark $data)"
  test "$graph" = '▁▃█'
}

it_charts_no_tier_0() {
  data="1,2,3,4,5"
  graph="$($spark $data)"
  test "$graph" = '▁▂▄▆█'
}

it_equalizes_at_midtier_on_same_data() {
  data="1,1,1,1"
  graph="$($spark $data)"
  test "$graph" = '▅▅▅▅'
}

# --- Label tests ---

it_shows_label_prefix() {
  graph="$($spark -l CPU 10 20 30 40 50)"
  test "$graph" = 'CPU ▁▂▄▆█'
}

it_shows_long_label() {
  graph="$($spark --label MEMORY 100 200 300)"
  test "$graph" = 'MEMORY ▁▄█'
}

it_shows_empty_label_gracefully() {
  graph="$($spark -l "" 10 20 30)"
  test "$graph" = '▁▄█'
}

# --- ASCII fallback tests ---

it_renders_ascii_fallback() {
  graph="$($spark --ascii 0 50 100)"
  test "$graph" = '_@'  || test "$graph" = '_:@' || echo "$graph" | grep -qv '[▁▂▃▄▅▆▇█]'
}

it_ascii_has_no_unicode_blocks() {
  graph="$($spark -a 0 30 55 80 33 150)"
  # Should NOT contain any Unicode block characters
  if echo "$graph" | grep -q '[▁▂▃▄▅▆▇█]'; then
    return 1
  fi
}

it_ascii_with_label() {
  graph="$($spark -l LOAD --ascii 0 50 100)"
  echo "$graph" | grep -q '^LOAD '
}

it_ascii_constant_data() {
  graph="$($spark -a 5 5 5 5)"
  # Constant data in ASCII should use the equal sign chars
  test "$graph" = '===='
}

# --- Dirty data tests ---

it_skips_na_values() {
  graph="$(echo "1,N/A,3,--,5" | $spark)"
  # Only 1,3,5 should remain -> min=1, max=5
  test "$graph" = '▁▄█'
}

it_handles_mixed_delimiters() {
  graph="$(echo "1,2 3,4 5" | $spark)"
  test "$graph" = '▁▂▄▆█'
}

it_handles_multiline_input() {
  graph="$(printf '10\n20\n30\n' | $spark)"
  test "$graph" = '▁▄█'
}

it_handles_tabs_and_spaces() {
  graph="$(printf '10\t20  30' | $spark)"
  test "$graph" = '▁▄█'
}

it_handles_all_garbage_input() {
  graph="$(echo "abc,def,N/A" | $spark)"
  test "$graph" = '(no data)'
}

it_handles_empty_lines() {
  graph="$(printf '10\n\n20\n\n30\n' | $spark)"
  test "$graph" = '▁▄█'
}

it_handles_negative_numbers() {
  graph="$($spark -10 0 10)"
  # min=-10, max=10, range=20
  # -10 -> idx 0, 0 -> idx ~3 or 4, 10 -> idx 7
  echo "$graph" | grep -q '[▁▂▃▄▅▆▇█]'
}

it_handles_only_one_valid_among_garbage() {
  graph="$(echo "foo,bar,42,baz" | $spark)"
  # Single value = constant
  test "$graph" = '▅'
}

# --- Values display tests ---

it_shows_values_with_flag() {
  graph="$($spark -v 10 20 30)"
  echo "$graph" | grep -q '| 10 20 30'
}

it_shows_values_with_label() {
  graph="$($spark -l MEM -v 1024 2048 512 4096)"
  echo "$graph" | grep -q '^MEM '
  echo "$graph" | grep -q '| 1024 2048 512 4096'
}

it_custom_separator() {
  graph="$($spark -v -s " :: " 10 20 30)"
  echo "$graph" | grep -q ':: 10 20 30'
}

it_shows_values_with_ascii() {
  graph="$($spark -a -v 0 50 100)"
  echo "$graph" | grep -q '| 0 50 100'
  # Ensure no Unicode
  if echo "$graph" | grep -q '[▁▂▃▄▅▆▇█]'; then
    return 1
  fi
}

# --- Version flag ---

it_shows_version() {
  graph="$($spark --version)"
  echo "$graph" | grep -q 'spark'
}

# --- Pipe + ops scenario tests ---

it_inspection_report_style() {
  output=""
  for metric in "CPU:10,20,50,80,95" "MEM:1024,2048,512,4096,2048"; do
    name=${metric%%:*}
    data=${metric#*:}
    line="$($spark -l $name $data)"
    output="${output}${output:+
}${line}"
  done
  echo "$output" | grep -q '^CPU '
  echo "$output" | grep -q '^MEM '
}
