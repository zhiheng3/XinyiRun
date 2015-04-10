.686p                       ; create 32 bit code

;include \masm32\INCLUDE\masm32.inc
include \masm32\include\masm32rt.inc

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

.code

start:
call main
inkey
exit

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

main PROC
	cls
    print "Hello World",13,10
	ret
main ENDP

END start