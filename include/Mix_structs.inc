MIX_INIT_FLAC      = 0x00000001
MIX_INIT_MOD       = 0x00000002
MIX_INIT_MP3       = 0x00000008
MIX_INIT_OGG       = 0x00000010
MIX_INIT_MID       = 0x00000020
MIX_INIT_OPUS      = 0x00000040
MIX_INIT_WAVPACK   = 0x00000080

MIX_DEFAULT_FORMAT = AUDIO_S16LSB

struct Mix_Chunk
       allocated rd 1
       abuf      rd 1
       alen      rd 1
       volume    rb 1
ends