
;-----------------------GRAPHICS----------------------------------------------

Window dd 0
WINDOW_TITLE db 'Durak', 0
WINDOW_W = 800
WINDOW_H = 600
WINDOW_X = 100
WINDOW_Y = 60
WINDOW_FLAGS = SDL_WINDOW_SHOWN

CARD_H = 96
CARD_W = 71
GAME_CARDS_Y = 220
DISTANCE_BETWEEN_CARDS = 16

Renderer dd 0
RENDERER_FLAGS = SDL_RENDERER_ACCELERATED and SDL_RENDERER_PRESENTVSYNC
imgFlags dd 0
CardsPath db "images\Cards.png", 0
BackPath db "images\Back.png", 0
CardsTexture dd 0
BackTexture dd 0
Temp dd 0

;------------------------------------------------------------------------------

PlayedCard1 SDL_Rect
PlayedCard1.visible db 0

PlayedCard2 SDL_Rect
PlayedCard2.visible db 0

PlayedCard3 SDL_Rect
PlayedCard3.visible db 0

PlayedCard4 SDL_Rect
PlayedCard4.visible db 0

TrumpCardRect SDL_Rect
TrumpCard.visible db 0

; тут что-то будет про инструкцию (ƒЋя ѕќЋ№«ќ¬ј“≈Ћя!!!), пока делать лень.

; временное
; потом в логике заменить на значение ф-ции подсчета карт в колоде
OneCardLeftInDeck db 1
IsDeckEmpty db 0

OtboyRect SDL_Rect
DeckRect SDL_Rect
CurrCardsPage db 0

PlayerCardRect SDL_Rect
CardRect SDL_Rect
EnemyCardRect SDL_Rect

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

    mov [WasLaunched], 1
    ret
endp

;--------------------------------initImages-----------------------------------------------------

proc initImages
      ;  добавить проверки!!!!
      ;  Ќ” Ќ≈ «јЅ”ƒ№ ≈ћј≈!
     cinvoke IMG_LoadTexture, [Renderer], CardsPath
     mov [CardsTexture], eax

     cinvoke IMG_LoadTexture, [Renderer], BackPath
     mov [BackTexture], eax

     ret
endp

;--------------------------------initRect------------------------------------------------------------

proc initRect uses ebx, Rect: DWORD, x: dword , y: dword, w: dword, h: dword
; очень грустно было замен€ть всего лишь 4 mov на вот эту процедуру
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
    ; потом допишу очистку пам€ти
    cinvoke IMG_Quit
    cinvoke SDL_Quit
    ret
endp

;----------------------------------drawCard----------------------------------------------

proc drawCard, x: DWORD, y: DWORD, CardType, CardNum

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
        mov [PlayerCardRect.x], 800 - CARD_W - DISTANCE_BETWEEN_CARDS
        mov [PlayerCardRect.y], 0
        mov [PlayerCardRect.h], CARD_H
        mov [PlayerCardRect.w], CARD_W
        cinvoke SDL_RenderCopy, [Renderer], [BackTexture], 0, OtboyRect
        ret
endp

;---------------------------------drawDeck-------------------------------------------------------

proc drawDeck
     .if ([IsDeckEmpty] = 0 )
         movzx eax, [Trump]
         movzx edx, [Trump + 2]
         stdcall drawCard, [TrumpCardRect.x], [TrumpCardRect.y], eax, edx
     .endif
     .if ([OneCardLeftInDeck] <> 0)
         cinvoke SDL_RenderCopy, [Renderer], [BackTexture], 0, Deck
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

proc drawPlayedCards

        ret

endp

;--------------------------------paint-----------------------------------------------

proc paint
     ; когда будешь делать отрисовку карты,
     ; которую мышкой двигают
     ; ее ѕќ—Ћ≈ƒЌ≈… рисовать
    ; условие, какой игрок ходит!!!!!
     cinvoke SDL_RenderClear, [Renderer]
     stdcall drawDeck
     stdcall drawOtboy

     .if ([CurrPlayerMove] = 1)
         stdcall drawEnemyCards, Player2.cards
         stdcall drawPlayerCards, Player1.cards
         jmp @f
     .endif
     stdcall drawEnemyCards, Player1.cards
     stdcall drawPlayerCards, Player2.cards
@@:
     cinvoke SDL_RenderPresent, [Renderer]
     ret

endp


