
;------------------------------giveCards-----------------------------------

proc giveCards uses ecx ebx eax
     mov cx, 2000
@@:
     stdcall Randomize
     stdcall RandomWord, 0, 35
     mov bx, ax
     stdcall RandomWord, 0, 35
     stdcall swapCards, AllCards, bx, ax
     dec cx
     cmp cx, 0
     jne @b
     ; выбираем козырь
     ; вот это поменять
     cld
     stdcall putCards, AllCards, Player1.cards, 6
     stdcall putCards, AllCards + 24, Player2.cards, 6
     stdcall putCards, AllCards + 48, Deck, 24
     mov eax, dword[Deck]
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

proc pushCard

        ret
endp

;----------------------------popCard---------------------------------------

proc popCard

        ret
endp

;----------------------------peek-------------------------------------------
; на вход принимает адрес стека и номер карты в стеке (не смещение в памяти!!)
proc peek

        ret
endp

















