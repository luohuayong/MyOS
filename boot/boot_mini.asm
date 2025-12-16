loop:
  jmp loop
; 一个扇区 512 字节
; 引导扇区最后两个字节固定为 0xaa55
; 剩余 510 字节除了代码外填充 0
times 510-($-$$) db 0
dw 0xaa55
