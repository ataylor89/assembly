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

## Understanding the frame pointer and the stack pointer

The frame pointer is a register that stores the start address of the current function's stack frame.

In the ARM64 architecture, the frame pointer is register X29.

The stack pointer is a register that stores the end address of the stack.

The stack pointer points to the "top" of the stack.

In the ARM64 architecture, the stack pointer is register SP.

We can also say that the stack pointer stores the end address of the current function's stack frame.

The top of the stack is equivalent to the end address of the current function's stack frame.

So the frame pointer points to the start of the stack frame, and the stack pointer points to the end of the stack frame.

The frame pointer is fixed during the execution of the function.

The stack pointer often changes during the execution of the function.

When a function pushes new data onto the stack, the stack pointer gets decremented.

It's important to know that, in many computer systems, including x86 systems and ARM64 systems, the stack grows downward.

The stack pointer gets decremented whenever data is pushed onto the stack.

So the frame pointer is always greater than or equal to the stack pointer.

When a function returns, the stack pointer gets set to the frame pointer.

The code that calls the function can load the old frame pointer from memory into register X29.

This way, the code that calls the function has the correct frame pointer and the correct stack pointer.

In summary, a function's stack frame is defined by the frame pointer and the stack pointer.

The frame pointer points to the start of the stack frame; the stack pointer points to the end of the stack frame.

All of the data that a function allocates onto the stack is stored between these two memory addresses.

## Summary

The frame pointer is register X29 and it points to the start of the stack frame; the stack pointer is register SP and it points to the end of the stack frame, also called the "top" of the stack.

## Understanding the return address

The return address is stored in register X30, also called the Link Register.

In our example, printf.s, we have a main routine.

The start address of our main routine is stored under the label "main".

The main routine has its own stack frame.

This stack frame has a frame pointer, a stack pointer, and a return address.

The start of the stack frame is stored in register X29.

The end of the stack frame is stored in register SP.

The return address is stored in register X30.

Our main routine doesn't really have a function to return to... so I think that it returns to the startup code that called it.

In other words, the return address for our main routine points to the startup code that called it.

Before we call the function printf, we save the return address in register X30 onto the stack.

(We also save the frame pointer onto the stack, as well as our argument, 2025.)

Then we call the function printf, by means of the branch with link (BL) instruction.

The branch with link (BL) instruction modifies the content of register X30.

The BL instruction stores the address of the instruction immediately after it in register X30.

It also stores the value of the stack pointer in register X29.

So when we enter the printf code, we have a new frame pointer and a new return address.

When the printf function returns, it returns to the address stored in register X30.

That is, it returns to the instruction immediately following the bl instruction in our code.

I know this is a little confusing... I'll try to explain it more clearly.

Before we call printf, by means of the BL instruction, we store the return address of our main routine onto the stack.

When we call printf, using the BL instruction, the BL instruction stores the address of the instruction immediately following it in register X30.

The printf function then uses this return address to return to our code, to the line of code immediately following the `bl _printf` instruction.

The BL instruction stores the correct return address in register X30, so that the function we call knows which line of code to return to after it finishes executing.

When the printf function finishes, it actually moves the return address in register X30 into the program counter, so that the program counter points to the instruction immediately following the `bl _printf` instruction.

In summary, register X30 should always contain the correct return address, so that when a function or routine finishes, the program counter gets updated correctly.

## Summary

In the ARM64 architecture, the register X30 should always contain the correct return address, so that when a function returns, or a routine returns, the program counter gets updated correctly.

## Explaining the code, line by line

To explain the code, line by line, we'll just add a comment above each line of assembly code.

Here is the code, reproduced, below:

    // The global directive makes a symbol globally visible,
    // so that it can be referenced by other parts of the program
    .global main

    // The ".balign 4" directive tells the assembler to pad the current location in memory
    // until it reaches an address that is a multiple of four
    .balign 4

    // The "main" label stores the start address of our program
    main:

        // Stores a pair of values from registers x29 and x30 onto the stack,
        // and decrements the stack pointer by 16 before storing them onto the stack
        stp x29, x30, [sp, #-16]!

        // Subtracts 16 from the stack pointer and stores the result in the stack pointer
        //
        // We are about to store the value 2025 onto the stack, and before we do so we have to decrement
        // the stack pointer, and make sure it is 16-byte aligned
        sub sp, sp, #16

        // Moves the constant 2025 (our argument to printf) into register x8
        mov x8, #2025

        // Stores the value in register x8 (2025) onto the stack
        str x8, [sp]

        // Loads the address corresponding to our str label into register x0
        // The printf function expects to find this address in register x0
        adr x0, str

        // The bl instruction means branch with link
        //
        // Before branching to the printf function, it does the following:
        // 1. It updates our frame pointer (register X29) to contain the address of the stack pointer (register SP)
        // 2. It updates the link register (register X30) to contain the address immediately following the bl instruction, which is the return address that the printf function will use
        //
        // After all of these preparations are done, the bl instruction branches to the printf function
        bl _printf

        // Our stack currently looks like this:
        //
        // <frame pointer>
        // Saved value in x29 (8 bytes)
        // Saved value in x30 (8 bytes)
        // Empty (8 bytes)
        // 2025 (8 bytes)
        // <stack pointer>
        //
        // In order to load the saved values for registers x29 and x30,
        // we have to increment the stack pointer by 16, so that it points to the correct memory address.
        //
        // Remember that the stack grows downward,
        // so the stack pointer address is equal to the frame pointer address minus 32 bytes
        add sp, sp, #16

        // Now that our stack pointer points to the correct location in memory,
        // we load the old values for registers x29 and x30 from the stack into registers x29 and x30
        ldp x29, x30, [sp, #16]

        // After loading a pair of values from the stack into registers x29 and x30,
        // we have the correct frame pointer and the correct return address
        //
        // Now we move the value 0 into register x0, which represents our exit status
        mov x0, #0

        // Now we move the value 1 into register x16, which represents system call number one, i.e. exit
        mov x16, #1

        // Now we make a system call to exit our application, using the call number provided in register x16
        svc #0

    // The str label stores the memory address of the start of our string
    // The .asciz directive defines a null-terminated string
    str:
        .asciz "The year is %d\n"

We have finished commenting the code. I hope that makes the code clear.

## Conclusion

In this document we talked about stack management, stack frames, frame pointers, stack pointers, return addresses, the printf function, and many other topics.

In the beginning of the document we asked the questions, "Why do we use the stack? Why do we need the stack?"

The answer is that we use the stack to pass arguments to a function, and we also use the stack to preserve register values, like the values contained in the registers x29 (the frame pointer) and x30 (the link register).

When we program in the C language, we do memory management.

When we program in assembly language, we do stack management.
