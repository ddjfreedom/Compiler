	.file	1 "runtime.c"
	.text
	.align	2
	.globl	malloc
	.ent	malloc
malloc:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-16
	sw	$fp,8($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	li  $2, 9
  syscall
	move	$sp,$fp
	lw	$fp,8($sp)
	addiu	$sp,$sp,16
	j	$31
	.end	malloc
	.align	2
	.globl	initArray
	.ent	initArray
initArray:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-16
	sw	$fp,8($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$5,20($fp)
	sw	$6,24($fp)
	sw	$0,0($fp)
$L3:
	lw	$2,0($fp)
	lw	$3,20($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L4
	lw	$2,0($fp)
	sll	$3,$2,2
	lw	$2,16($fp)
	addu	$3,$3,$2
	lw	$2,24($fp)
	sw	$2,0($3)
	lw	$2,0($fp)
	addiu	$2,$2,1
	sw	$2,0($fp)
	j	$L3
$L4:
	lw	$2,16($fp)
	move	$sp,$fp
	lw	$fp,8($sp)
	addiu	$sp,$sp,16
	j	$31
	.end	initArray
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,40,$31		# vars= 8, regs= 3/0, args= 16, gp= 0
	.mask	0xc0010000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-40
	sw	$31,32($sp)
	sw	$fp,28($sp)
	sw	$16,24($sp)
	move	$fp,$sp
	sw	$0,16($fp)
$L3:
	lw	$2,16($fp)
	slt	$2,$2,128
	beq	$2,$0,$L4
	lw	$2,16($fp)
	sll	$3,$2,2
	la	$2,chars
	addu	$16,$3,$2
	li	$4,2			# 0x2
	jal	malloc
	sw	$2,0($16)
	lw	$2,16($fp)
	sll	$3,$2,2
	la	$2,chars
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,16($fp)
	sb	$2,0($3)
	lw	$2,16($fp)
	sll	$3,$2,2
	la	$2,chars
	addu	$2,$3,$2
	lw	$2,0($2)
	sb	$0,1($2)
	lw	$2,16($fp)
	addiu	$2,$2,1
	sw	$2,16($fp)
	j	$L3
$L4:
	move	$4,$0
	jal	tigermain
	move	$sp,$fp
	lw	$31,32($sp)
	lw	$fp,28($sp)
	lw	$16,24($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	main
	.align	2
	.globl	exit
	.ent	exit
exit:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
  li  $2, 10
  syscall
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	j	$31
	.end	exit
	.align	2
	.globl	print
	.ent	print
print:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	move  $4, $5
  li  $2, 4
  syscall
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	j	$31
	.end	print
	.align	2
	.globl	printi
	.ent	printi
printi:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	move  $4, $5
  li  $2, 1
  syscall
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	j	$31
	.end	printi
	.align	2
	.globl	flush
	.ent	flush
flush:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	j	$31
	.end	flush
	.rdata
	.align	2
$LC0:
	.ascii	"\000"
	.text
	.align	2
	.globl	getchar
	.ent	getchar
getchar:
	.frame	$fp,40,$31		# vars= 16, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
  li  $4, 2
  li  $2, 9
  syscall
  move $4, $2
  li  $5, 2
  syscall
	lw	$3,0($4)
	li	$2,-1			# 0xffffffffffffffff
	bne	$3,$2,$L17
	la	$2,$LC0
	sw	$2,20($fp)
	j	$L14
$L17:
	la	$2,chars
	addu	$2,$2,$3
	sw	$2,20($fp)
$L14:
	lw	$2,20($fp)
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	getchar
	.align	2
	.globl	ord
	.ent	ord
ord:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-16
	sw	$fp,8($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$5,20($fp)
	lw	$2,20($fp)
	lb	$2,0($2)
	bne	$2,$0,$L20
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,0($fp)
	j	$L19
$L20:
	lw	$2,20($fp)
	lb	$2,0($2)
	sw	$2,0($fp)
$L19:
	lw	$2,0($fp)
	move	$sp,$fp
	lw	$fp,8($sp)
	addiu	$sp,$sp,16
	j	$31
	.end	ord
	.align	2
	.globl	chr
	.ent	chr
chr:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	sw	$5,28($fp)
	lw	$2,28($fp)
	bltz	$2,$L24
	lw	$2,28($fp)
	slt	$2,$2,128
	beq	$2,$0,$L24
	j	$L23
$L24:
	lw	$4,24($fp)
	li	$5,1			# 0x1
	jal	exit
$L23:
	lw	$3,28($fp)
	la	$2,chars
	addu	$2,$3,$2
	move	$sp,$fp
	lw	$31,20($sp)
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	.end	chr
	.align	2
	.globl	size
	.ent	size
size:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-16
	sw	$fp,8($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$5,20($fp)
	sw	$0,0($fp)
$L26:
	lw	$2,20($fp)
	lb	$2,0($2)
	beq	$2,$0,$L27
	lw	$2,0($fp)
	addiu	$2,$2,1
	sw	$2,0($fp)
	lw	$2,20($fp)
	addiu	$2,$2,1
	sw	$2,20($fp)
	j	$L26
$L27:
	lw	$2,0($fp)
	move	$sp,$fp
	lw	$fp,8($sp)
	addiu	$sp,$sp,16
	j	$31
	.end	size
	.align	2
	.globl	substring
	.ent	substring
substring:
	.frame	$fp,40,$31		# vars= 16, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	sw	$4,40($fp)
	sw	$5,44($fp)
	sw	$6,48($fp)
	sw	$7,52($fp)
	lw	$4,40($fp)
	lw	$5,44($fp)
	jal	size
	sw	$2,16($fp)
	lw	$2,48($fp)
	bltz	$2,$L31
	lw	$3,48($fp)
	lw	$2,52($fp)
	addu	$3,$3,$2
	lw	$2,16($fp)
	slt	$2,$2,$3
	bne	$2,$0,$L31
	j	$L30
$L31:
	lw	$4,40($fp)
	li	$5,1			# 0x1
	jal	exit
$L30:
	lw	$3,52($fp)
	li	$2,1			# 0x1
	bne	$3,$2,$L32
	lw	$3,44($fp)
	lw	$2,48($fp)
	addu	$2,$3,$2
	lb	$2,0($2)
	la	$3,chars
	addu	$2,$2,$3
	sw	$2,28($fp)
	j	$L29
$L32:
	lw	$2,52($fp)
	addiu	$2,$2,1
	move	$4,$2
	jal	malloc
	sw	$2,20($fp)
	sw	$0,24($fp)
$L34:
	lw	$2,52($fp)
	blez	$2,$L35
	lw	$3,20($fp)
	lw	$2,24($fp)
	addu	$4,$3,$2
	lw	$3,48($fp)
	lw	$2,44($fp)
	addu	$3,$3,$2
	lw	$2,24($fp)
	addu	$2,$3,$2
	lbu	$2,0($2)
	sb	$2,0($4)
	lw	$2,24($fp)
	addiu	$2,$2,1
	sw	$2,24($fp)
	lw	$2,52($fp)
	addiu	$2,$2,-1
	sw	$2,52($fp)
	j	$L34
$L35:
	lw	$3,20($fp)
	lw	$2,24($fp)
	addu	$2,$3,$2
	sb	$0,0($2)
	lw	$2,20($fp)
	sw	$2,28($fp)
$L29:
	lw	$2,28($fp)
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	substring
	.align	2
	.globl	concat
	.ent	concat
concat:
	.frame	$fp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$fp,48($sp)
	move	$fp,$sp
	sw	$4,56($fp)
	sw	$5,60($fp)
	sw	$6,64($fp)
	lw	$4,56($fp)
	lw	$5,60($fp)
	jal	size
	sw	$2,16($fp)
	lw	$4,56($fp)
	lw	$5,64($fp)
	jal	size
	sw	$2,20($fp)
	lw	$2,16($fp)
	bne	$2,$0,$L37
	lw	$2,64($fp)
	sw	$2,40($fp)
	j	$L36
$L37:
	lw	$2,20($fp)
	bne	$2,$0,$L39
	lw	$2,60($fp)
	sw	$2,40($fp)
	j	$L36
$L39:
	lw	$3,16($fp)
	lw	$2,20($fp)
	addu	$2,$3,$2
	sw	$2,28($fp)
	lw	$2,28($fp)
	addiu	$2,$2,1
	move	$4,$2
	jal	malloc
	sw	$2,32($fp)
	lw	$2,32($fp)
	sw	$2,36($fp)
$L41:
	addiu	$6,$fp,32
	lw	$3,0($6)
	addiu	$4,$fp,60
	lw	$2,0($4)
	lbu	$5,0($2)
	addiu	$2,$2,1
	sw	$2,0($4)
	move	$2,$3
	sb	$5,0($2)
	addiu	$3,$3,1
	sw	$3,0($6)
	sll	$2,$5,24
	sra	$2,$2,24
	beq	$2,$0,$L42
	j	$L41
$L42:
	lw	$2,32($fp)
	addiu	$2,$2,-1
	sw	$2,32($fp)
$L43:
	addiu	$6,$fp,32
	lw	$3,0($6)
	addiu	$4,$fp,64
	lw	$2,0($4)
	lbu	$5,0($2)
	addiu	$2,$2,1
	sw	$2,0($4)
	move	$2,$3
	sb	$5,0($2)
	addiu	$3,$3,1
	sw	$3,0($6)
	sll	$2,$5,24
	sra	$2,$2,24
	beq	$2,$0,$L44
	j	$L43
$L44:
	lw	$2,36($fp)
	sw	$2,40($fp)
$L36:
	lw	$2,40($fp)
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	j	$31
	.end	concat
	.align	2
	.globl	tigernot
	.ent	tigernot
tigernot:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	sw	$5,12($fp)
	lw	$2,12($fp)
	xori	$2,$2,0x0
	sltu	$2,$2,1
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	j	$31
	.end	tigernot

	.comm	chars,512
