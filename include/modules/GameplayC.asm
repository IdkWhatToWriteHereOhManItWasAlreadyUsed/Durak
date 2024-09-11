
;------------------------------giveCards-----------------------------------

proc giveCards
     mov ecx, 35
     mov edx, 0
     mov eax, Cards
@@:
     push ecx
     mov eax, ecx
     div 9
     inc eax
     mov [eax + edx],
     loop @b

     ret
endp




