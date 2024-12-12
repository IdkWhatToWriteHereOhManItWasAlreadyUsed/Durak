format PE GUI 4.0

entry Start

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
include "include\modules\ControlsH.inc"
include "include\RandomH.inc"



WasLaunched db 0
Running db $FF
Align 4
Event SDL_Event

section ".code" code readable executable

include "include\modules\GraphicsC.asm"
include "include\modules\GameplayC.asm"
include "include\modules\ControlsC.asm"
include "include\RandomC.asm"

Start:
    stdcall Init

    ;добавить проверки
    cmp [WasLaunched], 0
    je .Exit
    stdcall MainLoop


.Exit:
    stdcall DeInit
    invoke ExitProcess, 0
    ret

proc MainLoop usesdef

    stdcall GiveCards
    stdcall Paint
    .while ([Running] <> 0)     
        cinvoke SDL_PollEvent, Event
        .if (eax)
            .if ([Event.type] = SDL_QUIT)
                mov byte [Running], 0
                jmp EndLoop
            .endif

            .if ([Event.type] = SDL_MOUSEBUTTONUP)
                stdcall MouseButtonUpHandle
                stdcall Paint
                jmp EndLoop
            .endif
        .endif
        EndLoop:
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




