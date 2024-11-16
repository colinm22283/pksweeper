.code16

.section .bss

.global random_state
random_state: .skip 2

.section .text

.global random_init
random_init:
    mov $1, %ax
    mov %ax, (random_state)

    ret

.global random_generate
random_generate:
    mov (random_state), %ax

    mov %ax, %bx
    shl $7,  %bx
    xor %bx, %ax

    mov %ax, %bx
    shr $9, %bx
    xor %bx, %ax

    mov %ax, %bx
    shl $8, %bx
    xor %bx, %ax

    mov %ax, (random_state)

    ret
