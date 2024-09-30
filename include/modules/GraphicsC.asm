
;----------------------------------init----------------------------------------------

proc init usesdef

    cinvoke SDL_Init, SDL_INIT_EVERYTHING
    .if (eax = -1)
        ret
    .endif

    cinvoke IMG_Init

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
    stdcall initImages
    stdcall initRects
    mov [WasLaunched], 1
    ret
endp

;--------------------------------initImages-----------------------------------------------------

proc initImages
      ;  добавить проверки!!!!
      ;  НУ НЕ ЗАБУДЬ ЕМАЕ!
     cinvoke IMG_LoadTexture, [Renderer], CardsPath
     mov [CardsTexture], eax

     cinvoke IMG_LoadTexture, [Renderer], BackPath
     mov [BackTexture], eax

     ret
endp

;--------------------------------initRect------------------------------------------------------------

proc initRect uses ebx, Rect: DWORD, x: dword , y: dword, w: dword, h: dword
; очень грустно было заменять всего лишь 4 mov на вот эту процедуру
;                               (-_-)
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

;---------------------------------initRectSSSSSS-----------------------------------------------------------

proc initRects usesdef
        stdcall initRect, DeckRect, 800 - DISTANCE_BETWEEN_CARDS - CARD_H, GAME_CARDS_Y -2 * DISTANCE_BETWEEN_CARDS, CARD_W, CARD_H
        stdcall initRect, PlayerCardRect, DISTANCE_BETWEEN_CARDS, 600 - DISTANCE_BETWEEN_CARDS - CARD_H, CARD_W, CARD_H
        stdcall initRect,TrumpCardRect, 800 - DISTANCE_BETWEEN_CARDS - CARD_H, GAME_CARDS_Y, CARD_W, CARD_H
        stdcall initRect, PlayedCard4, 400 + CARD_W + 10 + CARD_W + 10, GAME_CARDS_Y, CARD_W, CARD_H
        stdcall initRect, PlayedCard4, 400 + CARD_W + 10 + CARD_W + 10, GAME_CARDS_Y, CARD_W, CARD_H
        stdcall initRect, PlayedCard1, 400 - CARD_W - CARD_W - 10, GAME_CARDS_Y ,  CARD_W, CARD_H
        stdcall initRect, PlayedCard2, 400 - CARD_W - 10, GAME_CARDS_Y, CARD_W, CARD_H
        stdcall initRect, PlayedCard3, 400 + CARD_W + 10, GAME_CARDS_Y, CARD_W, CARD_H
        stdcall initRect, OtboyRect, DISTANCE_BETWEEN_CARDS, GAME_CARDS_Y, CARD_W, CARD_H
        stdcall initRect, EnemyCardRect, 0, 0, CARD_W, CARD_H
        mov [CardRect.w], CARD_W
        mov [CardRect.h], CARD_H
    ret
endp

 ;----------------------------------deinit-----------------------------------------------------

proc deinit usesdef
    cinvoke SDL_DestroyRenderer, [Renderer]
    cinvoke SDL_DestroyWindow, [Window]
    ; потом допишу очистку памяти
    cinvoke IMG_Quit
    cinvoke SDL_Quit
    ret
endp

;----------------------------------drawCard----------------------------------------------

proc drawCard uses ecx, x: DWORD, y: DWORD, CardType, CardNum

; 1 бубны
; 2 пики
; 3 чирвы
; 4 кресте
; коды карт:  6 7 8 ...14

        push eax
        sub [CardNum], 6
        dec [CardType]

        mov ax, CARD_W
        mul [CardNum]
        mov [CardRect.x], eax

        mov ax,  CARD_H
        mul [CardType]
        mov [CardRect.y], eax

        mov eax, [x]
        mov [PlayerCardRect.x], eax
        mov eax, [y]
        mov [PlayerCardRect.y], eax

        cinvoke SDL_RenderCopy, [Renderer], [CardsTexture], CardRect, PlayerCardRect

        pop eax
        ret

