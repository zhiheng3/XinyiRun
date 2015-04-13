    .686p                       ; create 32 bit code
    .mmx                        ; enable MMX instructions
    .xmm                        ; enable SSE instructions
    .model flat, stdcall        ; 32 bit memory model
    option casemap :none        ; case sensitive

include XinyiRun.inc         ; local includes for this file
include Vars.inc

DrawStartMenu    PROTO hDC:DWORD
DrawHelpWin      PROTO hDC:DWORD
DrawGamePlayWin  PROTO hDC:DWORD
DrawGameOverWin  PROTO hDC:DWORD
DrawErrorWin     PROTO hDC:DWORD
DrawBackground   PROTO hDC:DWORD,ID:DWORD
DrawPictureNormal      PROTO hDC:DWORD,ID:DWORD,posX:DWORD,posY:DWORD,wid:DWORD,hei:DWORD
DrawPictureTransparent PROTO hDC:DWORD,ID:DWORD,posX:DWORD,posY:DWORD,wid:DWORD,hei:DWORD,color:DWORD
DrawTextF              PROTO hDC:DWORD,font_wid:DWORD,font_hei:DWORD,bold:DWORD,text_color:DWORD,text_posX:DWORD,text_posY:DWORD,text_addr:DWORD,text_size:DWORD
DrawALine              PROTO hDC:DWORD,posX1:DWORD,posY1:DWORD,posX2:DWORD,posY2:DWORD,line_style:DWORD,line_width:DWORD,line_color:DWORD
DrawAShape             PROTO hDC:DWORD,shape:DWORD,posX:DWORD,posY:DWORD,rect_width:DWORD,rect_height:DWORD,rect_color:DWORD,edge_color:DWORD,round_width:DWORD,round_height:DWORD
        

.data
FontName db "roman",0
gameTitle db "Welcome to XinyiRun!"
startTitle db "Start"
helpTitle db "Help"
exitTitle db "Exit"
.code
DrawProc PROC hDC:DWORD

    .IF scene == 0
        invoke DrawStartMenu,hDC
    .ELSEIF scene == 1
        invoke DrawHelpWin,hDC
    .ELSEIF scene == 2

        invoke DrawGamePlayWin,hDC
    .ELSEIF scene == 3
        invoke DrawGameOverWin,hDC
    .ELSE
        invoke DrawErrorWin,hDC
    .ENDIF
    ret
DrawProc ENDP

DrawStartMenu PROC hDC:DWORD
    invoke DrawBackground,hDC,100
    .IF selected_menu == 0
        invoke DrawPictureTransparent,hDC,111,250,150,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,120,250,220,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,130,250,290,120,60,0ffffffh
    .ELSEIF selected_menu == 1
        invoke DrawPictureTransparent,hDC,110,250,150,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,121,250,220,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,130,250,290,120,60,0ffffffh
    .ELSEIF selected_menu == 2
        invoke DrawPictureTransparent,hDC,110,250,150,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,120,250,220,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,131,250,290,120,60,0ffffffh
    .ENDIF
    ; invoke DrawTextF,hDC,50,26,700,00000ffh,50,50,ADDR gameTitle,SIZEOF gameTitle
    ; invoke DrawTextF,hDC,30,19,700,000ffffh,250,180,ADDR startTitle,SIZEOF startTitle
    ; invoke DrawTextF,hDC,30,19,700,000ffffh,250,240,ADDR helpTitle,SIZEOF helpTitle
    ; invoke DrawTextF,hDC,30,19,700,000ffffh,250,300,ADDR exitTitle,SIZEOF exitTitle
    ret
DrawStartMenu ENDP

DrawHelpWin PROC hDC:DWORD
    invoke DrawBackground,hDC,300
    ret
DrawHelpWin ENDP  

DrawGamePlayWin PROC hDC:DWORD
    invoke DrawBackground,hDC,300
    ret
DrawGamePlayWin ENDP

DrawGameOverWin PROC hDC:DWORD

    ret
DrawGameOverWin ENDP

DrawErrorWin PROC hDC:DWORD

    ret
DrawErrorWin ENDP

DrawBackground PROC hDC:DWORD,ID:DWORD
    LOCAL rect:RECT
    invoke GetClientRect,hWnd,addr rect
    invoke DrawPictureNormal,hDC,ID,0,0,rect.right,rect.bottom
    ret
DrawBackground ENDP

