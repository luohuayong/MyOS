# CMake 工具链文件：i686-elf.cmake

# 1. 明确指定目标系统
# 因为目标不是 Linux/Windows 等已知系统，所以使用 Generic
SET(CMAKE_SYSTEM_NAME Generic)

# 2. 设置目标架构的名称
SET(TARGET_ARCH i686)

# 3. 设置交叉编译工具链的前缀
# 确保这个前缀与您在 MSYS2 中构建的交叉编译器前缀一致
# 例如，如果您将交叉编译器安装在 /opt/cross/bin/i686-elf-gcc
SET(TOOLCHAIN_PREFIX "i686-elf-") 

# 4. 指定 C/C++ 编译器路径
# CMake 会在 PATH 中寻找，但最好显式指定
# 这里假设 i686-elf-gcc 位于 PATH 中（如果安装在 MSYS2 的某个 bin 目录）
SET(CMAKE_C_COMPILER   ${TOOLCHAIN_PREFIX}gcc)
SET(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)
SET(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}as)

# 5. 配置必要的编译选项
# 禁用链接时的共享库查找，确保是静态链接
SET(CMAKE_C_FLAGS    "-ffreestanding -O2 -g" CACHE STRING "C Compiler Flags")
SET(CMAKE_CXX_FLAGS  "-ffreestanding -O2 -g" CACHE STRING "CXX Compiler Flags")

# 6. 配置链接器和链接标志
# 告诉链接器使用我们自定义的链接脚本
SET(CMAKE_EXE_LINKER_FLAGS "-nostdlib -lgcc -Tlinker.ld" CACHE STRING "Linker Flags")

# 7. 禁用默认规则和查找
# 不搜索目标环境的默认头文件、库和运行时
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# 8. 告诉 CMake 目标不是可执行文件，而是裸二进制/内核文件
# 这通常在主 CMakeLists.txt 中完成，但在此处设置一些默认行为