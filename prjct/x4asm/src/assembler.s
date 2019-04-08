	.file	"assembler.c"
	.text
	.p2align 4,,15
	.globl	init
	.type	init, @function
init:
	andb	$-8, status(%rip)
	movl	$100, IC(%rip)
	movl	$0, NLINES(%rip)
	movl	$1, INP_LINE_POS(%rip)
	ret
	.size	init, .-init
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"w"
.LC1:
	.string	"\t%4d\t%d\n"
.LC2:
	.string	"%.4d\t"
.LC3:
	.string	"failed to save file: %s: %s"
.LC4:
	.string	"%s\t%d\n"
	.text
	.p2align 4,,15
	.globl	make_files
	.type	make_files, @function
make_files:
	pushq	%r15
	pushq	%r14
	leaq	.LC0(%rip), %rsi
	pushq	%r13
	pushq	%r12
	pushq	%rbp
	pushq	%rbx
	subq	$8, %rsp
	movq	OBJ_F(%rip), %rdi
	call	fopen@PLT
	movq	%rax, %rbp
	movl	IC(%rip), %eax
	movq	CODE_SEG_LIST(%rip), %r14
	movl	DC(%rip), %r8d
	leaq	.LC1(%rip), %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	leal	-100(%rax), %ecx
	xorl	%eax, %eax
	call	__fprintf_chk@PLT
	testq	%r14, %r14
	je	.L4
	leaq	.LC2(%rip), %r15
	.p2align 4,,10
	.p2align 3
.L9:
	movl	28(%r14), %ecx
	movq	%r15, %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	xorl	%eax, %eax
	movl	$13, %ebx
	movl	$1, %r12d
	call	__fprintf_chk@PLT
	movl	24(%r14), %r13d
	.p2align 4,,10
	.p2align 3
.L5:
	movl	%r12d, %eax
	movl	%ebx, %ecx
	movq	%rbp, %rsi
	sall	%cl, %eax
	testl	%r13d, %eax
	jne	.L6
	movl	$46, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L5
.L8:
	movq	%rbp, %rsi
	movl	$10, %edi
	call	fputc@PLT
	movq	32(%r14), %r14
	testq	%r14, %r14
	jne	.L9
.L4:
	movq	DATA_LIST(%rip), %r14
	testq	%r14, %r14
	je	.L10
	leaq	.LC2(%rip), %r15
	.p2align 4,,10
	.p2align 3
.L15:
	movl	4(%r14), %ecx
	movq	%r15, %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	xorl	%eax, %eax
	movl	$13, %ebx
	movl	$1, %r12d
	call	__fprintf_chk@PLT
	movl	(%r14), %r13d
	.p2align 4,,10
	.p2align 3
.L11:
	movl	%r12d, %eax
	movl	%ebx, %ecx
	movq	%rbp, %rsi
	sall	%cl, %eax
	testl	%r13d, %eax
	jne	.L12
	movl	$46, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L11
.L14:
	movq	%rbp, %rsi
	movl	$10, %edi
	call	fputc@PLT
	movq	8(%r14), %r14
	testq	%r14, %r14
	jne	.L15
.L10:
	movq	%rbp, %rdi
	call	fclose@PLT
	testl	%eax, %eax
	jne	.L52
.L16:
	movl	ENTRIES_DEF(%rip), %edx
	testl	%edx, %edx
	jne	.L53
