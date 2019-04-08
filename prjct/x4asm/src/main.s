	.file	"main.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"missing arguments"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	pushq	%rbx
	subq	$8, %rsp
	movq	(%rsi), %rax
	cmpl	$1, %edi
	movq	%rax, PROG_NAME(%rip)
	jle	.L8
	leal	-2(%rdi), %eax
	leaq	8(%rsi), %rbx
	leaq	16(%rsi,%rax,8), %rbp
	.p2align 4,,10
	.p2align 3
.L4:
	movq	(%rbx), %rdi
	addq	$8, %rbx
	call	init_fnames@PLT
	xorl	%eax, %eax
	call	assemble@PLT
	cmpq	%rbp, %rbx
	jne	.L4
.L3:
	movzbl	status(%rip), %eax
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	andl	$1, %eax
	ret
.L8:
	leaq	.LC0(%rip), %rdi
	call	die@PLT
	jmp	.L3
	.size	main, .-main
	.comm	IC,4,4
	.comm	DC,4,4
	.comm	PROG_NAME,8,8
	.ident	"GCC: (Ubuntu 7.2.0-8ubuntu3.2) 7.2.0"
	.section	.note.GNU-stack,"",@progbits
