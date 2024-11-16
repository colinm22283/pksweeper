.code16

.section .bss

.global board
board: .skip 80 * 24

.global cur_x
cur_x: .skip 2
.global cur_y
cur_y: .skip 2

.section .data

boom_str: .string "BOOM!"

.section .text

blank = 0
mine  = 10
csafe = 11
cmine = 12

mine_count = 50

.global init_board
init_board:
    mov $csafe,     %al
    mov $board, %bx
    mov $(80 * 24), %cx
    .ib_loop:
        movb %al, (%bx)
        inc  %bx

        loop .ib_loop

    mov %cx, (cur_x)
    mov %cx, (cur_y)
    
    mov $mine_count, %cx
    .ib_mine_loop:
        push  %cx

        call  random_generate
        mov   $22, %bx
        xor   %dx, %dx
        div   %bx
        inc   %dx
        push  %dx

        call  random_generate
        mov   $78, %bx
        xor   %dx, %dx
        div   %bx
        inc   %dl
        movzx %dl, %cx

        pop   %ax
        mov   $80, %bl
        mul   %bl
        mov   %ax, %si
        add   %cx, %si

        mov   $board, %bx
        mov   $cmine,  %cl
        mov   %cl, (%bx, %si)

        pop   %cx

        loop  .ib_mine_loop
    
    mov $cmine, %cl
    mov %cl, (board + 80 + 1)

    ret

.global print_board
print_board:
    mov $0x02, %ah
    mov $0x00, %bh
    xor %dx,   %dx
    int $0x10

    mov $80,     %ah
    mov (cur_y), %al
    mulb %ah
    add (cur_x), %ax

    mov $board, %bx
    mov $0, %cx
    .bp_loop:
        push %ax
        push %bx
        push %cx

        mov  $0x000F, %di

        cmp  %ax, %cx
        jne  ..not_cur
            mov $0x00F0, %di
        ..not_cur:

        movb (%bx), %al
        test %al,   %al
        jz  ..bp_blank 
        cmp  $mine, %al
        je   ..bp_mine
        ja   ..bp_uncovered
            add $'0', %al
            jmp ..bp_skip
        ..bp_blank:
            mov $' ', %al
            jmp ..bp_skip
        ..bp_mine:
            mov $'*', %al
            jmp ..bp_skip
        ..bp_uncovered:
            mov $'#', %al
        ..bp_skip:

        mov $0x09,   %ah
        mov %di,     %bx
        mov $1,      %cx
        int $0x10

        mov $0x03,   %ah
        xor %bh,     %bh
        int $0x10
        
        cmp $79, %dl
        jne ..bp_no_cur_reset
            xor %dl, %dl
            add $1,  %dh
            jmp ..bp_cur_reset_skip
        ..bp_no_cur_reset:
            add $1,  %dl
        ..bp_cur_reset_skip:

        mov $0x02, %ah
        xor %bh,   %bh
        int $0x10

        pop %cx
        pop %bx
        pop %ax

        inc %bx
        inc %cx

        cmp $(80 * 24), %cx
        jb  .bp_loop
    ret

.global uncover_cell
uncover_cell:
    mov (cur_x), %bx
    mov (cur_y), %ax
    mov $80, %cl
    mul %cl
    add %ax, %bx

    mov $board,     %si
    mov (%bx, %si), %al

    cmp $csafe, %al
    jb  ..uc_ret
        cmp $1,     %di
        je  ..uc_ret
        cmp $cmine, %al
        jne ..uc_not_mine    
            mov $0x1300,   %ax
            mov $0x004F,   %bx
            mov $5,        %cx
            mov $0x1800,   %dx
            mov $boom_str, %bp

            int $0x10

            hlt
        ..uc_not_mine:
        cmp $csafe, %al
        jne ..uc_not_safe
            # bx is board cur addr
            lea (%bx, %si), %bx
            
            xor %dl, %dl
            
            mov  -81(%bx),   %cx
            call ...uc_check_mine
            mov  -79(%bx),   %cl
            mov  -1(%bx),  %ch
            call ...uc_check_mine 
            mov  2(%bx),  %cl
            mov  80(%bx), %ch
            call ...uc_check_mine 
            mov  81(%bx), %cx
            call ...uc_check_mine 
            
            mov %dl, (%bx)

            test %dl, %dl
            jnz  ...uc_not_zero_mines
            ...uc_not_zero_mines:

            jmp ...uc_check_mine_skip
            ...uc_check_mine:
                cmp $cmine, %ch
                jne ....uc_skip_first
                    inc %dl
                ....uc_skip_first:
                cmp $cmine, %cl
                jne ....uc_skip_second
                    inc %dl
                ....uc_skip_second:

                ret
            ...uc_check_mine_skip:
        ..uc_not_safe:
    ..uc_ret:

    ret
