org 0x7c00
; 建立一个干净可控的运行环境
; 栈指针设置为 0x7c00
; 栈向 低地址增长,不会覆盖代码
start:
  cli
  xor ax,ax
  mov ds,ax
  mov es,ax
  mov ss,ax
  mov sp,0x7c00
  sti

; 显示字符 'B' 表示 boot 正在运行
mov ah, 0x0E
mov al, 'B'
int 0x10

; 使用 BIOS INT 13h 读取 loader（假设 loader 在第 2 扇区）
mov ah, 0x02    ; 读扇区
mov al, 1       ; 读 1 个扇区
mov ch, 0       ; 柱面
mov cl, 2       ; 扇区号（第2扇区）
mov dh, 0       ; 磁头
mov dl, 0x80    ; 硬盘0
mov bx, 0x8000  ; 加载地址
int 0x13

; 跳转到 loader
jmp 0x0000:0x8000

; 一个扇区 512 字节
; 引导扇区最后两个字节固定为 0xaa55
; 剩余 510 字节除了代码外填充 0
times 510-($-$$) db 0
dw 0xaa55
