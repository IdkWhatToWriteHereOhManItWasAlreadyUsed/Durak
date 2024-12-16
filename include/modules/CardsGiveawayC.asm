;//////////////////////////////////////////////////////////////////////
;//////////////////////////////////////////////////////////////////////
;/////////                                                   //////////
;/////////                Cards giveaway procedures          //////////
;/////////                                                   //////////
;//////////////////////////////////////////////////////////////////////
;//////////////////////////////////////////////////////////////////////

;------------------------------GiveCards-----------------------------------

proc GiveCards uses ecx ebx eax
     mov cx, 2000
     mov dword[Deck], 100
@@:
     stdcall Randomize
     stdcall RandomWord, 0, 35
     mov bx, ax
     stdcall RandomWord, 0, 35
     stdcall SwapCards, AllCards, bx, ax
     dec cx
     cmp cx, 0
     jne @b
     cld
     stdcall PutCards, AllCards, Player1Cards, 6
     stdcall PutCards, AllCards + 24, Player2Cards, 6
     stdcall PutCards, AllCards + 48, Deck + 4, 24
     stdcall PeekCard, Deck, 0
     mov [Trump], eax
     ret
endp

;-----------------------------SwapCards------------------------------------

proc SwapCards uses esi edx edi ebx ecx, Cards: DWORD, Index1: Word
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

;----------------------------PutCards-----------------------------------------

proc PutCards uses esi edi ecx eax, Src: DWORD, Dest: DWORD, Amount: DWORD
     mov esi, [Src]
     mov edi, [Dest]
     mov ecx, [Amount]
@@:
     movsd
     dec cx
     cmp cx, 0
     jne @b
     ret
endp
