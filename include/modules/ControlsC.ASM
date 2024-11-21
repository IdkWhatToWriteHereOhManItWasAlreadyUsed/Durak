
proc GetPressedRect, x: DWORD, y: DWORD
      ret
endp


proc MouseButtonUpHandle
      mov eax, [Event.button.x]
      mov [LastMouseButtonUp], eax
      mov eax, [Event.button.y]
      mov [LastMouseButtonUp + 4], eax
      ret
endp