.L18:
	cmpq	$0, EXTERN_REF_LIST(%rip)
	je	.L3
	movq	EXT_F(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	call	fopen@PLT
	movq	EXTERN_REF_LIST(%rip), %rbx
	movq	%rax, %rbp
	testq	%rbx, %rbx
	je	.L26
	leaq	.LC4(%rip), %r12
	.p2align 4,,10
	.p2align 3
.L27:
	movl	8(%rbx), %r8d
	movq	(%rbx), %rcx
	xorl	%eax, %eax
	movq	%r12, %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	call	__fprintf_chk@PLT
	movq	16(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L27
.L26:
	movq	%rbp, %rdi
	call	fclose@PLT
	testl	%eax, %eax
	jne	.L54
.L3:
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L6:
	movl	$47, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L5
	jmp	.L8
	.p2align 4,,10
	.p2align 3
.L12:
	movl	$47, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L11
	jmp	.L14
.L54:
	call	__errno_location@PLT
	movl	(%rax), %edi
	call	strerror@PLT
	addq	$8, %rsp
	movq	%rbp, %rdx
	leaq	.LC3(%rip), %rsi
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	movq	%rax, %rcx
	movl	$1, %edi
	xorl	%eax, %eax
	jmp	print_err@PLT
.L53:
	movq	ENT_F(%rip), %rdi
	leaq	.LC0(%rip), %rsi
	leaq	.LC4(%rip), %r12
	call	fopen@PLT
	movq	SYMBOL_TABLE(%rip), %rbx
	movq	%rax, %rbp
	testq	%rbx, %rbx
	je	.L20
	.p2align 4,,10
	.p2align 3
.L19:
	movl	16(%rbx), %eax
	testl	%eax, %eax
	jne	.L55
	movq	24(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L19
.L20:
	movq	%rbp, %rdi
	call	fclose@PLT
	testl	%eax, %eax
	je	.L18
.L56:
	call	__errno_location@PLT
	movl	(%rax), %edi
	call	strerror@PLT
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rcx
	movq	%rbp, %rdx
	movl	$1, %edi
	xorl	%eax, %eax
	call	print_err@PLT
	jmp	.L18
.L55:
	movl	12(%rbx), %r8d
	movq	(%rbx), %rcx
	xorl	%eax, %eax
	movq	%r12, %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	call	__fprintf_chk@PLT
	movq	24(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L19
	movq	%rbp, %rdi
	call	fclose@PLT
	testl	%eax, %eax
	je	.L18
	jmp	.L56
.L52:
	call	__errno_location@PLT
	movl	(%rax), %edi
	call	strerror@PLT
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rcx
	movq	%rbp, %rdx
	movl	$1, %edi
	xorl	%eax, %eax
	call	print_err@PLT
	jmp	.L16
	.size	make_files, .-make_files
	.section	.rodata.str1.1
.LC5:
	.string	"line is too long"
	.text
	.p2align 4,,15
	.globl	get_line
	.type	get_line, @function
get_line:
	pushq	%r13
	pushq	%r12
	leaq	status(%rip), %r13
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %r12
	movq	%rsi, %rbp
	xorl	%ebx, %ebx
	subq	$8, %rsp
.L58:
	movq	%r12, %rdi
	call	fgetc@PLT
	cmpb	$-1, %al
	movl	%eax, %edx
	je	.L64
.L115:
	cmpb	$10, %al
	je	.L113
	cmpl	$79, %ebx
	jg	.L114
.L80:
	cmpb	$59, %dl
	je	.L60
	movslq	%ebx, %rax
	movq	%r12, %rdi
	addl	$1, %ebx
	movb	%dl, 0(%rbp,%rax)
	call	fgetc@PLT
	cmpb	$-1, %al
	movl	%eax, %edx
	jne	.L115
.L64:
	testl	%ebx, %ebx
	je	.L84
.L113:
	movslq	%ebx, %rbx
	addq	%rbp, %rbx
.L63:
	movb	$0, (%rbx)
	movq	%rbp, %rax
.L57:
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L62:
	cmpb	$-1, %al
	je	.L64
.L60:
	movq	%r12, %rdi
	call	fgetc@PLT
	cmpb	$10, %al
	jne	.L62
	jmp	.L113
	.p2align 4,,10
	.p2align 3
.L114:
	cmpl	$80, %ebx
	jne	.L58
.L81:
	cmpb	$-1, %dl
	je	.L66
	cmpb	$9, %dl
	je	.L105
	cmpb	$32, %dl
	je	.L105
.L67:
	cmpb	$59, %dl
	je	.L72
	leaq	.LC5(%rip), %rsi
	xorl	%edi, %edi
	xorl	%eax, %eax
	orb	$1, 0(%r13)
	addl	$1, NLINES(%rip)
	call	print_err@PLT
	jmp	.L75
	.p2align 4,,10
	.p2align 3
.L116:
	cmpb	$-1, %al
	je	.L66
.L75:
	movq	%r12, %rdi
	call	fgetc@PLT
	cmpb	$10, %al
	jne	.L116
.L66:
	testb	$1, 0(%r13)
	je	.L78
	movq	%r12, %rdi
	addl	$1, NLINES(%rip)
	call	fgetc@PLT
	cmpb	$-1, %al
	movl	%eax, %edx
	je	.L84
	cmpb	$10, %al
	je	.L117
	xorl	%ebx, %ebx
	jmp	.L80
	.p2align 4,,10
	.p2align 3
.L78:
	movq	%r12, %rdi
	call	fgetc@PLT
	cmpb	$-1, %al
	movl	%eax, %edx
	je	.L87
	cmpb	$10, %al
	jne	.L81
.L87:
	leaq	80(%rbp), %rbx
	jmp	.L63
	.p2align 4,,10
	.p2align 3
.L118:
	cmpb	$10, %al
	je	.L86
.L72:
	movq	%r12, %rdi
	call	fgetc@PLT
	cmpb	$-1, %al
	jne	.L118
.L86:
	movb	$0, 80(%rbp)
	movq	%rbp, %rax
	jmp	.L57
	.p2align 4,,10
	.p2align 3
.L105:
	movq	%r12, %rdi
	call	fgetc@PLT
	cmpb	$10, %al
	movl	%eax, %edx
	je	.L66
	cmpb	$-1, %al
	je	.L66
	cmpb	$32, %al
	je	.L105
	cmpb	$9, %al
	jne	.L67
	jmp	.L105
.L84:
	xorl	%eax, %eax
	jmp	.L57
.L117:
	movq	%rbp, %rbx
	jmp	.L63
	.size	get_line, .-get_line
	.p2align 4,,15
	.globl	pass
	.type	pass, @function
pass:
	pushq	%r12
	movq	%rsi, %r12
	pushq	%rbp
	movq	%rdi, %rbp
	pushq	%rbx
	movq	%rdx, %rbx
	jmp	.L120
	.p2align 4,,10
	.p2align 3
.L122:
	xorl	%eax, %eax
	addl	$1, NLINES(%rip)
	movq	%rbx, in_line_ptr(%rip)
	movq	%rbx, LINE(%rip)
	call	skip_whitespaces@PLT
	movq	in_line_ptr(%rip), %rax
	cmpb	$0, (%rax)
	je	.L121
	xorl	%eax, %eax
	call	*%r12
.L121:
	andb	$-3, status(%rip)
	movl	$1, INP_LINE_POS(%rip)
.L120:
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	get_line
	testq	%rax, %rax
	movq	%rax, %rbx
	jne	.L122
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
	.size	pass, .-pass
	.section	.rodata.str1.1
.LC6:
	.string	"failed to allocate memory"
.LC7:
	.string	"r"
.LC8:
	.string	"Could not open file `%s': %s"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC9:
	.string	"+++++++++++++ PASS 1 +++++++++++++: %s\n"
	.align 8
.LC10:
	.string	"+++++++++++++ PASS 2 +++++++++++++: %s\n"
	.text
	.p2align 4,,15
	.globl	assemble
	.type	assemble, @function
assemble:
	pushq	%r12
	pushq	%rbp
	movl	$80, %edi
	pushq	%rbx
	call	malloc@PLT
	testq	%rax, %rax
	movq	%rax, %rbp
	je	.L150
.L125:
	movq	SRC_F(%rip), %rdi
	leaq	.LC7(%rip), %rsi
	andb	$-8, status(%rip)
	movl	$16, NINST(%rip)
	movl	$8, NREGS(%rip)
	movl	$28, NRESERVED(%rip)
	movq	$0, SYMBOL_TABLE(%rip)
	movq	$0, DATA_LIST(%rip)
	movq	$0, CODE_TABLE(%rip)
	movq	$0, CODE_SEG_LIST(%rip)
	movl	$0, ENTRIES_DEF(%rip)
	movl	$0, DC(%rip)
	movl	$100, IC(%rip)
	movl	$0, NLINES(%rip)
	movl	$1, INP_LINE_POS(%rip)
	call	fopen@PLT
	testq	%rax, %rax
	movq	%rax, %r12
	je	.L151
	movq	SRC_F(%rip), %rdx
	leaq	.LC9(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	movq	%rbp, %rbx
	call	__printf_chk@PLT
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L129:
	xorl	%eax, %eax
	addl	$1, NLINES(%rip)
	movq	%rbx, in_line_ptr(%rip)
	movq	%rbx, LINE(%rip)
	call	skip_whitespaces@PLT
	movq	in_line_ptr(%rip), %rax
	cmpb	$0, (%rax)
	je	.L128
	xorl	%eax, %eax
	call	parse_in_line@PLT
.L128:
	andb	$-3, status(%rip)
	movl	$1, INP_LINE_POS(%rip)
.L127:
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	get_line
	testq	%rax, %rax
	movq	%rax, %rbx
	jne	.L129
	testb	$1, status(%rip)
	jne	.L149
	movq	SYMBOL_TABLE(%rip), %rax
	testq	%rax, %rax
	je	.L131
	movl	IC(%rip), %edx
	.p2align 4,,10
	.p2align 3
.L132:
	cmpl	$1, 8(%rax)
	je	.L152
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L132
.L131:
	movq	DATA_LIST(%rip), %rax
	testq	%rax, %rax
	je	.L135
.L153:
	movl	IC(%rip), %edx
	.p2align 4,,10
	.p2align 3
.L136:
	addl	%edx, 4(%rax)
	movq	8(%rax), %rax
	testq	%rax, %rax
	jne	.L136
.L135:
	movq	%r12, %rdi
	call	rewind@PLT
	movq	SRC_F(%rip), %rdx
	leaq	.LC10(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	andb	$-8, status(%rip)
	movl	$100, IC(%rip)
	movl	$0, NLINES(%rip)
	movl	$1, INP_LINE_POS(%rip)
	call	__printf_chk@PLT
	jmp	.L137
	.p2align 4,,10
	.p2align 3
.L139:
	xorl	%eax, %eax
	addl	$1, NLINES(%rip)
	movq	%rbp, in_line_ptr(%rip)
	movq	%rbp, LINE(%rip)
	call	skip_whitespaces@PLT
	movq	in_line_ptr(%rip), %rax
	cmpb	$0, (%rax)
	je	.L138
	xorl	%eax, %eax
	call	parse_in_line_2@PLT
.L138:
	andb	$-3, status(%rip)
	movl	$1, INP_LINE_POS(%rip)
.L137:
	movq	%rbp, %rsi
	movq	%r12, %rdi
	call	get_line
	testq	%rax, %rax
	movq	%rax, %rbp
	jne	.L139
	testb	$1, status(%rip)
	jne	.L149
	xorl	%eax, %eax
	call	make_files
.L149:
	popq	%rbx
	movq	%r12, %rdi
	popq	%rbp
	popq	%r12
	jmp	fclose@PLT
	.p2align 4,,10
	.p2align 3
.L152:
	addl	%edx, 12(%rax)
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L132
	movq	DATA_LIST(%rip), %rax
	testq	%rax, %rax
	jne	.L153
	jmp	.L135
	.p2align 4,,10
	.p2align 3
.L151:
	call	__errno_location@PLT
	movl	(%rax), %edi
	call	strerror@PLT
	popq	%rbx
	popq	%rbp
	popq	%r12
	movq	SRC_F(%rip), %rdx
	leaq	.LC8(%rip), %rsi
	movq	%rax, %rcx
	movl	$3, %edi
	xorl	%eax, %eax
	jmp	print_err@PLT
	.p2align 4,,10
	.p2align 3
.L150:
	leaq	.LC6(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	print_err@PLT
	jmp	.L125
	.size	assemble, .-assemble
	.p2align 4,,15
	.globl	update_labels
	.type	update_labels, @function
update_labels:
	testq	%rdi, %rdi
	je	.L154
	movl	IC(%rip), %eax
	.p2align 4,,10
	.p2align 3
.L156:
	cmpl	$1, 8(%rdi)
	je	.L162
	movq	24(%rdi), %rdi
	testq	%rdi, %rdi
	jne	.L156
.L154:
	rep ret
	.p2align 4,,10
	.p2align 3
.L162:
	addl	%eax, 12(%rdi)
	movq	24(%rdi), %rdi
	testq	%rdi, %rdi
	jne	.L156
	rep ret
	.size	update_labels, .-update_labels
	.p2align 4,,15
	.globl	update_data_seg
	.type	update_data_seg, @function
update_data_seg:
	testq	%rdi, %rdi
	je	.L163
	movl	IC(%rip), %eax
	.p2align 4,,10
	.p2align 3
.L165:
	addl	%eax, 4(%rdi)
	movq	8(%rdi), %rdi
	testq	%rdi, %rdi
	jne	.L165
.L163:
	rep ret
	.size	update_data_seg, .-update_data_seg
	.section	.rodata.str1.1
.LC11:
	.string	"undefined label: `%s'\n"
	.text
	.p2align 4,,15
	.globl	update_code_seg
	.type	update_code_seg, @function
update_code_seg:
	pushq	%r13
	pushq	%r12
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %rbp
	subq	$8, %rsp
	movq	SYMBOL_TABLE(%rip), %rbx
	testq	%rbx, %rbx
	je	.L171
	movl	%esi, %r13d
	jmp	.L175
	.p2align 4,,10
	.p2align 3
.L172:
	movq	24(%rbx), %rbx
	testq	%rbx, %rbx
	je	.L171
.L175:
	movq	(%rbx), %r12
	movq	%rbp, %rdi
	movq	%r12, %rsi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L172
	movq	CODE_SEG_LIST(%rip), %rbp
	testq	%rbp, %rbp
	jne	.L173
	jmp	.L170
	.p2align 4,,10
	.p2align 3
.L176:
	movq	32(%rbp), %rbp
	testq	%rbp, %rbp
	je	.L170
.L173:
	cmpl	%r13d, 28(%rbp)
	jne	.L176
	movzwl	24(%rbp), %edx
	movl	%edx, %eax
	andw	$-16381, %dx
	shrw	$2, %ax
	orw	12(%rbx), %ax
	andw	$4095, %ax
	sall	$2, %eax
	orl	%edx, %eax
	cmpl	$2, 8(%rbx)
	movw	%ax, 24(%rbp)
	movzbl	24(%rbp), %eax
	je	.L188
	andl	$-4, %eax
	orl	$2, %eax
	movb	%al, 24(%rbp)
	movq	32(%rbp), %rbp
	testq	%rbp, %rbp
	jne	.L173
.L170:
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L171:
	addq	$8, %rsp
	movq	%rbp, %rdx
	leaq	.LC11(%rip), %rsi
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	xorl	%edi, %edi
	xorl	%eax, %eax
	jmp	print_err@PLT
	.p2align 4,,10
	.p2align 3
.L188:
	andl	$-4, %eax
	movl	$24, %edi
	orl	$1, %eax
	movb	%al, 24(%rbp)
	call	malloc@PLT
	movq	EXTERN_REF_LIST(%rip), %rcx
	movq	%r12, (%rax)
	movl	%r13d, 8(%rax)
	movq	$0, 16(%rax)
	testq	%rcx, %rcx
	jne	.L178
	jmp	.L189
	.p2align 4,,10
	.p2align 3
.L179:
	movq	%rdx, %rcx
.L178:
	movq	16(%rcx), %rdx
	testq	%rdx, %rdx
	jne	.L179
	movq	%rax, 16(%rcx)
	jmp	.L176
	.p2align 4,,10
	.p2align 3
.L189:
	movq	%rax, EXTERN_REF_LIST(%rip)
	jmp	.L176
	.size	update_code_seg, .-update_code_seg
	.p2align 4,,15
	.globl	add_extern_ref
	.type	add_extern_ref, @function
add_extern_ref:
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %rbp
	movl	$24, %edi
	movl	%esi, %ebx
	subq	$8, %rsp
	call	malloc@PLT
	movq	EXTERN_REF_LIST(%rip), %rcx
	movq	%rbp, (%rax)
	movl	%ebx, 8(%rax)
	movq	$0, 16(%rax)
	testq	%rcx, %rcx
	jne	.L191
	jmp	.L196
	.p2align 4,,10
	.p2align 3
.L193:
	movq	%rdx, %rcx
.L191:
	movq	16(%rcx), %rdx
	testq	%rdx, %rdx
	jne	.L193
	movq	%rax, 16(%rcx)
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.p2align 4,,10
	.p2align 3
.L196:
	movq	%rax, EXTERN_REF_LIST(%rip)
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	add_extern_ref, .-add_extern_ref
	.p2align 4,,15
	.globl	append_extern
	.type	append_extern, @function
append_extern:
	movq	(%rdi), %rdx
	testq	%rdx, %rdx
	jne	.L198
	jmp	.L202
	.p2align 4,,10
	.p2align 3
.L200:
	movq	%rax, %rdx
.L198:
	movq	16(%rdx), %rax
	testq	%rax, %rax
	jne	.L200
	movq	%rsi, 16(%rdx)
	ret
	.p2align 4,,10
	.p2align 3
.L202:
	movq	%rsi, (%rdi)
	ret
	.size	append_extern, .-append_extern
	.p2align 4,,15
	.globl	handle_ops2
	.type	handle_ops2, @function
handle_ops2:
	pushq	%rbp
	pushq	%rbx
	xorl	%eax, %eax
	movl	%edi, %ebp
	movl	$1, %ebx
	subq	$8, %rsp
	call	skip_whitespaces@PLT
	xorl	%eax, %eax
	call	is_junk@PLT
	testl	%eax, %eax
	jne	.L203
	movl	%ebp, %r8d
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	xorl	%edi, %edi
	xorl	%esi, %esi
	movl	%eax, %ebx
	call	xencode_code_word@PLT
.L203:
	addq	$8, %rsp
	movl	%ebx, %eax
	popq	%rbx
	popq	%rbp
	ret
	.size	handle_ops2, .-handle_ops2
	.p2align 4,,15
	.globl	handle2_ops0
	.type	handle2_ops0, @function
handle2_ops0:
	pushq	%r15
	pushq	%r14
	xorl	%eax, %eax
	pushq	%r13
	pushq	%r12
	pushq	%rbp
	pushq	%rbx
	subq	$8, %rsp
	call	get_op0@PLT
	movq	%rax, %r13
	xorl	%eax, %eax
	addq	$1, in_line_ptr(%rip)
	call	skip_whitespaces@PLT
	xorl	%eax, %eax
	call	get_op0@PLT
	movl	NREGS(%rip), %r12d
	movq	%rax, %r14
	testl	%r12d, %r12d
	jle	.L208
	xorl	%ebx, %ebx
	leaq	registers(%rip), %rbp
	jmp	.L211
	.p2align 4,,10
	.p2align 3
.L209:
	addq	$1, %rbx
	cmpl	%ebx, %r12d
	jle	.L208
.L211:
	movq	%rbx, %rax
	movq	%r13, %rdi
	movslq	%ebx, %r15
	salq	$4, %rax
	movq	0(%rbp,%rax), %rsi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L209
	salq	$4, %r15
	cmpl	$-1, 8(%rbp,%r15)
	je	.L208
	xorl	%ebx, %ebx
	jmp	.L210
	.p2align 4,,10
	.p2align 3
.L212:
	addq	$1, %rbx
	cmpl	%ebx, %r12d
	jle	.L208
.L210:
	movq	%rbx, %rax
	movq	%r14, %rdi
	movslq	%ebx, %r15
	salq	$4, %rax
	movq	0(%rbp,%rax), %rsi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L212
	movl	IC(%rip), %eax
	salq	$4, %r15
	addl	$1, %eax
	cmpl	$-1, 8(%rbp,%r15)
	je	.L208
	movl	%eax, IC(%rip)
.L214:
	addq	$8, %rsp
	xorl	%eax, %eax
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L208:
	movq	%r13, %rdi
	addl	$1, IC(%rip)
	call	is_label@PLT
	testl	%eax, %eax
	jne	.L226
.L215:
	movq	%r14, %rdi
	addl	$1, IC(%rip)
	call	is_label@PLT
	testl	%eax, %eax
	je	.L214
	movl	IC(%rip), %esi
	movq	%r14, %rdi
	call	update_code_seg
	jmp	.L214
	.p2align 4,,10
	.p2align 3
.L226:
	movl	IC(%rip), %esi
	movq	%r13, %rdi
	call	update_code_seg
	jmp	.L215
	.size	handle2_ops0, .-handle2_ops0
	.p2align 4,,15
	.globl	handle2_ops1
	.type	handle2_ops1, @function
handle2_ops1:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	call	get_op1@PLT
	movq	%rax, %rdi
	addl	$1, IC(%rip)
	movq	%rax, (%rsp)
	call	is_op_params@PLT
	testl	%eax, %eax
	je	.L228
	movq	(%rsp), %rdi
	movq	%rsp, %rbx
	movq	%rbx, %rsi
	call	get_op_p@PLT
	movq	(%rsp), %rdi
	movq	%rbx, %rsi
	movq	%rax, %rbp
	call	get_param1@PLT
	movq	(%rsp), %rdi
	movq	%rbx, %rsi
	movq	%rax, %r13
	call	get_param2@PLT
	movl	IC(%rip), %esi
	movq	%rbp, %rdi
	movq	%rax, %r14
	call	update_code_seg
	movl	NREGS(%rip), %r12d
	testl	%r12d, %r12d
	jle	.L229
	xorl	%ebx, %ebx
	leaq	registers(%rip), %rbp
	jmp	.L232
	.p2align 4,,10
	.p2align 3
.L230:
	addq	$1, %rbx
	cmpl	%ebx, %r12d
	jle	.L229
.L232:
	movq	%rbx, %rax
	movq	%r13, %rdi
	movslq	%ebx, %r15
	salq	$4, %rax
	movq	0(%rbp,%rax), %rsi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L230
	salq	$4, %r15
	cmpl	$-1, 8(%rbp,%r15)
	je	.L229
	xorl	%ebx, %ebx
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L233:
	addq	$1, %rbx
	cmpl	%ebx, %r12d
	jle	.L229
.L231:
	movq	%rbx, %rax
	movq	%r14, %rdi
	movslq	%ebx, %r15
	salq	$4, %rax
	movq	0(%rbp,%rax), %rsi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L233
	movl	IC(%rip), %eax
	salq	$4, %r15
	addl	$1, %eax
	cmpl	$-1, 8(%rbp,%r15)
	je	.L229
	movl	%eax, IC(%rip)
.L235:
	xorl	%eax, %eax
	movq	8(%rsp), %rdx
	xorq	%fs:40, %rdx
	jne	.L250
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L228:
	movq	(%rsp), %rdi
	call	is_label@PLT
	testl	%eax, %eax
	je	.L235
	movl	IC(%rip), %esi
	movq	(%rsp), %rdi
	call	update_code_seg
	jmp	.L235
	.p2align 4,,10
	.p2align 3
.L229:
	movq	%r13, %rdi
	addl	$1, IC(%rip)
	call	is_label@PLT
	testl	%eax, %eax
	jne	.L251
.L236:
	movq	%r14, %rdi
	addl	$1, IC(%rip)
	call	is_label@PLT
	testl	%eax, %eax
	je	.L235
	movl	IC(%rip), %esi
	movq	%r14, %rdi
	call	update_code_seg
	jmp	.L235
	.p2align 4,,10
	.p2align 3
.L251:
	movl	IC(%rip), %esi
	movq	%r13, %rdi
	call	update_code_seg
	jmp	.L236
.L250:
	call	__stack_chk_fail@PLT
	.size	handle2_ops1, .-handle2_ops1
	.section	.rodata.str1.1
.LC12:
	.string	"bad operand: `%s'\n"
	.text
	.p2align 4,,15
	.globl	analyze_op
	.type	analyze_op, @function
analyze_op:
	pushq	%r15
	pushq	%r14
	movl	%esi, %r15d
	pushq	%r13
	pushq	%r12
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %rbp
	subq	$8, %rsp
	movl	NREGS(%rip), %r13d
	testl	%r13d, %r13d
	jle	.L253
	xorl	%ebx, %ebx
	leaq	registers(%rip), %r14
	jmp	.L256
	.p2align 4,,10
	.p2align 3
.L254:
	addq	$1, %rbx
	cmpl	%ebx, %r13d
	jle	.L253
.L256:
	movq	%rbx, %rax
	movq	%rbp, %rdi
	movslq	%ebx, %r12
	salq	$4, %rax
	movq	(%r14,%rax), %rsi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L254
	salq	$4, %r12
	movl	8(%r14,%r12), %edx
	cmpl	$-1, %edx
	je	.L253
	andl	$4095, %edx
	addq	$8, %rsp
	movq	%rbp, %rax
	salq	$32, %rdx
	popq	%rbx
	orq	$3, %rdx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L253:
	movsbq	0(%rbp), %rbx
	cmpb	$35, %bl
	je	.L269
	call	__ctype_b_loc@PLT
	movq	(%rax), %rax
	testb	$4, 1(%rax,%rbx,2)
	je	.L261
	movq	%rbp, %rdi
	call	valid_label@PLT
	testl	%eax, %eax
	je	.L262
	xorl	%edx, %edx
	cmpl	$1, %r15d
	sbbl	%ecx, %ecx
	addl	$2, %ecx
	jmp	.L260
	.p2align 4,,10
	.p2align 3
.L261:
	leaq	.LC12(%rip), %rsi
	movq	%rbp, %rdx
	xorl	%edi, %edi
	xorl	%eax, %eax
	xorl	%ebp, %ebp
	call	print_err@PLT
	xorl	%edx, %edx
	xorl	%ecx, %ecx
.L260:
	andl	$4095, %edx
	addq	$8, %rsp
	movq	%rbp, %rax
	salq	$32, %rdx
	movq	%rdx, %rsi
	movl	%ecx, %edx
	popq	%rbx
	orq	%rsi, %rdx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L269:
	leaq	1(%rbp), %rbx
	movq	%rbx, %rdi
	call	valid_int@PLT
	testl	%eax, %eax
	jne	.L259
.L262:
	addq	$8, %rsp
	xorl	%eax, %eax
	xorl	%edx, %edx
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L259:
	movl	$10, %edx
	xorl	%esi, %esi
	movq	%rbx, %rdi
	call	strtol@PLT
	movl	%eax, %edx
	xorl	%ecx, %ecx
	andw	$4095, %dx
	jmp	.L260
	.size	analyze_op, .-analyze_op
	.section	.rodata.str1.1
.LC13:
	.string	"assembler.c"
	.section	.rodata.str1.8
	.align 8
.LC14:
	.string	"inst == MOV || inst == CMP || inst == ADD || inst == SUB || inst == LEA"
	.align 8
.LC15:
	.string	"unexpected comma after instruction"
	.align 8
.LC16:
	.string	"operand is expected after instruction"
	.section	.rodata.str1.1
.LC17:
	.string	"two operands expected"
	.section	.rodata.str1.8
	.align 8
.LC18:
	.string	"comma is expected after first operand"
	.align 8
.LC19:
	.string	"operand is expected after comma"
	.text
	.p2align 4,,15
	.globl	handle_ops0
	.type	handle_ops0, @function
handle_ops0:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbp
	pushq	%rbx
	movl	%edi, %ebx
	subq	$8, %rsp
	cmpl	$3, %edi
	jbe	.L271
	cmpl	$6, %edi
	jne	.L289
.L271:
	xorl	%eax, %eax
	call	get_op0@PLT
	movq	%rax, %r12
	movq	in_line_ptr(%rip), %rax
	testq	%r12, %r12
	je	.L290
	movzbl	(%rax), %edx
	testb	%dl, %dl
	je	.L291
	cmpb	$44, %dl
	jne	.L275
	addq	$1, %rax
	movq	%rax, in_line_ptr(%rip)
	xorl	%eax, %eax
	call	skip_whitespaces@PLT
	xorl	%eax, %eax
	call	get_op0@PLT
	testq	%rax, %rax
	movq	%rax, %r13
	je	.L292
.L278:
	xorl	%eax, %eax
	call	is_junk@PLT
	testl	%eax, %eax
	movl	%eax, %ebp
	je	.L293
	movl	$1, %ebp
	jmp	.L270
	.p2align 4,,10
	.p2align 3
.L291:
	leaq	.LC17(%rip), %rsi
	xorl	%edi, %edi
	xorl	%eax, %eax
	movl	$1, %ebp
	call	print_err@PLT
.L270:
	addq	$8, %rsp
	movl	%ebp, %eax
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L290:
	movzbl	(%rax), %eax
	cmpb	$44, %al
	je	.L294
	testb	%al, %al
	je	.L295
.L275:
	leaq	.LC18(%rip), %rsi
	xorl	%edi, %edi
	xorl	%eax, %eax
	movl	$1, %ebp
	call	print_err@PLT
	jmp	.L270
	.p2align 4,,10
	.p2align 3
.L293:
	xorl	%esi, %esi
	movq	%r12, %rdi
	call	analyze_op
	testq	%rax, %rax
	movq	%rax, %r12
	movq	%rdx, %r14
	je	.L270
	xorl	%esi, %esi
	movq	%r13, %rdi
	call	analyze_op
	testq	%rax, %rax
	movq	%rax, %r13
	movq	%rdx, %r15
	je	.L270
	movl	%ebx, %r8d
	movq	%rax, %rdx
	movq	%r15, %rcx
	movq	%r12, %rdi
	movq	%r14, %rsi
	call	validate_cat1_ops@PLT
	testl	%eax, %eax
	je	.L270
	movl	%ebx, %r8d
	movq	%r13, %rdx
	movq	%r15, %rcx
	movq	%r12, %rdi
	movq	%r14, %rsi
	call	xencode_code_word@PLT
	jmp	.L270
	.p2align 4,,10
	.p2align 3
.L295:
	leaq	.LC16(%rip), %rsi
	xorl	%edi, %edi
	movl	$1, %ebp
	call	print_err@PLT
	jmp	.L270
	.p2align 4,,10
	.p2align 3
.L294:
	leaq	.LC15(%rip), %rsi
	xorl	%edi, %edi
	xorl	%eax, %eax
	movl	$1, %ebp
	call	print_err@PLT
	jmp	.L270
	.p2align 4,,10
	.p2align 3
.L292:
	leaq	.LC19(%rip), %rsi
	xorl	%edi, %edi
	xorl	%eax, %eax
	call	print_err@PLT
	jmp	.L278
.L289:
	leaq	__PRETTY_FUNCTION__.4007(%rip), %rcx
	leaq	.LC13(%rip), %rsi
	leaq	.LC14(%rip), %rdi
	movl	$349, %edx
	call	__assert_fail@PLT
	.size	handle_ops0, .-handle_ops0
	.section	.rodata.str1.1
.LC20:
	.string	"bad parameter: `%s'"
	.text
	.p2align 4,,15
	.globl	analyze_p_op
	.type	analyze_p_op, @function
analyze_p_op:
	pushq	%r14
	pushq	%r13
	movl	NREGS(%rip), %r13d
	pushq	%r12
	pushq	%rbp
	movq	%rdi, %rbp
	pushq	%rbx
	testl	%r13d, %r13d
	jle	.L297
	xorl	%ebx, %ebx
	leaq	registers(%rip), %r14
	jmp	.L300
	.p2align 4,,10
	.p2align 3
.L298:
	addq	$1, %rbx
	cmpl	%ebx, %r13d
	jle	.L297
.L300:
	movq	%rbx, %rax
	movq	%rbp, %rdi
	movslq	%ebx, %r12
	salq	$4, %rax
	movq	(%r14,%rax), %rsi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L298
	salq	$4, %r12
	movl	8(%r14,%r12), %edx
	cmpl	$-1, %edx
	je	.L297
	andl	$4095, %edx
	movabsq	$52776558133251, %rcx
	movq	%rbp, %rax
	salq	$32, %rdx
	popq	%rbx
	orq	%rcx, %rdx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L297:
	movsbq	0(%rbp), %rbx
	cmpb	$35, %bl
	je	.L312
	call	__ctype_b_loc@PLT
	movq	(%rax), %rax
	testb	$4, 1(%rax,%rbx,2)
	je	.L305
	movq	%rbp, %rdi
	call	valid_label@PLT
	testl	%eax, %eax
	je	.L306
	movl	$1, %ecx
	xorl	%eax, %eax
	movl	$1, %edx
	jmp	.L304
	.p2align 4,,10
	.p2align 3
.L305:
	leaq	.LC20(%rip), %rsi
	movq	%rbp, %rdx
	xorl	%eax, %eax
	xorl	%edi, %edi
	xorl	%ebp, %ebp
	call	print_err@PLT
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	xorl	%edx, %edx
.L304:
	andl	$4095, %eax
	andl	$1, %edx
	andl	$1, %ecx
	salq	$32, %rax
	salq	$44, %rcx
	orq	%rax, %rdx
	movq	%rbp, %rax
	popq	%rbx
	orq	%rcx, %rdx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L312:
	leaq	1(%rbp), %rbx
	movq	%rbx, %rdi
	call	valid_int@PLT
	testl	%eax, %eax
	jne	.L303
.L306:
	popq	%rbx
	xorl	%eax, %eax
	xorl	%edx, %edx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
.L303:
	movl	$10, %edx
	xorl	%esi, %esi
	movq	%rbx, %rdi
	call	strtol@PLT
	xorl	%ecx, %ecx
	andw	$4095, %ax
	xorl	%edx, %edx
	jmp	.L304
	.size	analyze_p_op, .-analyze_p_op
	.section	.rodata.str1.8
	.align 8
.LC21:
	.string	"inst == NOT || inst == CLR || inst == INC || inst == DEC || inst == JMP || inst == BNE || inst == RED || inst == PRN || inst == JSR"
	.align 8
.LC22:
	.string	"valid operand is expected after `%s' instruction"
	.text
	.p2align 4,,15
	.globl	handle_ops1
	.type	handle_ops1, @function
handle_ops1:
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbp
	pushq	%rbx
	movl	%edi, %ebx
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leal	-4(%rbx), %eax
	cmpl	$1, %eax
	jbe	.L314
	leal	-7(%rbx), %eax
	cmpl	$6, %eax
	jbe	.L314
	leaq	__PRETTY_FUNCTION__.4014(%rip), %rcx
	leaq	.LC13(%rip), %rsi
	leaq	.LC21(%rip), %rdi
	movl	$405, %edx
	call	__assert_fail@PLT
	.p2align 4,,10
	.p2align 3
.L314:
	xorl	%eax, %eax
	call	get_op1@PLT
	testq	%rax, %rax
	movq	%rax, 16(%rsp)
	je	.L328
	xorl	%eax, %eax
	movl	$1, %ebp
	call	skip_whitespaces@PLT
	xorl	%eax, %eax
	call	is_junk@PLT
	testl	%eax, %eax
	je	.L329
.L313:
	movq	24(%rsp), %rcx
	xorq	%fs:40, %rcx
	movl	%ebp, %eax
	jne	.L330
	addq	$32, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L329:
	movq	16(%rsp), %rdi
	call	is_op_params@PLT
	testl	%eax, %eax
	movl	%eax, %ebp
	je	.L317
	leaq	16(%rsp), %rbp
	movq	16(%rsp), %rdi
	movq	%rbp, %rsi
	call	get_op_p@PLT
	movq	16(%rsp), %rdi
	movq	%rbp, %rsi
	movq	%rax, %r12
	call	get_param1@PLT
	testq	%rax, %rax
	movq	%rax, %r13
	je	.L318
	movq	16(%rsp), %rdi
	movq	%rbp, %rsi
	call	get_param2@PLT
	testq	%rax, %rax
	movq	%rax, %rbp
	je	.L318
	movl	$1, %esi
	movq	%r12, %rdi
	call	analyze_op
	movq	%r13, %rdi
	movq	%rdx, 8(%rsp)
	movq	%rax, %r12
	call	analyze_p_op
	movq	%rbp, %rdi
	movq	%rax, %r13
	movq	%rdx, %r14
	call	analyze_p_op
	movq	8(%rsp), %rcx
	subq	$8, %rsp
	movq	%rdx, %r9
	pushq	%rbx
	movq	%r13, %rdx
	movq	%rax, %r8
	movq	%r12, %rdi
	xorl	%ebp, %ebp
	movq	%rcx, %rsi
	movq	%r14, %rcx
	call	xencode_param_code_word@PLT
	popq	%rax
	popq	%rdx
	jmp	.L313
	.p2align 4,,10
	.p2align 3
.L328:
	leaq	INSTRUCTIONS_LIST(%rip), %rax
	leaq	.LC22(%rip), %rsi
	xorl	%edi, %edi
	movl	$1, %ebp
	movq	(%rax,%rbx,8), %rdx
	xorl	%eax, %eax
	call	print_err@PLT
	jmp	.L313
	.p2align 4,,10
	.p2align 3
.L317:
	movq	16(%rsp), %rdi
	xorl	%esi, %esi
	call	analyze_op
	movl	%ebx, %r8d
	movq	%rdx, %rcx
	xorl	%edi, %edi
	movq	%rax, %rdx
	xorl	%esi, %esi
	call	xencode_code_word@PLT
	jmp	.L313
	.p2align 4,,10
	.p2align 3
.L318:
	movl	$1, %ebp
	jmp	.L313
.L330:
	call	__stack_chk_fail@PLT
	.size	handle_ops1, .-handle_ops1
	.p2align 4,,15
	.globl	is_register
	.type	is_register, @function
is_register:
	pushq	%r14
	pushq	%r13
	movl	$-1, %eax
	movl	NREGS(%rip), %r13d
	pushq	%r12
	pushq	%rbp
	pushq	%rbx
	testl	%r13d, %r13d
	jle	.L331
	movq	%rdi, %rbp
	xorl	%ebx, %ebx
	leaq	registers(%rip), %r14
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L333:
	addq	$1, %rbx
	cmpl	%ebx, %r13d
	jle	.L338
.L334:
	movq	%rbx, %rax
	movq	%rbp, %rdi
	movslq	%ebx, %r12
	salq	$4, %rax
	movq	(%r14,%rax), %rsi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L333
	salq	$4, %r12
	movl	8(%r14,%r12), %eax
.L331:
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L338:
	popq	%rbx
	movl	$-1, %eax
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.size	is_register, .-is_register
	.p2align 4,,15
	.globl	getMbit
	.type	getMbit, @function
getMbit:
	movl	%esi, %ecx
	movl	$1, %eax
	sall	%cl, %eax
	testl	%edi, %eax
	setne	%al
	addl	$46, %eax
	ret
	.size	getMbit, .-getMbit
	.p2align 4,,15
	.globl	getNthbit
	.type	getNthbit, @function
getNthbit:
	movl	%esi, %ecx
	movl	$1, %eax
	sall	%cl, %eax
	testl	%edi, %eax
	setne	%al
	movzbl	%al, %eax
	ret
	.size	getNthbit, .-getNthbit
	.p2align 4,,15
	.globl	fprint_bits
	.type	fprint_bits, @function
fprint_bits:
	pushq	%r13
	pushq	%r12
	movq	%rdi, %r13
	pushq	%rbp
	pushq	%rbx
	movl	%esi, %r12d
	movl	$13, %ebx
	movl	$1, %ebp
	subq	$8, %rsp
	.p2align 4,,10
	.p2align 3
.L344:
	movl	%ebp, %eax
	movl	%ebx, %ecx
	movq	%r13, %rsi
	sall	%cl, %eax
	testl	%r12d, %eax
	jne	.L345
	movl	$46, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L344
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L345:
	movl	$47, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L344
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.size	fprint_bits, .-fprint_bits
	.section	.rodata.str1.1
.LC23:
	.string	"%d"
	.text
	.p2align 4,,15
	.globl	print_bits
	.type	print_bits, @function
print_bits:
	pushq	%r12
	movl	%edi, %r12d
	pushq	%rbp
	movl	$1, %ebp
	pushq	%rbx
	movl	$13, %ebx
	.p2align 4,,10
	.p2align 3
.L350:
	movl	%ebx, %ecx
	movl	%ebp, %eax
	xorl	%edx, %edx
	sall	%cl, %eax
	leaq	.LC23(%rip), %rsi
	movl	$1, %edi
	testl	%r12d, %eax
	setne	%dl
	xorl	%eax, %eax
	subl	$1, %ebx
	call	__printf_chk@PLT
	cmpl	$-1, %ebx
	jne	.L350
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
	.size	print_bits, .-print_bits
	.section	.rodata.str1.1
.LC24:
	.string	"Code label"
.LC25:
	.string	"Data label"
.LC26:
	.string	"External label"
.LC27:
	.string	"Unknown label type"
	.section	.rodata.str1.8
	.align 8
.LC28:
	.string	"-------------------- Label %s --------------------\n"
	.section	.rodata.str1.1
.LC29:
	.string	"Type: %s\n"
.LC30:
	.string	"Label addr: %d\n"
.LC31:
	.string	"Entry: %d\n"
	.text
	.p2align 4,,15
	.globl	print_symbol_table
	.type	print_symbol_table, @function
print_symbol_table:
	testq	%rdi, %rdi
	je	.L367
	pushq	%r14
	leaq	.LC26(%rip), %r14
	pushq	%r13
	leaq	.LC27(%rip), %r13
	pushq	%r12
	leaq	.LC24(%rip), %r12
	pushq	%rbp
	leaq	.LC25(%rip), %rbp
	pushq	%rbx
	movq	%rdi, %rbx
	.p2align 4,,10
	.p2align 3
.L359:
	movq	(%rbx), %rdx
	leaq	.LC28(%rip), %rsi
	xorl	%eax, %eax
	movl	$1, %edi
	call	__printf_chk@PLT
	movl	8(%rbx), %eax
	movq	%rbp, %rdx
	cmpl	$1, %eax
	je	.L357
	movq	%r12, %rdx
	jb	.L357
	cmpl	$2, %eax
	movq	%r13, %rdx
	cmove	%r14, %rdx
.L357:
	leaq	.LC29(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	movl	12(%rbx), %edx
	leaq	.LC30(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	movl	16(%rbx), %edx
	leaq	.LC31(%rip), %rsi
	xorl	%eax, %eax
	movl	$1, %edi
	call	__printf_chk@PLT
	movq	24(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L359
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L367:
	rep ret
	.size	print_symbol_table, .-print_symbol_table
	.section	.rodata.str1.8
	.align 8
.LC32:
	.string	"+++++++++++++++CODE area++++++++++++++++"
	.text
	.p2align 4,,15
	.globl	print_code_table
	.type	print_code_table, @function
print_code_table:
	pushq	%r14
	pushq	%r13
	movq	%rdi, %r13
	pushq	%r12
	leaq	.LC32(%rip), %rdi
	pushq	%rbp
	pushq	%rbx
	call	puts@PLT
	testq	%r13, %r13
	je	.L370
	leaq	.LC2(%rip), %r14
	.p2align 4,,10
	.p2align 3
.L373:
	movl	4(%r13), %edx
	movq	%r14, %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	movl	$13, %ebx
	movl	$1, %ebp
	call	__printf_chk@PLT
	movl	0(%r13), %r12d
	.p2align 4,,10
	.p2align 3
.L372:
	movl	%ebx, %ecx
	movl	%ebp, %eax
	xorl	%edx, %edx
	sall	%cl, %eax
	leaq	.LC23(%rip), %rsi
	movl	$1, %edi
	testl	%r12d, %eax
	setne	%dl
	xorl	%eax, %eax
	subl	$1, %ebx
	call	__printf_chk@PLT
	cmpl	$-1, %ebx
	jne	.L372
	movl	$10, %edi
	call	putchar@PLT
	movq	8(%r13), %r13
	testq	%r13, %r13
	jne	.L373
.L370:
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.size	print_code_table, .-print_code_table
	.p2align 4,,15
	.globl	fprint_xcode_table
	.type	fprint_xcode_table, @function
fprint_xcode_table:
	pushq	%r15
	pushq	%r14
	leaq	.LC1(%rip), %rdx
	pushq	%r13
	pushq	%r12
	movq	%rsi, %r14
	pushq	%rbp
	pushq	%rbx
	movl	$1, %esi
	movq	%rdi, %rbp
	subq	$8, %rsp
	movl	IC(%rip), %eax
	movl	DC(%rip), %r8d
	leal	-100(%rax), %ecx
	xorl	%eax, %eax
	call	__fprintf_chk@PLT
	testq	%r14, %r14
	je	.L380
	leaq	.LC2(%rip), %r15
	.p2align 4,,10
	.p2align 3
.L386:
	movl	28(%r14), %ecx
	movq	%r15, %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	xorl	%eax, %eax
	movl	$13, %ebx
	movl	$1, %r12d
	call	__fprintf_chk@PLT
	movl	24(%r14), %r13d
	.p2align 4,,10
	.p2align 3
.L382:
	movl	%r12d, %eax
	movl	%ebx, %ecx
	movq	%rbp, %rsi
	sall	%cl, %eax
	testl	%r13d, %eax
	jne	.L383
	movl	$46, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L382
.L385:
	movq	%rbp, %rsi
	movl	$10, %edi
	call	fputc@PLT
	movq	32(%r14), %r14
	testq	%r14, %r14
	jne	.L386
.L380:
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L383:
	movl	$47, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L382
	jmp	.L385
	.size	fprint_xcode_table, .-fprint_xcode_table
	.section	.rodata.str1.1
.LC33:
	.string	"\t%s\t%s,%s"
	.text
	.p2align 4,,15
	.globl	print_xcode_table
	.type	print_xcode_table, @function
print_xcode_table:
	pushq	%r14
	pushq	%r13
	movq	%rdi, %r13
	pushq	%r12
	leaq	.LC32(%rip), %rdi
	pushq	%rbp
	pushq	%rbx
	leaq	.LC2(%rip), %r14
	call	puts@PLT
	testq	%r13, %r13
	je	.L392
	.p2align 4,,10
	.p2align 3
.L393:
	movl	28(%r13), %edx
	movq	%r14, %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	movl	$13, %ebx
	movl	$1, %ebp
	call	__printf_chk@PLT
	movl	24(%r13), %r12d
	.p2align 4,,10
	.p2align 3
.L395:
	movl	%ebx, %ecx
	movl	%ebp, %eax
	xorl	%edx, %edx
	sall	%cl, %eax
	leaq	.LC23(%rip), %rsi
	movl	$1, %edi
	testl	%r12d, %eax
	setne	%dl
	xorl	%eax, %eax
	subl	$1, %ebx
	call	__printf_chk@PLT
	cmpl	$-1, %ebx
	jne	.L395
	movq	0(%r13), %rdx
	testq	%rdx, %rdx
	je	.L396
	movq	8(%r13), %rcx
	movq	16(%r13), %r8
	leaq	.LC33(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
.L396:
	movl	$10, %edi
	call	putchar@PLT
	movq	32(%r13), %r13
	testq	%r13, %r13
	jne	.L393
.L392:
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.size	print_xcode_table, .-print_xcode_table
	.p2align 4,,15
	.globl	print_extern_ref
	.type	print_extern_ref, @function
print_extern_ref:
	movl	8(%rdi), %ecx
	movq	(%rdi), %rdx
	leaq	.LC4(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	jmp	__printf_chk@PLT
	.size	print_extern_ref, .-print_extern_ref
	.section	.rodata.str1.8
	.align 8
.LC34:
	.string	"############### External References ##############"
	.text
	.p2align 4,,15
	.globl	print_extern_ref_list
	.type	print_extern_ref_list, @function
print_extern_ref_list:
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %rbx
	leaq	.LC34(%rip), %rdi
	subq	$8, %rsp
	call	puts@PLT
	testq	%rbx, %rbx
	je	.L402
	leaq	.LC4(%rip), %rbp
	.p2align 4,,10
	.p2align 3
.L404:
	movl	8(%rbx), %ecx
	movq	(%rbx), %rdx
	xorl	%eax, %eax
	movq	%rbp, %rsi
	movl	$1, %edi
	call	__printf_chk@PLT
	movq	16(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L404
.L402:
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	print_extern_ref_list, .-print_extern_ref_list
	.p2align 4,,15
	.globl	fprint_extern_ref
	.type	fprint_extern_ref, @function
fprint_extern_ref:
	movl	8(%rsi), %r8d
	movq	(%rsi), %rcx
	leaq	.LC4(%rip), %rdx
	movl	$1, %esi
	xorl	%eax, %eax
	jmp	__fprintf_chk@PLT
	.size	fprint_extern_ref, .-fprint_extern_ref
	.p2align 4,,15
	.globl	fprint_extern_ref_list
	.type	fprint_extern_ref_list, @function
fprint_extern_ref_list:
	testq	%rsi, %rsi
	je	.L419
	pushq	%r12
	leaq	.LC4(%rip), %r12
	pushq	%rbp
	movq	%rdi, %rbp
	pushq	%rbx
	movq	%rsi, %rbx
	.p2align 4,,10
	.p2align 3
.L413:
	movl	8(%rbx), %r8d
	movq	(%rbx), %rcx
	xorl	%eax, %eax
	movq	%r12, %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	call	__fprintf_chk@PLT
	movq	16(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L413
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
	.p2align 4,,10
	.p2align 3
.L419:
	rep ret
	.size	fprint_extern_ref_list, .-fprint_extern_ref_list
	.p2align 4,,15
	.globl	print_symbol
	.type	print_symbol, @function
print_symbol:
	pushq	%rbx
	movq	(%rdi), %rdx
	leaq	.LC28(%rip), %rsi
	movq	%rdi, %rbx
	xorl	%eax, %eax
	movl	$1, %edi
	call	__printf_chk@PLT
	movl	8(%rbx), %eax
	leaq	.LC25(%rip), %rdx
	cmpl	$1, %eax
	je	.L425
	leaq	.LC24(%rip), %rdx
	jb	.L425
	cmpl	$2, %eax
	leaq	.LC26(%rip), %rdx
	leaq	.LC27(%rip), %rax
	cmovne	%rax, %rdx
.L425:
	leaq	.LC29(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	movl	12(%rbx), %edx
	leaq	.LC30(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	movl	16(%rbx), %edx
	leaq	.LC31(%rip), %rsi
	movl	$1, %edi
	popq	%rbx
	xorl	%eax, %eax
	jmp	__printf_chk@PLT
	.size	print_symbol, .-print_symbol
	.p2align 4,,15
	.globl	print_code_word
	.type	print_code_word, @function
print_code_word:
	pushq	%r12
	pushq	%rbp
	leaq	.LC2(%rip), %rsi
	pushq	%rbx
	movl	4(%rdi), %edx
	movq	%rdi, %rbx
	xorl	%eax, %eax
	movl	$1, %edi
	movl	$1, %ebp
	call	__printf_chk@PLT
	movl	(%rbx), %r12d
	movl	$13, %ebx
	.p2align 4,,10
	.p2align 3
.L431:
	movl	%ebx, %ecx
	movl	%ebp, %eax
	xorl	%edx, %edx
	sall	%cl, %eax
	leaq	.LC23(%rip), %rsi
	movl	$1, %edi
	testl	%r12d, %eax
	setne	%dl
	xorl	%eax, %eax
	subl	$1, %ebx
	call	__printf_chk@PLT
	cmpl	$-1, %ebx
	jne	.L431
	popq	%rbx
	popq	%rbp
	popq	%r12
	movl	$10, %edi
	jmp	putchar@PLT
	.size	print_code_word, .-print_code_word
	.p2align 4,,15
	.globl	fprint_xcode_word
	.type	fprint_xcode_word, @function
fprint_xcode_word:
	pushq	%r13
	pushq	%r12
	leaq	.LC2(%rip), %rdx
	pushq	%rbp
	pushq	%rbx
	xorl	%eax, %eax
	movq	%rsi, %rbx
	movq	%rdi, %rbp
	movl	$1, %r12d
	subq	$8, %rsp
	movl	28(%rsi), %ecx
	movl	$1, %esi
	call	__fprintf_chk@PLT
	movl	24(%rbx), %r13d
	movl	$13, %ebx
	.p2align 4,,10
	.p2align 3
.L435:
	movl	%r12d, %eax
	movl	%ebx, %ecx
	movq	%rbp, %rsi
	sall	%cl, %eax
	testl	%r13d, %eax
	jne	.L436
	movl	$46, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L435
.L438:
	addq	$8, %rsp
	movq	%rbp, %rsi
	movl	$10, %edi
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	jmp	fputc@PLT
	.p2align 4,,10
	.p2align 3
.L436:
	movl	$47, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L435
	jmp	.L438
	.size	fprint_xcode_word, .-fprint_xcode_word
	.p2align 4,,15
	.globl	print_xcode_word
	.type	print_xcode_word, @function
print_xcode_word:
	pushq	%r13
	pushq	%r12
	leaq	.LC2(%rip), %rsi
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %r13
	xorl	%eax, %eax
	movl	$13, %ebx
	movl	$1, %ebp
	subq	$8, %rsp
	movl	28(%rdi), %edx
	movl	$1, %edi
	call	__printf_chk@PLT
	movl	24(%r13), %r12d
	.p2align 4,,10
	.p2align 3
.L441:
	movl	%ebx, %ecx
	movl	%ebp, %eax
	xorl	%edx, %edx
	sall	%cl, %eax
	leaq	.LC23(%rip), %rsi
	movl	$1, %edi
	testl	%r12d, %eax
	setne	%dl
	xorl	%eax, %eax
	subl	$1, %ebx
	call	__printf_chk@PLT
	cmpl	$-1, %ebx
	jne	.L441
	movq	0(%r13), %rdx
	testq	%rdx, %rdx
	je	.L442
	movq	8(%r13), %rcx
	movq	16(%r13), %r8
	leaq	.LC33(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
.L442:
	addq	$8, %rsp
	movl	$10, %edi
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	jmp	putchar@PLT
	.size	print_xcode_word, .-print_xcode_word
	.p2align 4,,15
	.globl	print_data_word
	.type	print_data_word, @function
print_data_word:
	pushq	%r12
	pushq	%rbp
	leaq	.LC2(%rip), %rsi
	pushq	%rbx
	movl	4(%rdi), %edx
	movq	%rdi, %rbx
	xorl	%eax, %eax
	movl	$1, %edi
	movl	$1, %ebp
	call	__printf_chk@PLT
	movl	(%rbx), %r12d
	movl	$13, %ebx
	.p2align 4,,10
	.p2align 3
.L449:
	movl	%ebx, %ecx
	movl	%ebp, %eax
	xorl	%edx, %edx
	sall	%cl, %eax
	leaq	.LC23(%rip), %rsi
	movl	$1, %edi
	testl	%r12d, %eax
	setne	%dl
	xorl	%eax, %eax
	subl	$1, %ebx
	call	__printf_chk@PLT
	cmpl	$-1, %ebx
	jne	.L449
	popq	%rbx
	popq	%rbp
	popq	%r12
	movl	$10, %edi
	jmp	putchar@PLT
	.size	print_data_word, .-print_data_word
	.section	.rodata.str1.8
	.align 8
.LC35:
	.string	"+++++++++++++++DATA area++++++++++++++++"
	.text
	.p2align 4,,15
	.globl	print_data_table
	.type	print_data_table, @function
print_data_table:
	pushq	%r14
	pushq	%r13
	movq	%rdi, %r13
	pushq	%r12
	leaq	.LC35(%rip), %rdi
	pushq	%rbp
	pushq	%rbx
	call	puts@PLT
	testq	%r13, %r13
	je	.L452
	leaq	.LC2(%rip), %r14
	.p2align 4,,10
	.p2align 3
.L455:
	movl	4(%r13), %edx
	movq	%r14, %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	movl	$13, %ebx
	movl	$1, %ebp
	call	__printf_chk@PLT
	movl	0(%r13), %r12d
	.p2align 4,,10
	.p2align 3
.L454:
	movl	%ebx, %ecx
	movl	%ebp, %eax
	xorl	%edx, %edx
	sall	%cl, %eax
	leaq	.LC23(%rip), %rsi
	movl	$1, %edi
	testl	%r12d, %eax
	setne	%dl
	xorl	%eax, %eax
	subl	$1, %ebx
	call	__printf_chk@PLT
	cmpl	$-1, %ebx
	jne	.L454
	movl	$10, %edi
	call	putchar@PLT
	movq	8(%r13), %r13
	testq	%r13, %r13
	jne	.L455
.L452:
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.size	print_data_table, .-print_data_table
	.p2align 4,,15
	.globl	fprint_data_word
	.type	fprint_data_word, @function
fprint_data_word:
	pushq	%r13
	pushq	%r12
	leaq	.LC2(%rip), %rdx
	pushq	%rbp
	pushq	%rbx
	xorl	%eax, %eax
	movq	%rsi, %rbx
	movq	%rdi, %rbp
	movl	$1, %r12d
	subq	$8, %rsp
	movl	4(%rsi), %ecx
	movl	$1, %esi
	call	__fprintf_chk@PLT
	movl	(%rbx), %r13d
	movl	$13, %ebx
	.p2align 4,,10
	.p2align 3
.L463:
	movl	%r12d, %eax
	movl	%ebx, %ecx
	movq	%rbp, %rsi
	sall	%cl, %eax
	testl	%r13d, %eax
	jne	.L464
	movl	$46, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L463
.L466:
	addq	$8, %rsp
	movq	%rbp, %rsi
	movl	$10, %edi
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	jmp	fputc@PLT
	.p2align 4,,10
	.p2align 3
.L464:
	movl	$47, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L463
	jmp	.L466
	.size	fprint_data_word, .-fprint_data_word
	.p2align 4,,15
	.globl	fprint_data_table
	.type	fprint_data_table, @function
fprint_data_table:
	testq	%rsi, %rsi
	je	.L480
	pushq	%r15
	pushq	%r14
	leaq	.LC2(%rip), %r15
	pushq	%r13
	pushq	%r12
	movq	%rsi, %r14
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %rbp
	subq	$8, %rsp
	.p2align 4,,10
	.p2align 3
.L474:
	movl	4(%r14), %ecx
	movq	%r15, %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	xorl	%eax, %eax
	movl	$13, %ebx
	movl	$1, %r12d
	call	__fprintf_chk@PLT
	movl	(%r14), %r13d
	.p2align 4,,10
	.p2align 3
.L470:
	movl	%r12d, %eax
	movl	%ebx, %ecx
	movq	%rbp, %rsi
	sall	%cl, %eax
	testl	%r13d, %eax
	jne	.L471
	movl	$46, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L470
.L473:
	movq	%rbp, %rsi
	movl	$10, %edi
	call	fputc@PLT
	movq	8(%r14), %r14
	testq	%r14, %r14
	jne	.L474
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L471:
	movl	$47, %edi
	subl	$1, %ebx
	call	fputc@PLT
	cmpl	$-1, %ebx
	jne	.L470
	jmp	.L473
.L480:
	rep ret
	.size	fprint_data_table, .-fprint_data_table
	.p2align 4,,15
	.globl	print_entries
	.type	print_entries, @function
print_entries:
	pushq	%rbp
	pushq	%rbx
	leaq	.LC4(%rip), %rbp
	movq	%rdi, %rbx
	subq	$8, %rsp
	testq	%rdi, %rdi
	je	.L483
	.p2align 4,,10
	.p2align 3
.L484:
	movl	16(%rbx), %eax
	testl	%eax, %eax
	jne	.L490
	movq	24(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L484
.L483:
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.p2align 4,,10
	.p2align 3
.L490:
	movl	12(%rbx), %ecx
	movq	(%rbx), %rdx
	xorl	%eax, %eax
	movq	%rbp, %rsi
	movl	$1, %edi
	call	__printf_chk@PLT
	movq	24(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L484
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	print_entries, .-print_entries
	.p2align 4,,15
	.globl	fprint_entries
	.type	fprint_entries, @function
fprint_entries:
	testq	%rsi, %rsi
	pushq	%r12
	movq	%rdi, %r12
	pushq	%rbp
	leaq	.LC4(%rip), %rbp
	pushq	%rbx
	movq	%rsi, %rbx
	je	.L491
	.p2align 4,,10
	.p2align 3
.L492:
	movl	16(%rbx), %eax
	testl	%eax, %eax
	jne	.L498
	movq	24(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L492
.L491:
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
	.p2align 4,,10
	.p2align 3
.L498:
	movl	12(%rbx), %r8d
	movq	(%rbx), %rcx
	xorl	%eax, %eax
	movq	%rbp, %rdx
	movl	$1, %esi
	movq	%r12, %rdi
	call	__fprintf_chk@PLT
	movq	24(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L492
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
	.size	fprint_entries, .-fprint_entries
	.p2align 4,,15
	.globl	ltype2str
	.type	ltype2str, @function
ltype2str:
	cmpl	$1, %edi
	leaq	.LC25(%rip), %rax
	je	.L499
	leaq	.LC24(%rip), %rax
	jb	.L499
	leaq	.LC26(%rip), %rax
	leaq	.LC27(%rip), %rdx
	cmpl	$2, %edi
	cmovne	%rdx, %rax
.L499:
	rep ret
	.size	ltype2str, .-ltype2str
	.p2align 4,,15
	.globl	init_fnames
	.type	init_fnames, @function
init_fnames:
	pushq	%r12
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %rbx
	call	strlen@PLT
	leaq	0(,%rax,4), %r12
	movq	%rax, %rbp
	movq	%r12, %rdi
	call	malloc@PLT
	testq	%rax, %rax
	movq	%rax, SRC_F(%rip)
	je	.L512
.L507:
	movq	%r12, %rdi
	call	malloc@PLT
	testq	%rax, %rax
	movq	%rax, OBJ_F(%rip)
	je	.L513
.L508:
	leaq	0(%rbp,%rbp,4), %rbp
	movq	%rbp, %rdi
	call	malloc@PLT
	testq	%rax, %rax
	movq	%rax, ENT_F(%rip)
	je	.L514
.L509:
	movq	%rbp, %rdi
	call	malloc@PLT
	testq	%rax, %rax
	movq	%rax, EXT_F(%rip)
	je	.L515
.L510:
	movq	SRC_F(%rip), %rdi
	movq	%rbx, %rsi
	call	strcpy@PLT
	movq	%rax, %rbp
	movq	%rax, %rdi
	call	strlen@PLT
	movl	$7561518, 0(%rbp,%rax)
	movq	OBJ_F(%rip), %rdi
	movq	%rbx, %rsi
	call	strcpy@PLT
	movq	%rax, %rbp
	movq	%rax, %rdi
	call	strlen@PLT
	movl	$6450990, 0(%rbp,%rax)
	movq	ENT_F(%rip), %rdi
	movq	%rbx, %rsi
	call	strcpy@PLT
	movq	%rax, %rbp
	movq	%rax, %rdi
	call	strlen@PLT
	addq	%rax, %rbp
	movq	%rbx, %rsi
	movl	$1953391918, 0(%rbp)
	movb	$0, 4(%rbp)
	movq	EXT_F(%rip), %rdi
	call	strcpy@PLT
	movq	%rax, %rbx
	movq	%rax, %rdi
	call	strlen@PLT
	addq	%rax, %rbx
	movl	$1954047278, (%rbx)
	movb	$0, 4(%rbx)
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
	.p2align 4,,10
	.p2align 3
.L515:
	leaq	.LC6(%rip), %rsi
	movl	$1, %edi
	call	print_err@PLT
	jmp	.L510
	.p2align 4,,10
	.p2align 3
.L512:
	leaq	.LC6(%rip), %rsi
	movl	$1, %edi
	call	print_err@PLT
	jmp	.L507
	.p2align 4,,10
	.p2align 3
.L513:
	leaq	.LC6(%rip), %rsi
	movl	$1, %edi
	call	print_err@PLT
	jmp	.L508
	.p2align 4,,10
	.p2align 3
.L514:
	leaq	.LC6(%rip), %rsi
	movl	$1, %edi
	call	print_err@PLT
	jmp	.L509
	.size	init_fnames, .-init_fnames
	.p2align 4,,15
	.globl	print_code_bits
	.type	print_code_bits, @function
print_code_bits:
	pushq	%r12
	movl	%edi, %r12d
	pushq	%rbp
	movl	$1, %ebp
	pushq	%rbx
	movl	$13, %ebx
	.p2align 4,,10
	.p2align 3
.L517:
	movl	%ebx, %ecx
	movl	%ebp, %eax
	xorl	%edx, %edx
	sall	%cl, %eax
	leaq	.LC23(%rip), %rsi
	movl	$1, %edi
	testl	%r12d, %eax
	setne	%dl
	xorl	%eax, %eax
	subl	$1, %ebx
	call	__printf_chk@PLT
	cmpl	$-1, %ebx
	jne	.L517
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
	.size	print_code_bits, .-print_code_bits
	.p2align 4,,15
	.globl	print_data_bits
	.type	print_data_bits, @function
print_data_bits:
	andl	$16383, %edi
	pushq	%r12
	movl	$1, %r12d
	pushq	%rbp
	movl	%edi, %ebp
	pushq	%rbx
	movl	$13, %ebx
	.p2align 4,,10
	.p2align 3
.L521:
	movl	%ebx, %ecx
	movl	%r12d, %eax
	xorl	%edx, %edx
	sall	%cl, %eax
	leaq	.LC23(%rip), %rsi
	movl	$1, %edi
	testl	%ebp, %eax
	setne	%dl
	xorl	%eax, %eax
	subl	$1, %ebx
	call	__printf_chk@PLT
	cmpl	$-1, %ebx
	jne	.L521
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
	.size	print_data_bits, .-print_data_bits
	.section	.rodata
	.align 8
	.type	__PRETTY_FUNCTION__.4014, @object
	.size	__PRETTY_FUNCTION__.4014, 12
__PRETTY_FUNCTION__.4014:
	.string	"handle_ops1"
	.align 8
	.type	__PRETTY_FUNCTION__.4007, @object
	.size	__PRETTY_FUNCTION__.4007, 12
__PRETTY_FUNCTION__.4007:
	.string	"handle_ops0"
	.comm	status,4,4
	.comm	EXTERN_REF_LIST,8,8
	.comm	CODE_SEG_LIST,8,8
	.comm	CODE_TABLE,8,8
	.comm	DATA_LIST,8,8
	.comm	SYMBOL_TABLE,8,8
	.comm	ENTRIES_DEF,4,4
	.comm	EXT_F,8,8
	.comm	ENT_F,8,8
	.comm	OBJ_F,8,8
	.comm	SRC_F,8,8
	.comm	NRESERVED,4,4
	.comm	NREGS,4,4
	.comm	NINST,4,4
	.comm	INP_LINE_POS,4,4
	.comm	NLINES,4,4
	.comm	LINE,8,8
	.comm	in_line_ptr,8,8
	.globl	registers
	.section	.rodata.str1.1
.LC36:
	.string	"r0"
.LC37:
	.string	"r1"
.LC38:
	.string	"r2"
.LC39:
	.string	"r3"
.LC40:
	.string	"r4"
.LC41:
	.string	"r5"
.LC42:
	.string	"r6"
	.section	.data.rel.local,"aw",@progbits
	.align 32
	.type	registers, @object
	.size	registers, 128
registers:
	.quad	.LC36
	.long	0
	.zero	4
	.quad	.LC37
	.long	1
	.zero	4
	.quad	.LC38
	.long	2
	.zero	4
	.quad	.LC39
	.long	3
	.zero	4
	.quad	.LC40
	.long	4
	.zero	4
	.quad	.LC41
	.long	5
	.zero	4
	.quad	.LC42
	.long	6
	.zero	4
	.quad	.LC36
	.long	7
	.zero	4
	.globl	opcodes
	.section	.rodata.str1.1
.LC43:
	.string	"mov"
.LC44:
	.string	"cmp"
.LC45:
	.string	"add"
.LC46:
	.string	"sub"
.LC47:
	.string	"not"
.LC48:
	.string	"clr"
.LC49:
	.string	"lea"
.LC50:
	.string	"inc"
.LC51:
	.string	"dec"
.LC52:
	.string	"jmp"
.LC53:
	.string	"bne"
.LC54:
	.string	"red"
.LC55:
	.string	"prn"
.LC56:
	.string	"jsr"
.LC57:
	.string	"rts"
.LC58:
	.string	"stop"
	.section	.data.rel.local
	.align 32
	.type	opcodes, @object
	.size	opcodes, 256
opcodes:
	.quad	.LC43
	.long	0
	.long	1
	.quad	.LC44
	.long	1
	.long	1
	.quad	.LC45
	.long	2
	.long	1
	.quad	.LC46
	.long	3
	.long	1
	.quad	.LC47
	.long	4
	.long	2
	.quad	.LC48
	.long	5
	.long	2
	.quad	.LC49
	.long	6
	.long	1
	.quad	.LC50
	.long	7
	.long	2
	.quad	.LC51
	.long	8
	.long	2
	.quad	.LC52
	.long	9
	.long	2
	.quad	.LC53
	.long	10
	.long	2
	.quad	.LC54
	.long	11
	.long	2
	.quad	.LC55
	.long	12
	.long	2
	.quad	.LC56
	.long	13
	.long	2
	.quad	.LC57
	.long	14
	.long	3
	.quad	.LC58
	.long	15
	.long	3
	.globl	REGISTERS_LIST
	.section	.rodata.str1.1
.LC59:
	.string	"r7"
	.section	.data.rel.local
	.align 32
	.type	REGISTERS_LIST, @object
	.size	REGISTERS_LIST, 64
REGISTERS_LIST:
	.quad	.LC36
	.quad	.LC37
	.quad	.LC38
	.quad	.LC39
	.quad	.LC40
	.quad	.LC41
	.quad	.LC42
	.quad	.LC59
	.globl	INSTRUCTIONS_LIST
	.align 32
	.type	INSTRUCTIONS_LIST, @object
	.size	INSTRUCTIONS_LIST, 128
INSTRUCTIONS_LIST:
	.quad	.LC43
	.quad	.LC44
	.quad	.LC45
	.quad	.LC46
	.quad	.LC47
	.quad	.LC48
	.quad	.LC49
	.quad	.LC50
	.quad	.LC51
	.quad	.LC52
	.quad	.LC53
	.quad	.LC54
	.quad	.LC55
	.quad	.LC56
	.quad	.LC57
	.quad	.LC58
	.globl	RESERVED_KEYWORDS
	.section	.rodata.str1.1
.LC60:
	.string	"data"
.LC61:
	.string	"entry"
.LC62:
	.string	"extern"
.LC63:
	.string	"string"
	.section	.data.rel.local
	.align 32
	.type	RESERVED_KEYWORDS, @object
	.size	RESERVED_KEYWORDS, 224
RESERVED_KEYWORDS:
	.quad	.LC36
	.quad	.LC37
	.quad	.LC38
	.quad	.LC39
	.quad	.LC40
	.quad	.LC41
	.quad	.LC42
	.quad	.LC59
	.quad	.LC43
	.quad	.LC44
	.quad	.LC45
	.quad	.LC46
	.quad	.LC47
	.quad	.LC48
	.quad	.LC49
	.quad	.LC50
	.quad	.LC51
	.quad	.LC52
	.quad	.LC53
	.quad	.LC54
	.quad	.LC55
	.quad	.LC56
	.quad	.LC57
	.quad	.LC58
	.quad	.LC60
	.quad	.LC61
	.quad	.LC62
	.quad	.LC63
	.comm	IC,4,4
	.comm	DC,4,4
	.comm	PROG_NAME,8,8
	.ident	"GCC: (Ubuntu 7.2.0-8ubuntu3.2) 7.2.0"
	.section	.note.GNU-stack,"",@progbits
