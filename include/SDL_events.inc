SDL_FIRSTEVENT = 0

SDL_QUIT = 0x100

SDL_MOUSEMOTION = 0x400
SDL_MOUSEBUTTONDOWN = 0x401
SDL_MOUSEBUTTONUP = 0x402
SDL_MOUSEWHEEL = 0x403

SDL_RELEASED = 0
SDL_PRESSED = 1

struct   PseudoEvent
    type          rd 1
    pad0          rb 52
ends

struct   SDL_QuitEvent
    type          rd 1
    timestamp          rd 1
ends

struct  SDL_MouseMotionEvent
    type rd 1
    timestamp rd 1
    windowID rd 1
    which rd 1
    state rd 1
    x rd 1 ; текущая координата
    y rd 1 ;
    xrel rd 1 ; скорость перемещения по х
    yrel rd 1 ; скорость перемещения по y
ends

struct SDL_MouseButtonEvent
    type rd 1
    timestamp rd 1
    windowID rd 1
    which rd 1
    button rb 1
    state rb 1;Нажат или опущен ;Здесь константы SDL_PRESSED или SDL_RELEASED, но я их не нашёл. Сам вставишь куда-нибудь их определения
    clicks rb 1;Дабл или сингл клик
    padding1 rb 1
    x rd 1
    y rd 1
ends

struct  SDL_MouseWheelEvent
    type rd 1
    timestamp rd 1
    windowID rd 1
    which rd 1
    x rd 1
    y rd 1
    direction rd 1
    preciseX rd 1
    preciseY rd 1
    mouseX rd 1
    mouseY rd 1
ends

struc   SDL_Event
{
        virtual
        .type          rd 1
        end virtual

        virtual
        .common        PseudoEvent
        end virtual

        virtual
        .quit       SDL_QuitEvent
        end virtual

        virtual
        .motion        SDL_MouseMotionEvent
        end virtual

        virtual
        .button        SDL_MouseButtonEvent
        end virtual

        virtual
        .wheel       SDL_MouseWheelEvent
        end virtual
}