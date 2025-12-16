; boot_hello.asm
; 使用 BIOS INT 10h 在屏幕上输出 "Hello,World!"

org 0x7c00

mov si,msg      ; 消息地址

.print:
  lodsb         ; AL = [SI], SI++
  cmp al, 0     ; 检查是否结束（AL=0）
  jz .hang      ; 如果是0，结束

  mov ah,0x0e   ; BIOS TTY 输出
  mov bh,0x00   ; 页号
  mov bl,0x07   ; 灰底白字
  int 0x10      ; BIOS INT 10h

  jmp .print

.hang:
  jmp .hang      ; 死循环，防止跑飞

msg db 'Hello,World!',0

; 填充到 512 字节
times 510-($-$$) db 0
dw 0xaa55

