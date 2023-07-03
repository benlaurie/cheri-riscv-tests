# Purecap?
#BUILD=~/cheri-riscv64/output/sdk/bin/clang --target=riscv64 -march=rv64imafdcxcheri -mabi=l64pc128d -I ../riscv-tests/env/p -I ../riscv-tests/isa/macros/scalar/ -nostdlib -mno-relax -Wl,-T../riscv-tests/env/p/link.ld
# Hybrid? (Use this for now because then the standard RISC-V preamble mostly works)
BUILD=~/cheri-riscv64/output/sdk/bin/clang --target=riscv64 -march=rv64imafdcxcheri -I include -I ../riscv-tests/env/p -I ../riscv-tests/isa/macros/scalar/ -nostdlib -mno-relax -Wl,-T../riscv-tests/env/p/link.ld
RUN=../sail-cheri-riscv/ocaml_emulator/cheri_riscv_ocaml_sim_RV64

all: out/ld-zero-perm out/ld-no-read out/ld-bounds

clean:
	rm out/*

run: out/*
	for f in $^; do \
		$(RUN) $$f; \
	done

# FIXME: this should check for failure!
out/%: rv64ui/%.S
	$(BUILD) $< -o $@
