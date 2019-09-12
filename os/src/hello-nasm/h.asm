Msg: db 'Hello, world'
MsgLen: equ $-Msg
mov eax, 4       ; 4 = sys_write 
mov ebx, 1       ; 1 = STDOUT
mov ecx, Msg     ; address of message
mov edx, MsgLen  ; length of string
int 80h          ; call the kernel
