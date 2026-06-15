#!/usr/bin/env roundup
#
# Unit tests for spark's internal layers.
# Sources the script directly so each function can be tested in isolation.

describe "spark unit: parse, render, and help layers"

# Source spark — the BASH_SOURCE guard prevents CLI dispatch.
source ./spark

# ── Layer 1: spark_parse ──────────────────────────────────────────────

it_parses_comma_separated_values() {
  result="$(spark_parse 1,2,3)"
  test "$result" = "1 2 3"
}

it_parses_space_separated_values() {
  result="$(spark_parse 1 2 3)"
  test "$result" = "1 2 3"
}

it_parses_mixed_comma_and_space() {
  result="$(spark_parse 1,2 3,4)"
  test "$result" = "1 2 3 4"
}

it_collapses_extra_whitespace() {
  result="$(spark_parse "1   2     3")"
  test "$result" = "1 2 3"
}

it_truncates_decimals() {
  result="$(spark_parse 5.5,20.9,100.1)"
  test "$result" = "5 20 100"
}

it_reads_from_stdin_when_no_args() {
  result="$(echo "4 8 15" | spark_parse)"
  test "$result" = "4 8 15"
}

it_reads_comma_stdin() {
  result="$(echo "1,2,3" | spark_parse)"
  test "$result" = "1 2 3"
}

it_handles_single_value() {
  result="$(spark_parse 42)"
  test "$result" = "42"
}

it_handles_zero_values() {
  result="$(spark_parse 0,0,0)"
  test "$result" = "0 0 0"
}

# ── Layer 2: spark_render ─────────────────────────────────────────────

it_renders_basic_sparkline() {
  result="$(spark_render "1 2 3")"
  test "$result" = "▁▄█"
}

it_renders_constant_data_at_midtier() {
  result="$(spark_render "5 5 5 5")"
  test "$result" = "▅▅▅▅"
}

it_renders_single_value_as_midtier() {
  result="$(spark_render "7")"
  test "$result" = "▅"
}

it_renders_two_values_min_max() {
  result="$(spark_render "0 100")"
  test "$result" = "▁█"
}

it_renders_wide_range() {
  result="$(spark_render "1 2 3 4 100 5 10 20 50 300")"
  test "$result" = "▁▁▁▁▃▁▁▁▂█"
}

it_renders_ascending_sequence() {
  result="$(spark_render "1 2 3 4 5")"
  test "$result" = "▁▂▄▆█"
}

it_renders_empty_input_as_failure() {
  ! spark_render ""
}

# ── Layer 4: spark_help ──────────────────────────────────────────────

it_help_contains_usage() {
  spark_help | grep -q USAGE
}

it_help_contains_examples() {
  spark_help | grep -q EXAMPLES
}

it_help_uses_custom_name() {
  spark_help "mytool" | grep -q "mytool"
}

it_help_defaults_to_spark_name() {
  spark_help | grep -q "spark"
}

# ── Layer 0: Constants ────────────────────────────────────────────────

it_defines_eight_standard_ticks() {
  test "${#SPARK_TICKS[@]}" -eq 8
}

it_defines_two_flat_ticks() {
  test "${#SPARK_FLAT_TICKS[@]}" -eq 2
}
