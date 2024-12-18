proc CreateNVSign uses ebx, Sign : DWord, TextPtr : DWord, .FontPath : DWord, .FontSize : DWord, Color : DWord
     mov ebx, [Sign]

     mov eax, [TextPtr]
     mov [ebx + NVSign.text], eax

     mov eax, [Color]
     mov [ebx + NVSign.color], eax

     cinvoke TTF_OpenFont, [.FontPath], [.FontSize]
     mov [ebx + NVSign.font], eax

     mov [ebx + NVSign.texture], 0
     ;�������, �� � �������
     mov dword [ebx + NVSign.wrap_length], WINDOW_W
     ret
endp

proc DestroyNVSign uses ebx, Sign : DWord
     mov ebx, [Sign]
     cinvoke SDL_DestroyTexture, [ebx + NVSign.texture]
     cinvoke TTF_CloseFont, [ebx + NVSign.font]
     ret
endp

proc RenderNVSign uses ebx, Sign : DWord
local SurfPointer rd 1
     mov ebx, [Sign]
     cinvoke TTF_RenderUTF8_Blended_Wrapped, dword[ebx + NVSign.font],dword [ebx + NVSign.text], dword [ebx + NVSign.color], [ebx + NVSign.wrap_length]
     mov [SurfPointer], eax
     cinvoke SDL_CreateTextureFromSurface, [Renderer], [SurfPointer]
     mov [ebx + NVSign.texture], eax
     cinvoke SDL_FreeSurface, [SurfPointer]
     lea eax, [ebx + NVSign.rect.w]
     lea edx, [ebx + NVSign.rect.h]
     cinvoke SDL_QueryTexture, [ebx + NVSign.texture], 0, 0, eax, edx
     ret
endp

proc DrawNVSign uses ebx, Sign : DWord
     mov ebx, [Sign]
     lea eax, [ebx + NVSign.rect]
     cinvoke SDL_RenderCopy, [Renderer], [ebx + NVSign.texture], 0, eax
     ret
endp