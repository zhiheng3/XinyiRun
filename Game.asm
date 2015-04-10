;Game Process and keydown handler

    .686p                       ; create 32 bit code
    .mmx                        ; enable MMX instructions
    .xmm                        ; enable SSE instructions
    .model flat, stdcall        ; 32 bit memory model
    option casemap :none        ; case sensitive

include XinyiRun.inc         ; local includes for this file
include Vars.inc


.code

InitGame PROC
    mov deltaX, 0
    mov deltaY, 0
    mov ellipse.x, 300
    mov ellipse.y, 200
    mov frames, 0
    mov speed, 1
    ret
InitGame ENDP

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

KeydownProc PROC wParam:DWORD
    mov deltaX, 0
    mov deltaY, 0
    mov ebx, speed
    switch wParam
        case VK_UP
            neg ebx
            mov deltaY, ebx
            return 0
        case VK_DOWN
            mov deltaY, ebx
            return 0
        case VK_LEFT
            neg ebx
            mov deltaX, ebx
            return 0
        case VK_RIGHT
            mov deltaX, ebx
            return 0
    endsw
    ret
KeydownProc ENDP

KeyupProc PROC wParam:DWORD
    ret
KeyupProc ENDP

END