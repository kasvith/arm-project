@ Image Processing with ARM

	.text	@ instruction memory

	.global main

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
original:
    ldr r0, =format_original
    bl printf

    @ r4 = i = 0
    mov r4, #0
    b original_loop

original_loop:
    mov r5, #0 @ j = 0

    mov r0, r4
    mov r1, r10
    cmp r1, r0
    bne original_inner_loop
    beq exit

original_inner_loop:
    cmp r5, r11 @ j < cols
    blt original_print
    beq original_new_line

original_new_line:
    ldr r0, =format_new_line
    bl printf

    add r4, r4, #1 @ i++
    b original_loop

original_print:
    @allocate stack for input
    sub	sp, sp, #4

    ldr	r0, =format_int
    mov	r1, sp
    bl	scanf	@scanf("%d",sp)

    @copy rows from stack to register
    ldr	r1, [sp,#0]

    add sp, sp, #4

    ldr r0, =format_int_space
    bl printf

    add r5, r5, #1 @ j++

    b original_inner_loop

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
inversion:
    ldr r0, =format_inversion
    bl printf

    @ r2 = 255
    mov r2, #255

    @ r4 = i = 0
    mov r4, #0
    b inversion_loop

inversion_loop:
    mov r5, #0 @ j = 0

    mov r0, r4
    mov r1, r10
    cmp r1, r0
    bne inversion_inner_loop
    beq exit

inversion_inner_loop:
    cmp r5, r11 @ j < cols
    blt inversion_print
    beq inversion_new_line

inversion_new_line:
    ldr r0, =format_new_line
    bl printf

    add r4, r4, #1 @ i++
    b inversion_loop

inversion_print:
    @allocate stack for input
    sub	sp, sp, #4

    ldr	r0, =format_int
    mov	r1, sp
    bl	scanf	@scanf("%d",sp)

    @copy rows from stack to register
    ldr	r1, [sp,#0]
    add sp, sp, #4

    ldr r0, =format_int_space
    rsb r1, r1, #255
    bl printf

    add r5, r5, #1 @ j++

    b inversion_inner_loop
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
rotate:
    ldr r0, =format_rotate
    bl printf

    @ calculate number of elements
    @ r9 = rows x cols
    mul r9, r10, r11

    @ calculate number of words r9 = num of elements x 4 = elements
    lsl r9, r9, #2

    @ allocaterequired space in stack
    sub sp, sp, r9

    mov r4, #0 @ i = 0
    b rotate_input

    b exit

rotate_input:
    cmp r4, r9 @ i == elements
    beq rotate_print

    @ if not scanf
    bl scan_int
    str r1, [sp, r4]

    add r4, r4, #4
    b rotate_input

rotate_print:
	mov r8, r9 @ backup sp to r8
	sub r9, r9, #4 @ sp = sp - 4
	@ pos in sp = r4
	@ r5 i = 0
	mov r5, #0
	b rotate_print_loop

rotate_print_loop:
	cmp r5, r10 @ i < rows
	beq rotate_exit

	@ proceed
	@ r6 j = 0
	mov r6, #0
	b rotate_print_inner_loop

	@ i++
	add r5, r5, #1
	b rotate_print_loop

rotate_print_inner_loop:
	cmp r6, r11 @ j < cols
	beq rotate_new_line @ print new line
	ldr r1, [sp, r9]
	sub r9, r9, #4
	ldr r0, =format_int_space
	bl printf

	@ j++
	add r6, r6, #1
	b rotate_print_inner_loop

rotate_new_line:
	ldr r0, =format_new_line
	bl printf
	@ i++
	add r5, r5, #1
	b rotate_print_loop @ j == cols then go to outer loop

rotate_exit:
	add sp, sp, r8 @ restore stack
	b exit

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
flip:
	ldr r0, =format_flip
	bl printf

	@ r3 i = 0
	mov r3, #0
	b flip_outer_loop

flip_outer_loop:
	cmp r3, r10 @ i < rows
	beq exit @ exit if rows == i

	mov r4, #0 @ j = 0
	b flip_input_loop


flip_input_loop:
	cmp r4, r11 @ j , cols
	beq flip_print_loop @ start printing when j == cols

	@ do scan_int
	bl scan_int
	push {r1}

	add r4, r4, #1
	b flip_input_loop

flip_print:
	mov r4, #0 @ j = 0
	b flip_print_loop

flip_print_loop:
	cmp r4, #0 @ j == 0
	beq flip_new_line @ go to new line

	@ do print
	pop {r1}
	ldr r0, =format_int_space
	bl printf

	sub r4, r4, #1 @ j++
	b flip_print_loop

flip_new_line:
	ldr r0, =format_new_line
	bl printf

	@ i++
	add r3, r3, #1
	b flip_outer_loop
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ scan integer
scan_int:
    sub sp,sp,#4
    str lr,[sp,#0]

	sub sp,sp,#4
    @scanf for integer
    ldr	r0, =format_int
    mov	r1, sp
    bl	scanf	@scanf("%d",sp)

    @copy int1 from the stack to register r1
    ldr	r1, [sp]

    @release stack
    add	sp, sp, #4

    @ stack handling (pop lr from the stack) and return
    ldr	lr, [sp, #0]
    add	sp, sp, #4
    mov	pc, lr

@ Display error and exit
exit_with_error:
    ldr r0, =format_invalid
    bl printf
    b exit

@ Exit the program
exit:
    @ stack handling (pop lr from the stack) and return
    ldr	lr, [sp, #0]
    add	sp, sp, #4
    mov	pc, lr

main:
	@ stack handling
	@ push (store) lr to the stack
	sub	sp, sp, #4
	str	lr, [sp, #0]

    @ rows = r10
    @ cols = r11
    @ opcode = r12

    @allocate stack for input
    sub	sp, sp, #4

    @ Get rows from user
    	@scanf to get rows
    	ldr	r0, =format_int
    	mov	r1, sp
    	bl	scanf	@scanf("%d",sp)

        @copy rows from stack to register
    	ldr	r10, [sp,#0]
    @end get rows from users

    @ Get cols from user
    	@scanf to get rows
    	ldr	r0, =format_int
    	mov	r1, sp
    	bl	scanf	@scanf("%d",sp)

        @copy cols from stack to register
    	ldr	r11, [sp,#0]
    @ end get cols from user

    @ Get opcode from user
    	@scanf to get opcode
    	ldr	r0, =format_int
    	mov	r1, sp
    	bl	scanf	@scanf("%d",sp)

        @copy opcode from stack to register
    	ldr	r12, [sp,#0]

    @ end get opcode from user

    @release stack
    add	sp, sp, #4

	@ select the operation
    cmp r12, #0
    beq original
    cmp r12, #1
    beq inversion
    cmp r12, #2
    beq rotate
    cmp r12, #3
    beq flip
    b exit_with_error

@ data memory
.data
    format_new_line : .asciz "\n"
    format_int: .asciz "%d"
    format_int_space: .asciz "%d "
    format_original: .asciz "Original\n"
    format_invalid: .asciz "Invalid operation\n"
    format_flip: .asciz "Flip\n"
    format_inversion: .asciz "Inversion\n"
    format_rotate: .asciz "Rotation by 180\n"
