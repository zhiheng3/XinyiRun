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
DrawPilars       PROTO hDC:DWORD
DrawPictureNormal      PROTO hDC:DWORD,ID:DWORD,posX:DWORD,posY:DWORD,wid:DWORD,hei:DWORD
DrawPictureTransparent PROTO hDC:DWORD,ID:DWORD,posXD:DWORD,posYD:DWORD,posXS:DWORD,posYS:DWORD,wid:DWORD,hei:DWORD,color:DWORD
DrawTextF              PROTO hDC:DWORD,font_wid:DWORD,font_hei:DWORD,bold:DWORD,text_color:DWORD,text_posX:DWORD,text_posY:DWORD,text_addr:DWORD,text_size:DWORD
DrawALine              PROTO hDC:DWORD,posX1:DWORD,posY1:DWORD,posX2:DWORD,posY2:DWORD,line_style:DWORD,line_width:DWORD,line_color:DWORD
DrawAShape             PROTO hDC:DWORD,shape:DWORD,posX:DWORD,posY:DWORD,rect_width:DWORD,rect_height:DWORD,rect_color:DWORD,edge_color:DWORD,round_width:DWORD,round_height:DWORD
DrawPlayer             PROTO hDC:DWORD
DrawNumber             PROTO hDC:DWORD,num:DWORD,num_posX:DWORD,num_posY:DWORD,num_width:DWORD,num_height:DWORD

.data
FontName db "roman",0
basePoxY DWORD 380
pilarPosY1 DWORD 280
baseHeight DWORD 20
playerHeight DWORD 50
playerWidth DWORD 36
freq DWORD 6
score_array_norder DWORD 10 DUP(?)
score_array_order DWORD 10 DUP(?)
score_num DWORD 0
deci DWORD 10
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
        invoke DrawPictureTransparent,hDC,111,250,150,0,0,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,120,250,220,0,0,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,130,250,290,0,0,120,60,0ffffffh
    .ELSEIF selected_menu == 1
        invoke DrawPictureTransparent,hDC,110,250,150,0,0,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,121,250,220,0,0,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,130,250,290,0,0,120,60,0ffffffh
    .ELSEIF selected_menu == 2
        invoke DrawPictureTransparent,hDC,110,250,150,0,0,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,120,250,220,0,0,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,131,250,290,0,0,120,60,0ffffffh
    .ENDIF
    ret
DrawStartMenu ENDP

DrawHelpWin PROC hDC:DWORD
    invoke DrawBackground,hDC,300
    ret
DrawHelpWin ENDP  

DrawGamePlayWin PROC hDC:DWORD
    LOCAL rect:RECT
    invoke GetClientRect,hWnd,addr rect
    invoke DrawBackground,hDC,300
    push eax
    mov eax,basePoxY
    add eax,baseHeight
    invoke DrawAShape,hDC,1,0,basePoxY,rect.right,eax,0000000h,0000000h,0,0
    pop eax
    invoke DrawPilars,hDC
    invoke DrawPlayer,hDC
    ret
DrawGamePlayWin ENDP

DrawGameOverWin PROC hDC:DWORD

    ret
DrawGameOverWin ENDP

DrawErrorWin PROC hDC:DWORD

    ret
DrawErrorWin ENDP

DrawPilars PROC hDC:DWORD
    LOCAL structSize: DWORD
    pusha
    mov structSize, TYPE pilars
    mov esi, 0
    mov ecx,PILAR_NUM
DrawP:
    invoke DrawAShape,hDC,1,pilars[esi].start_x,pilarPosY1,pilars[esi].end_x,basePoxY,0111111h,0111111h,0,0
    add esi, structSize
    Loop DrawP  
    popa
    ret
DrawPilars ENDP

DrawBackground PROC hDC:DWORD,ID:DWORD
    LOCAL rect:RECT
    invoke GetClientRect,hWnd,addr rect
    invoke DrawPictureNormal,hDC,ID,0,0,rect.right,rect.bottom
    ret
DrawBackground ENDP

DrawTextF PROC hDC:DWORD,font_wid:DWORD,font_hei:DWORD,bold:DWORD,text_color:DWORD,text_posX:DWORD,text_posY:DWORD,text_addr:DWORD,text_size:DWORD
    LOCAL hFont     :DWORD
    LOCAL hFontOld  :DWORD 
    pusha
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
    popa 
    ret
