# CHERI-RISC-V Tests

This uses the standard RISC-V testing framework to test the CHERI-RISC-V ISA.

You will need https://github.com/riscv/riscv-tests to build. It needs the following patch applied in the `env` directory:

```diff
diff --git a/p/riscv_test.h b/p/riscv_test.h
index 7bf35cf..4e4c9a9 100644
--- a/p/riscv_test.h
+++ b/p/riscv_test.h
@@ -158,7 +158,9 @@
 
 #define EXTRA_TVEC_USER
 #define EXTRA_TVEC_MACHINE
-#define EXTRA_INIT
+#ifndef EXTRA_INIT
+# define EXTRA_INIT
+#endif
 #define EXTRA_INIT_TIMER
 #define FILTER_TRAP
 #define FILTER_PAGE_FAULT
```

You will also need an appropriate LLVM, which https://github.com/CTSRD-CHERI/cheribuild can supply (we expect it to be in the nonstandard `~/cheri-riscv64` directory).

Then `make` should build the tests.

To run them (`make run`), we use the SAIL emulator from https://github.com/CTSRD-CHERI/sail-cheri-riscv.
