proc Randomize
     rdtsc
     mov [PrevRandom], eax
     ret
endp
proc RandomWord uses ecx edx, MinVal : Word, MaxVal : Word
     mov eax, [PrevRandom]
     mul [RANDOM_MULTIPLIER]
     add eax, RANDOM_INCREMENT
     mov [PrevRandom], eax

     mov cx, [MaxVal]
     sub cx, [MinVal]
     inc cx
     xor dx, dx
     div cx
     add dx, [MinVal]

     xchg    ax, dx
     ret
endp