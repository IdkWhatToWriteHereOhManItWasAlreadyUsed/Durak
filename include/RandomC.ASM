
RANDOM_INCREMENT = 47
PrevRandom dw ?

proc Randomize
     rdtsc
     mov [PrevRandom], ax
     ret
endp

proc RandomWord MinVal : Word, MaxVal : Word
     mov ax, [PrevRandom]
     rol ax, 7
     adc ax, RANDOM_INCREMENT
     mov [PrevRandom], ax

     mov cx, [MaxVal]
     sub cx, [MinVal]
     inc cx
     xor dx, dx
     div cx
     add dx, [MinVal]

     xchg    ax, dx
     ret
endp