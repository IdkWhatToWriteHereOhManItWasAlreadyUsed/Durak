
AllCards dw  1,6,1,7,1,8,1,9,1,10,1,11,1,12,1,13,1,14,2,6,2,7,2,8,2,9,2,10,2,11,2,12,2,13,2,14,3,6,3,7,3,8,3,9,3,10,3,11,3,12,3,13,3,14,4,6,4,7,4,8,4,9,4,10,4,11,4,12,4,13,4,14,0,0
Player1.Cards dd 36 dup 0
Player2.Cards dd 36 dup 0

CurrPlayerMove dw 1, 0

Deck dd  4, 24 dup 0
GameStack1 dd  4, 28 dup 0
GameStack2 dd  4, 28 dup 0
GameStack3 dd  4, 28 dup 0
GameStack4 dd  4, 28 dup 0

WAITING = 0
CARD_TO_BEAT_SELECTION = 1