DrawTextF PROC hDC:DWORD,font_wid:DWORD,font_hei:DWORD,bold:DWORD,text_color:DWORD,text_posX:DWORD,text_posY:DWORD,text_addr:DWORD,text_size:DWORD
    LOCAL hFont     :DWORD
    LOCAL hFontOld  :DWORD 
    invoke CreateFont,font_wid,font_hei,0,0,bold,0,0,0,DEFAULT_CHARSET,\
                            OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
                            DEFAULT_QUALITY,DEFAULT_PITCH or FF_ROMAN,\
                            ADDR FontName
    mov hFont, eax
    invoke SelectObject,hDC,hFont
    mov hFontOld, eax
    ;RGB    200,200,50
    invoke SetTextColor,hDC,text_color
    ; RGB    0,0,255
    ; invoke SetBkColor,hDC,eax
    invoke SetBkMode,hDC,TRANSPARENT
    invoke TextOut,hDC,text_posX,text_posY,text_addr,text_size
    invoke SelectObject,hDC,hFontOld
    invoke DeleteObject, hFont    
    ret
DrawTextF ENDP

DrawPictureNormal PROC hDC:DWORD,ID:DWORD,posX:DWORD,posY:DWORD,wid:DWORD,hei:DWORD
    LOCAL hBmpsource:DWORD
    LOCAL hDCback:DWORD
    invoke CreateCompatibleDC,hDC
    mov hDCback,eax
    invoke LoadImage,hInstance,ID,IMAGE_BITMAP,0,0,LR_LOADTRANSPARENT or LR_LOADMAP3DCOLORS
    mov hBmpsource,eax
    invoke SelectObject,hDCback,hBmpsource
    invoke BitBlt,hDC,posX,posY,wid,hei,hDCback,0,0,SRCCOPY
    invoke DeleteObject,hBmpsource
    invoke DeleteDC,hDCback
    ret
DrawPictureNormal ENDP

DrawPictureTransparent PROC hDC:DWORD,ID:DWORD,posX:DWORD,posY:DWORD,wid:DWORD,hei:DWORD,color:DWORD
    LOCAL hBmpsource:DWORD
    LOCAL hDCback:DWORD
    invoke CreateCompatibleDC,hDC
    mov hDCback,eax
    invoke LoadImage,hInstance,ID,IMAGE_BITMAP,0,0,LR_LOADTRANSPARENT or LR_LOADMAP3DCOLORS
    mov hBmpsource,eax
    invoke SelectObject,hDCback,hBmpsource
    invoke TransparentBlt,hDC,posX,posY,wid,hei,hDCback,0,0,wid,hei,color
    invoke DeleteObject,hBmpsource
    invoke DeleteDC,hDCback
    ret
DrawPictureTransparent ENDP

DrawALine PROC hDC:DWORD,posX1:DWORD,posY1:DWORD,posX2:DWORD,posY2:DWORD,line_style:DWORD,line_width:DWORD,line_color:DWORD
    LOCAL hPen      :DWORD
    LOCAL hPenOld   :DWORD
    INVOKE CreatePen, line_style, line_width, line_color
    mov hPen, eax 
    invoke SelectObject,hDC,hPen
    mov hPenOld, eax  
    invoke MoveToEx,hDC,posX1,posY1,NULL
    invoke LineTo,hDC,posX2,posY2
    invoke SelectObject, hDC, hPenOld
    invoke DeleteObject, hPen
    ret         
DrawALine ENDP 

; shape = 1 --> Draw a Rectangle
; shape = 2 --> Draw a Ellipse
; shape = 3 --> Draw a Rectangle with Round
;               need to point out round width and round height
DrawAShape PROC hDC:DWORD,shape:DWORD,posX1:DWORD,posY1:DWORD,posX2:DWORD,posY2:DWORD,shape_color:DWORD,edge_color:DWORD,round_width:DWORD,round_height:DWORD
    LOCAL hPen      :DWORD
    LOCAL hPenOld   :DWORD
    LOCAL hBrush    :DWORD
    LOCAL hBrushOld :DWORD
    LOCAL lb        :LOGBRUSH
    INVOKE CreatePen, 0, 1,edge_color
    mov hPen, eax
    mov lb.lbStyle, BS_SOLID
    mov lb.lbHatch, NULL
    push ebx
    mov ebx,shape_color
    mov lb.lbColor, ebx
    pop ebx
    INVOKE CreateBrushIndirect, ADDR lb
    mov hBrush, eax
    invoke SelectObject,hDC,hPen
    mov hPenOld, eax
    invoke SelectObject,hDC,hBrush
    mov hBrushOld, eax

    .IF shape==1
        invoke Rectangle,hDC,posX1,posY1,posX2,posY2
    .ELSEIF shape==2
        invoke Ellipse,hDC,posX1,posY1,posX2,posY2
    .ELSEIF shape==3
        invoke RoundRect,hDC,posX1,posY1,posX2,posY2,round_width,round_height
    .ENDIF
 
    invoke SelectObject, hDC, hBrushOld
    invoke DeleteObject, hBrush

    invoke SelectObject, hDC, hPenOld
    invoke DeleteObject, hPen    
    ret
DrawAShape ENDP

END