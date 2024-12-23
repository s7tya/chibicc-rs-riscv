#!/bin/bash
assert() {
  expected="$1"
  input="$2"

  cargo run -q -- "$input" > tmp.s
  riscv64-elf-gcc -o tmp tmp.s
  qemu-riscv64 ./tmp
  actual="$?"

  if [ "$actual" = "$expected" ]; then
    echo "$input => $actual"
  else
    echo "$input => $expected expected, but got $actual"
    exit 1
  fi
}

assert 0 0
assert 42 42
assert 21 "5+20-4"
assert 41 " 12 + 34 - 5 "
assert 20 "5+5*3"
assert 30 "(5+5)*3"
assert 2 "-3+5"
assert 13 "+3+10"

echo OK
