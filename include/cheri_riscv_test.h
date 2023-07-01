#define EXTRA_INIT                                                     \
  cspecialrw ct0, DDC, c0;                                              \
  cspecialrw c0, MTDC, ct0;

#include <riscv_test.h>
