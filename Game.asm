;Game Process and keydown handler

    .686p                       ; create 32 bit code
    .mmx                        ; enable MMX instructions
    .xmm                        ; enable SSE instructions
    .model flat, stdcall        ; 32 bit memory model
    option casemap :none        ; case sensitive

include XinyiRun.inc         ; local includes for this file
include Vars.inc

.data

.code

;Initializaiton
InitGame PROC
    mov scene, 0

    ;Scene0
    mov selected_menu, 0

    ret
InitGame ENDP

GameStart PROC
    mov scene, 2
    ret
GameStart ENDP

;Pilars operation
;Insert a random pilar in pilars[4]
InsertPilar PROC 
    ret
InsertPilar ENDP

;Delete pilars[0], move pilars[i] to pilars[i-1]
DeletePilar PROC
    ret
DeletePilar ENDP

;Move all pilars left, decrease the x-coor by 1
MovePilar PROC
    ret
MovePilar ENDP

;Pole operation
;Rotate the pole by 1 degree. Point 0 is axis. (Use transformation matrix, avoid division) 
RotatePole PROC
    ret
RotatePole ENDP

GameProc PROC uses eax
    .IF (deltaX != 0) || (deltaY != 0)
        inc frames
    .ENDIF

    mov eax, 100
    mul speed
    .IF (eax < frames)
        inc speed
    .ENDIF

    mov eax, ellipse.x
    add eax, deltaX
    .IF (eax < 0) || (eax > 560)
        INVOKE InitGame
        return 0
    .ENDIF
    mov ellipse.x, eax

    mov eax, ellipse.y
    add eax, deltaY
    .IF (eax < 0) || (eax > 400)
        INVOKE InitGame
        return 0
    .ENDIF
    mov ellipse.y, eax
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
                mov scene, 1
                mov selected_menu, 0
                return 0
            .ELSEIF selected_menu == 2
                return 1
            .ENDIF
    endsw
    return 0
Scene0KeydownHandler ENDP

KeydownProc PROC wParam:DWORD
    switch scene
        case 0
            INVOKE Scene0KeydownHandler, wParam
            ret
    endsw
    return 0
KeydownProc ENDP

KeyupProc PROC wParam:DWORD
    ret
KeyupProc ENDP

END