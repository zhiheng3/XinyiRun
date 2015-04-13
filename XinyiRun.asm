; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい
;                                Build this project with MAKEIT.BAT
; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    ; __UNICODE__ equ 1           ; uncomment to build as UNICODE

    .686p                       ; create 32 bit code
    .mmx                        ; enable MMX instructions
    .xmm                        ; enable SSE instructions
    .model flat, stdcall        ; 32 bit memory model
    option casemap :none        ; case sensitive

    include XinyiRun.inc         ; local includes for this file
    include Vars.inc
    ;include Irvine32.inc

;Vars defination

.data?
    hInstance      DWORD ?
    hWnd           DWORD ?
    hIcon          DWORD ?
    hCursor        DWORD ?
    CommandLine    DWORD ?
    sWid           DWORD ?
    sHgt           DWORD ?
    hTimer         DWORD ?

.data

;test vars
frames DWORD 0
speed DWORD 1
ellipse MyEllipse <300,200>
deltaX SDWORD 0
deltaY SDWORD 0

;Public vars defination
scene DWORD 0
;Scene 0
selected_menu DWORD 0
;Scene 2
pilars Pilar 5 DUP(<0, 0, 0>)
player_x DWORD 0
player_y DWORD 0
pole_x0 DWORD 0
pole_y0 DWORD 0
pole_x1 DWORD 0
pole_y1 DWORD 0
life DWORD 0
score DWORD 0
total_bonus DWORD 0
add_bonus DWORD 0
;Scene 3
high_score DWORD 0

;Random vars defination
random_seed DWORD ?

;Timer vars defination
dueTime FILETIME <-1, -1>
period DWORD 10

.code

