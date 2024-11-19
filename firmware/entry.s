.code16

.section .entry, "a"

.global entry
entry:
    mov $0x0003, %ax
	int $0x10

    movw $1, (random_state)

.global restart
restart:
    call init_board

    .loop:
        call print_board
        
        # do input stuff
        xor  %ah, %ah
        int  $0x16

        mov  (cur_x), %bx
        mov  (cur_y), %cx

        cmp  $0x48, %ah
        jne .not_up
            cmp $1, %cx
            je  .input_skip

            dec %cx

            jmp .input_skip
        .not_up:
        cmp $0x50, %ah
        jne .not_down
            cmp $22, %cx
            je  .input_skip

            inc %cx
            
            jmp .input_skip
        .not_down:
        cmp $0x4B, %ah
        jne .not_left
            cmp $1, %bx
            je  .input_skip

            dec %bx

            jmp .input_skip
        .not_left:
        cmp $0x4D, %ah
        jne .not_right
            cmp $78, %bx
            je  .input_skip
            
            inc %bx

            jmp .input_skip
        .not_right:
        cmp $0x1C, %ah
        jne .not_enter
            pusha

            call uncover_cell

            popa
        .not_enter:
        .input_skip:
        
        mov  %bx, (cur_x)
        mov  %cx, (cur_y)

        jmp .loop
    hlt

.section .sig, "a"

.global sig
sig:
    .byte 0x55
    .byte 0xAA

