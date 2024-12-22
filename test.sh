#!/bin/bash
assert() {
  expected="$1"
  input="$2"

  cargo run -q "$input" > tmp.s
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

echo OK
