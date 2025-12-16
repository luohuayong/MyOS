org 0x9000

; 显示字符 'K' 表示 kernel 正在运行
mov ah, 0x0E
mov al, 'K'
int 0x10

; 无限循环
jmp $