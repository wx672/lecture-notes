LOAD  [i], r0  ; load the value of 'i' into
               ;   a register from memory
ADD   r0, 1    ; increment the value
               ;   in the register
STORE r0, [i]  ; write the updated value
               ;   back to memory          
