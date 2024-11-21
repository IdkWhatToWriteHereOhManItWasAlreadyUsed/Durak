
proc IsClickInRect uses ebx edx, x: dword, y: dword
      xor eax, eax
      mov ebx, [x]     
      .if (ebx < Event.Button.x)
            add ebx, CARD_W
            .if (ebx > Event.Button.x)
                  jmp @f
            .endif
      .endif
      jmp exit
@@:
      mov ebx, [y]
      .if (ebx < Event.Button.y)
            add ebx, CARD_H
            .if (ebx > Event.Button.y)
                  mov eax, 1
            .endif
      .endif
exit:
      ret
endp

proc GetSelectedCard uses esi edi ecx, x: dword, y: dword
      xor eax, eax
      mov esi, [Player.Cards]
      mov cl, 4*9 ; одна страница это 9 карт или 36 байт
      mul byte [CurrCardsPage]
      movzx ebx, cx
      mov ecx, DISTANCE_BETWEEN_CARDS

      .while (DWORD [esi+ebx] <> 0)

            movzx edi, word [esi + ebx] ; карта
            ;  сравнение координат
            stdcall IsClickInRect, ecx, WINDOW_H - DISTANCE_BETWEEN_CARDS - CARD_H
            .if (eax = 1)
                  mov eax, edi
                  jmp exitDrawLoop
            .endif
            add ecx, DISTANCE_BETWEEN_CARDS + CARD_W
            add ebx, 4

            .if (ecx > WINDOW_W - DISTANCE_BETWEEN_CARDS - CARD_W)
            jmp exitDrawLoop
            .endif

      .endw
exitDrawLoop:
    ret
endp

proc HandleAttack

      ret
endp

proc HandleDefence

      ret
endp

; Event.Button.x Event.Button.y

proc MouseButtonUpHandle

      .if ([CurrPlayerMove] = ax)
            stdcall HandleAttack
      .endif
      stdcall HandleDefence
exit:
      ret
endp