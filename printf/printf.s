.global main
.balign 4

main:
    stp x29, x30, [sp, #-16]!
    sub sp, sp, #16
    mov x8, #2025
    str x8, [sp]
    adr x0, str
    bl _printf
    add sp, sp, #16
    ldp x29, x30, [sp, #16]
    mov x0, #0
    mov x16, #1
    svc #0

str:
    .asciz "The year is %d\n"
