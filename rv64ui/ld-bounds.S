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
#define BASE tdat

RVTEST_RV64U
RVTEST_CODE_BEGIN

  j run_tests;

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
    li t5, 3
    bne TESTNUM, t5, unexpected
    // And it had better be a "length" exception
    csrr t5, mtval
    andi t5, t5, 0x1f
    li t6, CHERI_EXCCODE_LENGTH
    bne t5, t6, unexpected

    RVTEST_PASS
  unexpected:
    RVTEST_FAIL
 
run_tests:
# switch into cap-mode
  lla t0, 1f
  cspecialr ct1, pcc
  csetoffset ct0, ct1, t0
  li t1, 1
  csetflags ct0, ct0, t1
  jr.cap ct0
1:

.option capmode

  cspecialrw c15, DDC, c0
  cllc ct5, tdat
  csetaddr c14, c15, t5
  li t5, 8
  csetbounds c15, c14, t5
  //cspecialrw c0, DDC, c15
  cmove c14, c15

  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------

  //TEST_LD_OP( 2, ld, 0x00ff00ff00ff00ff, %lo(tdat - BASE), 0 );
  TEST_CASE( 2, x13, 0x00ff00ff00ff00ff,
    li x15, 0x00ff00ff00ff00ff;
    cld x13, 0(c14);)

  TEST_CASE( 3, x13, 0x00ff00ff00ff00ff,
    li x15, 0xff00ff00ff00ff00;
    cld x13, 8(c14);)

  RVTEST_FAIL

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
tdat1:  .dword 0x00ff00ff00ff00ff
tdat2:  .dword 0xff00ff00ff00ff00
tdat3:  .dword 0x0ff00ff00ff00ff0
tdat4:  .dword 0xf00ff00ff00ff00f

RVTEST_DATA_END
