	.file	"vecmath.cpp"
# GNU C++14 (GCC) version 6.3.1 20170306 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 6.3.1 20170306, GMP version 6.1.2, MPFR version 3.1.5-p2, MPC version 1.0.3, isl version 0.15
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed:  -D_GNU_SOURCE -D_REENTRANT vecmath.cpp -march=ivybridge
# -mmmx -mno-3dnow -msse -msse2 -msse3 -mssse3 -mno-sse4a -mcx16 -msahf
# -mno-movbe -mno-aes -mno-sha -mpclmul -mpopcnt -mno-abm -mno-lwp -mno-fma
# -mno-fma4 -mno-xop -mno-bmi -mno-bmi2 -mno-tbm -mavx -mno-avx2 -msse4.2
# -msse4.1 -mno-lzcnt -mno-rtm -mno-hle -mno-rdrnd -mf16c -mfsgsbase
# -mno-rdseed -mno-prfchw -mno-adx -mfxsr -mxsave -mxsaveopt -mno-avx512f
# -mno-avx512er -mno-avx512cd -mno-avx512pf -mno-prefetchwt1
# -mno-clflushopt -mno-xsavec -mno-xsaves -mno-avx512dq -mno-avx512bw
# -mno-avx512vl -mno-avx512ifma -mno-avx512vbmi -mno-clwb -mno-mwaitx
# -mno-clzero -mno-pku --param l1-cache-size=32
# --param l1-cache-line-size=64 --param l2-cache-size=3072 -mtune=ivybridge
# -O3 -Wall -std=c++14 -fopenmp -fverbose-asm
# options enabled:  -faggressive-loop-optimizations -falign-labels
# -fasynchronous-unwind-tables -fauto-inc-dec -fbranch-count-reg
# -fcaller-saves -fchkp-check-incomplete-type -fchkp-check-read
# -fchkp-check-write -fchkp-instrument-calls -fchkp-narrow-bounds
# -fchkp-optimize -fchkp-store-bounds -fchkp-use-static-bounds
# -fchkp-use-static-const-bounds -fchkp-use-wrappers
# -fcombine-stack-adjustments -fcommon -fcompare-elim -fcprop-registers
# -fcrossjumping -fcse-follow-jumps -fdefer-pop
# -fdelete-null-pointer-checks -fdevirtualize -fdevirtualize-speculatively
# -fdwarf2-cfi-asm -fearly-inlining -feliminate-unused-debug-types
# -fexceptions -fexpensive-optimizations -fforward-propagate -ffunction-cse
# -fgcse -fgcse-after-reload -fgcse-lm -fgnu-runtime -fgnu-unique
# -fguess-branch-probability -fhoist-adjacent-loads -fident -fif-conversion
# -fif-conversion2 -findirect-inlining -finline -finline-atomics
# -finline-functions -finline-functions-called-once
# -finline-small-functions -fipa-cp -fipa-cp-alignment -fipa-cp-clone
# -fipa-icf -fipa-icf-functions -fipa-icf-variables -fipa-profile
# -fipa-pure-const -fipa-ra -fipa-reference -fipa-sra -fira-hoist-pressure
# -fira-share-save-slots -fira-share-spill-slots
# -fisolate-erroneous-paths-dereference -fivopts -fkeep-static-consts
# -fleading-underscore -flifetime-dse -flra-remat -flto-odr-type-merging
# -fmath-errno -fmerge-constants -fmerge-debug-strings
# -fmove-loop-invariants -fomit-frame-pointer -foptimize-sibling-calls
# -foptimize-strlen -fpartial-inlining -fpeephole -fpeephole2 -fplt
# -fpredictive-commoning -fprefetch-loop-arrays -free -freg-struct-return
# -freorder-blocks -freorder-functions -frerun-cse-after-loop
# -fsched-critical-path-heuristic -fsched-dep-count-heuristic
# -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic
# -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic
# -fsched-stalled-insns-dep -fschedule-fusion -fschedule-insns2
# -fsemantic-interposition -fshow-column -fshrink-wrap -fsigned-zeros
# -fsplit-ivs-in-unroller -fsplit-paths -fsplit-wide-types -fssa-backprop
# -fssa-phiopt -fstdarg-opt -fstrict-aliasing -fstrict-overflow
# -fstrict-volatile-bitfields -fsync-libcalls -fthread-jumps
# -ftoplevel-reorder -ftrapping-math -ftree-bit-ccp -ftree-builtin-call-dce
# -ftree-ccp -ftree-ch -ftree-coalesce-vars -ftree-copy-prop -ftree-cselim
# -ftree-dce -ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre
# -ftree-loop-distribute-patterns -ftree-loop-if-convert -ftree-loop-im
# -ftree-loop-ivcanon -ftree-loop-optimize -ftree-loop-vectorize
# -ftree-parallelize-loops= -ftree-partial-pre -ftree-phiprop -ftree-pre
# -ftree-pta -ftree-reassoc -ftree-scev-cprop -ftree-sink
# -ftree-slp-vectorize -ftree-slsr -ftree-sra -ftree-switch-conversion
# -ftree-tail-merge -ftree-ter -ftree-vrp -funit-at-a-time -funswitch-loops
# -funwind-tables -fverbose-asm -fzero-initialized-in-bss
# -m128bit-long-double -m64 -m80387 -malign-stringops -mavx
# -mavx256-split-unaligned-load -mavx256-split-unaligned-store -mcx16
# -mf16c -mfancy-math-387 -mfp-ret-in-387 -mfsgsbase -mfxsr -mglibc
# -mieee-fp -mlong-double-80 -mmmx -mpclmul -mpopcnt -mpush-args -mred-zone
# -msahf -msse -msse2 -msse3 -msse4 -msse4.1 -msse4.2 -mssse3 -mstv
# -mtls-direct-seg-refs -mvzeroupper -mxsave -mxsaveopt

	.text
	.align 2
	.p2align 4,,15
	.globl	_ZN4vec3C2Ev
	.type	_ZN4vec3C2Ev, @function
