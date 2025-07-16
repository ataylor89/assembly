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
adr | Loads a PC-relative address into a register (the offset of the address relative to the program counter)
svc | Supervisor call (or syscall). A system call is an operating system procedure, like write or exit.
str | Store data from a register into memory
ldr | Load data from memory into a register
stp | Store data from a pair of registers into memory
ldp | Load data from memory into a pair of registers
add | Add two values and store the result in a register
sub | Subtract one value from another and store the result in a register
.ascii | A directive that defines an ASCII string
.asciz | A directive that defines a null-terminated ASCII string

## Stack management

My family taught me that in C we do memory management, and in assembly we do stack management.

For a long time I asked, "Why do we need the stack? Why do we use the stack?"

The answer is simple... the stack can be used to pass arguments to a function.

It is also possible to use registers to pass arguments to a function, but if we were to rely on registers alone, and not use the stack, then our function (or library) would monopolize many registers.

When we use the stack to pass arguments to a function, we have to manage the stack.

In our example, printf.s, we store three values on the stack.

We store the values in registers X29 and X30 on the stack.

We also store the constant 2025 on the stack.

The printf function parses the format string, and sees that there is one integer argument. Then it pops the stack to retrieve the integer argument, 2025. Then it creates a new string according to the format that it's given.

It's important to know that, when we call a function like printf, the X29 and X30 registers get modified.

The X29 register contains the frame pointer, and it gets modified to point to a new stack frame.

The X30 register contains the return address, and it gets modified to point to a new return address.

For example, when we call printf with the command `bl _printf`, the register X30 gets updated to point to the address immediately following `bl _printf`, and the register X29 gets updated to point to a new stack frame.

We want to preserve the values of registers X29 and X30, since they get modified when we call printf.

In order to preserve these values, we save them to the stack before calling printf.

After printf is finished, we restore the values of registers X29 and X30, by loading them from the stack.

I'll try to explain this more concisely.

Our program has a stack frame. It stores the frame pointer in X29 and the return address in X30.

When we call printf, we store a new frame pointer in X29, and we store a new return address in X30.

In order to preserve the old frame pointer and the old return address, we save them onto the stack before calling printf. After printf is done, we restore the values of X29 and X30 by loading them from the stack.

I hope this explains why we store the values of X29 and X30 onto the stack, before calling printf. We need to preserve the values of X29 and X30 so we save them onto the stack, call printf, and then restore them from the stack.

We save the constant 2025 onto the stack as well.

The function printf pops the stack to get its integer argument, 2025.

In essence, we use the stack to pass arguments to a function.

We could also use registers to do this, but then the functions that we call would monopolize many registers, and make them unavailable for use.

For this reason, it is more practical to use the stack to pass arguments to a function.

I know that stack management is complicated. I have tried my best to explain it.

If you ask me the question, "Why do we use the stack?" the short answer is that we use the stack to pass arguments to a function. The long answer is that we use the stack to pass arguments to a function, and we also use it to preserve register values, like the values of registers X29 and X30.
