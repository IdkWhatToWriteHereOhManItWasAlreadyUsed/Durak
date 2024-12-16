

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
     inc eax
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

proc PopCardToPlayer, PlayerCards: DWORD
; returns card code if pushed, 0 if not pushed
     stdcall GetPlayerCardsAmount, [PlayerCards]
     .if (eax < 6)  
          ; for debug
          .if (dword[Deck] < 8)
               nop
          .endif
          stdcall PopCard, Deck
          stdcall GiveCard, [PlayerCards], eax
          mov eax, 1
          jmp @f
     .endif
     xor eax, eax
@@:
     ret
endp

proc GiveCardsAfterDefense
     .while(1)
          .if (DWORD [Deck] = 4)
               jmp @f
          .endif
          stdcall PopCardToPlayer, Player1Cards
          .if (DWORD [Deck] = 4)
               jmp @f
          .endif
          stdcall PopCardToPlayer, Player2Cards
          .if (eax = 0)
               jmp @f
          .endif
     .endw

@@:
     ret
endp

proc SwapKostyl uses ebx
     mov ebx, eax
     shr ebx, 16
     shl eax, 16
     mov ax, bx
     ret
endp

proc GrabCardsFromStack uses ebx edi esi, GameStack: DWORD, PlayerCards: DWORD
     mov esi, [GameStack]
     mov edi, [PlayerCards]
     .while (dword [esi] <> 4)
          stdcall PopCard, esi
          stdcall GiveCard, edi, eax
     .endw
     ret
endp

proc CheckAndPush uses esi edi, GameStackAddress: DWORD, PlayerCards: DWORD
; returns 0 in eax if not pushed. 1 if pushed
local Card: DWORD
     mov esi, [GameStackAddress]
     mov edi, [PlayerCards]
     mov eax, [esi]
     cmp eax, 4
     jne @f

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
          mov ax, [CurrPlayerMove]
          mov [CurrPlayerAttacker], ax
          mov word [IsShownGrabButton], 0
     .endif
@@:
     stdcall GiveCardsAfterDefense
     mov dword [IsShownScreenBetweenMoves], 1
     mov word [CurrCardsPage], 0
     ret
endp

proc HandleAttack
     stdcall SetPlayerCards
     mov byte [IsShownGrabButton], 0    
     stdcall IsClickedMoveTransferButton
     .if (eax)
          stdcall SwitchMove
          mov word [IsShownMoveTransferButton], 0
          mov word [IsShownGrabButton], 1
          jmp @f
     .endif

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

proc GetClickCode uses ebx     
     stdcall GetSelectedCard, esi
     .if (eax)
          mov ebx, 1
          jmp @f
     .endif

     stdcall GetSelectedGameStack
     .if (eax)
          mov ebx, 2
          jmp @f
     .endif

     stdcall IsClickedMoveTransferButton
     .if (eax)
          mov ebx, 3
          jmp @f
     .endif

     stdcall IsClickedGrabButton
     .if (eax)
          mov ebx, 4
          jmp @f
     .endif

     .if (ebx <> 3)
          .if (word [IsShownMoveTransferButton] = 1)
               xor ebx, ebx
          .endif
     .endif

     mov word [IsShownSelection], 0
     mov word [SelectingAttacker], 1
     xor ebx, ebx
@@:
     mov eax, ebx
     ret
endp

proc SetPlayerCards
; returns address of cards of current player to  esi
     .if ([CurrPlayerMove] = 1) 
          mov esi, Player1Cards
          jmp @f
     .endif

     mov esi, Player2Cards
@@:
     ret
endp

;ClickCode
; 0 - nothing
; 1 - selectedCard
; 2 - Attack
; 3 - moveTransfer
; 4 - Grab

proc CardChoosing
     mov word [SelectingAttacker], 1
     .if (word [IsShownMoveTransferButton] = 1)
          jmp @f
     .endif
     stdcall GetSelectedCard, esi 
     .if (eax)
          mov word [IsShownSelection], 1
          mov DWORD [SelectedCard], eax
          mov word [SelectingAttacker], 0
     .endif
@@:
     ret
endp

proc Attacking uses ebx
local SelectedStack dd ?
     .if (word [IsShownMoveTransferButton] = 1)
          jmp @f
     .endif
     .if (word [SelectingAttacker] = 1)
          jmp @f
     .endif
     stdcall GetSelectedGameStack
     .if (eax)
          mov [SelectedStack], eax
          .if (dword[eax] <> 8)
               mov word [IsShownSelection], 0
               mov word [SelectingAttacker], 1
               jmp @f
          .endif
         
          stdcall PeekTopCard, eax   
          stdcall SwapKostyl
          stdcall CanBeat, dword [SelectedCard],  eax
          .if (eax)
               mov eax, dword [SelectedCard]
               stdcall SwapKostyl
               stdcall TakeCard, esi, eax
               mov eax, dword [SelectedCard]
               stdcall SwapKostyl
               stdcall PushCard, dword [SelectedStack], eax

               stdcall AllCardsBeaten
               .if (eax)
                    mov word [IsShownMoveTransferButton], 1
                    mov word [IsShownGrabButton], 0     
                    mov word [IsShownSelection], 0
               .endif
          .endif  
          mov word [IsShownSelection], 0  
     .endif
     mov word [SelectingAttacker], 1
@@:
     ret
endp

proc TransferingMove
     stdcall SwitchMove
     stdcall ClearStack, GameStack1
     stdcall ClearStack, GameStack2
     stdcall ClearStack, GameStack3
     stdcall ClearStack, GameStack4
     mov word [IsShownSelection], 0
     mov byte [IsOtboyEmpty], 0
     mov word [IsShownMoveTransferButton], 0
     mov word [IsShownGrabButton], 0
     ret
endp

proc Grabbing
     mov edi, GameStack1
     .while (edi <> GameStack4 + 29*4)
          stdcall GrabCardsFromStack, edi, esi
          add edi, 29*4
     .endw
     stdcall SwitchMove
     mov word [IsShownMoveTransferButton], 0
     mov word [IsShownSelection], 0
     mov word [IsShownGrabButton], 0 
     mov word [SelectingAttacker], 1
     ret
endp

proc HandleDefence uses esi ebx
     stdcall SetPlayerCards
     stdcall GetClickCode

     .if (eax = 0)
          mov word [IsShownSelection], 0
          mov word [SelectingAttacker], 1
          jmp HandleDefenceExit
     .endif

     push eax
     .if (eax = 1)
          stdcall  CardChoosing       
     .endif
     pop eax

     push eax
     .if (eax = 2)
          stdcall Attacking       
     .endif
     pop eax

     push eax
     .if (eax = 3)
          stdcall TransferingMove  
     .endif
     pop eax
     
     push eax
     .if (eax = 4)
          stdcall Grabbing 
     .endif
     pop eax
HandleDefenceExit:
     ret
endp

proc IncCardsPage uses esi bx
     mov word [IsShownSelection], 0
     stdcall SetPlayerCards
     stdcall GetPlayerCardsAmount, esi
     mov bx, 9
     div bl
     ; удаляем остаток деления
     xor ah, ah
     .if (ax > word [CurrCardsPage])
          inc word [CurrCardsPage]
     .endif
     ret
endp

proc DecCardsPage uses esi bx
     mov word [IsShownSelection], 0
     .if (word [CurrCardsPage])
          dec word [CurrCardsPage]
     .endif
     ret
endp




