_ZN4vec3C2Ev:
.LFB4837:
	.cfi_startproc
	vxorps	%xmm0, %xmm0, %xmm0	# tmp88
	vmovss	%xmm0, 8(%rdi)	# tmp88, this_2(D)->z
	vmovss	%xmm0, 4(%rdi)	# tmp88, this_2(D)->y
	vmovss	%xmm0, (%rdi)	# tmp88, this_2(D)->x
	ret
	.cfi_endproc
.LFE4837:
	.size	_ZN4vec3C2Ev, .-_ZN4vec3C2Ev
	.globl	_ZN4vec3C1Ev
	.set	_ZN4vec3C1Ev,_ZN4vec3C2Ev
	.align 2
	.p2align 4,,15
	.globl	_ZN4vec3C2Efff
	.type	_ZN4vec3C2Efff, @function
_ZN4vec3C2Efff:
.LFB4840:
	.cfi_startproc
	vmovss	%xmm0, (%rdi)	# vx, this_2(D)->x
	vmovss	%xmm1, 4(%rdi)	# vy, this_2(D)->y
	vmovss	%xmm2, 8(%rdi)	# vz, this_2(D)->z
	ret
	.cfi_endproc
.LFE4840:
	.size	_ZN4vec3C2Efff, .-_ZN4vec3C2Efff
	.globl	_ZN4vec3C1Efff
	.set	_ZN4vec3C1Efff,_ZN4vec3C2Efff
	.align 2
	.p2align 4,,15
	.globl	_ZN4vec3aSERKS_
	.type	_ZN4vec3aSERKS_, @function
_ZN4vec3aSERKS_:
.LFB4842:
	.cfi_startproc
	vmovss	(%rsi), %xmm0	# rhs_2(D)->x, _3
	movq	%rdi, %rax	# this, this
	vmovss	%xmm0, (%rdi)	# _3, this_4(D)->x
	vmovss	4(%rsi), %xmm0	# rhs_2(D)->y, _6
	vmovss	%xmm0, 4(%rdi)	# _6, this_4(D)->y
	vmovss	8(%rsi), %xmm0	# rhs_2(D)->z, _8
	vmovss	%xmm0, 8(%rdi)	# _8, this_4(D)->z
	ret
	.cfi_endproc
.LFE4842:
	.size	_ZN4vec3aSERKS_, .-_ZN4vec3aSERKS_
	.align 2
	.p2align 4,,15
	.globl	_ZNK4vec3plERKS_
	.type	_ZNK4vec3plERKS_, @function
_ZNK4vec3plERKS_:
.LFB4843:
	.cfi_startproc
	leaq	8(%rsp), %r10	#,
	.cfi_def_cfa 10, 0
	andq	$-32, %rsp	#,
	pushq	-8(%r10)	#
	pushq	%rbp	#
	.cfi_escape 0x10,0x6,0x2,0x76,0
	movq	%rsp, %rbp	#,
	pushq	%r10	#
	.cfi_escape 0xf,0x3,0x76,0x78,0x6
	vmovss	4(%rdi), %xmm0	# this_2(D)->y, this_2(D)->y
	vmovss	(%rdi), %xmm2	# this_2(D)->x, this_2(D)->x
	vaddss	4(%rsi), %xmm0, %xmm0	# rhs_4(D)->y, this_2(D)->y, _9
	vaddss	(%rsi), %xmm2, %xmm2	# rhs_4(D)->x, this_2(D)->x, tmp102
	vmovss	8(%rdi), %xmm1	# this_2(D)->z, this_2(D)->z
	vmovss	%xmm0, -28(%rbp)	# _9, MEM[(struct vec3 *)&D.30632 + 4B]
	vaddss	8(%rsi), %xmm1, %xmm1	# rhs_4(D)->z, this_2(D)->z, _6
	vmovss	%xmm2, -32(%rbp)	# tmp102, MEM[(struct vec3 *)&D.30632]
	vmovq	-32(%rbp), %xmm0	# D.30632,
	popq	%r10	#
	.cfi_def_cfa 10, 0
	popq	%rbp	#
	leaq	-8(%r10), %rsp	#,
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4843:
	.size	_ZNK4vec3plERKS_, .-_ZNK4vec3plERKS_
	.align 2
	.p2align 4,,15
	.globl	_ZNK4vec3miERKS_
	.type	_ZNK4vec3miERKS_, @function
