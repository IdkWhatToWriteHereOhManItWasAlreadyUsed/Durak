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

;----------------------------PeekTopCard---------------------------------------

proc PeekTopCard uses esi ebx, Stack: DWORD
     mov esi, [Stack]
     mov ebx,DWORD [esi]
     sub ebx, 8
     shr ebx, 2
     stdcall PeekCard, esi, ebx
     ret
endp
;---------------------------clearStack--------------------------------------

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

;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////
;/////////                                                 //////////
;/////////               Other game procedures             //////////
;/////////                                                 //////////
;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////

proc CanBeat uses ebx ecx, Attacker: DWORD, Target: DWORD
     mov eax, [Trump]
     mov ebx, [Attacker]
     mov ecx, [Target]
     .if (word[Attacker] = ax)
          .if (word[Target] = ax)
               .if (bx > cx)
                    mov eax, 1
                    jmp exit
               .endif
               mov eax, 0
               jmp exit
          .endif
          mov eax, 0
          jmp exit
    .endif
    mov eax, word[Target]
    .if (ax = word[Attacker])
          .if (bx > cx)
               mov eax, 1
               jmp exit
          .endif
          mov eax, 0
    .endif
     mov eax, 0
exit:
     ret
endp

proc GetPlayerCardsAmount uses ecx esi, Player: DWORD
     xor eax, eax
     mov ecx, 35
     mov esi, [Player]
@@:
     shl ecx, 2
     .if (DWORD [esi + ecx] <> 0) 
          inc eax 
     .endif
     shr ecx, 2
     dec ecx
     cmp ecx, 0
     jne @b
     ret
endp

proc CanPush uses ebx esi, Card: DWORD
     ret
endp

proc CheckAndPush uses esi edi, GameStackAddress: DWORD, Player.Cards: DWORD
; returns 0 in eax if not pushed. 1 if pushed
     mov esi, [GameStackAddress]
     mov edi, [Player.Cards]
     mov eax, [esi]
     shr eax, 2
     test eax, 1h
     jz @f

     stdcall GetSelectedCard, edi
     cmp eax, 0
     je @f

     stdcall CanPush, eax  
     cmp eax, 0
     je @f

     mov bx, ax
     shr eax, 16
     stdcall PushCard, esi, ax, bx 
     mov eax, 1 
@@:
     ret
endp

proc HandleAttack
     .if ([CurrPlayerMove] = 1) 
          mov esi, Player1.Cards
          jmp @f
     .endif
     mov esi, Player2.Cards
@@:
     stdcall CheckAndPush, GameStack1, esi
     .if (eax = 0)
          stdcall CheckAndPush, GameStack2, esi         
     .endif
     .if (eax = 0)
          stdcall CheckAndPush, GameStack3, esi         
     .endif
     .if (eax = 0)
          stdcall CheckAndPush, GameStack4, esi         
     .endif
   
    ; mov eax, [GameStack1]
    ; shr eax, 2
    ; test eax, 1h
   ;  jnz @f
    ; stdcall GetSelectedCard, esi, edi
    ; cmp eax, 0
    ; je @f
   ;  mov bx, ax
   ;  shr eax, 16
    ; stdcall PushCard, GameStack1, ax, bx
    ; jmp @f   
   ; @@:



     ret
endp

proc HandleDefence
     
     ret
endp




























