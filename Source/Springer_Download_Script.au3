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
	DownloadPage("C:\Users\crazysaem\Documents\TestDownload", 151)
	
	For $i = 1 to ($number_of_pages-1) Step 1
		MouseClick("primary", $pos_next[0], $pos_next[1])
		Sleep(100)
		DownloadPage("C:\Users\crazysaem\Documents\TestDownload", ($i+151) )
	Next
EndFunc

Func DownloadPage($dir, $name)
	Local $count
	$count = 0
	MouseClick("secondary", $pos_page[0], $pos_page[1])
	Sleep(200)
	Send("l")
	;MouseClick("primary", $pos_page[0]+5, $pos_page[1]+5)
	;Sleep(300)
	While (WinWaitActive("Speichern unter", "", 10)==0)		
		MouseClick("primary", $pos_page[0]-10, $pos_page[1])
		MouseClick("secondary", $pos_page[0], $pos_page[1])
		Sleep(350)
		If(NOT WinActive("Speichern unter")) Then
			Send("l")
		Else
			MouseClick("primary", 50, 2)
		EndIf
		$count = $count + 1		
	WEnd
	
	If($count>0) Then
		Sleep(666*$count)
		MouseClick("primary", 50, 5)
	EndIf
	
	For $i = 1 to 5 Step 1
		Sleep(50)
		Send("{TAB}")
	Next
	Sleep(50)
	Send("{ENTER}")
	Sleep(50)
	Send($dir)
	Sleep(50)
	Send("{ENTER}")
	For $i = 1 to 5 Step 1
		Sleep(50)
		Send("{TAB}")
	Next
	Sleep(50)
	Send($name)
	Sleep(50)
	For $i = 1 to 3 Step 1
		Sleep(50)
		Send("{TAB}")
	Next
	Sleep(50)
	Send("{ENTER}")
	
	If(WinActive("Speichern unter")) Then
		While (WinWaitActive("Speichern unter", "", 1)<>0)
			;MouseClick("primary", 50, 5)
			WinActivate("Speichern unter")
			Sleep(50)
			Send("{ESC}")
			Sleep(50)
		WEnd
	EndIf
	
EndFunc