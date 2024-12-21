

;  Карты

    ;1 бубны
    ;2 пики
    ;З чирвы
    ;4 кресте
    ; коды карт: 6 7 8 ... 14 (по силе)

;

;----------------------------------Init----------------------------------------------

proc Init usesdef

    cinvoke SDL_Init, SDL_INIT_EVERYTHING
    .if (eax = -1)
        ret
    .endif

    cinvoke IMG_Init
    cinvoke TTF_Init
    .if (eax = -1)
        ret
    .endif

    cinvoke SDL_CreateWindow, WINDOW_TITLE, WINDOW_X, WINDOW_Y, WINDOW_W, WINDOW_H, WINDOW_FLAGS
    mov [Window], eax
    .if (eax = 0)
        ret
    .endif

    cinvoke SDL_CreateRenderer, [Window], -1, RENDERER_FLAGS
    mov [Renderer], eax
    .if (eax = 0)
        ret
    .endif


    cinvoke SDL_SetRenderDrawColor, [Renderer], 12, 93, 27, 1
    stdcall InitImages
    stdcall InitRects
    stdcall InitFont
    mov [WasLaunched], 1
    ret
endp

;---------------------------------InitFont-----------------------------------------------------------

proc InitFont
    mov [FontColor.r], 255
    mov [FontColor.g], 255
    mov [FontColor.b], 255
    mov [FontColor.a], 1

    mov [PlayerAttackMsgSign.rect.x], 120
    mov [PlayerAttackMsgSign.rect.y], 250

    mov [PlayerDefenceMsgSign.rect.x], 85
    mov [PlayerDefenceMsgSign.rect.y], 250

    mov [VictoryMsgSign.rect.x], 140
    mov [VictoryMsgSign.rect.y], 250

    stdcall CreateNVSign, PlayerAttackMsgSign, PlayerAttackMsg, FontPath, MsgFontSize, dword [FontColor]
    stdcall RenderNVSign, PlayerAttackMsgSign

    stdcall CreateNVSign, PlayerDefenceMsgSign, PlayerDefenceMsg, FontPath, MsgFontSize, dword [FontColor]
    stdcall RenderNVSign, PlayerDefenceMsgSign

    stdcall CreateNVSign, VictoryMsgSign, VictoryMsg, FontPath, MsgFontSize, dword [FontColor]
    stdcall RenderNVSign, VictoryMsgSign
    ret
endp

;--------------------------------InitImages-----------------------------------------------------

proc InitImages

    cinvoke IMG_LoadTexture, [Renderer], CardsPath
    mov [CardsTexture], eax

    cinvoke IMG_LoadTexture, [Renderer], SelectionPath
    mov [SelectionTexture], eax

    cinvoke IMG_LoadTexture, [Renderer], BackPath
    mov [BackTexture], eax

    cinvoke IMG_LoadTexture, [Renderer], MoveTransferButtonPath
    mov [MoveTransferButtonTexture], eax

    cinvoke IMG_LoadTexture, [Renderer], GrabButtonPath
    mov [GrabButtonTexture], eax
    ret
endp

;--------------------------------InitRect------------------------------------------------------------

proc InitRect uses ebx, Rect: DWORD, x: dword , y: dword, w: dword, h: dword
    mov eax, [Rect]
    mov ebx, [x]
    mov [eax], ebx
    mov ebx, [y]
    mov [eax+4], ebx
    mov ebx, [w]
    mov [eax+8], ebx
    mov ebx, [h]
    mov [eax+12], ebx
    ret
endp

;---------------------------------InitRectS-----------------------------------------------------------

