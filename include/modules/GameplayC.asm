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
     stdcall PutCards, AllCards, Player1.Cards, 6
     stdcall PutCards, AllCards + 24, Player2.Cards, 6
     stdcall PutCards, AllCards + 48, Deck + 4, 24
     
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

;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////
;/////////                                                 //////////
;/////////             Common Stack procedures             //////////
;/////////                                                 //////////
;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////

;--------------------------PushCard------------------------------------------

proc PushCard uses edi ebx ecx, Stack: DWORD, card: DWORD
     mov edi, [Stack]
     mov ebx, [edi]
     mov ecx, [card]
     mov [edi + ebx], ecx
     add dword [edi], 4
     ret
endp

;----------------------------PopCard---------------------------------------

proc PopCard uses esi ebx, Stack: DWORD
     mov esi, [Stack]
     mov ebx, [esi]
     cmp ebx, 4
     je @f
     mov eax, [esi + ebx]
     mov dword[esi + ebx], 0
     sub dword [esi], 4
@@:
     ret
endp

;----------------------------PeekCard---------------------------------------
; на вход принимает адрес стека и номер карты в стеке относительно его дна (нумерация с 0)
proc PeekCard uses esi ebx, Stack: DWORD, pos: DWORD
     mov esi, [Stack]
     mov ebx, [pos]
     shl ebx, 2
     mov eax, [esi + ebx + 4]
     ret
endp

;---------------------------ClearStack--------------------------------------

proc ClearStack uses esi ecx ebx, Stack: DWORD
     mov esi, [Stack]
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

;------------------------GetStackSize----------------------------------------

proc GetStackSize, Stack: DWORD
     mov eax, [Stack]
     mov eax, [eax]
     sub eax, 4
     ret
endp

;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////
;/////////                                                 //////////
;/////////             Bla bla bla bla bla bla             //////////
;/////////                                                 //////////
;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////
























