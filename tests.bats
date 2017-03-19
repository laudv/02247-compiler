#!/bin/bash
# Test file for using with bats: https://github.com/sstephenson/bats

# INSTALLATION
# Install bats in macOS by doing: $brew install bats
# for installation for other platforms check: https://github.com/sstephenson/bats/wiki/Install-Bats-Using-a-Package

# RUN
# From the command line: $bats tests.bats

load 'test/bats-support/load'
load 'test/bats-assert/load'

RESULT_OUTPUT="RESULT:"

OK="OK"
NULL_DEREF="NULL_DEREF"
MAYBE_NULL_DEREF="MAYBE_NULL_DEREF"
UNKNOWN_ERROR="UNKNOWN_ERROR"

function createResult() {
	echo $RESULT_OUTPUT $1 "at  " $2
}

function createDerefResult() {
	echo $RESULT_OUTPUT $NULL_DEREF "at  " $1
}

function assert_events_count() {
	assert_equal $(echo $output | grep -o $RESULT_OUTPUT | wc -l | tr -d " ") $1
}

function assert_dereference_at_instruction() {
  	assert_line $(createDerefResult $1)
}

@test "Example 1" {
  run ./opt example1

  assert_events_count 2
  assert_dereference_at_instruction "%7 = load i32, i32* %6, align 4"
  assert_dereference_at_instruction "%9 = load i32, i32* %8, align 4"
}

@test "Example 2" {
  run ./opt example2

  assert_events_count 1
  assert_dereference_at_instruction "%3 = load i32, i32* %2, align 4"
}

@test "Example 3" {
  run ./opt example3

  assert_events_count 1
  assert_dereference_at_instruction "%4 = load i32*, i32** %3, align 8"
}

@test "Example 4" {
  run ./opt example4

  assert_events_count 1
  assert_dereference_at_instruction "%10 = load i32, i32* %9, align 4"
}
