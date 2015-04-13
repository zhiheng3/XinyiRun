;Game Process and keydown handler

    .686p                       ; create 32 bit code
    .mmx                        ; enable MMX instructions
    .xmm                        ; enable SSE instructions
    .model flat, stdcall        ; 32 bit memory model
    option casemap :none        ; case sensitive

include XinyiRun.inc         ; local includes for this file
include Vars.inc

;macro vars
HEIGHT = 100
PILAR_RANDOM_RANGE_START = 20
PILAR_RANDOM_RANGE_END = 100
GAP_RANDOM_RANGE_START = 50
GAP_RANDOM_RANGE_END = 200

ST_STAND = 0   ;Wait for operation
ST_HOLD = 1    ;Pressing space
ST_ROTATE = 2  ;Rotate pole
ST_RUN = 3     ;Running
ST_BONUS = 4   ;Add bonus
ST_MOVE = 5    ;Move pilars
ST_DEAD = 6    ;Person dead

.data?
state DWORD ?
history_scene DWORD ?

.data
move_remain SDWORD -100

.code
;Initializaiton
InitGame PROC
    INVOKE GetTickCount
    mov random_seed, eax

    mov scene, 0

    ;Scene0
    mov selected_menu, 0

    ret
InitGame ENDP

;Get random number between first and second parameter
;The result is in eax
Random   proc uses ecx edx,
    first:DWORD, second:DWORD
   mov      eax, random_seed
   mov      ecx, 23
   mul      ecx
   add      eax, 7
   mov      ecx, second
   sub      ecx, first
   inc      ecx
   xor      edx, edx
   div      ecx
   add      edx, first
   mov      eax, edx
   mov      random_seed, eax
   ret
Random   endp

;Pilars operation
;Insert a random pilar ranged from 20 to 100 to pilars[4]
InsertPilar PROC USES eax ebx ecx edx esi
    local structSize: DWORD
    mov structSize, TYPE pilars
    mov esi, 0
    mov ecx, PILAR_NUM
    mov structSize, TYPE pilars

    L1:
    .IF pilars[esi].end_x == 0
        jmp Insert
    .ELSE
        add esi, structSize
        loop L1
    .ENDIF
    ret

    Insert:
    .IF esi == 0
        jmp FirstPilar
    .ELSE
        jmp OtherPilar
    .ENDIF

    FirstPilar:
    mov pilars[esi].start_x, GAP_RANDOM_RANGE_START
    INVOKE Random, PILAR_RANDOM_RANGE_START, PILAR_RANDOM_RANGE_END
    add eax, GAP_RANDOM_RANGE_START
    mov pilars[esi].end_x, eax
    mov pilars[esi].height, HEIGHT
    ret

    OtherPilar:
    mov ebx, esi
    sub ebx, structSize
    INVOKE Random, GAP_RANDOM_RANGE_START, GAP_RANDOM_RANGE_END
    mov edx, pilars[ebx].end_x
    add eax, edx
    mov pilars[esi].start_x, eax

    INVOKE Random, PILAR_RANDOM_RANGE_START, PILAR_RANDOM_RANGE_END
    mov edx, pilars[esi].start_x
    add edx, eax
    mov pilars[esi].end_x, edx
    mov pilars[esi].height, HEIGHT
    ret
InsertPilar ENDP

;Initial the pilars array which length is PILAR_NUM
InitialPilar PROC USES ecx
    mov ecx, PILAR_NUM

    L1:
    INVOKE InsertPilar
    loop L1

    ret
InitialPilar ENDP

;Delete pilars[0], move pilars[i] to pilars[i-1]
DeletePilar PROC USES eax ebx ecx esi
    local structSize: DWORD
    mov esi, 0
    mov ebx, 0
    mov ecx, PILAR_NUM
    mov structSize, TYPE pilars
    add ebx, structSize

    L1:
    .IF ecx == 1
        jmp Clear
    .ELSE
        jmp Exchange
    .ENDIF

    Clear:
    mov pilars[esi].start_x, 0
    mov pilars[esi].end_x, 0
    mov pilars[esi].height, 0
    ret

    Exchange:
    mov eax, pilars[ebx].start_x
    mov pilars[esi].start_x, eax
    mov eax, pilars[ebx].end_x
    mov pilars[esi].end_x, eax
    mov eax, pilars[ebx].height
    mov pilars[esi].height, eax
    add esi, structSize
    add ebx, structSize
    loop L1

