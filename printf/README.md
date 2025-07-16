# printf

## Compiling to machine code

First, I added the following line to my `~/.zshrc` file:

    export SYSLIBROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk

The path works for me, but it might not work for you.

If you're on MacOS, you can run the following command:

    xcrun -sdk macosx --show-sdk-path

I think that xcrun comes with the XCode tools.

The xcrun command will give you the path for SYSLIBROOT on your machine.

After defining the SYSLIBROOT environment variable, I entered the following commands in Terminal:

    % as -o printf.o printf.s
    % ld -o printf printf.o -lSystem -syslibroot $SYSLIBROOT -e main
    % ./printf
    The year is 2025

We discussed these commands in the readme for the hello world project.

The as command assembles the source code in printf.s.

The ld command links the printf.o object file with the System library to create an executable.

We run the executable with the command ./printf and it prints "The year is 2025" to standard output.

## Some vocabulary

Word | Definition
---- | ----------
Directive | An instruction for the assembler (e.g. .global, .balign, .text, .data)
Symbol | A variable that has a value
Label | A symbol that stores a memory address (e.g. main is a label and it corresponds to a memory address)
Symbol table | A table that stores information about symbols
Register | A storage device within the CPU
Kernel mode | A privileged mode in which the operating system runs
User mode | An unprivileged mode in which a user program runs
mov | The move instruction. It moves a value into a register.
adr | The address instruction. It moves an address into a register.
svc | Supervisor call (or syscall). A system call is an operating system procedure, like write or exit.
str | Store the value in a register onto the stack
stp | Store the values in a pair of registers onto the stack
ldp | Load two values from the stack into a pair of registers
add | Add two values and store the result in a register
sub | Subtract one value from another and store the result in a register
.ascii | A directive that defines an ASCII string
.asciz | A directive that defines a null-terminated ASCII string
