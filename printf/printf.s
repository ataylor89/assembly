.global main
.balign 4

main:
    stp X29, X30, [sp, -16]!
    sub sp, sp, #16
    mov X8, #2025
    str X8, [sp]
    adr X0, str
    bl _printf
    add sp, sp, #16
    ldp x29, x30, [sp, #16]
    mov X0, #0
    mov X16, #1
    svc #0

str:
    .asciz "The year is %d\n"
