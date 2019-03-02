default:
	@grep '^[^ :]\+:' Makefile | grep -ve grep -ve default

clean:
	rm -f untar

untar:
	docker run -v $(CURDIR):/src -w /src untar \
	  crystal build --debug ./src/untar.cr --link-flags "-L/usr/local/lib -ltar" 

docker:
	docker build -t untar .

run: docker untar
	docker run -ti -v $(CURDIR):/src -w /src --privileged untar ./untar

run-gdb: docker untar
	docker run -ti -v $(CURDIR):/src -w /src --privileged untar gdb ./untar

run-valgrind: docker untar
	docker run -ti --ulimit core=0:0 -v $(CURDIR):/src -w /src --privileged untar valgrind --track-origins=yes ./untar

test:
	crystal spec

.PHONY: default docker run run-gdb run-valgrind clean
