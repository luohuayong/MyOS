# MyOS

学习和实验操作系统编写

## 工具介绍

### qemu

qemu 是一个开源的、功能强大的硬件虚拟化平台和模拟器，可以模拟整个计算机系统（包括 CPU、内存、外设等），让你在一台物理机上运行多个不同的操作系统。
https://www.qemu.org/download/

## 参考文档

- 如何从零开始编写一个操作系统 https://github.com/ruiers/os-tutorial-cn

## 常用命令

```bash
# 编译汇编
nasm -f bin boot.asm -o boot.bin

# 启动一个32位的x86虚拟机，加载并运行引导程序二进制文件
qemu-system-i386 -drive format=raw,file=boot.bin

# cmake
cd build
cmake ..
cmake --build .

# cmake 调试模式
cmake --build . --target debug

# 新窗口 gdb 调试
gdb
target remote localhost:1234

# 运行并加载磁盘镜像
qemu-system-i386 -drive format=raw,file=bin/os.img

```

### qemu 参数说明

| 参数             | 含义                     |
| ---------------- | ------------------------ |
| -S               | CPU 上电后暂停，等待 GDB |
| -s               | 等价于 -gdb tcp::1234    |
| -m 16M           | 分配 16MB 内存           |
| -no-reboot       | 出错不自动重启           |
| -no-shutdown     | 不自动退出               |
| DEPENDS build_os | 先确保 os.img 已生成     |
| USES_TERMINAL    | 让 QEMU 正常占用终端     |
