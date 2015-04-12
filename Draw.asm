    .686p                       ; create 32 bit code
    .mmx                        ; enable MMX instructions
    .xmm                        ; enable SSE instructions
    .model flat, stdcall        ; 32 bit memory model
    option casemap :none        ; case sensitive

include XinyiRun.inc         ; local includes for this file
include Vars.inc


.code
DrawProc PROC hDC:DWORD

    LOCAL hPen      :DWORD
    LOCAL hPenOld   :DWORD
    LOCAL rBrush    :DWORD
    LOCAL bBrush    :DWORD
    LOCAL hBrushOld :DWORD

    LOCAL lb        :LOGBRUSH

    INVOKE CreatePen, 0, 1, 00000000h ;black
    mov hPen, eax

    mov lb.lbStyle, BS_SOLID
    mov lb.lbHatch, NULL

    mov lb.lbColor, 00FF0000h ;blue
    INVOKE CreateBrushIndirect, ADDR lb
    mov bBrush, eax

    mov lb.lbColor, 000000FFh ;red
    INVOKE CreateBrushIndirect, ADDR lb
    mov rBrush, eax

    invoke SelectObject,hDC,hPen
    mov hPenOld, eax

    invoke SelectObject,hDC,bBrush
    mov hBrushOld, eax

  ; ------------------------------------------------
  ; The 4 GDI functions use the pen colour set above
  ; and fill the area with the current brush.
  ; ------------------------------------------------

    .IF selected_menu == 0
        INVOKE SelectObject, hDC, rBrush
    .ELSE
        INVOKE SelectObject, hDC, bBrush
    .ENDIF

    invoke Ellipse, hDC , 250, 50, 350, 150

    .IF selected_menu == 1
        INVOKE SelectObject, hDC, rBrush
    .ELSE
        INVOKE SelectObject, hDC, bBrush
    .ENDIF

    invoke Ellipse, hDC , 250, 200, 350, 300

    .IF selected_menu == 2
        INVOKE SelectObject, hDC, rBrush
    .ELSE
        INVOKE SelectObject, hDC, bBrush
    .ENDIF

    invoke Ellipse, hDC , 250, 350, 350, 450

  ; ------------------------------------------------

    invoke SelectObject, hDC, hBrushOld
    invoke DeleteObject, bBrush
    invoke DeleteObject, rBrush

    invoke SelectObject, hDC, hPenOld
    invoke DeleteObject, hPen

    ret

DrawProc ENDP
END