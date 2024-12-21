
proc IsClickInRect uses ebx edx, x: dword, y: dword
      xor eax, eax
      mov ebx, [x]     
      .if (ebx < [Event.button.x])
            add ebx, CARD_W
            .if (ebx > [Event.button.x])
                  jmp @f
            .endif
      .endif
      jmp ext
@@:
      mov ebx, [y]
      .if (ebx < [Event.button.y])
            add ebx, CARD_H
            .if (ebx > [Event.button.y])
                  mov eax, 1
            .endif
      .endif
ext:
      ret
endp

proc GetSelectedCard uses esi edi ecx ebx, Player.Cards: DWORD   
      ; загружаем в esi адрес массива карт игрока
      mov esi, [Player.Cards]
      ; загружаем в al размер одной страницы капт
      mov al, 4*9 ; одна страница это 9 карт или 36 байт
      ; умножаем значение al на номер текущей страницы
      ; получаем смещение текущей страницы карт от начала массива
      mul byte [CurrCardsPage]
      movzx ebx, ax
      ; загружаем в ecx вертикальную координату первой карты
      mov ecx, DISTANCE_BETWEEN_CARDS
      ; обнуляем eax
      xor eax, eax
      ; проходим по массивку карт
      .while (DWORD [esi+ebx] <> 0)
            ; загружаем в edi карту 
            movzx edi, word [esi + ebx] 
            shl edi, 16
            mov di, word [esi + ebx + 2] 
            ; проверяем, нажал ли игрок на карту с текущей координатой
            stdcall IsClickInRect, ecx, WINDOW_H - DISTANCE_BETWEEN_CARDS - CARD_H
            ; если нажал на карту с текущей координатой
            .if (eax = 1)
                  ; возвращаем код карты в eax
                  mov eax, edi
                  ; выходим из функции
                  jmp @f
            .endif
            ; увеличиваем координату до координаты следующей карты
            add ecx, DISTANCE_BETWEEN_CARDS + CARD_W
            ; увеличиваем значение адреса, по которому будет читаться карта
            add ebx, 4
            ; если вышли за границы экрана
            ; это произойдет в случае, если за текущей страницей еще есть картф
            .if (ecx > WINDOW_W - DISTANCE_BETWEEN_CARDS - CARD_W)
                  ; выходим из функции
                  ; возвращаем 0, который уже был задан в eax
                  jmp @f
            .endif

      .endw
@@:
    ret
endp

proc IsClickedMoveTransferButton uses ebx
      xor eax, eax
      mov ebx, [Event.button.y]
      .if (ebx > [MoveTransferButtonRect.y])
            sub ebx, 40
            .if (ebx < [MoveTransferButtonRect.y])
                  mov ebx, [Event.button.x]
                  .if (ebx > [MoveTransferButtonRect.x])
                        sub ebx, 120
                        .if (ebx < [MoveTransferButtonRect.x])
                              .if (word[IsShownMoveTransferButton] = 1)
                                    mov eax, 1
                                    jmp @f
                              .endif
                        .endif
                  .endif
            .endif
      .endif
@@:
      ret
endp

proc IsClickedGrabButton uses ebx
      xor eax, eax
      mov ebx, [Event.button.y]
      .if (ebx > [GrabButtonRect.y])
            sub ebx, 40
            .if (ebx < [GrabButtonRect.y])
                  mov ebx, [Event.button.x]
                  .if (ebx > [GrabButtonRect.x])
                        sub ebx, 120
                        .if (ebx < [GrabButtonRect.x])
                              .if (word[IsShownGrabButton] = 1)
                                    mov eax, 1
                                    jmp @f
                              .endif
                        .endif
                  .endif
            .endif
      .endif
@@:
      ret
endp

proc IsClickedOtboyButton uses ebx
      xor eax, eax
      mov ebx, [Event.button.y]
      .if (ebx > [OtboyButtonRect.y])
            sub ebx, 40
            .if (ebx < [MoveTransferButtonRect.y])
                  mov ebx, [Event.button.x]
                  .if (ebx > [MoveTransferButtonRect.x])
                        sub ebx, 120
                        .if (ebx < [MoveTransferButtonRect.x])
                              .if (word[IsShownMoveTransferButton] = 1)
                                    mov eax, 1
                                    jmp @f
                              .endif
                        .endif
                  .endif
            .endif
      .endif
@@:
      ret
endp

proc GetSelectedGameStack uses esi ecx
local count dd 0  
      mov esi, GameStack1
      mov ecx,  400 - CARD_W - CARD_W - DISTANCE_BETWEEN_CARDS
@@:
      stdcall IsClickInRect, ecx, GAME_CARDS_Y
      .if (eax)
            mov eax, esi
           jmp @f
      .endif
      add ecx, DISTANCE_BETWEEN_CARDS + CARD_W
      add esi, 29*4
      inc dword [count]
      cmp dword [count], 4
      jne @b 
      xor eax, eax
@@:
      .if (Word [IsShownMoveTransferButton] = 1)
            .if (Word [IsShownSelection] = 1)
                  xor eax, eax
            .endif
      .endif
      ret
endp  

; Event.Button.x Event.Button.y
; click is saved in event struct

proc MouseButtonUpHandle uses
      .if (word [IsShownScreenBetweenMoves] = 1)
            mov word [IsShownScreenBetweenMoves], 0
            jmp @f
      .endif
      mov ax, [CurrPlayerAttacker]
      .if ([CurrPlayerMove] = ax)
            stdcall HandleAttack
            jmp @f
      .endif
      stdcall HandleDefence
@@:
      ret
endp

proc KeyUpHandle
      .if(dword [Event.key.keysym.sym] = SDLK_RIGHT)
            stdcall IncCardsPage
            jmp @f
      .endif
       .if(dword [Event.key.keysym.sym] = SDLK_LEFT)
            stdcall DecCardsPage
            jmp @f
      .endif
@@:
      ret
endp