
;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////
;//////                                                        //////
;//////   Proc for giving and taking away cards during game    //////
;//////                                                        //////
;////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////

proc GiveCard uses edi ebx, PlayerCards: DWORD, Card: DWORD
     mov edi, [PlayerCards]
     mov eax, [Card]
     xor ebx, ebx
     .while (Dword[edi + ebx] <> 0)
          add ebx, 4
     .endw
     mov Dword[edi + ebx], eax
     ret
endp

proc TakeCard uses esi ebx ecx, PlayerCards: DWORD, Card: DWORD
     mov esi, [PlayerCards]
     mov eax, [Card]
     xor ebx, ebx
     .while (Dword[esi + ebx] <> eax)
          add ebx, 4
     .endw
     .while (Dword[esi + ebx] <> 0)
          mov eax, Dword [esi + ebx + 4] 
          mov Dword[esi + ebx], eax
          add ebx, 4
     .endw
     ret
endp