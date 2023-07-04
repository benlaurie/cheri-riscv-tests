/*
   Copyright 2023 Ben Laurie

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

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
    cspecialr ct5, MTDC
    cspecialw DDC, ct5
    // For this test, we are expecting an exception
    li t5, 2
    bne TESTNUM, t5, unexpected
    // And it had better be a load exception
    csrr t5, mtval
    andi t5, t5, 0x1f
    li t6, CHERI_EXCCODE_PERM_LOAD
    bne t5, t6, unexpected
    RVTEST_PASS
  unexpected:
    RVTEST_FAIL
 
run_tests:
  li x14, 0
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