_ZNK4vec3miERKS_:
.LFB4844:
	.cfi_startproc
	leaq	8(%rsp), %r10	#,
	.cfi_def_cfa 10, 0
	andq	$-32, %rsp	#,
	pushq	-8(%r10)	#
	pushq	%rbp	#
	.cfi_escape 0x10,0x6,0x2,0x76,0
	movq	%rsp, %rbp	#,
	pushq	%r10	#
	.cfi_escape 0xf,0x3,0x76,0x78,0x6
	vmovss	4(%rdi), %xmm0	# this_2(D)->y, this_2(D)->y
	vmovss	(%rdi), %xmm2	# this_2(D)->x, this_2(D)->x
	vsubss	4(%rsi), %xmm0, %xmm0	# rhs_4(D)->y, this_2(D)->y, _9
	vsubss	(%rsi), %xmm2, %xmm2	# rhs_4(D)->x, this_2(D)->x, tmp102
	vmovss	8(%rdi), %xmm1	# this_2(D)->z, this_2(D)->z
	vmovss	%xmm0, -28(%rbp)	# _9, MEM[(struct vec3 *)&D.30644 + 4B]
	vsubss	8(%rsi), %xmm1, %xmm1	# rhs_4(D)->z, this_2(D)->z, _6
	vmovss	%xmm2, -32(%rbp)	# tmp102, MEM[(struct vec3 *)&D.30644]
	vmovq	-32(%rbp), %xmm0	# D.30644,
	popq	%r10	#
	.cfi_def_cfa 10, 0
	popq	%rbp	#
	leaq	-8(%r10), %rsp	#,
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4844:
	.size	_ZNK4vec3miERKS_, .-_ZNK4vec3miERKS_
	.align 2
	.p2align 4,,15
	.globl	_ZNK4vec3mlEf
	.type	_ZNK4vec3mlEf, @function
_ZNK4vec3mlEf:
.LFB4845:
	.cfi_startproc
	leaq	8(%rsp), %r10	#,
	.cfi_def_cfa 10, 0
	andq	$-32, %rsp	#,
	pushq	-8(%r10)	#
	pushq	%rbp	#
	.cfi_escape 0x10,0x6,0x2,0x76,0
	movq	%rsp, %rbp	#,
	pushq	%r10	#
	.cfi_escape 0xf,0x3,0x76,0x78,0x6
	vmulss	8(%rdi), %xmm0, %xmm1	# this_2(D)->z, scalar, _5
	vmulss	4(%rdi), %xmm0, %xmm2	# this_2(D)->y, scalar, _7
	vmulss	(%rdi), %xmm0, %xmm0	# this_2(D)->x, scalar, tmp97
	vmovss	%xmm2, -28(%rbp)	# _7, MEM[(struct vec3 *)&D.30656 + 4B]
	vmovss	%xmm0, -32(%rbp)	# tmp97, MEM[(struct vec3 *)&D.30656]
	vmovq	-32(%rbp), %xmm0	# D.30656,
	popq	%r10	#
	.cfi_def_cfa 10, 0
	popq	%rbp	#
	leaq	-8(%r10), %rsp	#,
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4845:
	.size	_ZNK4vec3mlEf, .-_ZNK4vec3mlEf
	.align 2
	.p2align 4,,15
	.globl	_ZN4vec33dotES_
	.type	_ZN4vec33dotES_, @function
_ZN4vec33dotES_:
.LFB4846:
	.cfi_startproc
	vmovq	%xmm0, -16(%rsp)	# rhs, rhs
	vmovss	4(%rdi), %xmm2	# this_2(D)->y, this_2(D)->y
	vmovss	(%rdi), %xmm0	# this_2(D)->x, this_2(D)->x
	vmulss	-12(%rsp), %xmm2, %xmm2	# rhs.y, this_2(D)->y, tmp104
	vmulss	-16(%rsp), %xmm0, %xmm0	# rhs.x, this_2(D)->x, tmp102
	vmulss	8(%rdi), %xmm1, %xmm1	# this_2(D)->z, rhs, tmp107
	vaddss	%xmm2, %xmm0, %xmm0	# tmp104, tmp102, tmp106
	vaddss	%xmm1, %xmm0, %xmm0	# tmp107, tmp106, tmp101
	ret
	.cfi_endproc
