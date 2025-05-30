; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck %s -check-prefix=GFX9
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1200 < %s | FileCheck %s -check-prefix=GFX12

; We have an indirect call with a known set of callees, which are
; known to not need any special inputs. The ABI still needs to use the
; register

; FIXME: Passing real values for workitem ID, and 0s that can be undef

define amdgpu_kernel void @indirect_call_known_no_special_inputs() {
; GFX9-LABEL: indirect_call_known_no_special_inputs:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_add_u32 flat_scratch_lo, s12, s17
; GFX9-NEXT:    s_addc_u32 flat_scratch_hi, s13, 0
; GFX9-NEXT:    s_add_u32 s0, s0, s17
; GFX9-NEXT:    s_addc_u32 s1, s1, 0
; GFX9-NEXT:    s_mov_b32 s13, s15
; GFX9-NEXT:    s_mov_b32 s12, s14
; GFX9-NEXT:    s_mov_b64 s[14:15], 0
; GFX9-NEXT:    s_load_dword s17, s[14:15], 0x0
; GFX9-NEXT:    s_getpc_b64 s[14:15]
; GFX9-NEXT:    s_add_u32 s14, s14, wobble@gotpcrel32@lo+4
; GFX9-NEXT:    s_addc_u32 s15, s15, wobble@gotpcrel32@hi+12
; GFX9-NEXT:    s_getpc_b64 s[18:19]
; GFX9-NEXT:    s_add_u32 s18, s18, snork@gotpcrel32@lo+4
; GFX9-NEXT:    s_addc_u32 s19, s19, snork@gotpcrel32@hi+12
; GFX9-NEXT:    s_load_dwordx2 s[20:21], s[18:19], 0x0
; GFX9-NEXT:    s_load_dwordx2 s[22:23], s[14:15], 0x0
; GFX9-NEXT:    v_lshlrev_b32_e32 v2, 20, v2
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_and_b32 s14, 1, s17
; GFX9-NEXT:    s_cmp_eq_u32 s14, 1
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 10, v1
; GFX9-NEXT:    s_cselect_b32 s19, s23, s21
; GFX9-NEXT:    s_cselect_b32 s18, s22, s20
; GFX9-NEXT:    v_or3_b32 v31, v0, v1, v2
; GFX9-NEXT:    s_mov_b32 s14, s16
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    v_mov_b32_e32 v4, 0
; GFX9-NEXT:    s_mov_b32 s32, 0
; GFX9-NEXT:    s_swappc_b64 s[30:31], s[18:19]
; GFX9-NEXT:    s_endpgm
;
; GFX12-LABEL: indirect_call_known_no_special_inputs:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_mov_b64 s[10:11], s[6:7]
; GFX12-NEXT:    s_getpc_b64 s[6:7]
; GFX12-NEXT:    s_sext_i32_i16 s7, s7
; GFX12-NEXT:    s_add_co_u32 s6, s6, snork@gotpcrel32@lo+8
; GFX12-NEXT:    s_add_co_ci_u32 s7, s7, snork@gotpcrel32@hi+16
; GFX12-NEXT:    s_mov_b64 s[8:9], s[4:5]
; GFX12-NEXT:    s_mov_b64 s[4:5], 0
; GFX12-NEXT:    s_getpc_b64 s[12:13]
; GFX12-NEXT:    s_sext_i32_i16 s13, s13
; GFX12-NEXT:    s_add_co_u32 s12, s12, wobble@gotpcrel32@lo+8
; GFX12-NEXT:    s_add_co_ci_u32 s13, s13, wobble@gotpcrel32@hi+16
; GFX12-NEXT:    s_load_u8 s14, s[4:5], 0x0
; GFX12-NEXT:    s_load_b64 s[4:5], s[6:7], 0x0
; GFX12-NEXT:    s_load_b64 s[6:7], s[12:13], 0x0
; GFX12-NEXT:    v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v4, 0
; GFX12-NEXT:    v_mov_b32_e32 v31, v0
; GFX12-NEXT:    s_mov_b32 s32, 0
; GFX12-NEXT:    s_wait_kmcnt 0x0
; GFX12-NEXT:    s_and_b32 s12, 1, s14
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX12-NEXT:    s_cmp_eq_u32 s12, 1
; GFX12-NEXT:    s_cselect_b32 s13, s7, s5
; GFX12-NEXT:    s_cselect_b32 s12, s6, s4
; GFX12-NEXT:    s_mov_b64 s[4:5], s[0:1]
; GFX12-NEXT:    s_mov_b64 s[6:7], s[2:3]
; GFX12-NEXT:    s_swappc_b64 s[30:31], s[12:13]
; GFX12-NEXT:    s_endpgm

bb:
  %cond = load i1, ptr addrspace(4) null
  %tmp = select i1 %cond, ptr @wobble, ptr @snork
  call void %tmp(ptr poison, i32 undef, ptr poison)
  ret void
}

define void @wobble() {
; GFX9-LABEL: wobble:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX12-LABEL: wobble:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-NEXT:    s_wait_expcnt 0x0
; GFX12-NEXT:    s_wait_samplecnt 0x0
; GFX12-NEXT:    s_wait_bvhcnt 0x0
; GFX12-NEXT:    s_wait_kmcnt 0x0
; GFX12-NEXT:    s_setpc_b64 s[30:31]
bb:
  ret void
}

define void @snork() {
; GFX9-LABEL: snork:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX12-LABEL: snork:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-NEXT:    s_wait_expcnt 0x0
; GFX12-NEXT:    s_wait_samplecnt 0x0
; GFX12-NEXT:    s_wait_bvhcnt 0x0
; GFX12-NEXT:    s_wait_kmcnt 0x0
; GFX12-NEXT:    s_setpc_b64 s[30:31]
bb:
  ret void
}
