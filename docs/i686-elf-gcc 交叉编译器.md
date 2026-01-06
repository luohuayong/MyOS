# i686-elf-gcc 交叉编译器

本文档用于**系统学习与查阅 i686-elf-gcc**，面向：

- 操作系统 / Bootloader 学习
- 裸机（Bare Metal）开发
- 不依赖宿主系统运行库的程序

---

## 一、i686-elf-gcc 是什么？

### 1️⃣ 名称拆解

```text
i686   - 目标 CPU 架构（32 位 x86）
elf    - 目标文件格式（ELF）
gcc    - GNU Compiler Collection
```

👉 **i686-elf-gcc = 面向 32 位 x86、生成 ELF 文件的交叉编译器**

---

### 2️⃣ 为什么不用普通 gcc？

| 普通 gcc      | i686-elf-gcc |     |
| ------------- | ------------ | --- |
| 依赖宿主系统  | 完全独立     |     |
| 自动链接 libc | ❌ 不链接    |     |
| 适合应用程序  | ❌           |     |
| 适合 OS       | ❌           | ✅  |

> 写 OS 时 **绝不能依赖 Windows / Linux 的运行库**

---

## 二、i686-elf-gcc 的典型用途

- 编译内核（kernel.c）
- 编译驱动 / 中断处理
- 生成 `.o / .elf`
- 配合 linker script (`link.ld`)

**不用于：**

- Windows 应用
- Linux 用户程序

---

## 三、工具链组成

通常一套完整工具链包括：

| 工具             | 作用     |
| ---------------- | -------- |
| i686-elf-gcc     | 编译 C   |
| i686-elf-as      | 汇编     |
| i686-elf-ld      | 链接     |
| i686-elf-objdump | 反汇编   |
| i686-elf-objcopy | 格式转换 |

---

## 四、安装方式（MSYS2 / Windows）

### 方式一：预编译工具链（推荐）

- 下载现成的 `i686-elf-gcc` 工具链
- 解压到：

```text
C:\opt\cross
```

- 将以下路径加入 PATH：

```text
C:\opt\cross\bin
```

---

### 方式二：自行编译（了解即可）

步骤概要：

1. binutils
2. gcc（不含 libc）
3. 设置 target=i686-elf

⚠️ 新手不建议

---

## 五、基本使用方式

### 1️⃣ 编译 C 文件

```bash
i686-elf-gcc -c kernel.c -o kernel.o \
  -std=gnu99 \
  -ffreestanding \
  -O2 \
  -Wall -Wextra
```

### 参数说明

| 参数           | 含义         |
| -------------- | ------------ |
| -c             | 只编译不链接 |
| -ffreestanding | 裸机环境     |
| -std=gnu99     | C 标准       |
| -O2            | 优化         |

---

### 2️⃣ 编译汇编文件

```bash
i686-elf-as boot.s -o boot.o
```

或使用 gcc 调用汇编器：

```bash
i686-elf-gcc -c boot.s -o boot.o
```

---

### 3️⃣ 链接生成 ELF

```bash
i686-elf-gcc \
  -T link.ld \
  -o kernel.elf \
  boot.o kernel.o \
  -ffreestanding \
  -nostdlib
```

---

## 六、linker script（link.ld）示例

```ld
ENTRY(_start)

SECTIONS
{
  . = 1M;

  .text : { *(.text*) }
  .rodata : { *(.rodata*) }
  .data : { *(.data*) }
  .bss : { *(.bss*) }
}
```

---

## 七、生成裸机二进制文件

```bash
i686-elf-objcopy \
  -O binary \
  kernel.elf kernel.bin
```

用于：

- QEMU 启动
- 写入磁盘镜像

---

## 八、调试与反汇编

### objdump

```bash
i686-elf-objdump -d kernel.elf
```

### QEMU + GDB

```bash
qemu-system-i386 \
  -kernel kernel.bin \
  -S -s
```

```bash
i686-elf-gdb kernel.elf
```

---

## 九、常见错误

### ❌ undefined reference to memset

原因：

- freestanding 环境无 libc

解决：

- 自己实现 memset / memcpy

---

### ❌ 使用了 printf

裸机环境 **不能用**

---

## 十、推荐学习顺序

1. NASM / GAS 汇编
2. bootloader（16 位）
3. 进入保护模式
4. i686-elf-gcc 编译 C 内核
5. 中断 / 内存管理

---

## 十一、一句话总结

> **i686-elf-gcc 是为操作系统而生的编译器，不是给应用程序用的**

当你开始写 C 内核时，它是必需品。
