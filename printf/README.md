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
mov | Moves a value into a register
adr | Loads a PC-relative address into a register (the offset of the address relative to the program counter)
svc | Supervisor call (or syscall) calls an operating system procedure
str | Stores data from a register into memory
ldr | Loads data from memory into a register
stp | Stores data from a pair of registers into memory
ldp | Loads data from memory into a pair of registers
add | Adds two values and stores the result in a register
sub | Subtracts one value from another and stores the result in a register
.ascii | A directive that defines an ASCII string
.asciz | A directive that defines a null-terminated ASCII string

## Stack management

My family taught me that in C we do memory management, and in assembly we do stack management.

For a long time I asked, "Why do we need the stack? Why do we use the stack?"

I'll do my best to explain.

We use the stack to pass arguments to a function. We also use the stack to preserve register values.

When we call the function printf, in our example printf.s, first we save the values of registers X29 and X30 onto the stack, so that we can restore them later.

Then we push the value 2025 onto the stack, because it is an argument to the printf function.

When we finally call printf with the command `bl _printf`, the registers X29 and X30 get modified.

The register X29 contains the frame pointer, and it gets modified to contain a new frame pointer.

The register X30 contains the return address, and it gets modified to contain a new return address.

After printf is finished, we restore the old values of X29 and X30 by loading them from the stack.

This way we preserve the values of registers X29 and X30.

You might ask, "Why don't we just use registers to pass arguments to a function?"

We actually can... but it's impractical to use registers.

If we pass 50 arguments to printf, then it's hard to find enough registers to store these values.

It's also the case that, if we use registers to pass arguments to a function, and solely rely on registers, then the functions we call would monopolize a certain set of registers. We want these registers to be available for use by the assembly programmer... we don't want them to be reserved for the functions that we call.

For these reasons, it is more practical to use the stack to pass arguments to a function.

We use the stack to pass arguments to a function. We also use the stack to preserve register values.
