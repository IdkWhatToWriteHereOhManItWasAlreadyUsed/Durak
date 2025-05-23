SDL_INIT_TIMER      =   00000001h
SDL_INIT_AUDIO      =   00000010h
SDL_INIT_VIDEO      =   00000020h
SDL_INIT_CDROM      =   00000100h
SDL_INIT_JOYSTICK   =   00000200h
SDL_INIT_NOPARACHUTE    =   00100000h
SDL_INIT_EVENTTHREAD    =   01000000h
SDL_INIT_EVERYTHING =   0000FFFFh
SDL_APPMOUSEFOCUS   =   01h
SDL_APPINPUTFOCUS   =   02h
SDL_APPACTIVE       =   04h

SDL_WINDOW_FULLSCREEN = 0x00000001
SDL_WINDOW_OPENGL = 0x00000002
SDL_WINDOW_SHOWN = 0x00000004
SDL_WINDOW_HIDDEN = 0x00000008
SDL_WINDOW_BORDERLESS = 0x00000010
SDL_WINDOW_RESIZABLE = 0x00000020
SDL_WINDOW_MINIMIZED = 0x00000040
SDL_WINDOW_MAXIMIZED          = 0x00000080
SDL_WINDOW_MOUSE_GRABBED      = 0x00000100
SDL_WINDOW_INPUT_FOCUS        = 0x00000200
SDL_WINDOW_MOUSE_FOCUS        = 0x00000400
SDL_WINDOW_FULLSCREEN_DESKTOP = 0x00001001
SDL_WINDOW_FOREIGN            = 0x00000800
SDL_WINDOW_ALLOW_HIGHDPI      = 0x00002000

SDL_WINDOW_MOUSE_CAPTURE     = 0x00004000
SDL_WINDOW_ALWAYS_ON_TOP     = 0x00008000
SDL_WINDOW_SKIP_TASKBAR      = 0x00010000
SDL_WINDOW_UTILITY           = 0x00020000
SDL_WINDOW_TOOLTIP           = 0x00040000
SDL_WINDOW_POPUP_MENU        = 0x00080000
SDL_WINDOW_KEYBOARD_GRABBED  = 0x00100000
SDL_WINDOW_VULKAN            = 0x10000000
SDL_WINDOW_METAL             = 0x20000000
SDL_WINDOW_INPUT_GRABBED     = SDL_WINDOW_MOUSE_GRABBED

SDL_RENDERER_SOFTWARE       = 0x00000001
SDL_RENDERER_ACCELERATED    = 0x00000002
SDL_RENDERER_PRESENTVSYNC   = 0x00000004
SDL_RENDERER_TARGETTEXTURE  = 0x00000008

AUDIO_U8                    = 0x0008  ; Unsigned 8-bit samples
AUDIO_S8                    = 0x8008  ; Signed 8-bit samples
AUDIO_U16LSB                = 0x0010  ; Unsigned 16-bit samples
AUDIO_S16LSB                = 0x8010  ; Signed 16-bit samples
AUDIO_U16MSB                = 0x1010  ; As above, but big-endian byte order
AUDIO_S16MSB                = 0x9010  ; As above, but big-endian byte order
AUDIO_U16                   = AUDIO_U16LSB
AUDIO_S16                   = AUDIO_S16LSB

struct   SDL_Color
    r          rb 1
    g          rb 1
    b          rb 1
    a          rb 1
ends

struct   SDL_Rect
    x          rd 1
    y          rd 1
    w          rd 1
    h          rd 1
ends

struct SDL_Surface
    flags      rd 1
    format     rd 1
    w          rd 1
    h          rd 1
    pitch      rd 1
    pixels     rd 1
    userdata   rd 1
    locked     rd 1
    list_blitmap rd 1
    clip_rect  SDL_Rect
    map        rd 1
    refcount   rd 1
ends

struct SDL_Font
    ; в душе не ебу, сколько оно байт, найду методом тыка
    FT_Face rd 1
    height rd 1
    ascent rd 1
    descent rd 1
    lineskip rd 1
    style rd 1
    outline_val rd 1
    allow_kerning rd 1
    other_useless_pizdos rd 20
ends

include "SDL_keyboard.inc"
include "SDL_events.inc"