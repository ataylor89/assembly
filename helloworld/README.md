# Hello World

## Compiling to machine code

I am currently using MacOS Monterey version 12.4 on an Apple M1 chip.

The instructions I am about to give you work for my chip and operating system. It's really specific to MacOS and ARM64. Older Mac computers have an x86 processor, and newer Mac computers have an ARM64 processor.

To compile the assembly code into machine code, I typed the following commands, from within the helloworld folder.

    % as -o helloworld.o helloworld.s
    % ld -o helloworld helloworld.o -lSystem -syslibroot $SYSLIBROOT -e main
    % ./helloworld
    Hello world!

It's important to know that... before doing this... I created an environment variable called $SYSLIBROOT.

I edited my ~/.zshrc file and added the line

    export SYSLIBROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk

So you can see that I defined the environment variable $SYSLIBROOT before compiling the assembly code.

This way, I don't have to type out a long path every time I compile the assembly code.

It's also important to point out that... the path for $SYSLIBROOT works for me but it might not work for you.

To find the correct path, you can run the following command in Terminal"

    xcrun -sdk macosx --show-sdk-path

## Review

To compile the assembly code into machine code, I first defined the environment variable $SYSLIBROOT in my ~/.zshrc file. You can find the correct path by running the command `xcrun -sdk macosx --show-sdk-path` in Terminal.

Then I typed the following commands in the helloworld directory.

    % as -o helloworld.o helloworld.s
    % ld -o helloworld helloworld.o -lSystem -syslibroot $SYSLIBROOT -e main
    % ./helloworld
    Hello world!

The -lSystem and -syslibroot options specify the path in which to find the System library. We need to include the System library when we link the helloworld.o object file.

The -e option specifies the entry point, which corresponds to the memory address symbolized by the main label.

The -o option specifies the name of the output file.

## Some vocabulary

Before we explain the assembly code, it helps to learn some vocabulary.

Word | Definition
---- | ----------
Directive | An instruction for the assembler (e.g. .global, .balign, .text, .data)
Symbol | A variable that has a value
Label | A symbol that stores a memory address (e.g. main is a label and it correponds to a memory address)
mov | The move instruction. It moves a value into a register.
adr | The address instruction. It moves an address into a register.
svc | Supervised call (or syscall). A system call is an operating system procedure, like write or exit.
Symbol table | A table that stores information about symbols
Register | A storage device within the CPU

## Explaining the code, line by line

To explain the code, line by line, we'll just add a comment above each line of assembly code.

Here is the code, reproduced, below:

    // The global directive makes a symbol globally visible,
    // so that it can be referenced by other parts of the program.
    .global main

    // It's interesting... this directive appears to be unnecessary.
    // What it accomplishes is this: it makes sure that the memory address
    // corresponding to the main label is a multiple of four.
    // The reason it appears unnecessary, to me, is that the assembler or linker should take care of this,
    // without the programmer having to do it manually.
    .balign 4

    // The main label stores the start address of our program
    main:
        
        // This instruction moves the value 1 into the 64-bit register X0
        // The value 1 corresponds to the file descriptor stdout
        mov X0, #1

        // This instruction moves the memory address stored under the label str into the 64-bit register X1
        // To be clear, the address is actually the starting address of our string "Hello world!\n"
        adr X1, str

        // This instruction moves the length of our string into the 64-bit register X2
        mov X2, len

        // This instruction moves the value 4 into the 64-bit register X16
        // The value 4 corresponds to system call number 4, i.e. the write operation
        mov X16, #4

        // This instruction executes a system call, using the call number stored in X16
        svc #0

        // This instruction moves the value 0 into the 64-bit register X0
        // The value 0 represents the exit status that will be passed to the exit procedure
        mov X0, #0

        // This instruction moves the value 1 into the 64-bit register X16
        // The value 1 corresponds to system call number one, i.e. the exit procedure
        mov X16, #1

        // This instruction executes a system call, using the call number stored in X16
        svc #0

    // This label stores the starting address of our string
    str: 
        .ascii "Hello world!\n"

    // This variable stores the length of our string
    len = . - str

We have finished commenting our code. I hope that makes the code clear.

I have been writing assembly for a long time, so I am used to concepts like instructions, registers, and machine code. What we are really doing is feeding instructions into a processor (or a chip) and the processor executes these instructions. The processor is capable of moving numeric data (binary data) into a register, into memory, or into an IO device like a computer screen.

IO is an acronym that means "input output".

We can think of a computer as a chip (processor), a memory system (RAM), and a collection of IO devices. The chip (or processor) is capable of writing data to registers, memory, and IO devices.

Essentially, a processor (CPU) executes instructions, and moves data to different parts of a computer.

Assembly language allows us to interact with a processor at a very low level.

We compile assembly language into an object file. Then we link the object file into an executable.

The operating system loads an executable into memory.

Then, the operating system sets the CPU's instruction pointer to the entry point of the program.