proc InitRects usesdef
    stdcall InitRect, DeckRect, 800 - DISTANCE_BETWEEN_CARDS - CARD_H, GAME_CARDS_Y -2 * DISTANCE_BETWEEN_CARDS, CARD_W, CARD_H
    stdcall InitRect, PlayerCardRect, DISTANCE_BETWEEN_CARDS, 600 - DISTANCE_BETWEEN_CARDS - CARD_H, CARD_W, CARD_H
    stdcall InitRect, TrumpCardRect, 800 - DISTANCE_BETWEEN_CARDS - CARD_H, GAME_CARDS_Y, CARD_W, CARD_H

    stdcall InitRect, PlayedCard1, 400 - CARD_W - CARD_W - DISTANCE_BETWEEN_CARDS, GAME_CARDS_Y ,  CARD_W, CARD_H
    stdcall InitRect, PlayedCard2, 400 - CARD_W , GAME_CARDS_Y, CARD_W, CARD_H
    stdcall InitRect, PlayedCard3, 400 + DISTANCE_BETWEEN_CARDS, GAME_CARDS_Y, CARD_W, CARD_H
    stdcall InitRect, PlayedCard4, 400 + CARD_W + DISTANCE_BETWEEN_CARDS *2, GAME_CARDS_Y, CARD_W, CARD_H

    stdcall InitRect, OtboyRect, DISTANCE_BETWEEN_CARDS, GAME_CARDS_Y, CARD_W, CARD_H
    stdcall InitRect, EnemyCardRect, 0, 0, CARD_W, CARD_H
    stdcall InitRect, MoveTransferButtonRect, 300, 350, 200, 40
    stdcall InitRect, GrabButtonRect, 600, 350, 120, 40
    stdcall InitRect, OtboyButtonRect, DISTANCE_BETWEEN_CARDS, 350, 120, 40


    mov [CardRect.w], CARD_W
    mov [CardRect.h], CARD_H
    mov [SelectionRect.w], CARD_W + 20
    mov [SelectionRect.h], CARD_H + 20
    ret
endp

;----------------------------------DeInit-----------------------------------------------------

proc DeInit usesdef
    cinvoke SDL_DestroyRenderer, [Renderer]
    cinvoke SDL_DestroyWindow, [Window]
    cinvoke TTF_Quit
    cinvoke IMG_Quit
    cinvoke SDL_Quit
    ret
endp

;----------------------------------DrawCard----------------------------------------------

proc DrawCard uses ecx eax, x: DWORD, y: DWORD, CardType, CardNum
    ; преобразовывем масть и силу карты в номер строки и столбца на картинке со всеми картами
    sub [CardNum], 6
    dec [CardType]
    ; вычисляем горизонтальную координату прямоугольника на картинке со всеми картами
    mov ax, CARD_W
    mul [CardNum]   
    mov [CardRect.x], eax
    ; вычисляем вертикальную координату прямоугольника на картинке со всеми картами
    mov ax,  CARD_H
    mul [CardType]
    mov [CardRect.y], eax
    ; задаём координаты текущей карты на экране
    mov eax, [x]
    mov [PlayerCardRect.x], eax
    mov eax, [y]
    mov [PlayerCardRect.y], eax
    ; переносим карту на рендерер для того, чтобы она отобразилась на экране
    cinvoke SDL_RenderCopy, [Renderer], [CardsTexture], CardRect, PlayerCardRect

    ret
endp

;---------------------------------DrawEnemyCards-----------------------------------------------

proc DrawEnemyCards, Player.Cards: DWORD
    push ecx
    push ebx
    xor ecx, ecx
    xor ebx, ebx
    mov esi, [Player.Cards]
    .while (DWORD [esi+ebx] <> 0)
            inc ecx
            add ebx, 4
    .endw
    cmp ebx, 0
    je Exit
    mov [PlayerCardRect.x], DISTANCE_BETWEEN_CARDS
    mov [PlayerCardRect.y], DISTANCE_BETWEEN_CARDS
    mov [PlayerCardRect.h], CARD_H
    mov [PlayerCardRect.w], CARD_W