.LFE4846:
	.size	_ZN4vec33dotES_, .-_ZN4vec33dotES_
	.align 2
	.p2align 4,,15
	.globl	_ZN4vec313rotateAroundXEf
	.type	_ZN4vec313rotateAroundXEf, @function
_ZN4vec313rotateAroundXEf:
.LFB4847:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	vcvtss2sd	%xmm0, %xmm0, %xmm0	# degrees, tmp110
	movq	%rdi, %rbx	# this, this
	subq	$16, %rsp	#,
	.cfi_def_cfa_offset 32
	vmulsd	.LC1(%rip), %xmm0, %xmm0	#, tmp110, tmp111
	movq	%rsp, %rsi	#,
	leaq	8(%rsp), %rdi	#, tmp122
	vcvtsd2ss	%xmm0, %xmm0, %xmm0	# tmp111, rads
	vcvtss2sd	%xmm0, %xmm0, %xmm0	# rads, tmp114
	call	sincos	#
	vmovss	8(%rbx), %xmm3	# this_11(D)->z, _14
	vxorps	%xmm1, %xmm1, %xmm1	# costheta
	vxorps	%xmm0, %xmm0, %xmm0	# sintheta
	vcvtsd2ss	(%rsp), %xmm1, %xmm1	#, costheta, costheta
	vcvtsd2ss	8(%rsp), %xmm0, %xmm0	#, sintheta, sintheta
	vmulss	4(%rbx), %xmm1, %xmm2	# this_11(D)->y, costheta, tmp115
	vmulss	%xmm3, %xmm0, %xmm4	# _14, sintheta, tmp118
	vmulss	%xmm3, %xmm1, %xmm1	# _14, costheta, tmp120
	vsubss	%xmm4, %xmm2, %xmm2	# tmp118, tmp115, _17
	vmulss	%xmm2, %xmm0, %xmm0	# _17, sintheta, tmp119
	vmovss	%xmm2, 4(%rbx)	# _17, this_11(D)->y
	vaddss	%xmm1, %xmm0, %xmm0	# tmp120, tmp119, tmp121
	vmovss	%xmm0, 8(%rbx)	# tmp121, this_11(D)->z
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 16
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE4847:
	.size	_ZN4vec313rotateAroundXEf, .-_ZN4vec313rotateAroundXEf
	.align 2
	.p2align 4,,15
	.globl	_ZN4vec313rotateAroundYEf
	.type	_ZN4vec313rotateAroundYEf, @function
_ZN4vec313rotateAroundYEf:
.LFB4848:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	vcvtss2sd	%xmm0, %xmm0, %xmm0	# degrees, tmp110
	movq	%rdi, %rbx	# this, this
	subq	$16, %rsp	#,
	.cfi_def_cfa_offset 32
	vmulsd	.LC1(%rip), %xmm0, %xmm0	#, tmp110, tmp111
	movq	%rsp, %rsi	#,
	leaq	8(%rsp), %rdi	#, tmp122
	vcvtsd2ss	%xmm0, %xmm0, %xmm0	# tmp111, rads
	vcvtss2sd	%xmm0, %xmm0, %xmm0	# rads, tmp114
	call	sincos	#
	vmovss	8(%rbx), %xmm3	# this_11(D)->z, _14
	vxorps	%xmm0, %xmm0, %xmm0	# costheta
	vxorps	%xmm1, %xmm1, %xmm1	# sintheta
	vcvtsd2ss	(%rsp), %xmm0, %xmm0	#, costheta, costheta
	vcvtsd2ss	8(%rsp), %xmm1, %xmm1	#, sintheta, sintheta
	vmulss	(%rbx), %xmm0, %xmm2	# this_11(D)->x, costheta, tmp115
	vmulss	%xmm3, %xmm1, %xmm4	# _14, sintheta, tmp116
	vmulss	%xmm3, %xmm0, %xmm0	# _14, costheta, tmp120
	vaddss	%xmm4, %xmm2, %xmm2	# tmp116, tmp115, _16
	vmulss	%xmm2, %xmm1, %xmm1	# _16, sintheta, tmp119
	vmovss	%xmm2, (%rbx)	# _16, this_11(D)->x
	vsubss	%xmm1, %xmm0, %xmm0	# tmp119, tmp120, tmp121
	vmovss	%xmm0, 8(%rbx)	# tmp121, this_11(D)->z
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 16
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE4848:
	.size	_ZN4vec313rotateAroundYEf, .-_ZN4vec313rotateAroundYEf
	.align 2
	.p2align 4,,15
	.globl	_ZN4viewC2Eiif
	.type	_ZN4viewC2Eiif, @function
