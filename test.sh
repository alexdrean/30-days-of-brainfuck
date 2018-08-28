#!/bin/bash

for param in "$*"
do
	cd $param || continue
	sh "compile.sh" || (cd .. && continue)

	./program ../hello_world.bf > hello_world.out
	diff ../hello_world.ref hello_world.out > /dev/null && echo "OK $param HELLO_WORLD" || echo "ERROR $param HELLO_WORLD ERROR"

	./program ../hello_nested_world.bf > hello_nested_world.out
	diff ../hello_nested_world.ref hello_nested_world.out > /dev/null && echo "OK $param HELLO_NESTED_WORLD" || echo "ERROR $param HELLO_NESTED_WORLD"

	echo "187438238" | ./program ../factor.bf > factor.out
	diff ../factor.ref factor.out > /dev/null && echo "OK $param FACTOR" || echo "ERROR $param FACTOR"
	cd ..
done