endp

;---------------------------------drawEnemyCards-----------------------------------------------

proc drawEnemyCards, Player.cards: DWORD

        push ecx
        push ebx
        xor ecx, ecx
        xor ebx, ebx
        mov esi, [Player.cards]
        .while (DWORD [esi+ebx] <> 0)
               inc ecx
               add ebx, 4
        .endw
        cmp ebx, 0
        je exit
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
exit:
        mov [PlayerCardRect.h], CARD_H
        mov [PlayerCardRect.w], CARD_W
        pop ebx
        pop ecx

        ret
endp

;------------------------------drawOtboy---------------------------------------------------

proc drawOtboy
        cmp byte [IsOtboyEmpty], 0
        je @f
        mov [PlayerCardRect.x], 800 - CARD_W - DISTANCE_BETWEEN_CARDS
        mov [PlayerCardRect.y], 0
        mov [PlayerCardRect.h], CARD_H
        mov [PlayerCardRect.w], CARD_W
        cinvoke SDL_RenderCopy, [Renderer], [BackTexture], 0, OtboyRect
        @@:
        ret
endp

;---------------------------------drawDeck-------------------------------------------------------

proc drawDeck
     .if (dword [Deck] > 8)
         movzx eax, [Trump]
         movzx edx, [Trump + 2]
         stdcall drawCard, [TrumpCardRect.x], [TrumpCardRect.y], eax, edx
     .endif
     .if (dword [Deck] > 4)
         cinvoke SDL_RenderCopy, [Renderer], [BackTexture], 0, DeckRect
     .endif
     ret
endp

;---------------------------------drawPlayerCards-----------------------------------------------------

proc drawPlayerCards uses esi eax ebx edi, Player.cards: DWORD

        mov esi, [Player.cards]
        mov al, 4*9 ; одна страница это 9 карт или 36 байт
        mul byte [CurrCardsPage]
        movzx ebx, ax
        mov eax, DISTANCE_BETWEEN_CARDS
        .while (DWORD [esi+ebx] <> 0)
               movzx edi, word [esi + ebx + 2]
               push edi
               movzx edi, word [esi + ebx]
               push edi
               stdcall drawCard, eax, WINDOW_H - DISTANCE_BETWEEN_CARDS - CARD_H
               add eax, DISTANCE_BETWEEN_CARDS + CARD_W
               add ebx, 4
               .if (eax > WINDOW_W - DISTANCE_BETWEEN_CARDS - CARD_W)
                   jmp exitDrawLoop
               .endif
        .endw
exitDrawLoop:
        ret
endp

;--------------------------------drawPlayedCards-----------------------------------------------

proc drawPlayedCards uses esi edi ecx
local Card dd 0
        lea esi, [GameStack1]
        lea edi, [PlayedCard1]
        mov ecx, 4
loopstart:
        movzx ebx, word[esi + 2]
       ; mov eax, [esi + ebx]
        mov eax, dword [Trump]
        mov [Card], eax
        stdcall drawCard, dword [edi], dword [edi + 4], dword[Card]
        add esi, 60
        add edi, 18
        dec ecx
        cmp ecx, 0
        jne loopstart
        ret

endp

;--------------------------------paint-----------------------------------------------

proc paint, Player: Dword, Enemy: Dword
     ; когда будешь делать отрисовку карты,
     ; которую мышкой двигают
     ; ее ПОСЛЕДНЕЙ рисовать
    ; условие, какой игрок ходит!!!!!
     cinvoke SDL_RenderClear, [Renderer]
     stdcall drawDeck
     stdcall drawOtboy
     stdcall drawPlayedCards

     stdcall drawEnemyCards,[Enemy]
     stdcall drawPlayerCards, [Player]
@@:
     cinvoke SDL_RenderPresent, [Renderer]
     ret

endp


