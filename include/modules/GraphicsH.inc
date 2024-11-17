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
RENDERER_FLAGS = SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC
imgFlags dd 0
CardsPath db "images\Cards.png", 0
BackPath db "images\Back.png", 0
SelectionPath db "images\Selection.png", 0
CardsTexture dd 0
BackTexture dd 0
SelectionTexture dd 0
Temp dd 0

;------------------------------------------------------------------------------

PlayedCard1 SDL_Rect
PlayedCard1.visible dw 0

PlayedCard2 SDL_Rect
PlayedCard2.visible dw 0

PlayedCard3 SDL_Rect
PlayedCard3.visible dw 0

PlayedCard4 SDL_Rect
PlayedCard4.visible dw 0

TrumpCardRect SDL_Rect
TrumpCard.visible dw 0

; тут что-то будет про инструкцию (ƒЋя ѕќЋ№«ќ¬ј“≈Ћя!!!), пока делать лень.

OneCardLeftInDeck db 0
IsDeckEmpty db 0
IsOtboyEmpty db 0
IsCardSelected db 0

OtboyRect SDL_Rect
DeckRect SDL_Rect
CurrCardsPage db 0

PlayerCardRect SDL_Rect
CardRect SDL_Rect
EnemyCardRect SDL_Rect
selectionRect SDL_Rect