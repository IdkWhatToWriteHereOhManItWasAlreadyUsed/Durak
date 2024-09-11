       format PE GUI 4.0
entry start

include "..\include\win32ax.inc"
include "..\include\api\kernel32.inc"
include "..\include\api\user32.inc"
include "include\SDL_structs.inc"
include "include\SDL_events.inc"
include "include\SDL_imports.inc"
include "include\IMG_imports.inc"
include "include\Cstd_headers.inc"
include "include\RandomC.asm"

section ".data" data readable writeable

include "include\modules\GraphicsH.inc"
include "include\modules\GameplayH.inc"

WasLaunched db 0
Running db $FF
align 4
Event SDL_Event

section ".code" code readable executable

include "include\modules\GraphicsC.asm"
include "include\modules\GameplayC.asm"

start:
    stdcall init
    stdcall initImages
    stdcall initRects

    ; ну и имена чета, но это потом
    cmp [WasLaunched], 0
    je .exit
    stdcall mainloop


.exit:
    stdcall deinit
    invoke ExitProcess, 0
    ret

proc mainloop usesdef
    .while ([Running] <> 0)
          ; stdcall paint
           .if ([CurrPlayerMove] = 1)
               stdcall paint, Player1.cards, Player2.cards
               jmp @f
          .endif
          stdcall paint, Player2.cards, Player1.cards
          @@:
EventLoop:
        cinvoke SDL_Delay, 50
           cinvoke SDL_PollEvent, Event
           .if (eax)
               .if ([Event.type] = SDL_QUIT)
                   mov byte [Running], 0
                   jmp @f
               .endif
               .if ([Event.type] = SDL_MOUSEMOTION)
                   nop
                   jmp EventLoop
               .endif
               jmp EventLoop
          .endif
          jmp EventLoop

          @@:

    .endw
    ret
endp

;------------------------------------------------------------------------------

section ".idata" import data readable writeable


    library \
    kernel32,"kernel32.dll",\
    user32,"user32.dll",\
    sdl,"SDL2.dll",\
    sdl_image,"SDL2_image.dll",\
    msvcrt, "msvcrt.dll"




