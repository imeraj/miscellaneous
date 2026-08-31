.SUFFIXES: .erl .beam .yrl

.erl.beam:
	erlc -W $<

MODS = example unit_test

all: 	 ${MODS:%=%.beam} example example_drv.so
	@erl -noshell -s unit_test start
example:  example.c erl_comm.c example_driver.c
	gcc -o example example.c erl_comm.c example_driver.c
example_drv.so: example.c
	gcc -I /usr/local/lib/erlang/usr/include\
            -o example_drv.so -fPIC -bundle -flat_namespace -undefined suppress\
            example.c
clean:
	rm example example_drv.so *.beam
