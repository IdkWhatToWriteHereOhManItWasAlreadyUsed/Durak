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

;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////
;//////                                                        //////
;//////   Proc for giving and taking away cards during game    //////
;//////                                                        //////
;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////

proc GiveCard uses edi ebx, PlayerCards: DWORD, Card: DWORD
     mov edi, [PlayerCards]
     mov eax, [Card]
     xor ebx, ebx
     .while (Dword[edi + ebx] = 0)
          add ebx, 4
     .endw
     mov Dword[edi + ebx], eax
     ret
endp

proc TakeCard uses esi ebx ecx, PlayerCards: DWORD, Card: DWORD
     mov esi, [PlayerCards]
     mov eax, [Card]
     xor ebx, ebx
     .while (Dword[esi + ebx] <> eax)
          add ebx, 4
     .endw
     .while (Dword[esi + ebx] <> 0)
          mov eax, Dword [esi + ebx + 4] 
          mov Dword[esi + ebx], eax
          add ebx, 4
     .endw
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
     mov ebx, eax
     shr ebx, 16
     shl eax, 16
     mov ax, bx
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
    mov eax, [Target]
    shr eax, 16
    .if (ax = word[Attacker + 2])
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

proc CanPush uses ecx esi ebx, Card: DWORD
     mov ecx, [Card]

     mov esi, GameStack1 
     mov ebx, [esi]
     cmp ebx, 4
     je HasEmptyStackOrCanPush
     shr ebx, 2 
     dec ebx 
     .while(ebx <> 0)
          dec ebx
          stdcall PeekCard, esi, ebx
          push ebx
          mov ebx, eax
          shl eax, 16
          shr ebx, 16
          mov ax, bx
          pop ebx
          .if(cx = ax)
               jmp HasEmptyStackOrCanPush
          .endif    
     .endw

     mov esi, GameStack2 
     mov ebx, [esi]
     shr ebx, 2
     cmp ebx, 1
     je @f
     dec ebx

     .while(ebx <> 0)
          dec ebx
          stdcall PeekCard, esi, ebx
          push ebx
          mov ebx, eax
          shl eax, 16
          shr ebx, 16
          mov ax, bx
          pop ebx
         .if(cx = ax)
               jmp HasEmptyStackOrCanPush
          .endif    
     .endw
@@:
     mov esi, GameStack3 
     mov ebx, [esi]
     shr ebx, 2
     cmp ebx, 1
     je @f
     dec ebx

     .while(ebx <> 0)
          dec ebx
          stdcall PeekCard, esi, ebx
          push ebx
          mov ebx, eax
          shl eax, 16
          shr ebx, 16
          mov ax, bx
          pop ebx
          .if(cx = ax)
               jmp HasEmptyStackOrCanPush
          .endif      
     .endw
@@:
     mov esi, GameStack4 
     mov ebx, [esi]
     shr ebx, 2
     cmp ebx, 1
     je @f
     dec ebx

     .while(ebx <> 0)
          dec ebx
          stdcall PeekCard, esi, ebx
          push ebx
          mov ebx, eax
          shl eax, 16
          shr ebx, 16
          mov ax, bx
          pop ebx
          .if(cx = ax)
               jmp HasEmptyStackOrCanPush
          .endif   
     .endw
@@:
     xor eax, eax
     jmp ex
HasEmptyStackOrCanPush:
     mov eax, 1
ex:
     ret
endp

proc CheckAndPush uses esi edi, GameStackAddress: DWORD, PlayerCards: DWORD
; returns 0 in eax if not pushed. 1 if pushed
local Card: DWORD
     mov esi, [GameStackAddress]
     mov edi, [PlayerCards]
     mov eax, [esi]
     shr eax, 2
     dec eax
     test eax, 1h
     jnz @f

     stdcall GetSelectedCard, edi
     cmp eax, 0
     je @f
     
     mov DWORD [Card], eax

     stdcall CanPush, eax  
     cmp eax, 0
     je @f

     mov ebx,  DWORD [Card]
     mov eax,  DWORD [Card]
     stdcall SwapKostyl
     stdcall PushCard, esi, eax
     stdcall TakeCard, DWORD [PlayerCards], eax
     mov eax, 1 
     ret
     ; ай ай ай неструктурное программирование
@@:
     xor eax, eax
     ret
endp