DrawTextF ENDP

DrawPictureNormal PROC hDC:DWORD,ID:DWORD,posX:DWORD,posY:DWORD,wid:DWORD,hei:DWORD
    LOCAL hBmpsource:DWORD
    LOCAL hDCback:DWORD
    pusha
    invoke CreateCompatibleDC,hDC
    mov hDCback,eax
    invoke LoadImage,hInstance,ID,IMAGE_BITMAP,0,0,LR_LOADTRANSPARENT or LR_LOADMAP3DCOLORS
    mov hBmpsource,eax
    invoke SelectObject,hDCback,hBmpsource
    invoke BitBlt,hDC,posX,posY,wid,hei,hDCback,0,0,SRCCOPY
    invoke DeleteObject,hBmpsource
    invoke DeleteDC,hDCback
    popa
    ret
DrawPictureNormal ENDP

DrawPictureTransparent PROC hDC:DWORD,ID:DWORD,posXD:DWORD,posYD:DWORD,posXS:DWORD,posYS:DWORD,wid:DWORD,hei:DWORD,color:DWORD
    LOCAL hBmpsource:DWORD
    LOCAL hDCback:DWORD
    pusha
    invoke CreateCompatibleDC,hDC
    mov hDCback,eax
    invoke LoadImage,hInstance,ID,IMAGE_BITMAP,0,0,LR_LOADTRANSPARENT or LR_LOADMAP3DCOLORS
    mov hBmpsource,eax
    invoke SelectObject,hDCback,hBmpsource
    invoke TransparentBlt,hDC,posXD,posYD,wid,hei,hDCback,posXS,posYS,wid,hei,color
    invoke DeleteObject,hBmpsource
    invoke DeleteDC,hDCback
    popa
    ret
DrawPictureTransparent ENDP

DrawALine PROC hDC:DWORD,posX1:DWORD,posY1:DWORD,posX2:DWORD,posY2:DWORD,line_style:DWORD,line_width:DWORD,line_color:DWORD
    LOCAL hPen      :DWORD
    LOCAL hPenOld   :DWORD
    pusha
    INVOKE CreatePen, line_style, line_width, line_color
    mov hPen, eax 
    invoke SelectObject,hDC,hPen
    mov hPenOld, eax  
    invoke MoveToEx,hDC,posX1,posY1,NULL
    invoke LineTo,hDC,posX2,posY2
    invoke SelectObject, hDC, hPenOld
    invoke DeleteObject, hPen
    popa
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
    pusha
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
    popa  
    ret
DrawAShape ENDP

DrawPlayer PROC hDC:DWORD
    ;LOCAL frequency:DWORD
    LOCAl posX:DWORD
    LOCAl posY:DWORD
    LOCAl picStartX:DWORD
    pusha
    mov eax,player_x
    mov posX,eax

    mov ebx,pilarPosY1
    sub ebx,playerHeight

    mov posY,ebx

    xor edx,edx
    xor eax,eax
    mov eax,player_f

    div freq
    ;mov frequency,edx

    imul edx,playerWidth
    mov picStartX,edx
    invoke DrawPictureTransparent,hDC,301,posX,posY,picStartX,0,playerWidth,playerHeight,0ffffffh
    popa
    ret
DrawPlayer ENDP

DrawNumber PROC hDC:DWORD,num:DWORD,num_posX:DWORD,num_posY:DWORD,num_width:DWORD,num_height:DWORD
    pusha


    popa
    ret
DrawNumber ENDP 

ParseNumber PROC num:DWORD
    pusha
    xor ebx,ebx
    xor edx,edx
    xor eax,eax
    mov eax,num   
p1:
    div deci
    mov [esi],edx
    add esi,TYPE score_array_norder
    add ebx,1
        jmp pout
    .ENDIF
    xor edx,edx
    jmp p1 
pout:       
    mov score_num,ebx
    popa
    ret
ParseNumber ENDP 

PutNumInOrder PROC
    pusha
    push eax
    mov eax,score_num
    imul eax,TYPE score_array_norder
    sub eax,TYPE score_array_norder
    add edi,eax
    pop eax
    mov ecx,score_num
put1:
    mov ebx,[edi]
    mov [esi],ebx
    add esi,TYPE score_array_order
    sub edi,TYPE score_array_norder
    Loop put1    
    popa
    ret
PutNumInOrder ENDP
END