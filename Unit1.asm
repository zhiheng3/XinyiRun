.686p                       ; create 32 bit code

;include \masm32\INCLUDE\masm32.inc
include \masm32\include\masm32rt.inc
include \masm32\macros/macros.asm

HEIGHT = 60
PILAR_RANDOM_RANGE_START = 20
PILAR_RANDOM_RANGE_END = 100
GAP_RANDOM_RANGE_START = 20
GAP_RANDOM_RANGE_END = 200

Pilar STRUCT
    start_x DWORD 0;Start x-coor
    end_x DWORD 0;End x-coor
    height DWORD 0;Height of pilar
Pilar ENDS

.data
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
random_seed DWORD ?

.code

start:
call main
inkey
exit

;Get random number between first and second parameter
;The result is in eax
Random   proc uses ecx edx,
    first:DWORD, second:DWORD
   ;INVOKE GetCycleCount
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
   mov random_seed, eax
   ret
Random   endp

;Pilars operation

;Insert a random pilar ranged from 20 to 100 to pilars[4]
InsertPilar PROC USES eax ebx ecx edx esi
    local structSize: DWORD
    mov structSize, TYPE pilars
    mov esi, 0
    mov ecx, 5
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
    INVOKE Random, PILAR_RANDOM_RANGE_START, PILAR_RANDOM_RANGE_END
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

;Initial the pilars array which length is 5
InitialPilar PROC USES ecx
    mov ecx, 5

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
    mov ecx, 5
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
MovePilar PROC USES ecx esi
    local structSize: DWORD
    mov esi, 0
    mov ecx, 5
    mov structSize, TYPE pilars

    L1:
    .IF pilars[esi].start_x != 0
        dec pilars[esi].start_x
    .ENDIF

    .IF pilars[esi].end_x != 0
        dec pilars[esi].end_x
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
    ;printf("y0*175:%d\n", eax)
    mov temp, eax
    mov eax, x0
    mov ecx, 9998
    mul ecx
    ;printf("x0*9998:%d\n", eax)
    add eax, temp
    ;printf("x1:%d\n", eax)
    div divisor
    mov pole_x1, eax
    ;printf("x1:%d\n", x1)

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
    ;printf("y1:%d\n", pole_y1)

    ret
RotatePole ENDP

main PROC
    cls
    ;print "Hello World",13,10
    INVOKE GetTickCount
    mov random_seed, eax
    
    INVOKE RotatePole, 19,70
    printf("%d\n", pole_x1)
    printf("%d\n", pole_y1)

    ;mov ecx, 5
    ;mov esi, 0
    ;L1:
    ;push ecx
    ;;printf("%d\n", ecx)
    ;printf("%d\n", pilars[esi].start_x)
    ;printf("%d\n", pilars[esi].end_x)
    ;printf("%d\n", pilars[esi].height)
    ;printf("\n")
    ;add esi, TYPE pilars
    ;pop ecx
    ;loop L1

    ;push ecx
    ;printf ("---------------\n")
    ;pop ecx

    ;INVOKE MovePilar
    ;mov ecx, 5
    ;mov esi, 0
    ;L2:
    ;push ecx
    ;;printf("%d\n", ecx)
    ;printf("%d\n", pilars[esi].start_x)
    ;printf("%d\n", pilars[esi].end_x)
    ;printf("%d\n", pilars[esi].height)
    ;printf("\n")
    ;add esi, TYPE pilars
    ;pop ecx
    ;loop L2

    ret
main ENDP

END start