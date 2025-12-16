cmake_minimum_required(VERSION 3.20)
project(MyOS NONE)

# 设置输出目录
set(OS_BUILD_DIR ${CMAKE_BINARY_DIR}/bin)
file(MAKE_DIRECTORY ${OS_BUILD_DIR})

# NASM 编译规则
find_program(NASM_EXECUTABLE nasm)
if(NOT NASM_EXECUTABLE)
    message(FATAL_ERROR "NASM not found")
endif()

# boot
add_custom_command(
    OUTPUT ${OS_BUILD_DIR}/boot.bin
    COMMAND ${NASM_EXECUTABLE} -f bin ${CMAKE_SOURCE_DIR}/boot/boot.asm -o ${OS_BUILD_DIR}/boot.bin
    DEPENDS ${CMAKE_SOURCE_DIR}/boot/boot.asm
)

# loader
add_custom_command(
    OUTPUT ${OS_BUILD_DIR}/loader.bin
    COMMAND ${NASM_EXECUTABLE} -f bin ${CMAKE_SOURCE_DIR}/loader/loader.asm -o ${OS_BUILD_DIR}/loader.bin
    DEPENDS ${CMAKE_SOURCE_DIR}/loader/loader.asm
)

# kernel
add_custom_command(
    OUTPUT ${OS_BUILD_DIR}/kernel.bin
    COMMAND ${NASM_EXECUTABLE} -f bin ${CMAKE_SOURCE_DIR}/kernel/kernel.asm -o ${OS_BUILD_DIR}/kernel.bin
    DEPENDS ${CMAKE_SOURCE_DIR}/kernel/kernel.asm
)

# 生成 os.img
add_custom_command(
    OUTPUT ${OS_BUILD_DIR}/os.img
    COMMAND ${CMAKE_COMMAND} -E echo "Creating os.img"
    COMMAND ${CMAKE_COMMAND} -E env LANG=C
            dd if=${OS_BUILD_DIR}/boot.bin of=${OS_BUILD_DIR}/os.img bs=512 count=1
    COMMAND ${CMAKE_COMMAND} -E env LANG=C
            dd if=${OS_BUILD_DIR}/loader.bin of=${OS_BUILD_DIR}/os.img bs=512 seek=1
    COMMAND ${CMAKE_COMMAND} -E env LANG=C
            dd if=${OS_BUILD_DIR}/kernel.bin of=${OS_BUILD_DIR}/os.img bs=512 seek=2
    DEPENDS ${OS_BUILD_DIR}/boot.bin ${OS_BUILD_DIR}/loader.bin ${OS_BUILD_DIR}/kernel.bin
)

# 创建虚拟目标
add_custom_target(build_os ALL DEPENDS ${OS_BUILD_DIR}/os.img)

# qemu + gdb 加载磁盘镜像并 debug
add_custom_target(debug
    COMMAND qemu-system-i386
        -drive format=raw,file=${OS_BUILD_DIR}/os.img
        -m 16M
        -S
        -s
        -no-reboot
        -no-shutdown
    DEPENDS build_os
    USES_TERMINAL
)