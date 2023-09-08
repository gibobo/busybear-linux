all: busybear.bin

clean:
	rm -fr \
		build \
		src/riscv-pk/build/bbl \
		src/linux/vmlinux \
		src/busybox/busybox

distclean: clean
	rm -fr archives

busybear.bin:
	./scripts/build.sh

archive:
	tar --exclude build --exclude archives --exclude busybear.bin \
	    -C .. -cjf ../busybear-linux.tar.bz2 busybear-linux
