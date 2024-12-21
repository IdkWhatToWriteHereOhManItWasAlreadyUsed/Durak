
;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////
;/////////                                                 //////////
;/////////             Common Stack procedures             //////////
;/////////                                                 //////////
;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////

;--------------------------PushCard------------------------------------------

proc PushCard uses edi ebx ecx, Stack: DWORD, card: DWORD
     ; загружаем в регистр edi адрес стека, в который хотим положить карту
     mov edi, [Stack]
     ; загружаем в регистр ebx смещение вершины стека относительно его дна в байтах
     mov ebx, [edi]
     ; промежуточно загружаем карту в ecx
     mov ecx, [card]
     ; загружаем карту на вершину стека
     mov [edi + ebx], ecx
     ; увеличиваем значение смещения вершины стека
     add dword [edi], 4
     ret
endp

;----------------------------PopCard---------------------------------------

proc PopCard uses esi ebx, Stack: DWORD
     mov esi, [Stack]
     mov ebx, [esi]
     cmp ebx, 4
     je @f
     sub ebx, 4
     mov eax, [esi + ebx]
     mov dword[esi + ebx], 0
     sub dword [esi], 4
@@:
     ret
endp

;----------------------------PeekCard---------------------------------------
; на вход принимает адрес стека и номер карты в стеке относительно его дна (нумерация с 0)
proc PeekCard uses esi ecx ebx, Stack: DWORD, pos: DWORD
     mov esi, [Stack]
     mov ebx, [pos]
     shl ebx, 2
     mov eax, [esi + ebx + 4]
     ret
endp

;----------------------------PeekTopCard---------------------------------------

proc PeekTopCard uses esi ebx, Stack: DWORD
     mov esi, [Stack]
     mov ebx,DWORD [esi]
     sub ebx, 8
     shr ebx, 2
     stdcall PeekCard, esi, ebx
     ret
endp
;---------------------------ClearStack--------------------------------------

proc ClearStack uses esi ecx ebx, Stack: DWORD
     mov esi, [Stack]
     mov ecx, [esi]
     xor ebx, ebx
@@:
     mov dword[esi + ebx], 0
     add ebx, 4
     cmp ebx, ecx
     jne @b
     mov dword[esi], 4
     ret
endp