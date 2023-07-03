# See LICENSE for license details.

#*****************************************************************************
# ld.S
#-----------------------------------------------------------------------------
#
# Test ld instruction.
#

#include "cheri_riscv_test.h"
#include "test_macros.h"
#include "cherireg.h"

#define DDC 1

RVTEST_RV64U
RVTEST_CODE_BEGIN

  j run_tests

mtvec_handler:
  csrr t5, mcause
  li t6, 0x1c
  beq t5, t6, cap_exception
  j other_exception
  
  cap_exception:
    // Restore DDC in case that's the problem
    cspecialrw ct5, MTDC, c0
    cspecialrw c0, DDC, ct5
    // For this test, we are expecting an exception
    li t5, 2
    beq TESTNUM, t5, expected
    RVTEST_FAIL
  expected:
    RVTEST_PASS
 
run_tests:
  li x14, ~CHERI_PERM_LOAD
  cspecialrw c15, DDC, c0
  candperm c15, c15, x14
  cspecialrw c0, DDC, c15

  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------

  TEST_LD_OP( 2, ld, 0x00ff00ff00ff00ff, 0,  tdat );
  RVTEST_FAIL

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

in_test: .dword 0

tdat:
tdat1:  .dword 0x00ff00ff00ff00ff
tdat2:  .dword 0xff00ff00ff00ff00
tdat3:  .dword 0x0ff00ff00ff00ff0
tdat4:  .dword 0xf00ff00ff00ff00f

RVTEST_DATA_END
