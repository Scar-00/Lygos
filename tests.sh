CC=bin/lygosc

$CC tests/match.ly -o tests/match -e llvm-ir
$CC tests/member_fn.ly -o tests/member_fn -e llvm-ir
$CC tests/for_loop.ly -o tests/for_loop -e llvm-ir

./tests/match
./tests/member_fn
./tests/for_loop
