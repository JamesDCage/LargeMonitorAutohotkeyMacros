; Window manipulation hotkeys
; James Cage 02/27/19
; For use on computers with a single 4k monitor and a keyboard that has a number pad
; Updated 04/27/19 - Added ability to use XButton1 on mouse

; -----------------------------------------------------------------
; Constants

Main_Width := 1850     ; Width of horizontal windows
Doc_Width := 1250      ; Width of window for documents (verticle)
                       ; proportions will be 8.5 x 11
Center_Factor := 1.05  ; Scale up center window to help keep it from being 
                       ; completely covered by other windows.
X_Base_offset := 80    ; I prefer "centered" windows to be moved slightly right
Y_Base_Offset := -30   ; Prefer window slightly above centerline
Overlap := 20          ; Side by side windows overlap slightly to make
                       ; it easier to grab side of window



; -----------------------------------------------------------------
; Functions

; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Turn NumLock back on after moving a window

NumReLock()
{
    if !(GetKeyState("NumLock", "T"))  ; If NumLock is not on ...
		SetNumLockState, On            ; ... then turn it on.
}
	
	
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Given desired window width and height, and offset from center,
; position window on screen

J_Window(W, H, Offset_x, Offset_y)
{

    SysGet, Mon1, Monitor, 1
	WinGetPos,,, Width, Height, A
    Mon1Width := Mon1Right - Mon1Left  ; Should be 3840
    Mon1Height := Mon1Bottom - Mon1Top ; Should be 2160
	
    ; Could include code to scale function arguments in case monitor resolution changes,
	; but will skip for now
	
	W_x := (Mon1Width - W)/2 + Offset_x
	W_y := (Mon1Height - H)/2 + Offset_y
	WinMove, A,, W_x, W_y, W, H
	NumReLock()

	
}
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



; ---------------------------------------------------------------------
; Main Window - 3 x 4
; 5 with Num Lock off

NumPadClear::
    Wanted_Width := Main_Width * Center_Factor
	Wanted_Height := 3 * Wanted_Width / 4
	H_offset := X_Base_offset
	V_offset := Y_Base_Offset
	J_Window(Wanted_Width, Wanted_Height, H_offset, V_offset)

Return

; ---------------------------------------------------------------------
; Main Window - Document view
; 0 with Num Lock off, or
; Shift + 5 with Num Lock off

NumPadIns::
+NumPadClear::
    Wanted_Width := Doc_Width * Center_Factor
	Wanted_Height := 11 * Wanted_Width / 8.5
	H_offset := X_Base_offset
	V_offset := Y_Base_offset
	J_Window(Wanted_Width, Wanted_Height, H_offset, V_offset)

Return

; ---------------------------------------------------------------------
; Main Window Left
; 4 with Num Lock off

NumPadLeft::
    Wanted_Width := Main_Width 
	Wanted_Height := 3 * Wanted_Width / 4
	H_offset := -Wanted_Width / 2 + Overlap + X_Base_offset
	V_offset := Y_Base_Offset
	J_Window(Wanted_Width, Wanted_Height, H_offset, V_offset)

Return

; ---------------------------------------------------------------------
; Main Window Right
; 6 with Num Lock off

NumPadRight::
    Wanted_Width := 1850 
	Wanted_Height := 3 * Wanted_Width / 4
	H_offset := Wanted_Width / 2 - Overlap  + X_Base_offset
	V_offset := Y_Base_Offset
	J_Window(Wanted_Width, Wanted_Height, H_offset, V_offset)

Return

; ---------------------------------------------------------------------
; Doc Window Left
; 1 with Num Lock off, or
; Shift + 4 with Num Lock off

NumPadEnd::
+NumPadLeft::
    Wanted_Width := Doc_Width
	Wanted_Height := 11 * Wanted_Width / 8.5
	H_offset := -Wanted_Width / 2 + X_Base_offset + Overlap
	V_offset := Y_Base_Offset
	J_Window(Wanted_Width, Wanted_Height, H_offset, V_offset)

Return


; ---------------------------------------------------------------------
; Doc Window Right
; 3 with Num Lock off, or
; Shift + 6 with Num Lock off


NumPadPgdn::
+NumPadRight::
    Wanted_Width := Doc_Width
	Wanted_Height := 11 * Wanted_Width / 8.5
	H_offset := Wanted_Width / 2 + X_Base_offset  - Overlap
	V_offset := Y_Base_Offset
	J_Window(Wanted_Width, Wanted_Height, H_offset, V_offset)

Return

; ---------------------------------------------------------------------
; Main Window Up
; 8 with Num Lock off

NumPadUp::
    Wanted_Width := 1850 
	Wanted_Height := 2160 / 2 + Overlap
	H_offset := X_Base_offset
	V_offset := -(2160 - Wanted_Height) / 2
	J_Window(Wanted_Width, Wanted_Height, H_offset, V_offset)

Return

; ---------------------------------------------------------------------
; Main Window Down
; 2 with Num Lock off

NumPadDown::
    Wanted_Width := 1850 
	Wanted_Height := 2160/2 + Overlap
	H_offset := X_Base_offset
	V_offset := (2160 - Wanted_Height) / 2
	J_Window(Wanted_Width, Wanted_Height, H_offset, V_offset)

Return

; ---------------------------------------------------------------------
; Restore Windows
; NumPad dot (period) with NumLock off
; If a window is maximized, restore it.
; If the window is not maximized, maximize it.

NumPadDel::

	WinGet, maxxed, MinMax, A

	if maxxed = 1 
	{
	    SendInput #{Down}
	} 
	else 
	{
	    SendInput #{Up}
	}
	NumReLock()

Return

; ---------------------------------------------------------------------
; I never use the Insert key. Remap it to reload this script

Insert::
    Reload
Return

; ---------------------------------------------------------------------
; Call window placement macros using mouse position and mouse special button. 

XButton1::

CoordMode, Mouse, Screen
MouseGetPos xpos,ypos

screen_x = 3840
screen_y = 2160

a := screen_x / 6
b := 2 * a
c := 4 * a
d := 5 * a
k := screen_y / 6
j := screen_y / 2
i := 5 * k

;msgbox %a% %b% %c% %d% %k% %j% %i%


if (xpos < a)
{
    GoSub NumPadLeft
}
else if (xpos < b)
{
    GoSub NumPadEnd
}
else if (xpos > d)
{
    if (ypos < k)
	{
	    GoSub NumPadDel   ; Toggle maximized state
	}
	else
	{
	    GoSub NumPadRight
	}
}
else if (xpos > c)
{
    GoSub NumPadPgdn
}
else if (ypos < k)
{
    GoSub NumPadUp
}
else if (ypos < j)
{
    GoSub NumPadIns
}
else if (ypos < i)
{
    GoSub NumPadClear
}
else
{
    GoSub NumPadDown
}


Return



