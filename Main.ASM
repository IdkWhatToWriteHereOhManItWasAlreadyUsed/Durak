format PE GUI 4.0

entry Start

include "D:\FASM\include\win32ax.inc"
include "D:\FASM\include\api\kernel32.inc"
include "D:\FASM\include\api\user32.inc"
include "include\SDL_structs.inc"
include "include\SDL_imports.inc"
include "include\IMG_imports.inc"
include "include\TTF_imports.inc"
include "include\Cstd_headers.inc"
include "include\SDL_keyboard.inc"

section ".data" data readable writeable

include "include\modules\NVSignH.inc"
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
include "include\modules\ControlsC.asm"
include "include\RandomC.asm"
include "include\modules\CardsGiveawayC.asm"
include "include\modules\StackProcedures.asm"
include "include\modules\GivingAndTakingProcedures.asm"
include "include\modules\GameplayC.asm"
include "include\modules\NVSignC.ASM"


Start:
    stdcall Init
    cmp [WasLaunched], 0
    je .Exit
    stdcall MainLoop

.Exit:
    stdcall DeInit
    invoke ExitProcess, 0
    ret

proc MainLoop 
    stdcall GiveCards
    stdcall Paint
    .while (byte [Running] <> 0)     
       ; cinvoke SDL_Delay, 40
        cinvoke SDL_PollEvent, Event
        .if (eax)
            .if ([Event.type] = SDL_QUIT)
                mov byte [Running], 0
                stdcall DeInit
                invoke ExitProcess, 0
                ret
            .endif  

            .if ([Event.type] = SDL_MOUSEBUTTONUP)
                stdcall MouseButtonUpHandle
                sub esp,4
                stdcall Paint
            .endif

            .if ([Event.type] = SDL_KEYUP)
                stdcall KeyUpHandle
                stdcall Paint
            .endif
        .endif
        EndLoop:
    .endw
ExitLoop:
    ret
endp

;------------------------------------------------------------------------------

section ".idata" import data readable writeable


    library \
    kernel32,"kernel32.dll",\
    user32,"user32.dll",\
    sdl,"SDL2.dll",\
    sdl_image,"SDL2_image.dll",\
    sdl_ttf, "SDL2_ttf.dll",\
    msvcrt, "msvcrt.dll"




