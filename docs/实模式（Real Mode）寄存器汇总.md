# x86 实模式（Real Mode）寄存器汇总

本文系统性汇总 **x86 实模式（8086 兼容）** 下的寄存器说明，适用于学习汇编语言、理解内存寻址以及使用 emu8086 / x86dbg 等调试工具。

---

## 一、通用寄存器（General Purpose Registers）

8086 共有 8 个 16 位通用寄存器，其中 4 个可拆分为两个 8 位寄存器。

| 寄存器 | 全名              | 可拆分  | 说明           | 常见用途            |
| ------ | ----------------- | ------- | -------------- | ------------------- |
| AX     | Accumulator       | AH / AL | 累加器         | 算术运算、乘除、I/O |
| BX     | Base              | BH / BL | 基址寄存器     | 内存寻址（基址）    |
| CX     | Count             | CH / CL | 计数寄存器     | 循环（LOOP）、移位  |
| DX     | Data              | DH / DL | 数据寄存器     | 乘除扩展、I/O       |
| SP     | Stack Pointer     | ❌      | 栈顶指针       | 指向栈顶            |
| BP     | Base Pointer      | ❌      | 栈基址指针     | 访问栈参数          |
| SI     | Source Index      | ❌      | 源变址寄存器   | 字符串源地址        |
| DI     | Destination Index | ❌      | 目标变址寄存器 | 字符串目标地址      |

---

## 二、段寄存器（Segment Registers）

**实模式地址计算公式：**

> 物理地址 = 段寄存器 × 16 + 偏移地址

| 寄存器 | 全名          | 默认配合 | 说明                 |
| ------ | ------------- | -------- | -------------------- |
| CS     | Code Segment  | IP       | 代码段               |
| DS     | Data Segment  | BX / SI  | 数据段               |
| SS     | Stack Segment | SP / BP  | 栈段                 |
| ES     | Extra Segment | DI       | 附加段（字符串指令） |

### 示例

```asm
mov ax, 1234h
mov ds, ax
mov al, [5678h]
```

访问的物理地址为：

```
1234h * 16 + 5678h
```

---

## 三、指令指针寄存器（Instruction Pointer）

| 寄存器 | 全名                | 位数  | 说明                     |
| ------ | ------------------- | ----- | ------------------------ |
| IP     | Instruction Pointer | 16 位 | 指向下一条将要执行的指令 |

> **CS\*\***:IP\*\* 共同决定当前 CPU 执行位置。

---

## 四、标志寄存器（FLAGS）

FLAGS 是 16 位寄存器，以下是实模式下最常用的标志位：

| 位  | 标志 | 英文            | 作用         |
| --- | ---- | --------------- | ------------ |
| 0   | CF   | Carry Flag      | 进位 / 借位  |
| 2   | PF   | Parity Flag     | 奇偶校验     |
| 4   | AF   | Auxiliary Carry | BCD 运算     |
| 6   | ZF   | Zero Flag       | 结果是否为 0 |
| 7   | SF   | Sign Flag       | 符号位       |
| 8   | TF   | Trap Flag       | 单步调试     |
| 9   | IF   | Interrupt Flag  | 中断允许     |
| 10  | DF   | Direction Flag  | 字符串方向   |
| 11  | OF   | Overflow Flag   | 有符号溢出   |

### 示例

```asm
cmp ax, bx
jz equal   ; 当 ZF = 1 时跳转
```

---

## 五、字符串指令相关寄存器

| 指令          | 使用的寄存器  | 说明       |
| ------------- | ------------- | ---------- |
| MOVSB / MOVSW | DS:SI → ES:DI | 内存块拷贝 |
| CMPSB / CMPSW | DS:SI ↔ ES:DI | 比较字符串 |
| LODSB / LODSW | DS:SI → AL/AX | 从内存加载 |
| STOSB / STOSW | AL/AX → ES:DI | 写入内存   |
| SCASB / SCASW | AL/AX ↔ ES:DI | 扫描字符串 |

> DF = 0：SI / DI 自动递增
> DF = 1：SI / DI 自动递减

---

## 六、寄存器分类速查表

| 类别       | 寄存器      |
| ---------- | ----------- |
| 通用寄存器 | AX BX CX DX |
| 指针/变址  | SP BP SI DI |
| 段寄存器   | CS DS SS ES |
| 控制寄存器 | IP FLAGS    |

---

> 本文档适用于：8086、DOS、实模式引导程序（Bootloader）以及汇编入门学习。
