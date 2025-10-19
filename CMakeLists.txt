
cmake_minimum_required(VERSION 3.10)
project(rpi_kernel C ASM)

file(GLOB_RECURSE ASM_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.S)
file(GLOB_RECURSE C_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.c)

add_executable(
  kernel.elf
  ${ASM_FILES}
  ${C_FILES}
)

target_include_directories(kernel.elf PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_options(kernel.elf PRIVATE
    -mcpu=cortex-a7
    -nostdlib
    -ffreestanding
    -Wall
    -Wextra
    -O0 
    -g  # Include debug symbols
)

target_link_options(kernel.elf PRIVATE
  -T ${CMAKE_CURRENT_SOURCE_DIR}/kernel.ld
  -nostdlib
)


add_custom_command(
  OUTPUT kernel.img
  COMMAND ${CMAKE_OBJCOPY} -O binary kernel.elf kernel.img
  DEPENDS kernel.elf
  COMMENT "Converting ELF to binary kernel.img"
)


add_custom_target(kernel_image ALL
    DEPENDS kernel.img
)

add_custom_target(run
    COMMAND qemu-system-arm -M raspi2b -no-reboot -nographic -serial mon:stdio -kernel kernel.elf
    DEPENDS kernel.elf
    COMMENT "Running in QEMU"
)


add_custom_target(gdb
    COMMAND ${CMAKE_GDB} ${CMAKE_BINARY_DIR}/kernel.elf
        -ex "target remote localhost:1234"
        -ex "break _start"
        -ex "continue"
    DEPENDS kernel.elf
    COMMENT "Starting GDB (ensure 'make wait-for-gdb' is running in another terminal)"
)

add_custom_target(wait-for-gdb
    COMMAND qemu-system-arm -M raspi2b -no-reboot -nographic -serial mon:stdio -S -s -gdb tcp::1234
    DEPENDS kernel.elf
    COMMENT "Starting QEMU, waiting for GDB on localhost:1234"
)


add_custom_target(debug
    COMMAND ${CMAKE_COMMAND} -E echo "Starting QEMU and GDB..."
    COMMAND qemu-system-arm -M raspi2b -no-reboot -nographic -serial mon:stdio -S -gdb tcp::1234 &
    COMMAND ${CMAKE_GDB} ${CMAKE_BINARY_DIR}/kernel.elf
        -ex "target remote localhost:1234"
        -ex "break _start"
        -ex "continue"
    DEPENDS kernel.elf
    COMMENT "Starting QEMU and GDB together"
)