.global main
.balign 4

main:
    mov X0, #1
    adr X1, str
    mov X2, len
    mov X16, #4
    svc #0

    mov X0, #0
    mov X16, #1
    svc #0

str: 
    .ascii "Hello world!\n"

len = . - str