drawEnemyCardsLoop:
    push ecx
    cinvoke SDL_RenderCopy, [Renderer], [BackTexture], EnemyCardRect , PlayerCardRect

    pop ecx
    add [PlayerCardRect.x],  CARD_W / 4
    loop drawEnemyCardsLoop
Exit:
    mov [PlayerCardRect.h], CARD_H
    mov [PlayerCardRect.w], CARD_W
    pop ebx
    pop ecx

    ret
endp

;---------------------------------DrawOtboy---------------------------------------------------

proc DrawOtboy
    cmp byte [IsOtboyEmpty], 1
    je @f
   
   ; cinvoke SDL_RenderCopy, [Renderer], [BackTexture], 0, OtboyRect
@@:
    ret
endp

;---------------------------------DrawDeck-------------------------------------------------------

proc DrawDeck uses edx eax
    ; если первое двойное слово в колоде больше 4
    ; а значит, в колоде  есть карты
    .if (dword [Deck] > 4)
        ; находим самую нижнюю карту в колоде
        stdcall PeekCard, Deck, 0
        ; разбиваем полученный код карты на 2 двойных слова
        movzx edx, ax
        shr eax, 16
        ; выполняем отрисовку карты
        stdcall DrawCard, [TrumpCardRect.x], [TrumpCardRect.y],  edx, eax
    .endif
    ; если в колоде больше 1 карты
    .if (dword [Deck] > 8)
        ; рисуем рубашку
        cinvoke SDL_RenderCopy, [Renderer], [BackTexture], 0, DeckRect
    .endif
    ret
endp

;----------------------------------DrawSelection-----------------------------------------------------

proc DrawSelection uses ecx eax ebx
    ; если в данный момент нужно отобразить выделение
    .if (word [IsShownSelection] <> 0)
        ; получаем координаты, на которых нужно отобразить выделение
        stdcall GetSelectionCoords
        ; задаём координаты вы
        mov ecx, eax
        sub ecx, 10
        mov [SelectionRect.x], ecx
        mov ecx, ebx
        sub ecx, 10
        mov [SelectionRect.y], ecx
        cinvoke SDL_RenderCopy, [Renderer], [SelectionTexture], 0, SelectionRect
    .endif
    ret
endp

;----------------------------------GetSelectionCoords-----------------------------------------------------

proc GetSelectionCoords 
; returns x to eax, y to ebx
    mov ecx, DISTANCE_BETWEEN_CARDS
    .while (1)
        ;  сравнение координат
        stdcall IsClickInRect, ecx, WINDOW_H - DISTANCE_BETWEEN_CARDS - CARD_H
        .if (eax = 1)
            mov eax, ecx
            mov ebx, WINDOW_H - DISTANCE_BETWEEN_CARDS - CARD_H 
            jmp @f
        .endif
        add ecx, DISTANCE_BETWEEN_CARDS + CARD_W
        .if (ecx > 1000)
            mov eax, 1000
            mov ebx, 1000
            jmp @f
        .endif
    .endw
@@:
    ret
endp
;---------------------------------DrawPlayerCards-----------------------------------------------------

proc DrawPlayerCards uses esi eax ebx edi, PlayerCards: DWORD
    mov esi, [PlayerCards]
    mov al, 4*9 ; одна страница это 9 карт или 36 байт
    mul byte [CurrCardsPage]
    movzx ebx, ax
    mov eax, DISTANCE_BETWEEN_CARDS
 
    .while (DWORD [esi+ebx] <> 0)

        movzx edi, word [esi + ebx + 2]
        push edi
        movzx edi, word [esi + ebx]
        push edi
        stdcall DrawCard, eax, WINDOW_H - DISTANCE_BETWEEN_CARDS - CARD_H
        add eax, DISTANCE_BETWEEN_CARDS + CARD_W
        add ebx, 4

        .if (eax > WINDOW_W - DISTANCE_BETWEEN_CARDS - CARD_W)
            jmp exitDrawLoop
        .endif

    .endw
exitDrawLoop:
    ret
endp

