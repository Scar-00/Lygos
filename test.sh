CC=bin/lygosc

$CC tests/match.ly -o tests/match -e llvm-ir
$CC tests/member_fn.ly -o tests/member_fn -e llvm-ir
$CC tests/for_loop.ly -o tests/for_loop -e llvm-ir
$CC tests/init_list.ly -o tests/init_list -e llvm-ir
$CC tests/macro.ly -o tests/macro -e llvm-ir
$CC tests/trait.ly -o tests/trait -e llvm-ir

./tests/match
./tests/member_fn
./tests/for_loop
./tests/init_list
./tests/macro
./tests/trait
