format PE GUI 4.0

entry start

include "D:\FASM\include\win32ax.inc"
include "D:\FASM\include\api\kernel32.inc"
include "D:\FASM\include\api\user32.inc"
include "include\SDL_structs.inc"
include "include\SDL_imports.inc"
include "include\IMG_imports.inc"
include "include\Cstd_headers.inc"

section ".data" data readable writeable

include "include\modules\GraphicsH.inc"
include "include\modules\GameplayH.inc"
include "include\RandomH.inc"



WasLaunched db 0
Running db $FF
align 4
Event SDL_Event

section ".code" code readable executable

include "include\modules\GraphicsC.asm"
include "include\modules\GameplayC.asm"
include "include\RandomC.asm"

start:
    stdcall init

    ; �� � ����� ����, �� ��� �����
    cmp [WasLaunched], 0
    je .exit
    stdcall mainloop


.exit:
    stdcall deinit
    invoke ExitProcess, 0
    ret

proc mainloop usesdef

     stdcall giveCards
    .while ([Running] <> 0)

          .if ([CurrPlayerMove] = 1)
               stdcall paint, Player1.cards, Player2.cards
               jmp EventLoop
          .endif

          stdcall paint, Player2.cards, Player1.cards
          EventLoop:
          cinvoke SDL_Delay, 50
          cinvoke SDL_PollEvent, Event
          .if (eax)

               .if ([Event.type] = SDL_QUIT)
                   mov byte [Running], 0
                   jmp Endloop
               .endif

               .if ([Event.type] = SDL_MOUSEBUTTONDOWN)
                 ;   stdcall MouseButtonDownHandle,

                   jmp EventLoop
               .endif

               jmp EventLoop
          .endif
          jmp EventLoop
          Endloop:
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




