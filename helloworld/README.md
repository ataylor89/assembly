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