proc SwitchMove uses eax ebx
     stdcall IsClickedMoveTransferButton
     .if (eax)
          mov ax, [CurrPlayerMove]
          mov bx, [CurrPlayerAttacker]
          .if (ax = bx)
               .if (word [CurrPlayerMove] = 1)
                    mov word [CurrPlayerMove], 2
                    jmp @f
               .endif
               mov word [CurrPlayerMove], 1
               @@:
          .endif

          .if (ax <> bx)
               mov ax, word [CurrPlayerMove]
               mov [CurrPlayerAttacker], ax
          .endif
          @@:
     .endif

     stdcall IsClickedGrabButton
     .if (eax)
          .if (word [CurrPlayerMove] = 1)
               mov word [CurrPlayerMove], 2
               jmp @f
          .endif
          mov word [CurrPlayerMove], 1
          @@:
     .endif
@@:
     ret
endp

proc HandleAttack
     mov byte [IsShownGrabButton], 0 
     mov byte [IsShownOtboyButton], 0 
     .if (Dword [GameStack1] > 8)
          mov byte [IsShownOtboyButton], 1 
     .endif
     .if ([CurrPlayerMove] = 1) 
          mov esi, Player1Cards
          jmp @f
     .endif
     mov esi, Player2Cards

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

     .if (eax <> 0)
          mov byte [IsShownMoveTransferButton], 1
     .endif

     stdcall SwitchMove

     stdcall IsClickedOtboyButton
     .if (eax)
          mov ax, [CurrPlayerAttacker]
          .if (ax = 1)
               mov word [CurrPlayerMove], 2
               jmp @f
          .endif
          mov word [CurrPlayerMove], 1
          jmp @f
     .endif
@@:
     ret
endp

proc AllCardsBeaten uses esi ecx
     mov esi, GameStack1
     mov eax, 1
@@:
     mov ecx, 4
     .if (dword[esi] = 4)
          jmp @f
     .endif
     .if (dword[esi] <> 12)
          xor eax, eax
          jmp @f
     .endif
     dec ecx
     add esi, 29*4
     cmp ecx, 0
     jne @b
@@:
     ret
endp

proc GiveCardsAfterDefense, PlayerCards: DWORD
     stdcall GetPlayerCardsAmount, PlayerCards
     .if (eax < 6)
          ;while (eax >)
          .endw
     .endif   
     ret
endp

proc SwapKostyl uses ebx 
     mov ebx, eax
     shr ebx, 16
     shl eax, 16
     mov ax, bx
     ret
endp

proc HandleDefence uses esi ebx
     mov word [IsShownMoveTransferButton], 0
     mov byte [IsShownGrabButton], 1
     .if ([CurrPlayerMove] = 1) 
          mov esi, Player1Cards
          jmp @f
     .endif

     mov esi, Player2Cards
@@:
     stdcall AllCardsBeaten
     .if (eax)
          mov word [IsShownMoveTransferButton], 1
          mov word [SelectingAttacker], 1
          jmp canAttack
     .endif

     stdcall GetSelectedCard, esi
     .if (eax)
          .if (word [SelectingAttacker] = 0)
               jmp @f
          .endif
     .endif

     .if (eax = 0)
          mov word [IsShownSelection], 0     
     .endif

     .if (word [IsShownMoveTransferButton] = 0)   
          .if (word [SelectingAttacker] = 1)
               stdcall GetSelectedCard, esi 
               .if (eax)
                    @@:
                    ; drawSelection потом
                    mov word [IsShownSelection], 1
                    mov DWORD [SelectedCard], eax
                    mov word [SelectingAttacker], 0
                    jmp @f
               .endif
          .endif

          stdcall GetSelectedGameStack
          .if (eax)
               mov ebx, eax
               stdcall PeekTopCard, eax
               push ebx
               stdcall SwapKostyl
               stdcall CanBeat, dword [SelectedCard],  eax
               .if (eax)
                    mov eax, dword [SelectedCard]
                    stdcall SwapKostyl
                    stdcall TakeCard, esi, eax
                    mov eax, dword [SelectedCard]
                    stdcall SwapKostyl
                    pop ebx
                    stdcall PushCard, ebx, eax
                    stdcall AllCardsBeaten
                    .if (eax)
                         mov word [IsShownMoveTransferButton], 1
                    .endif
                    mov word [SelectingAttacker], 1
                    mov word [IsShownSelection], 0
                    jmp @f
               .endif
               mov word [SelectingAttacker], 1
               pop ebx
          .endif
     .endif

canAttack:

     stdcall SwitchMove
     stdcall IsClickedMoveTransferButton
     .if (eax)
          stdcall ClearStack, GameStack1
          stdcall ClearStack, GameStack2
          stdcall ClearStack, GameStack3
          stdcall ClearStack, GameStack4
          mov word [IsShownSelection], 0
          mov word [IsShownMoveTransferButton], 0
          jmp @f
     .endif

@@:    
     ret
endp




