;--------------------------------DrawPlayedCards-----------------------------------------------

proc DrawPlayedCards uses esi ebx

    mov esi, PlayedCard1
    stdcall PeekTopCard, GameStack1
    movzx ebx, ax
    shr eax, 16
    stdcall DrawCard,  dword [esi], dword [esi + 4], ebx, eax

    mov esi, PlayedCard2
    stdcall PeekTopCard, GameStack2
    movzx ebx, ax
    shr eax, 16
    stdcall DrawCard,  dword [esi], dword [esi + 4], ebx, eax

    mov esi, PlayedCard3
    stdcall PeekTopCard, GameStack3
    movzx ebx, ax
    shr eax, 16
    stdcall DrawCard,  dword [esi], dword [esi + 4], ebx, eax

    mov esi, PlayedCard4
    stdcall PeekTopCard, GameStack4
    movzx ebx, ax
    shr eax, 16
    stdcall DrawCard,  dword [esi], dword [esi + 4], ebx, eax
    ret
endp

;--------------------------------DrawButtons-----------------------------------------------

proc DrawButtons
    .if (word [IsShownMoveTransferButton] <> 0)
        cinvoke SDL_RenderCopy, [Renderer], [MoveTransferButtonTexture], 0, MoveTransferButtonRect
    .endif

    .if (word [IsShownGrabButton] <> 0)
        cinvoke SDL_RenderCopy, [Renderer], [GrabButtonTexture], 0, GrabButtonRect
    .endif
    ret
endp

;--------------------------------DrawScreen-----------------------------------------------

proc DrawScreen, Player: Dword, Enemy: Dword
    cinvoke SDL_RenderClear, [Renderer]
    .if (word [IsShownVictoryScreen])
        stdcall DrawVictoryScreen
        jmp @f
    .endif
    .if (word [IsShownScreenBetweenMoves] = 0)

        stdcall DrawDeck
        stdcall DrawSelection
        stdcall DrawOtboy
        stdcall DrawPlayedCards
        stdcall DrawEnemyCards,[Enemy]
        stdcall DrawPlayerCards, [Player]
        stdcall DrawButtons
        jmp @f
    .endif
    
    stdcall DrawScreenBetweenMoves
@@:
    cinvoke SDL_RenderPresent, [Renderer]
    ret
endp

proc DrawScreenBetweenMoves
    movzx eax, [CurrPlayerMove]
    ; если следующий игрок атакует
    .if (ax = word[CurrPlayerAttacker])
        cinvoke wsprintf, PlayerAttackMsg, AttackFormat, eax 
        stdcall RenderNVSign, PlayerAttackMsgSign
        stdcall DrawNVSign, PlayerAttackMsgSign
        jmp @f
    .endif
    ; если следующий игрок защищается
    cinvoke wsprintf, PlayerDefenceMsg, DefenceFormat, eax 
    stdcall RenderNVSign, PlayerDefenceMsgSign
    stdcall DrawNVSign, PlayerDefenceMsgSign
    jmp @f
@@: 
    ret
endp

proc DrawVictoryScreen
    movzx eax, [CurrPlayerMove]
    cinvoke wsprintf, VictoryMsg, VictoryFormat, eax 
    stdcall RenderNVSign, VictoryMsgSign
    stdcall DrawNVSign, VictoryMsgSign
    cinvoke SDL_RenderPresent, [Renderer]
    cinvoke SDL_Delay, 6000
    mov byte [Running], 0
    ret
endp

proc DrawText
    ret
endp

;-----------------------------------Paint-----------------------------------------------

proc Paint
    .if (word [IsShownScreenBetweenMoves] = 1)
        stdcall DrawScreenBetweenMoves
    .endif
    .if ([CurrPlayerMove] = 1)
        stdcall DrawScreen, Player1Cards, Player2Cards
        jmp @f
    .endif
    stdcall DrawScreen, Player2Cards, Player1Cards
@@: 
    ret
endp




