Window dd 0
WINDOW_TITLE db 'Durak', 0
align 4
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

PlayedCard1 SDL_Rect


PlayedCard2 SDL_Rect


PlayedCard3 SDL_Rect


PlayedCard4 SDL_Rect


TrumpCardRect SDL_Rect


; что-то про инструкцию для пользователя

IsOtboyEmpty db 0
align 4

OtboyRect SDL_Rect
DeckRect SDL_Rect
CurrCardsPage db 0
align 4

PlayerCardRect SDL_Rect
CardRect SDL_Rect
EnemyCardRect SDL_Rect
SelectionRect SDL_Rect