DeletePilar ENDP

;Move all pilars left, decrease the x-coor by 1
MovePilar PROC USES ecx esi ebx, Step:DWORD

    local structSize: DWORD
    mov esi, 0
    mov ecx, PILAR_NUM
    mov ebx, Step
    mov structSize, TYPE pilars

    L1:
    .IF pilars[esi].start_x != 0
        sub pilars[esi].start_x, ebx
    .ENDIF

    .IF pilars[esi].end_x != 0
        sub pilars[esi].end_x, ebx
    .ENDIF
    add esi, structSize
    loop L1

    ret
MovePilar ENDP

;Pole operation
;Rotate the pole by 1 degree. Point 0 is axis. (Use transformation matrix, avoid division) 
;The result x1 is in pole_x1, y1 is in pole_y1
RotatePole PROC USES eax ecx,
    x0:DWORD, y0: DWORD
    local temp:DWORD, divisor:DWORD
    mov divisor, 10000
    mov edx, 0

    mov eax, y0
    mov ecx, 175
    mul ecx
    mov temp, eax
    mov eax, x0
    mov ecx, 9998
    mul ecx
    add eax, temp
    div divisor
    mov pole_x1, eax
    
    mov eax, x0
    mov ecx, 175
    mul ecx
    mov temp, eax
    mov eax, y0
    mov ecx, 9998
    mul ecx
    sub eax, temp
    div divisor
    mov pole_y1, eax

    ret
RotatePole ENDP

GameStart PROC
    INVOKE InitialPilar
    mov state, ST_STAND
    mov eax, pilars[0].start_x
    mov player_x, eax
    mov eax, pilars[0].height
    mov player_y, eax
    mov player_f, 0
    mov scene, 2
    ret
GameStart ENDP

GameProc PROC uses eax
    inc player_f
    .IF player_f == 6
        mov player_f, 0
    .ENDIF

    .IF move_remain > 0
        INVOKE MovePilar, 5
        sub move_remain, 5
    .ELSEIF move_remain != -100
        INVOKE DeletePilar
        INVOKE InitialPilar
        mov move_remain, -100
    .ENDIF
    ret
GameProc ENDP

Scene0KeydownHandler PROC wParam:DWORD
    switch wParam
        case VK_UP
            .IF selected_menu > 0
                dec selected_menu
            .ENDIF
            return 0
        case VK_DOWN
            .IF selected_menu < 2
                inc selected_menu
            .ENDIF
            return 0
        case VK_RETURN
            .IF selected_menu == 0
                INVOKE GameStart
                return 0
            .ELSEIF selected_menu == 1
                mov history_scene, 0
                mov scene, 1
                mov selected_menu, 0
                return 0
            .ELSEIF selected_menu == 2
                return 1
            .ENDIF
    endsw
    return 0
Scene0KeydownHandler ENDP

Scene1KeydownHandler PROC wParam:DWORD
    switch wParam
        case VK_ESCAPE
            mov eax, history_scene
            mov scene, eax
            return 0
    endsw
    return 0
Scene1KeydownHandler ENDP

Scene2KeydownHandler PROC wParam:DWORD
    switch wParam
        case VK_RETURN
            mov eax, pilars[TYPE pilars].start_x
            sub eax, GAP_RANDOM_RANGE_START
            mov move_remain, eax
            return 0
    endsw
    return 0
Scene2KeydownHandler ENDP

KeydownProc PROC wParam:DWORD
    switch scene
        case 0
            INVOKE Scene0KeydownHandler, wParam
            ret
        case 1
            INVOKE Scene1KeydownHandler, wParam
            ret
        case 2
            INVOKE Scene2KeydownHandler, wParam
            ret
    endsw
    return 0
KeydownProc ENDP

KeyupProc PROC wParam:DWORD
    ret
KeyupProc ENDP

END