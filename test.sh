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

assert 0 "0;"
assert 42 "42;"

assert 21 "5+20-4;"

assert 41 " 12 + 34 - 5 ;"

assert 20 "5+5*3;"

assert 30 "(5+5)*3;"

assert 2 "-3+5;"
assert 13 "+3+10;"

assert 1 "20==10*2;"
assert 0 "20==10*3;"

assert 1 "5>0;"
assert 0 "0>5;"
assert 0 "5>5;"

assert 1 "0<5;"
assert 0 "5<0;"
assert 0 "5<5;"

assert 1 "5>=5;"
assert 1 "5<=5;"

assert 1 "10>=5;"
assert 0 "5>=10;"

assert 1 "5<=10;"
assert 0 "10<=5;"

assert 3 '1; 2; 3;'

echo OK
