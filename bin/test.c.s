	.file	1 "test.c"

 # GNU C 2.7.2.3 [AL 1.1, MM 40, tma 0.1] SimpleScalar running sstrix compiled by GNU C

 # Cc1 defaults:
 # -mgas -mgpOPT

 # Cc1 arguments (-G value = 8, Cpu = default, ISA = 1):
 # -quiet -dumpbase -O0 -o

gcc2_compiled.:
__gnu_compiled_c:
	.rdata
	.align	2
$LC0:
	.ascii	"true %d\n\000"
	.align	2
$LC1:
	.ascii	"false %d\n\000"
	.align	2
$LC2:
	.ascii	"Final count: %d\n\000"
	.text
	.align	2
	.globl	main

	.text

	.loc	1 3
	.ent	main
main:
	.frame	$fp,48,$31		# vars= 24, regs= 2/0, args= 16, extra= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	subu	$sp,$sp,48
	sw	$31,44($sp)
	sw	$fp,40($sp)
	move	$fp,$sp
	jal	__main
	sw	$0,28($fp)
	sw	$0,32($fp)
	sw	$0,16($fp)
$L2:
	lw	$2,16($fp)
	slt	$3,$2,100
	bne	$3,$0,$L5
	j	$L3
$L5:
	lw	$2,16($fp)
	li	$6,0x66666667		# 1717986919
	mult	$2,$6
	mfhi	$5
	mflo	$4
	srl	$6,$5,0
	move	$7,$0
	sra	$3,$6,1
	sra	$4,$2,31
	subu	$3,$3,$4
	move	$5,$3
	sll	$4,$5,2
	addu	$4,$4,$3
	subu	$2,$2,$4
	bne	$2,$0,$L6
	lw	$2,28($fp)
	xori	$3,$2,0x0000
	sltu	$2,$3,1
	sw	$2,28($fp)
$L6:
	lw	$2,28($fp)
	beq	$2,$0,$L7
	sw	$0,20($fp)
$L8:
	lw	$2,20($fp)
	slt	$3,$2,3
	bne	$3,$0,$L11
	j	$L9
$L11:
	lw	$2,20($fp)
	lw	$3,16($fp)
	addu	$2,$2,$3
	andi	$3,$2,0x0001
	bne	$3,$0,$L12
	lw	$3,32($fp)
	addu	$2,$3,1
	move	$3,$2
	sw	$3,32($fp)
$L12:
	la	$4,$LC0
	lw	$5,32($fp)
	jal	printf
$L10:
	lw	$3,20($fp)
	addu	$2,$3,1
	move	$3,$2
	sw	$3,20($fp)
	j	$L8
$L9:
	j	$L13
$L7:
	sw	$0,24($fp)
$L14:
	lw	$2,24($fp)
	slt	$3,$2,2
	bne	$3,$0,$L17
	j	$L15
$L17:
	lw	$2,24($fp)
	lw	$3,16($fp)
	mult	$2,$3
	mflo	$2
	li	$6,0x55555556		# 1431655766
	mult	$2,$6
	mfhi	$5
	mflo	$4
	srl	$6,$5,0
	move	$7,$0
	sra	$4,$2,31
	subu	$3,$6,$4
	move	$5,$3
	sll	$4,$5,1
	addu	$4,$4,$3
	subu	$2,$2,$4
	li	$3,0x00000001		# 1
	bne	$2,$3,$L18
	lw	$3,32($fp)
	subu	$2,$3,1
	move	$3,$2
	sw	$3,32($fp)
$L18:
	la	$4,$LC1
	lw	$5,32($fp)
	jal	printf
$L16:
	lw	$3,24($fp)
	addu	$2,$3,1
	move	$3,$2
	sw	$3,24($fp)
	j	$L14
$L15:
$L13:
$L4:
	lw	$3,16($fp)
	addu	$2,$3,1
	move	$3,$2
	sw	$3,16($fp)
	j	$L2
$L3:
	la	$4,$LC2
	lw	$5,32($fp)
	jal	printf
	move	$2,$0
	j	$L1
$L1:
	move	$sp,$fp			# sp not trusted here
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addu	$sp,$sp,48
	j	$31
	.end	main