_ZN4viewC2Eiif:
.LFB4850:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	vxorps	%xmm1, %xmm1, %xmm1	# tmp106
	vxorps	%xmm2, %xmm2, %xmm2	# tmp117
	movq	%rdi, %rbx	# this, this
	subq	$16, %rsp	#,
	.cfi_def_cfa_offset 32
	movl	%esi, 44(%rdi)	# width, this_2(D)->w
	movl	%esi, %esi	# width, width.0_5
	movl	%edx, 48(%rdi)	# height, this_2(D)->h
	movl	%edx, %edx	# height, height.1_8
	vmovss	%xmm1, 20(%rdi)	# tmp106, MEM[(struct vec3 *)this_2(D) + 12B].z
	vcvtsi2ssq	%rdx, %xmm2, %xmm2	# height.1_8, tmp117, tmp117
	vmovss	%xmm1, 16(%rdi)	# tmp106, MEM[(struct vec3 *)this_2(D) + 12B].y
	vmovss	%xmm1, 12(%rdi)	# tmp106, MEM[(struct vec3 *)this_2(D) + 12B].x
	vmovss	%xmm1, 32(%rdi)	# tmp106, MEM[(struct vec3 *)this_2(D) + 24B].z
	vmovss	%xmm1, 28(%rdi)	# tmp106, MEM[(struct vec3 *)this_2(D) + 24B].y
	vmovss	%xmm1, 24(%rdi)	# tmp106, MEM[(struct vec3 *)this_2(D) + 24B].x
	vxorps	%xmm1, %xmm1, %xmm1	# tmp112
	vcvtsi2ssq	%rsi, %xmm1, %xmm1	# width.0_5, tmp112, tmp112
	vmovss	%xmm0, 40(%rdi)	# fieldOfView, this_2(D)->fov
	vcvtss2sd	%xmm0, %xmm0, %xmm0	# fieldOfView, tmp122
	vmulsd	.LC3(%rip), %xmm0, %xmm0	#, tmp122, tmp123
	vmulsd	.LC1(%rip), %xmm0, %xmm0	#, tmp123, tmp125
	vdivss	%xmm2, %xmm1, %xmm1	# tmp117, tmp112, _12
	vcvtsd2ss	%xmm0, %xmm0, %xmm0	# tmp125, _19
	vmovss	%xmm0, (%rdi)	# _19, this_2(D)->fovrad
	vcvtss2sd	%xmm0, %xmm0, %xmm0	# _19, tmp127
	vmovss	%xmm1, 36(%rdi)	# _12, this_2(D)->aspectRatio
	vmovss	%xmm1, 12(%rsp)	# _12, %sfp
	call	tan	#
	vmovss	12(%rsp), %xmm1	# %sfp, _12
	vxorps	%xmm3, %xmm3, %xmm3	# tmp130
	vxorps	%xmm4, %xmm4, %xmm4	# tmp131
	vcvtsd2ss	%xmm0, %xmm3, %xmm3	# _22, tmp130, tmp130
	vmovss	%xmm3, 4(%rbx)	# tmp130, this_2(D)->fovtan
	vcvtss2sd	%xmm1, %xmm1, %xmm1	# _12, tmp128
	vdivsd	%xmm1, %xmm0, %xmm1	# tmp128, _22, tmp129
	vcvtsd2ss	%xmm1, %xmm4, %xmm4	# tmp129, tmp131, tmp131
	vmovss	%xmm4, 8(%rbx)	# tmp131, this_2(D)->fovtanAspect
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 16
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE4850:
	.size	_ZN4viewC2Eiif, .-_ZN4viewC2Eiif
	.globl	_ZN4viewC1Eiif
	.set	_ZN4viewC1Eiif,_ZN4viewC2Eiif
	.align 2
	.p2align 4,,15
	.globl	_ZN4view14getRayForPixelEii
	.type	_ZN4view14getRayForPixelEii, @function