start:

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

  ; ------------------
  ; set global values
  ; ------------------
    mov hInstance,   rv(GetModuleHandle, NULL)
    mov CommandLine, rv(GetCommandLine)
    mov hIcon,       rv(LoadIcon,hInstance,500)
    mov hCursor,     rv(LoadCursor,NULL,IDC_ARROW)
    mov sWid,        rv(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,        rv(GetSystemMetrics,SM_CYSCREEN)

    call Main

    invoke ExitProcess,eax

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

Main proc

    LOCAL Wwd:DWORD,Wht:DWORD,Wtx:DWORD,Wty:DWORD,mWid:DWORD
    LOCAL wc:WNDCLASSEX
    LOCAL icce:INITCOMMONCONTROLSEX

  ; --------------------------------------
  ; comment out the styles you don't need.
  ; --------------------------------------
    mov icce.dwSize, SIZEOF INITCOMMONCONTROLSEX            ; set the structure size
    xor eax, eax                                            ; set EAX to zero

    or eax, ICC_BAR_CLASSES                                 ; toolbar & status bar
    or eax, ICC_WIN95_CLASSES

 ;     or eax, ICC_ANIMATE_CLASS                               ; OR as many styles as you need to it
 ;     or eax, ICC_COOL_CLASSES
 ;     or eax, ICC_DATE_CLASSES
 ;     or eax, ICC_HOTKEY_CLASS
 ;     or eax, ICC_INTERNET_CLASSES
 ;     or eax, ICC_LISTVIEW_CLASSES
 ;     or eax, ICC_PAGESCROLLER_CLASS
 ;     or eax, ICC_PROGRESS_CLASS
 ;     or eax, ICC_TAB_CLASSES
 ;     or eax, ICC_TREEVIEW_CLASSES
 ;     or eax, ICC_UPDOWN_CLASS
 ;     or eax, ICC_USEREX_CLASSES

  ; --------------------------------------------
  ; NOTE : It is marginally more efficient to OR
  ; required styles together at assembly time.
  ; --------------------------------------------

    mov icce.dwICC, eax
    invoke InitCommonControlsEx,ADDR icce                   ; initialise the common control library
  ; --------------------------------------

    STRING szClassName,   "Application_Class"
    STRING szDisplayName, "Xinyi Run"

  ; ---------------------------------------------------
  ; set window class attributes in WNDCLASSEX structure
  ; ---------------------------------------------------
    mov wc.cbSize,         sizeof WNDCLASSEX
    mov wc.style,          CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW
    m2m wc.lpfnWndProc,    OFFSET WndProc
    mov wc.cbClsExtra,     NULL
    mov wc.cbWndExtra,     NULL
    m2m wc.hInstance,      hInstance
    m2m wc.hbrBackground,  COLOR_BTNFACE+1
    mov wc.lpszMenuName,   NULL
    mov wc.lpszClassName,  OFFSET szClassName
    m2m wc.hIcon,          hIcon
    m2m wc.hCursor,        hCursor
    m2m wc.hIconSm,        hIcon

  ; ------------------------------------
  ; register class with these attributes
  ; ------------------------------------
    invoke RegisterClassEx, ADDR wc

  ; ---------------------------------------------
  ; set width and height as percentages of screen
  ; ---------------------------------------------
  ;  invoke GetPercent,sWid,70
    mov Wwd, 640
  ;  invoke GetPercent,sHgt,70
    mov Wht, 480

  ; ----------------------
  ; set aspect ratio limit
  ; ----------------------
    FLOAT4 aspect_ratio, 1.4    ; set the maximum startup aspect ratio

    fild Wht                    ; load source
    fld aspect_ratio            ; load multiplier
    fmul                        ; multiply source by multiplier
    fistp mWid                  ; store result in variable

    mov eax, Wwd
    .if eax > mWid              ; if the default window width is > aspect ratio
      m2m Wwd, mWid             ; set the width to the maximum aspect ratio
    .endif

  ; ------------------------------------------------
  ; Top X and Y co-ordinates for the centered window
  ; ------------------------------------------------
    mov eax, sWid
    sub eax, Wwd                ; sub window width from screen width
    shr eax, 1                  ; divide it by 2
    mov Wtx, eax                ; copy it to variable

    mov eax, sHgt
    sub eax, Wht                ; sub window height from screen height
    shr eax, 1                  ; divide it by 2
    mov Wty, eax                ; copy it to variable

IF 0  ; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    create the main window with the size and attributes defined above

    WS_OVERLAPPEDWINDOW         = a sizable window with a system menu
    WS_OVERLAPPED               = a fixed size window
    WS_OVERLAPPED or WS_SYSMENU = a fixed window with a system menu

    OR the styles from CreateWindowEx() together to get the window characteristics you require

ENDIF ; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES,
                          ADDR szClassName,
                          ADDR szDisplayName,
                          WS_OVERLAPPED or WS_SYSMENU,
                          Wtx,Wty,Wwd,Wht,
                          NULL,NULL,
                          hInstance,NULL
    mov hWnd,eax

    invoke LoadMenu,hInstance,600
    invoke SetMenu,hWnd,eax

    invoke ShowWindow,hWnd, SW_SHOWNORMAL
    invoke UpdateWindow,hWnd

    call MsgLoop
    ret

Main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

MsgLoop proc

    LOCAL msg:MSG
    push eax
    push ebx
    lea ebx, msg

    INVOKE InitGame

    ;Create Timer
    INVOKE CreateWaitableTimer, NULL, FALSE, NULL
    mov hTimer, eax
    INVOKE SetWaitableTimer, hTimer, ADDR dueTime, period, NULL, NULL, 0
msgloop:
    INVOKE  WaitForSingleObject, hTimer, 0
    .IF eax == WAIT_OBJECT_0
        ;Game Process
        INVOKE GameProc
        INVOKE InvalidateRect, hWnd, NULL, FALSE
        jmp msgloop
    .ELSE
        ;PeekMessage
        INVOKE PeekMessage, ebx, 0, 0, 0, PM_REMOVE
        test eax, eax
        jz msgloop
        .IF msg.message == WM_QUIT
            jmp quit
        .ENDIF
        INVOKE TranslateMessage, ebx
        INVOKE DispatchMessage,  ebx
        jmp msgloop
    .ENDIF

quit:
    INVOKE CloseHandle, hTimer
    ;INVOKE MsgboxI, NULL, testtext, testtext, MB_OK, 0
    pop ebx
    pop eax
    ret

MsgLoop endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

WndProc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD

    LOCAL var    :DWORD
    LOCAL caW    :DWORD
    LOCAL caH    :DWORD
    LOCAL fname  :DWORD
    LOCAL opatn  :DWORD
    LOCAL spatn  :DWORD
    LOCAL rect    :RECT
    LOCAL buffer1[260]:TCHAR ; these are two spare buffers
    LOCAL buffer2[260]:TCHAR ; for text manipulation etc..
    LOCAL hDC    :DWORD
    LOCAL Ps     :PAINTSTRUCT
    LOCAL hMemDC :DWORD
    LOCAL hBmp   :DWORD

    Switch uMsg
        case WM_KEYDOWN
            INVOKE KeydownProc, wParam
            .IF eax == 1
                INVOKE SendMessage, hWin, WM_SYSCOMMAND, SC_CLOSE, NULL
            .ENDIF
            return 0
        case WM_KEYUP
            INVOKE KeyupProc, wParam
            return 0
        case WM_COMMAND
        ; -------------------------------------------------------------------
            switch wParam
                case 1999
app_close:
            invoke SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
            endsw
      ; -------------------------------------------------------------------

      case WM_DROPFILES
      ; --------------------------
      ; process dropped files here
      ; --------------------------
        mov fname, DropFileName(wParam)
        fn MsgboxI,hWin,fname,"WM_DROPFILES",MB_OK,500
        return 0

      case WM_CREATE

      case WM_SIZE

      case WM_PAINT ;Refresh
        INVOKE BeginPaint, hWin, ADDR Ps
        mov hDC, eax

        invoke GetClientRect,hWnd,addr rect
        invoke CreateCompatibleDC,hDC
        mov hMemDC,eax
        invoke CreateCompatibleBitmap,hDC,rect.right,rect.bottom
        mov hBmp,eax
        invoke SelectObject,hMemDC,hBmp
        INVOKE DrawProc,hMemDC        
        invoke BitBlt,hDC,0,0,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY
        invoke DeleteObject,hBmp
        invoke DeleteDC,hMemDC

        INVOKE EndPaint, hWin, ADDR Ps
        return 0

      case WM_CLOSE
      ; -----------------------------
      ; perform any required cleanups
      ; here before closing.
      ; -----------------------------

      case WM_DESTROY
        invoke PostQuitMessage,NULL
        return 0

    Endsw

    invoke DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

MsgboxI proc hParent:DWORD,pText:DWORD,pTitle:DWORD,mbStyle:DWORD,IconID:DWORD

    LOCAL mbp   :MSGBOXPARAMS

    or mbStyle, MB_USERICON

    mov mbp.cbSize,             SIZEOF mbp
    m2m mbp.hwndOwner,          hParent
    mov mbp.hInstance,          rv(GetModuleHandle,0)
    m2m mbp.lpszText,           pText
    m2m mbp.lpszCaption,        pTitle
    m2m mbp.dwStyle,            mbStyle
    m2m mbp.lpszIcon,           IconID
    mov mbp.dwContextHelpId,    NULL
    mov mbp.lpfnMsgBoxCallback, NULL
    mov mbp.dwLanguageId,       NULL

    invoke MessageBoxIndirect,ADDR mbp

    ret

MsgboxI endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

end start
