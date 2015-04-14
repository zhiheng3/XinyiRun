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
DrawPlayer       PROTO hDC:DWORD
DrawPole         PROTO hDC:DWORD
DrawPictureNormal      PROTO hDC:DWORD,ID:DWORD,posX:DWORD,posY:DWORD,wid:DWORD,hei:DWORD
DrawPictureTransparent PROTO hDC:DWORD,ID:DWORD,posXD:DWORD,posYD:DWORD,posXS:DWORD,posYS:DWORD,widD:DWORD,heiD:DWORD,widS:DWORD,heiS:DWORD,color:DWORD
DrawTextF              PROTO hDC:DWORD,font_wid:DWORD,font_hei:DWORD,bold:DWORD,text_color:DWORD,text_posX:DWORD,text_posY:DWORD,text_addr:DWORD,text_size:DWORD
DrawALine              PROTO hDC:DWORD,posX1:DWORD,posY1:DWORD,posX2:DWORD,posY2:DWORD,line_style:DWORD,line_width:DWORD,line_color:DWORD
DrawAShape             PROTO hDC:DWORD,shape:DWORD,posX:DWORD,posY:DWORD,rect_width:DWORD,rect_height:DWORD,rect_color:DWORD,edge_color:DWORD,round_width:DWORD,round_height:DWORD
DrawNumberArray        PROTO hDC:DWORD,num:DWORD,start_posX:DWORD,start_posY:DWORD,numD_width:DWORD,numD_height:DWORD,color:DWORD
DrawANumber            PROTO hDC:DWORD,numSingle:DWORD,num_posX:DWORD,num_posY:DWORD,numD_width:DWORD,numD_height:DWORD,color:DWORD
ParseNumber            PROTO num:DWORD
PutNumInOrder          PROTO
.data
FontName db "roman",0
basePosY DWORD 380
pilarPosY1 DWORD 280
baseHeight DWORD 20
playerHeightS DWORD 57
playerWidthS DWORD 70
playerHeightD DWORD 40
playerWidthD DWORD 49
freq DWORD 7
score_array_norder DWORD 10 DUP(?)
score_array_order DWORD 10 DUP(?)
score_num DWORD 0
deci DWORD 10
numS_width DWORD 118
numS_height DWORD 236
numberoffset DWORD 80

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
        invoke DrawPictureTransparent,hDC,111,250,150,0,0,120,60,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,120,250,220,0,0,120,60,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,130,250,290,0,0,120,60,120,60,0ffffffh
    .ELSEIF selected_menu == 1
        invoke DrawPictureTransparent,hDC,110,250,150,0,0,120,60,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,121,250,220,0,0,120,60,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,130,250,290,0,0,120,60,120,60,0ffffffh
    .ELSEIF selected_menu == 2
        invoke DrawPictureTransparent,hDC,110,250,150,0,0,120,60,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,120,250,220,0,0,120,60,120,60,0ffffffh
        invoke DrawPictureTransparent,hDC,131,250,290,0,0,120,60,120,60,0ffffffh
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
    mov eax,basePosY
    add eax,baseHeight
    invoke DrawAShape,hDC,1,0,basePosY,rect.right,eax,0000000h,0000000h,0,0
    pop eax
    invoke DrawPilars,hDC
    invoke DrawPlayer,hDC
    invoke DrawPole,hDC
    invoke DrawNumberArray,hDC,score,325,20,20,30,0ffffffh
    .IF life > 99
        invoke DrawNumberArray,hDC,99,220,55,16,24,0ffffffh
    .ELSE
        invoke DrawNumberArray,hDC,life,220,55,16,24,0ffffffh
    .ENDIF
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
    invoke DrawAShape,hDC,1,pilars[esi].start_x,pilarPosY1,pilars[esi].end_x,basePosY,0111111h,0111111h,0,0
    add esi, structSize
    Loop DrawP  
    popa
    ret
DrawPilars ENDP

DrawPole PROC hDC:DWORD
    pusha
    mov eax,basePosY
    sub eax,pole_y0
    mov ebx,basePosY
    sub ebx,pole_y1
    invoke DrawALine,hDC,pole_x0,eax,pole_x1,ebx,PS_SOLID,2,0000000h
    popa
    ret
DrawPole ENDP

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

DrawPictureTransparent PROC hDC:DWORD,ID:DWORD,posXD:DWORD,posYD:DWORD,posXS:DWORD,posYS:DWORD,widD:DWORD,heiD:DWORD,widS:DWORD,heiS:DWORD,color:DWORD
    LOCAL hBmpsource:DWORD
    LOCAL hDCback:DWORD
    pusha
    invoke CreateCompatibleDC,hDC
    mov hDCback,eax
    invoke LoadImage,hInstance,ID,IMAGE_BITMAP,0,0,LR_LOADTRANSPARENT or LR_LOADMAP3DCOLORS
    mov hBmpsource,eax
    invoke SelectObject,hDCback,hBmpsource
    invoke TransparentBlt,hDC,posXD,posYD,widD,heiD,hDCback,posXS,posYS,widS,heiS,color
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

    mov ebx,basePosY
    sub ebx,player_y
    sub ebx,playerHeightD


    mov posY,ebx

    xor edx,edx
    xor eax,eax
    mov eax,player_f

    div freq
    ;mov frequency,edx
    .IF edx==0
        invoke DrawPictureTransparent,hDC,362,posX,posY,0,0,17,playerHeightD,21,57,0ffffffh
    .ELSE
        sub edx,1
        imul edx,playerWidthS
        mov picStartX,edx
        invoke DrawPictureTransparent,hDC,361,posX,posY,picStartX,0,playerWidthD,playerHeightD,playerWidthS,playerHeightS,0ffffffh
    .ENDIF
 
    popa
    ret
DrawPlayer ENDP

DrawNumberArray PROC hDC:DWORD,num:DWORD,start_posX:DWORD,start_posY:DWORD,numD_width:DWORD,numD_height:DWORD,color:DWORD
    pusha
    invoke ParseNumber,num
    invoke PutNumInOrder
    mov ecx,score_num
    mov esi,offset score_array_order

    mov eax,start_posX
DrawNumL:
    mov ebx,[esi]
    invoke DrawANumber,hDC,ebx,eax,start_posY,numD_width,numD_height,color
    add eax,numD_width
    add eax,5
    add esi,TYPE score_array_order
    Loop DrawNumL    
    popa
    ret
DrawNumberArray ENDP

DrawANumber PROC hDC:DWORD,numSingle:DWORD,num_posX:DWORD,num_posY:DWORD,numD_width:DWORD,numD_height:DWORD,color:DWORD
    pusha
    mov eax,numSingle
    add eax,10
    mov ebx,numS_height
    sub ebx,numberoffset
    invoke DrawPictureTransparent,hDC,eax,num_posX,num_posY,0,numberoffset,numD_width,numD_height,numS_width,ebx,color
    popa
    ret
DrawANumber ENDP 

ParseNumber PROC num:DWORD
    pusha
    xor ebx,ebx
    mov esi,OFFSET score_array_norder
    xor edx,edx
    xor eax,eax
    mov eax,num   
p1:
    div deci
    mov [esi],edx
    add esi,TYPE score_array_norder
    add ebx,1
    .IF eax==0
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
    mov edi,OFFSET score_array_norder
    mov esi,OFFSET score_array_order
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