_ZN4view14getRayForPixelEii:
.LFB4852:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	addl	%edx, %edx	# tmp125
	vxorps	%xmm2, %xmm2, %xmm2	# tmp126
	addl	%ecx, %ecx	# tmp133
	subq	$16, %rsp	#,
	.cfi_def_cfa_offset 32
	vmovss	12(%rsi), %xmm0	# MEM[(const struct vec3 &)this_2(D) + 12].x, MEM[(const struct vec3 &)this_2(D) + 12].x
	vcvtsi2ss	%edx, %xmm2, %xmm2	# tmp125, tmp126, tmp126
	movq	%rdi, %rbx	# .result_ptr, .result_ptr
	movl	44(%rsi), %eax	# this_2(D)->w, this_2(D)->w
	vxorps	%xmm3, %xmm3, %xmm3	# _14
	vxorps	%xmm5, %xmm5, %xmm5	# tmp142
	vmovss	%xmm0, (%rdi)	# MEM[(const struct vec3 &)this_2(D) + 12].x, MEM[(struct vec3 *)&<retval>].x
	vmovss	16(%rsi), %xmm0	# MEM[(const struct vec3 &)this_2(D) + 12].y, MEM[(const struct vec3 &)this_2(D) + 12].y
	vmovss	%xmm0, 4(%rdi)	# MEM[(const struct vec3 &)this_2(D) + 12].y, MEM[(struct vec3 *)&<retval>].y
	vmovss	20(%rsi), %xmm0	# MEM[(const struct vec3 &)this_2(D) + 12].z, MEM[(const struct vec3 &)this_2(D) + 12].z
	vmovss	%xmm0, 8(%rdi)	# MEM[(const struct vec3 &)this_2(D) + 12].z, MEM[(struct vec3 *)&<retval>].z
	vxorps	%xmm0, %xmm0, %xmm0	# _7
	vcvtsi2ssq	%rax, %xmm0, %xmm0	# this_2(D)->w, _7, _7
	movl	48(%rsi), %eax	# this_2(D)->h, this_2(D)->h
	vsubss	%xmm0, %xmm2, %xmm2	# _7, tmp126, tmp127
	vcvtsi2ssq	%rax, %xmm3, %xmm3	# this_2(D)->h, _14, _14
	vdivss	%xmm0, %xmm2, %xmm2	# _7, tmp127, tmp128
	vxorps	%xmm0, %xmm0, %xmm0	# tmp134
	vcvtsi2ss	%ecx, %xmm0, %xmm0	# tmp133, tmp134, tmp134
	vsubss	%xmm0, %xmm3, %xmm1	# tmp134, _14, tmp135
	vmulss	4(%rsi), %xmm2, %xmm2	# this_2(D)->fovtan, tmp128, _11
	vdivss	%xmm3, %xmm1, %xmm1	# _14, tmp135, tmp136
	vmovss	.LC4(%rip), %xmm3	#, tmp147
	vmulss	%xmm2, %xmm2, %xmm0	# _11, _11, tmp138
	vmovss	%xmm2, 12(%rdi)	# _11, <retval>.direction.x
	vmovss	%xmm3, 20(%rdi)	# tmp147, <retval>.direction.z
	vmulss	8(%rsi), %xmm1, %xmm1	# this_2(D)->fovtanAspect, tmp136, _21
	vmulss	%xmm1, %xmm1, %xmm4	# _21, _21, tmp139
	vmovss	%xmm1, 16(%rdi)	# _21, <retval>.direction.y
	vaddss	%xmm4, %xmm0, %xmm0	# tmp139, tmp138, tmp140
	vaddss	%xmm3, %xmm0, %xmm0	# tmp147, tmp140, _40
	vucomiss	%xmm0, %xmm5	# _40, tmp142
	vsqrtss	%xmm0, %xmm4, %xmm4	# _40, _41
	jbe	.L26	#,
	vmovss	%xmm3, 12(%rsp)	# tmp147, %sfp
	vmovss	%xmm4, 8(%rsp)	# _41, %sfp
	vmovss	%xmm1, 4(%rsp)	# _21, %sfp
	vmovss	%xmm2, (%rsp)	# _11, %sfp
	call	sqrtf	#
	vmovss	12(%rsp), %xmm3	# %sfp, tmp147
	vmovss	8(%rsp), %xmm4	# %sfp, _41
	vmovss	4(%rsp), %xmm1	# %sfp, _21
	vmovss	(%rsp), %xmm2	# %sfp, _11
.L26:
	vdivss	%xmm4, %xmm2, %xmm2	# _41, _11, tmp143
	movq	%rbx, %rax	# .result_ptr,
	vdivss	%xmm4, %xmm1, %xmm1	# _41, _21, tmp144
	vmovss	%xmm2, 12(%rbx)	# tmp143, MEM[(struct vec3 *)&<retval> + 12B].x
	vdivss	%xmm4, %xmm3, %xmm3	# _41, tmp147, tmp145
	vmovss	%xmm1, 16(%rbx)	# tmp144, MEM[(struct vec3 *)&<retval> + 12B].y
	vmovss	%xmm3, 20(%rbx)	# tmp145, MEM[(struct vec3 *)&<retval> + 12B].z
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 16
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE4852:
	.size	_ZN4view14getRayForPixelEii, .-_ZN4view14getRayForPixelEii
	.align 2
	.p2align 4,,15
	.globl	_ZN3ray11castAgainstE6sphere
	.type	_ZN3ray11castAgainstE6sphere, @function
