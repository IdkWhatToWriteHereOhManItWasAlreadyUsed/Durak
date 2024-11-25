
proc IsClickInRect uses ebx edx, x: dword, y: dword
      xor eax, eax
      mov ebx, [x]     
      .if (ebx < [Event.button.x])
            add ebx, CARD_W
            .if (ebx > [Event.button.x])
                  jmp @f
            .endif
      .endif
      jmp exit
@@:
      mov ebx, [y]
      .if (ebx < [Event.button.y])
            add ebx, CARD_H
            .if (ebx > [Event.button.y])
                  mov eax, 1
            .endif
      .endif
exit:
      ret
endp

proc GetSelectedCard uses esi edi ecx, Player.Cards: DWORD
    
      mov esi, [Player.Cards]
      mov al, 4*9 ; одна страница это 9 карт или 36 байт
      mul byte [CurrCardsPage]
      movzx ebx, ax
      mov ecx, DISTANCE_BETWEEN_CARDS
      xor eax, eax
      .while (DWORD [esi+ebx] <> 0)
            movzx edi, word [esi + ebx] 
            shl edi, 16
            mov di, word [esi + ebx + 2] 
            ;  сравнение координат
            stdcall IsClickInRect, ecx, WINDOW_H - DISTANCE_BETWEEN_CARDS - CARD_H
            .if (eax = 1)
                  mov eax, edi
                  jmp @f
            .endif
            add ecx, DISTANCE_BETWEEN_CARDS + CARD_W
            add ebx, 4

            .if (ecx > WINDOW_W - DISTANCE_BETWEEN_CARDS - CARD_W)
            jmp @f
            .endif

      .endw
@@:
    ret
endp

proc GetSelectedGameStack uses esi
      mov esi, [PlayedCard1]
    
      ret
endp  


; Event.Button.x Event.Button.y
; click is saved in event struct

proc MouseButtonUpHandle
      mov ax, [CurrPlayerAttacker]
      .if ([CurrPlayerMove] = ax)
            stdcall HandleAttack
            jmp @f
      .endif
      stdcall HandleDefence
@@:
      ret
endp