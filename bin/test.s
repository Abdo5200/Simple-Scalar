	.file	1 "test.c"

 # GNU C 2.7.2.3 [AL 1.1, MM 40, tma 0.1] SimpleScalar running sstrix compiled by GNU C

 # Cc1 defaults:
 # -mgas -mgpOPT

 # Cc1 arguments (-G value = 8, Cpu = default, ISA = 1):
 # -quiet -dumpbase -o

gcc2_compiled.:
__gnu_compiled_c:
	.rdata
	.align	2
$LC0:
	.ascii	"Hello, SimpleScalar!\n\000"
	.align	2
$LC1:
	.ascii	"x is zero\n\000"
	.text
	.align	2
	.globl	main

	.text

	.loc	1 3
	.ent	main
main:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, extra= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	subu	$sp,$sp,32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	jal	__main
	sw	$0,16($fp)
	la	$4,$LC0
	jal	printf
	lw	$2,16($fp)
	bne	$2,$0,$L2
	la	$4,$LC1
	jal	printf
$L2:
	move	$2,$0
	j	$L1
$L1:
	move	$sp,$fp			# sp not trusted here
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addu	$sp,$sp,32
	j	$31
	.end	main
