# Embedded FPGA Video Game: Head Soccer

## Project Context
This project aimed to design a fully functional 2D arcade game, inspired by the mobile game "Head Soccer", directly implemented on a **Basys 3 FPGA board**. 

The core technical challenge was to establish a seamless interaction between a custom-built hardware architecture and the software game logic. It served as a practical foundation for understanding strict memory constraints, hardware-software cross-compilation, and end-to-end embedded system design.

## Hardware Architecture & Optimization (VHDL)
The hardware foundation was written entirely in VHDL to support the game's visual and processing requirements:
* **Custom VGA Controller:** Engineered a hardware-level 640x480 VGA controller to manage synchronization signals (HSYNC, VSYNC) and accurate pixel rendering.
* **Strict Memory Management:** To respect the FPGA's strict 1800 kbits memory limit, I implemented a custom scaling logic in VHDL that takes a 120x160 pixel background image and scales it by a factor of 4 directly on the screen.
* **Dynamic Bootloader:** Integrated a custom bootloader mapped to a 4096-word RAM block. This allowed the dynamic loading of compiled C binaries via a serial port without needing to regenerate the heavy hardware bitstream for every software iteration, drastically improving development speed.

## Software Logic & "Proto-AI" (C)
The game mechanics were written in C and cross-compiled to run on a **Plasma soft-core processor** embedded within the FPGA.
* **Physics & Collisions:** Handled real-time hardware inputs (physical FPGA buttons) to control the player's movements, jumps, and ball collision physics.
* **Dynamic Opponent (Bot):** Programmed a standalone automated opponent that actively tracks the ball's position. To enhance the user experience, the bot features a dynamic difficulty system: its tracking speed and reaction time increment every time the player scores a goal.

## Tech Stack & Hardware Requirements
* **Hardware:** Digilent Basys 3 FPGA Board (Xilinx Artix-7), VGA Monitor
* **Hardware Description Language:** VHDL
* **Software Language:** C (Bare-metal)
* **Processor Architecture:** Plasma Soft-Core (MIPS architecture)
* **Key Concepts:** Memory Management, VGA Synchronization, Cross-Compilation, Game Physics

## How it Works
1. The VHDL bitstream is synthesized and flashed onto the Basys 3 board, configuring the physical logic gates, the VGA controller, and the Plasma soft-core.
2. The C game logic is compiled into a `.bin` file.
3. Using the custom bootloader, the `.bin` executable is sent via Serial Port directly into the FPGA's RAM block.
4. The soft-core executes the game logic, reading physical button states and updating sprite coordinates, while the hardware VGA controller reads these coordinates to render the frames at 60Hz.
