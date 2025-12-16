org 0x8000

mov ah,0x0e
mov al,'L'
int 0x10

; 读取 kernel（假设 kernel 从第3扇区开始，连续 4 扇区）
mov ah, 0x02    ; 读扇区
mov al, 4       ; 读 4 个扇区
mov ch, 0       ; 柱面
mov cl, 3       ; 第3扇区开始
mov dh, 0       ; 磁头
mov dl, 0x80    ; 硬盘0
mov bx, 0x9000  ; kernel 加载到 0x9000
int 0x13

; 跳转到 kernel
jmp 0x0000:0x9000

; 填充到 512 字节（可选，如果 loader 只有 1 扇区）
times 510-($-$$) db 0
dw 0xAA55