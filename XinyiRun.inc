; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

;     include files
;     ~~~~~~~~~~~~~
      include \masm32\INCLUDE\windows.inc
      include \masm32\INCLUDE\masm32.inc
      include \masm32\INCLUDE\gdi32.inc
      include \masm32\INCLUDE\user32.inc
      include \masm32\INCLUDE\kernel32.inc
      include \masm32\INCLUDE\Comctl32.inc
      include \masm32\INCLUDE\comdlg32.inc
      include \masm32\INCLUDE\shell32.inc
      include \masm32\INCLUDE\oleaut32.inc
      include \masm32\INCLUDE\msvcrt.inc
      include \masm32\INCLUDE\msimg32.inc

      include \masm32\macros\macros.asm

;     libraries
;     ~~~~~~~~~
      includelib \masm32\LIB\masm32.lib
      includelib \masm32\LIB\gdi32.lib
      includelib \masm32\LIB\user32.lib
      includelib \masm32\LIB\kernel32.lib
      includelib \masm32\LIB\Comctl32.lib
      includelib \masm32\LIB\comdlg32.lib
      includelib \masm32\LIB\shell32.lib
      includelib \masm32\LIB\oleaut32.lib
      includelib \masm32\LIB\msvcrt.lib
      includelib \masm32\LIB\msimg32.lib

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

      ; -----------------
      ; Local prototypes
      ; -----------------
        WndProc          PROTO :DWORD,:DWORD,:DWORD,:DWORD
        MsgLoop          PROTO
        Main             PROTO
        MsgboxI          PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD

        DrawProc         PROTO hDC:DWORD
        DrawStartMenu    PROTO hDC:DWORD
        DrawHelpWin      PROTO hDC:DWORD
        DrawGamePlayWin  PROTO hDC:DWORD
        DrawGameOverWin  PROTO hDC:DWORD
        DrawErrorWin     PROTO hDC:DWORD
        DrawBackground   PROTO hDC:DWORD
        DrawPictureNormal      PROTO hDC:DWORD,ID:DWORD,posX:DWORD,posY:DWORD,wid:DWORD,hei:DWORD
        DrawPictureTransparent PROTO hDC:DWORD,ID:DWORD,posX:DWORD,posY:DWORD,wid:DWORD,hei:DWORD,color:DWORD
        DrawTextF              PROTO hDC:DWORD,font_wid:DWORD,font_hei:DWORD,bold:DWORD,text_color:DWORD,text_posX:DWORD,text_posY:DWORD,text_addr:DWORD,text_size:DWORD
        DrawALine              PROTO hDC:DWORD,posX1:DWORD,posY1:DWORD,posX2:DWORD,posY2:DWORD,line_style:DWORD,line_width:DWORD,line_color:DWORD
        DrawAShape             PROTO hDC:DWORD,shape:DWORD,posX:DWORD,posY:DWORD,rect_width:DWORD,rect_height:DWORD,rect_color:DWORD,edge_color:DWORD,round_width:DWORD,round_height:DWORD
        InitGame         PROTO
        GameProc         PROTO
        KeydownProc      PROTO wParam:DWORD
        KeyupProc        PROTO wParam:DWORD