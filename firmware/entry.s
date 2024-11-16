.code16

.section .entry, "a"
.global entry
entry:
    cli

    xor %ax, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss

    mov $stack_top, %sp

    mov $0x0003, %ax
	int $0x10

    call random_init
    call init_board

    .loop:
        call print_board
        
        # do input stuff
        xor  %ah, %ah
        int  $0x16

        mov  (cur_x), %bx
        mov  (cur_y), %cx

        cmp  $0x50, %ah
        jne  .not_down
            cmp $22, %cx
            je  .skip_input

            inc %cx

            jmp .skip_input
        .not_down:
        cmp  $0x48, %ah
        jne .not_up
            cmp $1, %cx
            je  .skip_input
            
            dec %cx

            jmp .skip_input
        .not_up:
        cmp $0x4D, %ah
        jne .not_right
            cmp $78, %bx
            je  .skip_input

            inc %bx

            jmp .skip_input
        .not_right:
        cmp $0x4B, %ah
        jne .not_left
            cmp $1, %bx
            je  .skip_input

            dec %bx
            
            jmp .skip_input
        .not_left:
        cmp $0x1C, %ah
        jne .not_enter
            push %bx
            push %cx

            xor  %di, %di
            call uncover_cell

            pop %cx
            pop %bx
        .not_enter:
        .skip_input:

        mov  %bx, (cur_x)
        mov  %cx, (cur_y)

        jmp .loop
    hlt

.section .sig, "a"
.global sig
sig:
    .byte 0x55
    .byte 0xAA

.section .text

