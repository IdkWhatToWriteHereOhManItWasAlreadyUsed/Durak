
;------------------------------giveCards-----------------------------------

proc giveCards uses ecx ebx eax
     mov cx, 2000
     mov dword[Deck], 24
@@:
     stdcall Randomize
     stdcall RandomWord, 0, 35
     mov bx, ax
     stdcall RandomWord, 0, 35
     stdcall swapCards, AllCards, bx, ax
     dec cx
     cmp cx, 0
     jne @b
     cld
     stdcall putCards, AllCards, Player1.cards, 6
     stdcall putCards, AllCards + 24, Player2.cards, 6
     stdcall putCards, AllCards + 48, Deck + 4, 24
     mov eax, dword[Deck + 4]
     mov dword[Trump], eax
     ret
endp

;-----------------------------swapCards------------------------------------

proc swapCards uses esi edx edi ebx ecx, Cards: DWORD, Index1: Word
     movzx esi, [Index1]
     shl esi, 2
     movzx edi, [Index1+2]
     shl edi, 2
     mov eax, [Cards]
     mov ebx, [eax + esi]
     mov ecx, [eax + edi]
     mov [eax + edi], ebx
     mov[eax + esi], ecx
     ret
endp

;----------------------------putCards-----------------------------------------

proc putCards uses esi edi ecx eax, src: DWORD, dest: DWORD, amount: DWORD
     mov esi, [src]
     mov edi, [dest]
     mov ecx, [amount]
@@:
     movsd
     dec cx
     cmp cx, 0
     jne @b
     ret
endp

;--------------------------pushCard------------------------------------------

proc pushCard uses edi ebx ecx, stack: DWORD, card: DWORD
        mov edi, [stack]
        mov ebx, [edi]
        mov ecx, [card]
        mov [edi + ebx], ecx
        add dword [edi], 4
        ret
endp

;----------------------------popCard---------------------------------------

proc popCard uses esi ebx, stack: DWORD
        mov esi, [stack]
        mov ebx, [edi]
        mov eax, [esi + ebx]
        mov dword[esi + ebx], 0
        sub dword [edi], 4
        ret
endp

;----------------------------peekCard---------------------------------------
; на вход принимает адрес стека и позиция в стеке (не смещение в памяти!!)
proc peekCard uses esi ebx, stack: DWORD, pos: DWORD
        mov esi, [stack]
        mov ebx, [pos]
        shl ebx, 2
        mov eax, [esi + ebx + 4]
        ret
endp

;---------------------------clearStack--------------------------------------

proc clearStack uses esi ecx ebx, stack: DWORD
     mov esi, [stack]
     mov ecx, [esi]
     xor ebx, ebx
@@:
     mov dword[esi + ebx], 0
     shl ebx, 2
     cmp ebx, ecx
     jne @b
     mov dword[esi], 4
     ret
endp
























