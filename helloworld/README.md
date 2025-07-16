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

The -e option specifies the entry point, which corresponds to the memory address stored under the main label.

The -o option specifies the name of the output file.

## Some vocabulary

Before we explain the assembly code, it helps to learn some vocabulary.

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

In the next section we will talk about how a computer works.

## How a computer works

At the heart of a computer is the central processing unit, or the CPU.

The CPU, or processor, is a chip that executes instructions.

The CPU has a register, called the instruction pointer (IP) or program counter (PC), which stores the memory address of the next instruction.

The program counter typically gets incremented after an instruction is executed.

Sometimes, the program counter gets set to point to a new region of memory, like after a jmp instruction or during a context switch.

You can think of a program as one or more threads of execution.

You can think of a thread as a list, or sequence, of instructions.

Every program has a main thread, and the main thread has a start address.

When a program is run by the user, the operating system loads it into memory and sets the instruction pointer of the CPU to point to the start address of the main thread of the program.

The CPU then fetches the instruction from this address, decodes the instruction (like breaking it down into an opcode and operands), and then executes the instruction.

The instruction pointer (also known as the program counter) gets incremented, and the CPU repeats this cycle of fetch-decode-execute.

If you consider our hello world program, you can see that the program consists of a single thread.

The label "main" stores the start address of the program, the entry point to the program.

The operating system loads our executable into memory. Then the operating system sets the program counter to point to the address stored under the label "main".

Our program has a text section and a data section.

The text section and the data section appear in both the object file and the executable.

The text section has eight instructions.

The data section contains a string ("Hello world!\n") and a variable representing the length of the string.

The CPU executes each instruction in order, starting with the first instruction.

The first instruction is "mov X0, #1".

Our program makes two system calls, write and exit.

First it prepares the write system call, by storing the address of our string and the length of our string in registers X1 and X2. It also stores the system call number in register X16.

Then it makes the system call.

Then it prepares the exit system call, by storing the exit status in register X0, and by storing the system call number in register X16.

Then it makes the system call.

After the second system call is executed, our program has finished running.

There is no need to keep the program in memory anymore, so the operating system frees up all of the memory that was used by our program.

You might wonder, "How does it work for a longer program, for a program that runs indefinitely?"

For example, a web browser runs indefinitely.

How does the processor switch between different processes, like a web browser and a text editor?

This is a really good question.

The CPU has to run kernel code as well as application code, and switch between applications.

How does it do this?

The answer is simple (but it's also hard to find).

The CPU has a built-in timer.

The timer has an interval that can be set programmatically.

When the interval is up, it generates an interrupt.

The CPU switches from user mode to kernel mode to handle the interrupt.

The kernel has an interrupt handler which handles the interrupt.

The interrupt handler saves the current context and decides which process will run next.

The interrupt handler loads the context of the next process... which involves storing the address of the next instruction in the program counter, and setting every register to the appropriate value.

When the interrupt handler has finished, it switches the CPU back to user mode, and lets the CPU continue its cycle of fetch, decode, and execute.

In case you were wondering, the CPU has a mode bit in its status register that signifies whether the CPU is in user mode or kernel mode.

The kernel is capable of modifying the mode bit in the status register to effectively change modes.

I think we have finished explaining how a processor works.

The key lesson here is that the CPU has a built-in timer that generates an interrupt after a certain interval.

The kernel has an interrupt handler which handles the interrupt.

The interrupt handler decides which process will run next, which process will get the CPU's time and attention.

This is how time-sharing works.

The CPU has a built-in timer that enables time sharing.
