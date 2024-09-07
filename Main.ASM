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

include "include\modules\Graphics.asm"
include "include\modules\Gameplay.asm"

section ".data" data readable writeable

WasLaunched db 0
Running db $FF

align 4
Event SDL_Event

section ".code" code readable executable

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
    .while ([Running] = $FF)
           cinvoke SDL_PollEvent, Event
           .if (eax)
               .if ([Event.type] = SDL_QUIT)
                   mov byte [Running], 0
               .endif
               .if ([Event.type] = SDL_MOUSEMOTION)

              .endif
              stdcall paint
          .endif
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