_ZN3ray11castAgainstE6sphere:
.LFB4856:
	.cfi_startproc
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vxorps	%xmm3, %xmm3, %xmm3	# tmp176
	pushq	%rbx	#
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx	# .result_ptr, .result_ptr
	subq	$56, %rsp	#,
	.cfi_def_cfa_offset 80
	vmovss	(%rsi), %xmm8	# this_3(D)->origin.x, _5
	vmovss	%xmm3, 8(%rdi)	# tmp176, MEM[(struct vec3 *)&<retval>].z
	vmovq	%xmm0, 32(%rsp)	# s, s
	vmovss	4(%rsi), %xmm9	# this_3(D)->origin.y, _7
	vmovss	32(%rsp), %xmm5	# MEM[(struct sphere *)&s], s$pos$x
	vmovq	%xmm1, 40(%rsp)	# s, s
	vmovss	36(%rsp), %xmm4	# MEM[(struct sphere *)&s + 4B], s$pos$y
	vmovss	%xmm3, 4(%rdi)	# tmp176, MEM[(struct vec3 *)&<retval>].y
	vsubss	%xmm5, %xmm8, %xmm12	# s$pos$x, _5, _10
	vmovss	12(%rsi), %xmm6	# this_3(D)->direction.x, _4
	vmovss	%xmm3, (%rdi)	# tmp176, MEM[(struct vec3 *)&<retval>].x
	vsubss	%xmm4, %xmm9, %xmm15	# s$pos$y, _7, _12
	vmovss	16(%rsi), %xmm7	# this_3(D)->direction.y, _6
	vmovss	%xmm3, 20(%rdi)	# tmp176, MEM[(struct vec3 *)&<retval> + 12B].z
	vmovss	40(%rsp), %xmm10	# MEM[(struct sphere *)&s + 8B], s$pos$z
	vmovss	%xmm3, 16(%rdi)	# tmp176, MEM[(struct vec3 *)&<retval> + 12B].y
	vmovss	8(%rsi), %xmm11	# this_3(D)->origin.z, _9
	vmulss	%xmm12, %xmm6, %xmm1	# _10, _4, tmp148
	vmovss	%xmm3, 12(%rdi)	# tmp176, MEM[(struct vec3 *)&<retval> + 12B].x
	vmulss	%xmm15, %xmm7, %xmm0	# _12, _6, tmp149
	vmovss	20(%rsi), %xmm2	# this_3(D)->direction.z, _8
	movb	$0, 28(%rdi)	#, <retval>.hitSomething
	vsubss	%xmm10, %xmm11, %xmm14	# s$pos$z, _9, _15
	vmulss	%xmm12, %xmm12, %xmm12	# _10, _10, tmp153
	vmovss	44(%rsp), %xmm13	# MEM[(struct sphere *)&s + 12B], s$rad
	vmulss	%xmm15, %xmm15, %xmm15	# _12, _12, tmp154
	vmulss	%xmm13, %xmm13, %xmm13	# s$rad, s$rad, tmp159
	vaddss	%xmm0, %xmm1, %xmm1	# tmp149, tmp148, tmp150
	vmulss	%xmm14, %xmm2, %xmm0	# _15, _8, tmp151
	vmulss	%xmm14, %xmm14, %xmm14	# _15, _15, tmp156
	vaddss	%xmm15, %xmm12, %xmm12	# tmp154, tmp153, tmp155
	vaddss	%xmm0, %xmm1, %xmm1	# tmp151, tmp150, dotProduct
	vaddss	%xmm14, %xmm12, %xmm12	# tmp156, tmp155, distanceBetweenSqr
	vmulss	%xmm1, %xmm1, %xmm0	# dotProduct, dotProduct, tmp152
	vsubss	%xmm12, %xmm0, %xmm0	# distanceBetweenSqr, tmp152, tmp158
	vaddss	%xmm13, %xmm0, %xmm0	# tmp159, tmp158, importantPart
	vucomiss	%xmm0, %xmm3	# importantPart, tmp176
	ja	.L33	#,
	vcvtss2sd	%xmm0, %xmm0, %xmm0	# importantPart, _30
	vxorpd	%xmm12, %xmm12, %xmm12	# tmp163
	vsqrtsd	%xmm0, %xmm13, %xmm13	# _30, _32
	vucomisd	%xmm0, %xmm12	# _30, tmp163
	vxorps	.LC2(%rip), %xmm1, %xmm1	#, dotProduct, tmp161
	movb	$1, 28(%rdi)	#, <retval>.hitSomething
	vcvtss2sd	%xmm1, %xmm1, %xmm1	# tmp161, _29
	vmovsd	%xmm13, (%rsp)	# _32, %sfp
	jbe	.L31	#,
	movq	%rsi, %rbp	# this, this
	vmovss	%xmm3, 28(%rsp)	# tmp176, %sfp
	vmovss	%xmm10, 24(%rsp)	# s$pos$z, %sfp
	vmovss	%xmm5, 20(%rsp)	# s$pos$x, %sfp
	vmovss	%xmm4, 16(%rsp)	# s$pos$y, %sfp
	vmovsd	%xmm1, 8(%rsp)	# _29, %sfp
	call	sqrt	#
	vmovss	8(%rbp), %xmm11	# MEM[(const struct vec3 *)this_3(D)].z, _9
	vmovss	4(%rbp), %xmm9	# MEM[(const struct vec3 *)this_3(D)].y, _7
	vmovss	0(%rbp), %xmm8	# MEM[(const struct vec3 *)this_3(D)].x, _5
	vmovss	20(%rbp), %xmm2	# MEM[(const struct vec3 *)this_3(D) + 12B].z, _8
	vmovss	16(%rbp), %xmm7	# MEM[(const struct vec3 *)this_3(D) + 12B].y, _6
	vmovss	12(%rbp), %xmm6	# MEM[(const struct vec3 *)this_3(D) + 12B].x, _4
	vmovss	28(%rsp), %xmm3	# %sfp, tmp176
	vmovss	24(%rsp), %xmm10	# %sfp, s$pos$z
	vmovss	20(%rsp), %xmm5	# %sfp, s$pos$x
	vmovss	16(%rsp), %xmm4	# %sfp, s$pos$y
	vmovsd	8(%rsp), %xmm1	# %sfp, _29
