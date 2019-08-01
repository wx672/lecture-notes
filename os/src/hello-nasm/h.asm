Msg: db 'Hello, world'
MsgLen: equ $-Msg
mov eax,4      ; sys_write syscall = 4
mov ebx,1      ; 1 = STDOUT
mov ecx,Msg    ; offset of the message
mov edx,MsgLen ; length of string
int 80h        ; call the kernel
