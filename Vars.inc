;vars.inc
;Define the public variables
EXTERNDEF hInstance:DWORD,hWnd:DWORD,hIcon:DWORD,hCursor:DWORD,CommandLine:DWORD,sWid:DWORD,sHgt:DWORD,hTimer:DWORD
;test vars
MyEllipse STRUCT
	x DWORD 0
	y DWORD 0
MyEllipse ENDS

EXTERNDEF deltaX:SDWORD,
          deltaY:SDWORD,
          speed:DWORD,
          frames:DWORD,
          ellipse:MyEllipse

;Structure
Pilar STRUCT
	start_x DWORD 0;Start x-coor
	end_x DWORD 0;End x-coor
	height DWORD 0;Height of pilar
Pilar ENDS
;Public vars

EXTERNDEF scene:DWORD, random_seed:DWORD ;Scene number, 0:Start, 1:Help, 2:Game, 3:Gameover

;Scene 0
EXTERNDEF selected_menu:DWORD ;0:Start, 1:Help, 2:Exit

;Scene 2
EXTERNDEF pilars:Pilar, ;Array of pilars
          player_x:DWORD, ;Player position x-coor
          player_y:DWORD, ;Player position y-coor
          pole_x0:DWORD, ;Pole left x-coor
          pole_y0:DWORD, ;Pole left y-coor
          pole_x1:DWORD, ;Pole right x-coor
          pole_y1:DWORD, ;Pole right y-coor
          life:DWORD, ;Remain lives
          score:DWORD, ;Current score
          total_bonus:DWORD, ;Current bonus(Could be accumulated)
          add_bonus:DWORD ;Latest bonus

;Scene 3
EXTERNDEF high_score:DWORD ;Highest score stored



