;В text хранится указатель на строку
;Положение надписи задаётся через rect
;По умолчанию надпись принимает натуральный размер текста
struct NVSign
       texture      rd 1
       font         rd 1
       text         rd 1
       wrap_length  rd 1
       rect         SDL_Rect
       color        SDL_Color
ends