.L31:
	vsubsd	(%rsp), %xmm1, %xmm1	# %sfp, _29, tmp164
	vcvtsd2ss	%xmm1, %xmm1, %xmm1	# tmp164, d
	vmulss	%xmm6, %xmm1, %xmm6	# _4, d, tmp167
	vmulss	%xmm7, %xmm1, %xmm7	# _6, d, tmp166
	vmulss	%xmm2, %xmm1, %xmm2	# _8, d, tmp165
	vaddss	%xmm8, %xmm6, %xmm8	# _5, tmp167, _52
	vaddss	%xmm9, %xmm7, %xmm9	# _7, tmp166, _50
	vaddss	%xmm11, %xmm2, %xmm2	# _9, tmp165, _48
	vsubss	%xmm8, %xmm5, %xmm5	# _52, s$pos$x, _46
	vmovss	%xmm8, (%rbx)	# _52, MEM[(struct vec3 *)&<retval>].x
	vsubss	%xmm9, %xmm4, %xmm4	# _50, s$pos$y, _45
	vmovss	%xmm9, 4(%rbx)	# _50, MEM[(struct vec3 *)&<retval>].y
	vmovss	%xmm2, 8(%rbx)	# _48, MEM[(struct vec3 *)&<retval>].z
	vsubss	%xmm2, %xmm10, %xmm2	# _48, s$pos$z, _44
	vmulss	%xmm5, %xmm5, %xmm0	# _46, _46, tmp168
	vmulss	%xmm4, %xmm4, %xmm6	# _45, _45, tmp169
	vaddss	%xmm6, %xmm0, %xmm0	# tmp169, tmp168, tmp170
	vmulss	%xmm2, %xmm2, %xmm6	# _44, _44, tmp171
	vaddss	%xmm6, %xmm0, %xmm0	# tmp171, tmp170, _87
	vucomiss	%xmm0, %xmm3	# _87, tmp176
	vsqrtss	%xmm0, %xmm6, %xmm6	# _87, _88
	jbe	.L32	#,
	vmovss	%xmm6, 24(%rsp)	# _88, %sfp
	vmovss	%xmm5, 20(%rsp)	# _46, %sfp
	vmovss	%xmm4, 16(%rsp)	# _45, %sfp
	vmovss	%xmm2, 8(%rsp)	# _44, %sfp
	vmovss	%xmm1, (%rsp)	# d, %sfp
	call	sqrtf	#
	vmovss	24(%rsp), %xmm6	# %sfp, _88
	vmovss	20(%rsp), %xmm5	# %sfp, _46
	vmovss	16(%rsp), %xmm4	# %sfp, _45
	vmovss	8(%rsp), %xmm2	# %sfp, _44
	vmovss	(%rsp), %xmm1	# %sfp, d
.L32:
	vdivss	%xmm6, %xmm5, %xmm5	# _88, _46, tmp173
	vmovss	%xmm1, 24(%rbx)	# d, <retval>.distance
	vdivss	%xmm6, %xmm4, %xmm4	# _88, _45, tmp174
	vmovss	%xmm5, 12(%rbx)	# tmp173, MEM[(struct vec3 *)&<retval> + 12B].x
	vdivss	%xmm6, %xmm2, %xmm2	# _88, _44, tmp175
	vmovss	%xmm4, 16(%rbx)	# tmp174, MEM[(struct vec3 *)&<retval> + 12B].y
	vmovss	%xmm2, 20(%rbx)	# tmp175, MEM[(struct vec3 *)&<retval> + 12B].z
.L33:
	addq	$56, %rsp	#,
	.cfi_def_cfa_offset 24
	movq	%rbx, %rax	# .result_ptr,
	popq	%rbx	#
	.cfi_def_cfa_offset 16
	popq	%rbp	#
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE4856:
	.size	_ZN3ray11castAgainstE6sphere, .-_ZN3ray11castAgainstE6sphere
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	584335455
	.long	1066524487
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC2:
	.long	2147483648
	.long	0
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC3:
	.long	0
	.long	1071644672
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC4:
	.long	1065353216
	.ident	"GCC: (GNU) 6.3.1 20170306"
	.section	.note.GNU-stack,"",@progbits
