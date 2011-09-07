#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>

Global $state, $label1, $label2, $pos_next, $pos_page, $number_of_pages

;Opt('MustDeclareVars', 1)

HotKeySet("^q", "HOTKEY")
HotKeySet("^e", "HOTKEY_EXIT")

Example()



Func Example()
    Local $msg, $Button_1, $Button_2
	
	$state = -1
    
    GUICreate("My GUI", 200, 200)  ; will create a dialog box that when displayed is centered

	$Button_1 = GUICtrlCreateButton("Set Next", 5, 5)
	$label1 = GUICtrlCreateLabel("<NOT SET>", 60, 11)
	$Button_2 = GUICtrlCreateButton("Set Page", 5, 40)
	$label2 = GUICtrlCreateLabel("<NOT SET>", 60, 51)
	$edit1 = GUICtrlCreateEdit("0000", 5, 75, 30, 20, $ES_CENTER + $ES_NUMBER + $WS_BORDER, 0)
	$Button_3 = GUICtrlCreateButton("Start Script", 115, 75)

    GUISetState()      ; will display an empty dialog box

    ; Run the GUI until the dialog is closed
    Do
		$msg = GUIGetMsg()
		Select
		Case $msg = $Button_1
			$state = 0
			GUISetState(@SW_MINIMIZE)
			;MsgBox(64, "Help", "Move the Mouse Cursor over the Next Button, then press CTRL+Q")
		Case $msg = $Button_2
			$state = 1
			GUISetState(@SW_MINIMIZE)
			;MsgBox(64, "Help", "Move the Mouse Cursor over the Page, then press CTRL+Q")
		Case $msg = $Button_3
			$number_of_pages = GUICtrlRead($edit1)
			DownloadBook()			
		EndSelect
    Until $msg = $GUI_EVENT_CLOSE

EndFunc

Func HOTKEY()
	Select
	Case $state = 0
		$pos_next = MouseGetPos()
	Case $state = 1
		$pos_page = MouseGetPos()
	EndSelect	
	
	GUISetState(@SW_RESTORE)
EndFunc

Func HOTKEY_EXIT()
	Exit
EndFunc

Func DownloadBook()
	;MsgBox(64, "test", $number_of_pages)
	GUISetState(@SW_MINIMIZE)
	
	DownloadPage("C:\Users\crazysaem\Documents\TestDownload", 152, "u", "Grafik speichern", 120, 10000, 0 )
	Sleep(100)
	
	For $i = 1 to ($number_of_pages-1) Step 1
		MouseClick("primary", $pos_next[0], $pos_next[1], 1, 0)		
		DownloadPage("C:\Users\crazysaem\Documents\TestDownload", ($i+152), "u", "Grafik speichern", 120, 10000, 0 )
	Next
EndFunc

Func _WinWaitActive($windowname, $delay)
	;Sleep($delay)
	;Local int $end
	;$end = $delay/100
	For $i = 0 to $delay Step 100
		if(WinActive($windowname)) Then
			return 1
		Else
			Sleep(100)
		EndIf		
	Next
	return 0
EndFunc

Func DownloadPage($dir, $name, $dlkey, $savewindow, $buttondelay, $windowfocusdelay, $movespeed)
	Local $count
	$count = 0
	MouseClick("secondary", $pos_page[0], $pos_page[1], 1, $movespeed)
	Sleep(200)
	Send($dlkey)
	;MouseClick("primary", $pos_page[0]+5, $pos_page[1]+5)
	;Sleep(300)
	While (_WinWaitActive($savewindow, $windowfocusdelay)==0)		
		MouseClick("primary", $pos_page[0]-10, $pos_page[1], 1, $movespeed)
		MouseClick("secondary", $pos_page[0], $pos_page[1], 1, $movespeed)
		Sleep(350)
		If(NOT WinActive($savewindow)) Then
			Send($dlkey)
		Else
			MouseClick("primary", 50, 5, 1, $movespeed)
		EndIf
		$count = $count + 1		
	WEnd
	
	If($count>0) Then
		Sleep(666*$count)
		MouseClick("primary", 50, 5, 1, $movespeed)
	EndIf
	
;~ 	For $i = 1 to 5 Step 1
;~ 		Sleep($buttondelay)
;~ 		Send("{TAB}")
;~ 	Next
;~ 	Sleep($buttondelay)
;~ 	Send("{ENTER}")
;~ 	Sleep($buttondelay)
;~ 	Send($dir)
;~ 	Sleep($buttondelay)
;~ 	Send("{ENTER}")
;~ 	For $i = 1 to 5 Step 1
;~ 		Sleep($buttondelay)
;~ 		Send("{TAB}")
;~ 	Next
	
	Sleep($buttondelay)
	Send($name)
	Sleep($buttondelay)
	For $i = 1 to 3 Step 1
		Sleep($buttondelay)
		Send("{TAB}")
	Next
	Sleep($buttondelay)
	Send("{ENTER}")
	Sleep($buttondelay)
	
	If(WinActive($savewindow)) Then
		While (_WinWaitActive($savewindow, 1000)<>0)
			;MouseClick("primary", 50, 5)
			WinActivate($savewindow)
			Sleep($buttondelay)
			Send("{ESC}")
			Sleep($buttondelay)
		WEnd
	EndIf
	
EndFunc