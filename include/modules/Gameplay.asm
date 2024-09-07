Player1.cards dw 36 dup (1,9), 0,0
Player2.cards dw 36 dup (1,9),0,0
Trump dw 2, 14
CurrPlayerMove dw 1
Deck dw 28 dup (0,0)  ; 26 байт на карты и 6 на обозначение конца стека

GameStack1 dw 28 dup (0,0)
GameStack2 dw 28 dup (0,0)
GameStack3 dw 28 dup (0,0)
GameStack4 dw 28 dup (0,0)
; раздача 5 карт

;------------------------------giveCards-----------------------------------

proc giveCards
     mov ecx, 35
     mov edx, 0
     mov eax, Cards
@@:
     push ecx
     mov eax, ecx
     div 9
     inc eax
     mov [eax + edx],
     loop @b

     ret
endp




