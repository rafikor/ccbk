;; see "Using Keyboard NumPad as a Mouse -- by deguix"
; http://www.autohotkey.com

;START OF CONFIG SECTION

#SingleInstance force
#MaxHotkeysPerInterval 500

; Using the keyboard hook to implement the NumPad hotkeys prevents
; them from interfering with the generation of ANSI characters such
; as a.  This is because AutoHotkey generates such characters
; by holding down ALT and sending a series of NumPad keystrokes.
; Hook hotkeys are smart enough to ignore such keystrokes.
#UseHook

SysGet, Mon1, Monitor
resolutionWidth:=Mon1Right-Mon1Left

SysGet, Mon1, Monitor
;resolutionWidth:=Mon1Right-Mon1Left
resolutionWidth:=1920
resolX:=Mon1Right-Mon1Left
resolY:=-Mon1Top+Mon1Bottom
xCoord:=resolX/2
yCoord:=resolY/2

MouseSpeed:=0.1*resolutionWidth/1920
MouseSpeedFast:=0.2*resolutionWidth/1920
MouseSpeedFastFast:=0.03*resolutionWidth/1920
MouseAccelerationSpeed:=200*resolutionWidth/1920 ;10 ;in pixels/MouseAccelerationCycles
MouseAccelerationCycles:=20*resolutionWidth/1920 ;20 ;50,interval of timer executions to increase speed by the variable above
MouseAccelerationCyclesOld:=MouseAccelerationCycles
MouseAccelerationTimerInterval:=10 ;10 ;30 ;10 ;in milliseconds (this ends up to being approximate depending on computer performance)
MouseMaxSpeed:=30*resolutionWidth/1920 ;MouseMaxSpeed:=10
MouseMaxSpeedUsual:=20*resolutionWidth/1920 ;7
MouseMaxSpeedFast:=20*resolutionWidth/1920 ;7
MouseMaxSpeedSlow:=5*resolutionWidth/1920 ;3
MouseRotationAngle:=0

;Mouse wheel speed is also set on Control Panel. As that
;will affect the normal mouse behavior, the real speed of
;these three below are times the normal mouse wheel speed.
MouseWheelSpeed:=1
MouseWheelSpeedFast:=2
MouseWheelAccelerationSpeed:=1 ;in pixels/MouseAccelerationCycles
MouseWheelAccelerationCycles:=50 ;interval of timer executions to increase speed by the variable above
MouseWheelAccelerationTimerInterval:=35 ;in milliseconds (this ends up to being approximate depending on computer performance)
MouseWheelMaxSpeed:=5
MouseWheelRotationAngle:=0

MouseButtonPressCheckTimerInterval:=10

;0=Pressing a button and releasing = down + up events. 1=First time pressing/releasing = down, second time = up.
MouseButtonClickLockDownState:=0
MouseButtonMovementLockDownState:=0

;END OF CONFIG SECTION

PI:= 4*ATan(1)

;This is needed or key presses would faulty send their natural
;actions. Like NumPadDiv would send sometimes "/" to the
;screen.
#InstallKeybdHook

Temp = 0
Temp2 = 0

MouseRotationAnglePart = %MouseRotationAngle%
;Divide by 45° because MouseMove only supports whole numbers,
;and changing the mouse rotation to a number lesser than 45°
;could make strange movements.
;
;For example: 22.5° when pressing i:
;  First it would move upwards until the speed
;  to the side reaches 1.
MouseRotationAnglePart /= 45
MouseWheelRotationAnglePart = %MouseRotationAngle%
MouseWheelRotationAnglePart /= 45

MovementVectorMagnitude:=0
MovementVectorDirection:=0
MovementVectors:=0
MovementVectorDefaultMagnitude:=MouseSpeed

MovementWheelVectorMagnitude:=0
MovementWheelVectorDirection:=0
MovementWheelVectors:=0
MovementWheelVectorDefaultMagnitude:=MouseWheelSpeed

Buttons:=0

SetKeyDelay, -1
SetMouseDelay, -1

if (false)
{
tKUp:="k"
tKDown:="m"
tKLeft:="e"
tKRight:="r"

tMUp:="j"
tMDown:="n"
tMLeft:="f"
tMRight:="v"

tKCtrl:="d"
tKSpeed:="l"

tMLclk:="s"
tMRclk:="SC027"
tMMclk:="w"
tMDLclk:="a"

tMWhlUp:="h"
tMWhlDown:="b"

tKhome:="c"
tKend:="g"
tKpgUp:="u"
tKpgDown:="i"
}
else{
tKUp:="o"
tKDown:="k"
tKLeft:="e"
tKRight:="r"

tMUp:="i"
tMDown:="j"
tMLeft:="d"
tMRight:="f"

tKCtrl:="a"
tKSlow:="s"
tKCtrlMouse:="v"
tKSpeed:="SC027" ;"SC027"

tMLclk:="l" ;l"a"
tMRclk:="m" ;"l"
tMMclk:="q"
tMDLclk:="w"

tMWhlUp:="u"
tMWhlDown:="h"

tKhome:="t"
tKend:="g"
tKpgUp:="x"
tKpgDown:="c"
tAppsKey:="b"
tMWhlLeft:="y"
tMWhlRight:="p"

stubKey1:="z"
stubKey2:="v" ;"v"
;stubKey3:="b"

;stubKey5:="m"
keySaveMousePos:="n"
}

savedMousePosX:=0
savedMousePosY:=0

Hotkey, %tKCtrl%, ButtonA
Hotkey, +%tKCtrl%, ButtonA
Hotkey, z, restoreMousePos ;ButtonZDown
;Hotkey, z UP, ButtonZUp
Hotkey, %tMLclk%, ButtonLeftClick
Hotkey, +%tMLclk%, ButtonLeftClick
Hotkey, *NumPadIns, ButtonLeftClickIns
Hotkey, %tMMclk%, ButtonMiddleClick
Hotkey, *NumPadClear, ButtonMiddleClickClear
Hotkey, %tMRclk%, ButtonRightClick
Hotkey, *NumPadDel, ButtonRightClickDel
Hotkey, *NumPadDiv, ButtonX1Click
Hotkey, *NumPadMult, ButtonX2Click

Hotkey, %tMWhlUp%, ButtonWheelUp
Hotkey, %tMWhlDown%, ButtonWheelDown
Hotkey, +%tMWhlUp%, ButtonWheelUp
Hotkey, +%tMWhlDown%, ButtonWheelDown

;mu
Hotkey, %tMDLclk%, DoubleClick
Hotkey, %tKDown%, KeyDown
Hotkey, +%tKDown%, KeyDownShift
Hotkey, %tKUp%, KeyUp
Hotkey, +%tKUp%, KeyUpShift
Hotkey, %tKLeft%, KeyLeft
Hotkey, %tKRight%, KeyRight
Hotkey, +%tKLeft%, KeyLeftShift
Hotkey, +%tKRight%, KeyRightShift
Hotkey, %tKpgUp%, KeyPgUp
Hotkey, %tKpgDown%, KeyPgDown
Hotkey, +%tKpgUp%, KeyPgUpShift
;Hotkey, +%tKpgDown%, KeyPgDownShift
Hotkey, %tKhome%, KeyHome
Hotkey, %tKend%, KeyEnd

Hotkey, +%tKhome%, KeyHomeShift
Hotkey, +%tKend%, KeyEndShift

Hotkey, %tMRight%, ButtonRightFast
;Hotkey, v, ButtonRight
Hotkey, *NumPadPgUp, ButtonUpRight
Hotkey, %tMUp%, ButtonUpFast
;Hotkey, p, ButtonUp
Hotkey, *NumPadHome, ButtonUpLeft
Hotkey, %tMLeft%, ButtonLeftFast
;Hotkey, c, ButtonLeft
Hotkey, *NumPadEnd, ButtonDownLeft
Hotkey, %tMDown%, ButtonDownFast
Hotkey, *%tKSpeed%, ButtonDownStub ;ButtonDown
Hotkey, *NumPadPgDn, ButtonDownRight

Hotkey, *NumPad6, ButtonWheelRight
Hotkey, *NumPad9, ButtonWheelUpRight
Hotkey, *NumPad8, ButtonWheelUp
Hotkey, *NumPad7, ButtonWheelUpLeft
Hotkey,*NumPad4, ButtonWheelLeft
Hotkey, *NumPad1, ButtonWheelDownLeft
;Hotkey, *%tMWhlDown%, ButtonWheelDown
Hotkey, *NumPad3, ButtonWheelDownRight

Hotkey, NumPadEnter & i, ButtonSpeedUp
Hotkey, NumPadEnter & j, ButtonSpeedDown
Hotkey, NumPadEnter & NumPadHome, ButtonAccelerationSpeedUp
Hotkey, NumPadEnter & NumPadEnd, ButtonAccelerationSpeedDown
Hotkey, NumPadEnter & NumPadPgUp, ButtonMaxSpeedUp
Hotkey, NumPadEnter & NumPadPgDn, ButtonMaxSpeedDown
Hotkey, NumPadEnter & d, ButtonRotationAngleUp
Hotkey, NumPadEnter & f, ButtonRotationAngleDown

Hotkey, NumPadEnter & NumPad8, ButtonWheelSpeedUp
Hotkey, NumPadEnter & NumPad2, ButtonWheelSpeedDown
Hotkey, NumPadEnter & NumPad7, ButtonWheelAccelerationSpeedUp
Hotkey, NumPadEnter & NumPad1, ButtonWheelAccelerationSpeedDown
Hotkey, NumPadEnter & NumPad9, ButtonWheelMaxSpeedUp
Hotkey, NumPadEnter & NumPad3, ButtonWheelMaxSpeedDown
Hotkey, NumPadEnter & NumPad4, ButtonWheelRotationAngleUp
Hotkey, NumPadEnter & NumPad6, ButtonWheelRotationAngleDown

Hotkey, %tAppsKey%, HotAppsKey

;Hotkey, %stubKey1%, winCenter
;Hotkey, %stubKey2%, stubDisableHotkeys
;Hotkey, %stubKey3%, stubDisableHotkeys
;Hotkey, %stubKey4%, stubDisableHotkeys
;Hotkey, %stubKey5%, stubDisableHotkeys
Hotkey, %tKSlow%, ButtonA
Hotkey, %tKCtrlMouse%, ButtonA

Hotkey, %tMWhlLeft%, funcWheelLeft
Hotkey, %tMWhlRight%, funcWheelRight

Hotkey, ~^1, stubDisableHotkeys
Hotkey, ~^2, stubDisableHotkeys
Hotkey, !LShift, stubDisableHotkeys2L
Hotkey, !RShift, stubDisableHotkeys2R
Hotkey, %keySaveMousePos%, saveMousePos

;Hotkey, y, yFunc




Hotkey, NumPadEnter, ButtonEnter


ru := DllCall("LoadKeyboardLayout", "Str", "00000419", "Int", 1)
en := DllCall("LoadKeyboardLayout", "Str", "00000409", "Int", 1)
isOnePress:=0

isBeginHalfX:=0
isBeginHalfY:=0

;Gosub, ~CapsLock  ; Initialize based on current CapsLock state.
return

;#include Notify.ahk
^!CapsLock UP::
WinActivate, Jupyter QtConsole
return
;Key activation support


CapsLock::
; Wait for it to be released because otherwise the hook state gets reset
; while the key is down, which causes the up-event to get suppressed,
; which in turn prevents toggling of the CapsLock state/light:
;KeyWait, CapsLock
;ToolTip, %isOnePress%
Gosub, disableHotkeys
;Send {Ctrl down}
;Send 2
;Send {Ctrl up}
PostMessage 0x50, 0, %en%,, A
return

CapsLock UP::
return

<+CapsLock::
Gosub, disableHotkeys
;Send {Ctrl down}
;Send 1
;Send {Ctrl up}
PostMessage 0x50, 0, %ru%,, A
return

;LWin::
;Gosub, disableHotkeys
;PostMessage 0x50, 0, %ru%,, A
;return

;^`::
;Send {SC029}
;return

!RWin::
SendPlay  {Win}
ToolTip, lol2
return

;<!CapsLock UP::


;LWin::
RAlt::
;Send {Ctrl down}
;Send 2
;Send {Ctrl up}
;PostMessage 0x50, 0, %en%,, A
;GetKeyState, CapsLockState, CapsLock, T

    Gosub, enableHotkeys

return

;RWin UP::
;Gosub, disableHotkeys
;return



yFunc:
Gosub, disableHotkeys
Hotkey, %tMRight%, on
Hotkey, %tMUp%, on
Hotkey, %tMLeft%, on
Hotkey, %tMDown%, on

isBeginHalfX:=3
isBeginHalfY:=3

;xCoordHalf:=resolX/2
;yCoordHalf:=resolY/2
CoordMode, Mouse, Screen
MouseGetPos, xCoordHalf, yCoordHalf
MouseMove, xCoordHalf, yCoordHalf, 0
return


enableHotkeys:

isBeginHalfX:=0
isBeginHalfY:=0

   Hotkey, %tKCtrl%, on
    Hotkey, +%tKCtrl%, on
Hotkey, z, on
;Hotkey, z UP, on
Hotkey, %tMLclk%, on
Hotkey, +%tMLclk%, on
Hotkey, *NumPadIns, on
Hotkey, %tMMclk%, on
Hotkey, *NumPadClear, on
Hotkey, %tMRclk%, on
Hotkey, *NumPadDel, on
Hotkey, *NumPadDiv, on
Hotkey, *NumPadMult, on

Hotkey, %tMWhlUp%, on
Hotkey, %tMWhlDown%, on
Hotkey, +%tMWhlUp%, on
Hotkey, +%tMWhlDown%, on

;mu
Hotkey, %tMDLclk%, on
Hotkey, %tKDown%, on
Hotkey, +%tKDown%, on
Hotkey, %tKUp%, on
Hotkey, +%tKUp%, on
Hotkey, %tKLeft%, on
Hotkey, %tKRight%, on
Hotkey, +%tKLeft%, on
Hotkey, +%tKRight%, on
Hotkey, %tKpgUp%, on
Hotkey, %tKpgDown%, on
Hotkey, +%tKpgUp%, on
;Hotkey, +%tKpgDown%, on
Hotkey, %tKhome%, on
Hotkey, %tKend%, on

Hotkey, +%tKhome%, on
Hotkey, +%tKend%, on

Hotkey, %tMRight%, on
;Hotkey, v, on
Hotkey, *NumPadPgUp, on
Hotkey, %tMUp%, on
;Hotkey, p, on
Hotkey, *NumPadHome, on
Hotkey, %tMLeft%, on
;Hotkey, c, on
Hotkey, *NumPadEnd, on
Hotkey, %tMDown%, on
Hotkey, *%tKSpeed%, on ;ButtonDown
Hotkey, *NumPadPgDn, on

Hotkey, *NumPad6, on
Hotkey, *NumPad9, on
Hotkey, *NumPad8, on
Hotkey, *NumPad7, on
Hotkey,*NumPad4, on
Hotkey, *NumPad1, on
;Hotkey, *%tMWhlDown%, on
Hotkey, *NumPad3, on

Hotkey, NumPadEnter & i, on
Hotkey, NumPadEnter & j, on
Hotkey, NumPadEnter & NumPadHome, on
Hotkey, NumPadEnter & NumPadEnd, on
Hotkey, NumPadEnter & NumPadPgUp, on
Hotkey, NumPadEnter & NumPadPgDn, on
Hotkey, NumPadEnter & d, on
Hotkey, NumPadEnter & f, on

Hotkey, NumPadEnter & NumPad8, on
Hotkey, NumPadEnter & NumPad2, on
Hotkey, NumPadEnter & NumPad7, on
Hotkey, NumPadEnter & NumPad1, on
Hotkey, NumPadEnter & NumPad9, on
Hotkey, NumPadEnter & NumPad3, on
Hotkey, NumPadEnter & NumPad4, on
Hotkey, NumPadEnter & NumPad6, on

Hotkey, NumPadEnter, on

Hotkey, %tMWhlLeft%, on
Hotkey, %tMWhlRight%, on

Hotkey, %tAppsKey%, on

;Hotkey, %stubKey1%, on
;Hotkey, %stubKey2%, on
;Hotkey, %stubKey3%, on
;Hotkey, %stubKey4%, on
;Hotkey, %stubKey5%, on
Hotkey, %tKSlow%, on
Hotkey, %tKCtrlMouse%, on
Hotkey, %keySaveMousePos%, on
;Hotkey, y, on

Hotkey, ~^1, on
Hotkey, ~^2, on
Hotkey, !LShift, on
Hotkey, !RShift, on

OutputVarXZ:=0
OutputVarYZ:=0
MouseGetPos, OutputVarXZ, OutputVarYZ, 0
  ToolTip, Mousekeys,OutputVarXZ+ 50,OutputVarYZ-70
  Menu, Tray, Icon, Shell32.dll, 174
  SetTimer, RemoveToolTip, 1000
  
  ;TrayTip,, On
  ;Gosub, ShowTT
  ;ID:=Notify("hhh","ttttt", 1000)
  ;A_Cursor=Cross
;}
return

disableHotkeys:
Hotkey, %tKCtrl%, off
    Hotkey, +%tKCtrl%, off
Hotkey, z, off
;Hotkey, z UP, off
Hotkey, %tMLclk%, off
Hotkey, +%tMLclk%, off
Hotkey, *NumPadIns, off
Hotkey, %tMMclk%, off
Hotkey, *NumPadClear, off
Hotkey, %tMRclk%, off
Hotkey, *NumPadDel, off
Hotkey, *NumPadDiv, off
Hotkey, *NumPadMult, off

Hotkey, %tMWhlUp%, off
Hotkey, %tMWhlDown%, off
Hotkey, +%tMWhlUp%, off
Hotkey, +%tMWhlDown%, off

;mu
Hotkey, %tMDLclk%, off
Hotkey, %tKDown%, off
Hotkey, +%tKDown%, off
Hotkey, %tKUp%, off
Hotkey, +%tKUp%, off
Hotkey, %tKLeft%, off
Hotkey, %tKRight%, off
Hotkey, +%tKLeft%, off
Hotkey, +%tKRight%, off
Hotkey, %tKpgUp%, off
Hotkey, %tKpgDown%, off
Hotkey, +%tKpgUp%, off
;Hotkey, +%tKpgDown%, off
Hotkey, %tKhome%, off
Hotkey, %tKend%, off

Hotkey, +%tKhome%, off
Hotkey, +%tKend%, off

Hotkey, %tMRight%, off
;Hotkey, v, off
Hotkey, *NumPadPgUp, off
Hotkey, %tMUp%, off
;Hotkey, p, off
Hotkey, *NumPadHome, off
Hotkey, %tMLeft%, off
;Hotkey, c, off
Hotkey, *NumPadEnd, off
Hotkey, %tMDown%, off
Hotkey, *%tKSpeed%, off ;ButtonDown
Hotkey, *NumPadPgDn, off

Hotkey, *NumPad6, off
Hotkey, *NumPad9, off
Hotkey, *NumPad8, off
Hotkey, *NumPad7, off
Hotkey,*NumPad4, off
Hotkey, *NumPad1, off
;Hotkey, *%tMWhlDown%, off
Hotkey, *NumPad3, off

Hotkey, NumPadEnter & i, off
Hotkey, NumPadEnter & j, off
Hotkey, NumPadEnter & NumPadHome, off
Hotkey, NumPadEnter & NumPadEnd, off
Hotkey, NumPadEnter & NumPadPgUp, off
Hotkey, NumPadEnter & NumPadPgDn, off
Hotkey, NumPadEnter & d, off
Hotkey, NumPadEnter & f, off

Hotkey, NumPadEnter & NumPad8, off
Hotkey, NumPadEnter & NumPad2, off
Hotkey, NumPadEnter & NumPad7, off
Hotkey, NumPadEnter & NumPad1, off
Hotkey, NumPadEnter & NumPad9, off
Hotkey, NumPadEnter & NumPad3, off
Hotkey, NumPadEnter & NumPad4, off
Hotkey, NumPadEnter & NumPad6, off

Hotkey, %tAppsKey%, off

Hotkey, %tMWhlLeft%, off
Hotkey, %tMWhlRight%, off

;Hotkey, %stubKey1%, off
;Hotkey, %stubKey2%, off
;Hotkey, %stubKey3%, off
;Hotkey, %stubKey4%, off
;Hotkey, %stubKey5%, off
Hotkey, %tKSlow%, off
Hotkey, %tKCtrlMouse%, off

Hotkey, ~^1, off
Hotkey, ~^2, off
Hotkey, !LShift, off
Hotkey, !RShift, off
Hotkey, %keySaveMousePos%, off
;Hotkey, y, off


Hotkey, NumPadEnter, off

OutputVarXZ:=0
OutputVarYZ:=0
MouseGetPos, OutputVarXZ, OutputVarYZ, 0
  ToolTip, Mousekeys_OFF,OutputVarXZ+ 50,OutputVarYZ-70
  Menu, Tray, Icon, Shell32.dll, 173
  SetTimer, RemoveToolTip, 1000
  ;Msgbox, %ID%
  ;WinClose, %ID%
  
   ;TrayTip,, Off
return


;~^1::
;Gosub, disableHotkeys
;return

;~^2::
;Gosub, disableHotkeys
;return

;~!Shift::
;Gosub, disableHotkeys
;return

funcWheelLeft:
Send, {WheelLeft}
return

funcWheelRight:
Send, {WheelRight}
return

stubDisableHotkeys2L:
Gosub, disableHotkeys
Send, {RAlt down}
Send, {RShift down}
Send, {RShift up}
Send, {RAlt up}
return

stubDisableHotkeys2R:
Gosub, disableHotkeys
Send, {LAlt down}
Send, {LShift down}
Send, {LShift up}
Send, {LAlt up}
return

stubDisableHotkeys:
Gosub, disableHotkeys
return

HotAppsKey:
Send, {AppsKey}
return

ScrollLock::
Run, "D:\Program Files\Mozilla Firefox\firefox.exe" http://192.168.255.26:8080/browse/%clipboard%
Return

winCenter:
WinGetActiveStats, Title, Width, Height, X, Y

;ControlGetFocus, OutputVar ,Title
;ToolTip, %OutputVar%
;ControlGetPos , X, Y, Width, Height, OutputVar, Title
;MouseMove X, Y

MouseMove, X*0+Width/2, Y*0+Height/2*0+20, 0


return

ShowTT:
;GetKeyState, CapsLockState, CapsLock, T
If CapsLockState = D
    TrayTip,, On
else
    TrayTip
SetTimer, RemoveToolTip2, 3000
Sleep, 1000
return

RemoveToolTip2:
SetTimer, RemoveToolTip2, Off
TrayTip
Gosub, ShowTT
return

ButtonEnter:
Send, {NumPadEnter}
Return

;Mouse click support
ButtonLeftClick:
ButtonLeftClickIns:
ButtonClickType:="Left"
MouseButtonName:="LButton"
Goto ButtonClickStart
ButtonMiddleClick:
ButtonMiddleClickClear:
ButtonClickType:="Middle"
MouseButtonName:="MButton"
Goto ButtonClickStart
ButtonRightClick:
ButtonRightClickDel:
ButtonClickType:="Right"
MouseButtonName:="RButton"
Goto ButtonClickStart
ButtonX1Click:
ButtonClickType:="X1"
MouseButtonName:="XButton1"
Goto ButtonClickStart
ButtonX2Click:
ButtonClickType:="X2"
MouseButtonName:="XButton2"
ButtonClickStart:
StringReplace, ButtonName, A_ThisHotkey, *
StringReplace, ButtonName, ButtonName, +,

If (ButtonDown_%ButtonName%!=1)
{
  ButtonDown_%ButtonName%:=1
  Buttons:=Buttons+1
  Button%Buttons%Name:=ButtonName
  Button%Buttons%ClickType:=ButtonClickType
  Button%Buttons%MouseButtonName:=MouseButtonName
  Button%Buttons%Initialized:=0
  Button%Buttons%UnHoldStep:=0
  If (Buttons = 1)
    SetTimer, MouseButtonPressCheck, % MouseButtonPressCheckTimerInterval
}
Return

MouseButtonPressCheck:
If (Buttons=0)
{
  SetTimer, MouseButtonPressCheck, off
  Return
}

Button:=0
Loop
{
  Button:=Button+1
  If (Button%Buttons%Initialized=0)
  {
    GetKeyState, MouseButtonState, % Button%Button%MouseButtonName
    If (MouseButtonState="D")
      Continue    
    MouseButtonStateShift:="U"
    MouseButtonStateA:="D"
    GetKeyState, MouseButtonStateShift, Shift
    GetKeyState, MouseButtonStateA, %tKCtrlMouse%, P
    ;TrayTip,,% MouseButtonStateA
    If (MouseButtonStateShift="D")
      Send, {Shift down}
      If (MouseButtonStateA="D")
      Send, {Control down}
    MouseClick, % Button%Button%ClickType,,, 1, 0, D    
    Button%Buttons%Initialized:=1
  }
 
  GetKeyState, ButtonState, % Button%Button%Name, P
  If (ButtonState="U" and (MouseButtonClickLockDownState=0 or (MouseButtonClickLockDownState=1 and Button%Buttons%UnHoldStep=2)))
  {
    ButtonName:=Button%Buttons%Name
    ButtonDown_%ButtonName%:=0
    MouseClick, % Button%Button%ClickType,,, 1, 0, U
    If (MouseButtonStateShift="D")
      Send, {Shift up}
    If (MouseButtonStateA="D")
      Send, {Control up}
   
    ButtonTemp:=Button
    ButtonTempPrev:=ButtonTemp-1

    Loop
    {
      ButtonTemp:=ButtonTemp+1
      ButtonTempPrev:=ButtonTempPrev+1
     
      If (Buttons<ButtonTemp)
      {
        Button%ButtonTempPrev%Name:=""
        Button%ButtonTempPrev%ClickType:=""
        Button%ButtonTempPrev%MouseButtonName:=""
        Button%ButtonTempPrev%Initialized:=0
        Break
      }
      Button%ButtonTempPrev%Name:=Button%ButtonTemp%Name
      Button%ButtonTempPrev%ClickType:=Button%ButtonTemp%ClickType
      Button%ButtonTempPrev%MouseButtonName:=Button%ButtonTemp%MouseButtonName
      Button%ButtonTempPrev%Initialized:=Button%ButtonTemp%Initialized
    }
    Buttons:=Buttons-1
  }
  
  If(ButtonState="U" and MouseButtonClickLockDownState=1 and Button%Buttons%UnHoldStep=0)
    Button%Buttons%UnHoldStep:=1
  If(ButtonState="D" and MouseButtonClickLockDownState=1 and Button%Buttons%UnHoldStep=1)
    Button%Buttons%UnHoldStep:=2
  
  If (Buttons<=Button)
    Break
}
Return

;Mouse movement support
ButtonDownRight:
MovementVectorDirectionTemp+=1
ButtonDown:
MovementVectorDirectionTemp+=1
ButtonDownLeft:
MovementVectorDirectionTemp+=1
ButtonLeft:
MovementVectorDirectionTemp+=1
ButtonUpLeft:
MovementVectorDirectionTemp+=1
ButtonUp:
MovementVectorDirectionTemp+=1
ButtonUpRight:
MovementVectorDirectionTemp+=1
ButtonRight:
StringReplace, MovementButtonName, A_ThisHotkey, *
If (MovementButtonDown_%MovementButtonName%!=1)
{
  MovementButtonDown_%MovementButtonName%:=1
  MovementVectors:=MovementVectors+1
  MovementVector%MovementVectors%Name:=MovementButtonName
  MovementVector%MovementVectors%Direction:=(MovementVectorDirectionTemp*PI/4)+(MouseRotationAngle*PI/180)
  MovementVector%MovementVectors%Magnitude:=MouseSpeedFastFast
  MovementVector%MovementVectors%Initialized:=0
  MovementVector%MovementVectors%UnHoldStep:=0
  If (MovementVectors = 1)
  {
    MouseCurrentAccelerationSpeed:=MouseSpeed
    SetTimer, MovementVectorAcceleration, % MouseAccelerationTimerInterval
  }
}
MovementVectorDirectionTemp:=0
Return

;Mouse movement support fast
ButtonDownRightFast:
MovementVectorDirectionTemp+=1
ButtonDownFast:
if (isBeginHalfY<>0)
{
    isBeginHalfY:=isBeginHalfY*2
    
    yCoordHalf:=yCoordHalf+resolY/isBeginHalfY/1.7
    MouseMove, xCoordHalf, yCoordHalf, 0
    return
}
MovementVectorDirectionTemp+=1
ButtonDownLeftFast:
MovementVectorDirectionTemp+=1
ButtonLeftFast:
if (isBeginHalfX<>0)
{
    isBeginHalfX:=isBeginHalfX*2
    xCoordHalf:=xCoordHalf-resolX/isBeginHalfX/1.7
    MouseMove, xCoordHalf, yCoordHalf, 0
    return
}
MovementVectorDirectionTemp+=1
ButtonUpLeftFast:
MovementVectorDirectionTemp+=1
ButtonUpFast:
if (isBeginHalfY<>0)
{
    isBeginHalfY:=isBeginHalfY*2
    yCoordHalf:=yCoordHalf-resolY/isBeginHalfY/1.7
    MouseMove, xCoordHalf, yCoordHalf, 0
    return
}
MovementVectorDirectionTemp+=1
ButtonUpRightFast:
MovementVectorDirectionTemp+=1
ButtonRightFast:
if (isBeginHalfX<>0)
{
    isBeginHalfX:=isBeginHalfX*2
    xCoordHalf:=xCoordHalf+resolX/isBeginHalfX/1.7
    MouseMove, xCoordHalf, yCoordHalf, 0
    return
}
;TrayTip,,%A_ThisHotkey%
;GetKeyState, MovementButtonState, %tMRight%, P
;if (MovementButtonState="D" )
;{
;GetKeyState, MovementButtonState, %tMUp%, P
;if (MovementButtonState="D" )
;MovementVectorDirectionTemp:=1
;}
StringReplace, MovementButtonName, A_ThisHotkey, *
If (MovementButtonDown_%MovementButtonName%!=1)
{
MouseSpeedTMP:=MouseSpeed
MouseAccelerationTimerIntervalTMP:=MouseAccelerationTimerInterval
MouseAccelerationCycles:=MouseAccelerationCyclesOld




GetKeyState, MovementButtonStateSpeed, %tKSpeed%, P
GetKeyState, MovementButtonState, %tKCtrl%, P
if (MovementButtonStateSpeed="U" )
{
    if (MovementButtonState="D" )
    {
    MouseSpeedTMP:=MouseSpeedFast
    }
}


;TrayTip,,"Lol"

  MovementButtonDown_%MovementButtonName%:=1
  MovementVectors:=MovementVectors+1
  MovementVector%MovementVectors%Name:=MovementButtonName
  MovementVector%MovementVectors%Direction:=(MovementVectorDirectionTemp*PI/4)+(MouseRotationAngle*PI/180)
  MovementVector%MovementVectors%Magnitude:=MouseSpeedTMP ;MouseSpeed
  MovementVector%MovementVectors%Initialized:=0
  MovementVector%MovementVectors%UnHoldStep:=0
  If (MovementVectors = 1)
  {
    SetTimer, MovementVectorAcceleration, % MouseAccelerationTimerIntervalTMP
    MouseCurrentAccelerationSpeed:=MouseSpeed
  }
}
MovementVectorDirectionTemp:=0
Return

MovementVectorAddition:
;Add 2 vectors
MovementVectorX:=MovementVectorMagnitude*Cos(MovementVectorDirection)+MovementVector%MovementVector%Magnitude*Cos(MovementVector%MovementVector%Direction)
MovementVectorY:=MovementVectorMagnitude*Sin(MovementVectorDirection)+MovementVector%MovementVector%Magnitude*Sin(MovementVector%MovementVector%Direction)
MovementVectorMagnitude:=Sqrt(MovementVectorX**2+MovementVectorY**2)
MovementVectorDirection:=ATan(MovementVectorY/MovementVectorX)
If (MovementVectorX<0)
{
  If (MovementVectorY>0)
    MovementVectorDirection:=MovementVectorDirection-PI
  Else
    MovementVectorDirection:=PI+MovementVectorDirection
}
MovementVectorMagnitudeRatio:=MovementVectorMagnitude/MouseSpeed
Return

ButtonA:
Return

OutputVarXZ:=-1
OutputVarYZ:=-1

ButtonZDown:
OutputVarZ:=""
;WinGetActiveTitle, OutputVarZ
;Xz:=0
;Yz:=0
;Widthz:=0
;Heightz:=0
;WinGetPos , Xz, Yz, Widthz, Heightz, OutputVarZ
;
if (OutputVarYZ~=-1)
    MouseGetPos, OutputVarXZ, OutputVarYZ
else
    MouseMove, % OutputVarXZ, % OutputVarYZ, 0
;MouseMove, % Xz, % Yz, 0
;TrayTip,,% Xz . "x"
Return

ButtonZUp:
MouseMove, % OutputVarXZ, % OutputVarYZ, 0
OutputVarXZ:=-1
OutputVarYZ:=-1
Return

saveMousePos:
MouseGetPos, savedMousePosX, savedMousePosY
return

restoreMousePos:
MouseMove, % savedMousePosX, % savedMousePosY, 0
return

ButtonDownStub:
Return

MovementVectorAcceleration:
If (MovementVectors=0)
{
  MovementVectorX:=0.000000
  MovementVectorY:=0.000000
  MovementVectorMagnitude:=0.000000
  MovementVectorDirection:=0.000000
  MovementVectorMagnitudeRatio:=0.000000
  MovementResultantVectorMagnitude:=0.000000
  MovementResultantVectorDirection:=0.000000
  MovementResultantVectorX:=0.000000
  MovementResultantVectorY:=0.000000
  ;TrayTip,,% "(" . MovementResultantVectorMagnitude . "," . MovementResultantVectorDirection . ") - <" . MovementResultantVectorX . "," . MovementResultantVectorY . ">"
  SetTimer, MovementVectorAcceleration, off
  Return
}
MovementVector:=0
Loop
{

MouseMaxSpeed:=MouseMaxSpeedUsual ;MouseMaxSpeedSlow
GetKeyState, MovementButtonStateSpeed, %tKSpeed%, P
GetKeyState, MovementButtonState, %tKCtrl%, P
if (MovementButtonStateSpeed="U" )
{
    if (MovementButtonState="U" )
    {    
    MouseAccelerationCycles:=MouseAccelerationCyclesOld
    }
    else
    {
    MouseAccelerationCycles:=MouseAccelerationCyclesOld*5    
    }
}
GetKeyState, MovementButtonStateCtrl, %tKCtrl%, P
GetKeyState, MovementButtonState, %tKSpeed%, P
if (MovementButtonStateCtrl="D" )
{
    if (MovementButtonState="U" )
    {
    ;MouseMaxSpeed:=MouseMaxSpeedSlow*2
    MouseAccelerationCycles:=MouseAccelerationCycles*1.3
    }
}
GetKeyState, MovementButtonState, %tKSlow%, P
if (MovementButtonState="D" )
    {
    MouseMaxSpeed:=MouseMaxSpeedSlow
    MouseAccelerationCycles:=MouseAccelerationCycles*1.5
    ;;MouseAccelerationCycles:=MouseAccelerationCyclesOld
    }
GetKeyState, MovementButtonState, %tKSlow%, P
if (MovementButtonState="D" )
{
    MouseAccelerationCycles:=MouseAccelerationCyclesOld*10
    if (MovementButtonStateCtrl="D" )
    {
        MouseAccelerationCycles:=MouseAccelerationCyclesOld*20
        MouseMaxSpeed:=MouseMaxSpeedSlow/2
    }
}



    
  MovementVector:=MovementVector+1
  If (MovementVector%MovementVector%Initialized=0)
  {
    Gosub, MovementVectorAddition
    MovementVector%MovementVector%Initialized:=1
  }
  GetKeyState, MovementButtonState, % MovementVector%MovementVector%Name, P
  If (MovementButtonState="U" and (MouseButtonMovementLockDownState=0 or (MouseButtonMovementLockDownState=1 and MovementVector%MovementVector%UnHoldStep=2)))
  {
    MovementButtonName:=MovementVector%MovementVector%Name
    MovementButtonDown_%MovementButtonName%:=0
    MovementVector%MovementVector%Magnitude:=-MovementVector%MovementVector%Magnitude
    Gosub, MovementVectorAddition
    MovementVectorTemp:=MovementVector
    MovementVectorTempPrev:=MovementVector-1
    Loop
    {
      MovementVectorTemp:=MovementVectorTemp+1
      MovementVectorTempPrev:=MovementVectorTempPrev+1
      If (MovementVectors<MovementVectorTemp)
      {
        MovementVector%MovementVectorTempPrev%Name:=""
        MovementVector%MovementVectorTempPrev%Direction:=0
        MovementVector%MovementVectorTempPrev%Magnitude:=0
        MovementVector%MovementVectorTempPrev%Initialized:=0
        MovementVector%MovementVectorTempPrev%UnHoldStep:=0
        Break
      }
      MovementVector%MovementVectorTempPrev%Name:=MovementVector%MovementVectorTemp%Name
      MovementVector%MovementVectorTempPrev%Direction:=MovementVector%MovementVectorTemp%Direction
      MovementVector%MovementVectorTempPrev%Magnitude:=MovementVector%MovementVectorTemp%Magnitude
      MovementVector%MovementVectorTempPrev%Initialized:=MovementVector%MovementVectorTemp%Initialized
      MovementVector%MovementVectorTempPrev%UnHoldStep:=MovementVector%MovementVectorTemp%UnHoldStep
    }
    MovementVectors:=MovementVectors-1
  }
  
  If(MovementButtonState="U" and MouseButtonMovementLockDownState=1 and MovementVector%MovementVector%UnHoldStep=0)
    MovementVector%MovementVector%UnHoldStep:=1
  If(MovementButtonState="D" and MouseButtonMovementLockDownState=1 and MovementVector%MovementVector%UnHoldStep=1)
    MovementVector%MovementVector%UnHoldStep:=2
  
  If (MovementVectors<=MovementVector)
    Break
}



If (MouseCurrentAccelerationSpeed<MouseMaxSpeed/MovementVectorMagnitudeRatio)
  MouseCurrentAccelerationSpeed:=MouseCurrentAccelerationSpeed+(MouseAccelerationSpeed/MouseAccelerationCycles)
else
    MouseCurrentAccelerationSpeed:=MouseMaxSpeed/MovementVectorMagnitudeRatio

MovementResultantVectorMagnitude:=MouseCurrentAccelerationSpeed*MovementVectorMagnitudeRatio
MovementResultantVectorDirection:=MovementVectorDirection
;TrayTip,,% MouseMaxSpeed

;If (MovementResultantVectorMagnitude>MouseMaxSpeed)  
;    MovementResultantVectorMagnitude:=MouseMaxSpeed

GetKeyState, MovementButtonState, %tKSpeed%, P
if (MovementButtonState="D" )
{
if (MovementButtonStateCtrl="U" )
{
if(MovementResultantVectorMagnitude>=1)
    MovementResultantVectorMagnitude:=50*resolutionWidth/1920
    ;TrayTip,,"Lol"
    }
else{
    MovementResultantVectorMagnitude:=100*resolutionWidth/1920
}

;TrayTip,,"Lol"
}

;TrayTip,,%MovementResultantVectorMagnitude%
MovementResultantVectorX:=MovementResultantVectorMagnitude*Cos(MovementResultantVectorDirection)
MovementResultantVectorY:=MovementResultantVectorMagnitude*Sin(MovementResultantVectorDirection)
;TrayTip,,% "(" . MovementResultantVectorMagnitude . "," . MovementResultantVectorDirection . ") - <" . MovementResultantVectorX . "," . MovementResultantVectorY . ">"
MouseMove, % MovementResultantVectorX, % -MovementResultantVectorY, 0, R
Return

;Mouse wheel movement support
ButtonWheelDownRight:
MovementWheelVectorDirectionTemp+=1
ButtonWheelDown:
MovementWheelVectorDirectionTemp+=1
ButtonWheelDownLeft:
MovementWheelVectorDirectionTemp+=1
ButtonWheelLeft:
MovementWheelVectorDirectionTemp+=1
ButtonWheelUpLeft:
MovementWheelVectorDirectionTemp+=1
ButtonWheelUp:
MovementWheelVectorDirectionTemp+=1
ButtonWheelUpRight:
MovementWheelVectorDirectionTemp+=1
ButtonWheelRight:
StringReplace, MovementWheelButtonName, A_ThisHotkey, *
If (MovementWheelButtonDown_%MovementWheelButtonName%!=1)
{
MouseWheelSpeedTMP:=MouseWheelSpeedFast
GetKeyState, MovementButtonState, %tKSpeed%, P
GetKeyState, MovementButtonStateS, %tkCtrl%, P
if (MovementButtonState="U" )
    {
    if (MovementButtonStateS="U" )
    {
      MouseWheelSpeedTMP:=MouseWheelSpeed
      }
   }
   
GetKeyState, MovementButtonStateCtrl, %tKSlow%, P
if (MovementButtonStateCtrl="D")
{
Send {Ctrl down}
}

  MovementWheelButtonDown_%MovementWheelButtonName%:=1
  MovementWheelVectors:=MovementWheelVectors+1
  MovementWheelVector%MovementWheelVectors%Name:=MovementWheelButtonName
  MovementWheelVector%MovementWheelVectors%Direction:=(MovementWheelVectorDirectionTemp*PI/4)+(MouseWheelRotationAngle*PI/180)
  MovementWheelVector%MovementWheelVectors%Magnitude:=MouseWheelSpeedTMP
  MovementWheelVector%MovementWheelVectors%Initialized:=0
  MovementWheelVector%MovementWheelVectors%UnHoldStep:=0
 
  If (MovementWheelVectors = 1)
  {
    MouseWheelCurrentAccelerationSpeed:=MouseWheelSpeed
    SetTimer, MovementWheelVectorAcceleration, % MouseWheelAccelerationTimerInterval
  }
}
MovementWheelVectorDirectionTemp:=0
Return

MovementWheelVectorAddition:
;Add 2 vectors
MovementWheelVectorX:=MovementWheelVectorMagnitude*Cos(MovementWheelVectorDirection)+MovementWheelVector%MovementWheelVector%Magnitude*Cos(MovementWheelVector%MovementWheelVector%Direction)
MovementWheelVectorY:=MovementWheelVectorMagnitude*Sin(MovementWheelVectorDirection)+MovementWheelVector%MovementWheelVector%Magnitude*Sin(MovementWheelVector%MovementWheelVector%Direction)
MovementWheelVectorMagnitude:=Sqrt(MovementWheelVectorX**2+MovementWheelVectorY**2)
MovementWheelVectorDirection:=ATan(MovementWheelVectorY/MovementWheelVectorX)
If (MovementWheelVectorX<0)
{
  If (MovementWheelVectorY>0)
    MovementWheelVectorDirection:=MovementWheelVectorDirection-PI
  Else
    MovementWheelVectorDirection:=PI+MovementWheelVectorDirection
}
MovementWheelVectorMagnitudeRatio:=MovementWheelVectorMagnitude/MouseWheelSpeed
Return

MovementWheelVectorAcceleration:
If (MovementWheelVectors=0)
{
  MovementWheelVectorX:=0.000000
  MovementWheelVectorY:=0.000000
  MovementWheelVectorMagnitude:=0.000000
  MovementWheelVectorDirection:=0.000000
  MovementWheelVectorMagnitudeRatio:=0.000000

  MovementWheelResultantVectorMagnitude:=0.000000
  MovementWheelResultantVectorDirection:=0.000000
  MovementWheelResultantVectorX:=0.000000
  MovementWheelResultantVectorY:=0.000000
 
  ;TrayTip,,% "(" . MovementResultantVectorMagnitude . "," . MovementResultantVectorDirection . ") - <" . MovementResultantVectorX . "," . MovementResultantVectorY . ">"
  SetTimer, MovementWheelVectorAcceleration, off
  Return
}

MovementWheelVector:=0
Loop
{
  MovementWheelVector:=MovementWheelVector+1
  If (MovementWheelVector%MovementWheelVector%Initialized=0)
  {
    Gosub, MovementWheelVectorAddition
    MovementWheelVector%MovementWheelVector%Initialized:=1
  }
 
  GetKeyState, MovementWheelButtonState, % MovementWheelVector%MovementWheelVector%Name, P
  If (MovementWheelButtonState="U" and (MouseButtonMovementLockDownState=0 or (MouseButtonMovementLockDownState=1 and MovementWheelVector%MovementWheelVector%UnHoldStep=2)))
  {
    MovementWheelButtonName:=MovementWheelVector%MovementWheelVector%Name
    MovementWheelButtonDown_%MovementWheelButtonName%:=0
    MovementWheelVector%MovementWheelVector%Magnitude:=-MovementWheelVector%MovementWheelVector%Magnitude
    Gosub, MovementWheelVectorAddition
   
    MovementWheelVectorTemp:=MovementWheelVector
    MovementWheelVectorTempPrev:=MovementWheelVector-1
    Loop
    {
      MovementWheelVectorTemp:=MovementWheelVectorTemp+1
      MovementWheelVectorTempPrev:=MovementWheelVectorTempPrev+1
     
      If (MovementWheelVectors<MovementWheelVectorTemp)
      {
        MovementWheelVector%MovementWheelVectorTempPrev%Name:=""
        MovementWheelVector%MovementWheelVectorTempPrev%Direction:=0
        MovementWheelVector%MovementWheelVectorTempPrev%Magnitude:=0
        MovementWheelVector%MovementWheelVectorTempPrev%Initialized:=0
        MovementWheelVector%MovementWheelVectorTempPrev%UnHoldStep:=0
        Break
      }
     
      MovementWheelVector%MovementWheelVectorTempPrev%Name:=MovementWheelVector%MovementWheelVectorTemp%Name
      MovementWheelVector%MovementWheelVectorTempPrev%Direction:=MovementWheelVector%MovementWheelVectorTemp%Direction
      MovementWheelVector%MovementWheelVectorTempPrev%Magnitude:=MovementWheelVector%MovementWheelVectorTemp%Magnitude
      MovementWheelVector%MovementWheelVectorTempPrev%Initialized:=MovementWheelVector%MovementWheelVectorTemp%Initialized
      MovementWheelVector%MovementWheelVectorTempPrev%UnHoldStep:=MovementWheelVector%MovementWheelVectorTemp%UnHoldStep
    }
    MovementWheelVectors:=MovementWheelVectors-1
  }
  If(MovementWheelButtonState="U" and MouseButtonMovementLockDownState=1 and MovementWheelVector%MovementWheelVector%UnHoldStep=0)
    MovementWheelVector%MovementWheelVector%UnHoldStep:=1
  If(MovementWheelButtonState="D" and MouseButtonMovementLockDownState=1 and MovementWheelVector%MovementWheelVector%UnHoldStep=1)
    MovementWheelVector%MovementWheelVector%UnHoldStep:=2

  If (MovementWheelVectors<=MovementWheelVector)
    Break
}

If (MouseWheelCurrentAccelerationSpeed<MouseWheelMaxSpeed)
  MouseWheelCurrentAccelerationSpeed:=MouseWheelCurrentAccelerationSpeed+(MouseWheelAccelerationSpeed/MouseWheelAccelerationCycles)

MovementWheelResultantVectorMagnitude:=MouseWheelCurrentAccelerationSpeed*MovementWheelVectorMagnitudeRatio
MovementWheelResultantVectorDirection:=MovementWheelVectorDirection
MovementWheelResultantVectorX:=MovementWheelResultantVectorMagnitude*Cos(MovementWheelResultantVectorDirection)
MovementWheelResultantVectorY:=MovementWheelResultantVectorMagnitude*Sin(MovementWheelResultantVectorDirection)
;TrayTip,,% "(" . MovementResultantVectorMagnitude . "," . MovementResultantVectorDirection . ") - <" . MovementResultantVectorX . "," . MovementResultantVectorY . ">"

If (MovementWheelResultantVectorX>=0)
  MouseClick, wheelright,,, % MovementWheelResultantVectorX, 0, D
Else
  MouseClick, wheelleft,,, % -MovementWheelResultantVectorX, 0, D

If (MovementWheelResultantVectorY>=0)
  MouseClick, wheelup,,, % MovementWheelResultantVectorY, 0, D
Else
  MouseClick, wheeldown,,, % -MovementWheelResultantVectorY, 0, D
if (MovementButtonStateCtrl="D")
{
Send {Ctrl up}
}
Return


;Speed/rotation configuration support
;Movement
ButtonSpeedUp:
MouseSpeed:=MouseSpeed+2
ButtonSpeedDown:
MouseSpeed--
If (MouseSpeed>MouseMaxSpeed)
  MouseSpeed:=MouseMaxSpeed
If (MouseSpeed<=1)
{
  MouseSpeed:=1
  ToolTip, Mouse speed: %MouseSpeed% pixel
}
Else
  ToolTip, Mouse speed: %MouseSpeed% pixels
SetTimer, RemoveToolTip, 1000
Return

ButtonAccelerationSpeedUp:
MouseAccelerationSpeed:=MouseAccelerationSpeed+2
ButtonAccelerationSpeedDown:
MouseAccelerationSpeed--
If (MouseAccelerationSpeed<=1)
{
  MouseAccelerationSpeed:=1
  ToolTip, Mouse acceleration speed: %MouseAccelerationSpeed% pixel/cycle
}
Else
  ToolTip, Mouse acceleration speed: %MouseAccelerationSpeed% pixels/cycle
SetTimer, RemoveToolTip, 1000
Return

ButtonMaxSpeedUp:
MouseMaxSpeed:=MouseMaxSpeed+2
ButtonMaxSpeedDown:
MouseMaxSpeed--
If (MouseSpeed>MouseMaxSpeed)
  MouseSpeed:=MouseMaxSpeed
If (MouseMaxSpeed<=1)
{
  MouseMaxSpeed:=1
  ToolTip, Mouse maximum speed: %MouseMaxSpeed% pixel
}
Else
  ToolTip, Mouse maximum speed: %MouseMaxSpeed% pixels
SetTimer, RemoveToolTip, 1000
Return

ButtonRotationAngleUp:
MouseRotationAnglePart:=MouseRotationAnglePart+2
ButtonRotationAngleDown:
MouseRotationAnglePart--
If(MouseRotationAnglePart>=8)
  MouseRotationAnglePart:=0
If(MouseRotationAnglePart<0)
  MouseRotationAnglePart:=7
MouseRotationAngle = %MouseRotationAnglePart%
MouseRotationAngle *= 45
ToolTip, Mouse rotation angle: %MouseRotationAngle%°
SetTimer, RemoveToolTip, 1000
Return

;Wheel
ButtonWheelSpeedUp:
MouseWheelSpeed:=MouseWheelSpeed+2
ButtonWheelSpeedDown:
MouseWheelSpeed--
If (MouseWheelSpeed>MouseWheelMaxSpeed)
  MouseWheelSpeed:=MouseWheelMaxSpeed
If (MouseWheelSpeed<=1)
  MouseWheelSpeed:=1
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
MouseWheelSpeedTemp:=MouseWheelSpeed*MouseWheelSpeedMultiplier
If (MouseWheelSpeedTemp=1)
  ToolTip, Mouse wheel speed: %MouseWheelSpeedTemp% line
Else
  ToolTip, Mouse wheel speed: %MouseWheelSpeedTemp% lines
SetTimer, RemoveToolTip, 1000
Return

ButtonWheelAccelerationSpeedUp:
MouseWheelAccelerationSpeed:=MouseWheelAccelerationSpeed+2
ButtonWheelAccelerationSpeedDown:
MouseWheelAccelerationSpeed--
If (MouseWheelAccelerationSpeed<=1)
  MouseWheelAccelerationSpeed:=1
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
MouseWheelAccelerationSpeedTemp:=MouseWheelAccelerationSpeed*MouseWheelSpeedMultiplier
If (MouseWheelAccelerationSpeedTemp=1)
  ToolTip, Mouse wheel acceleration speed: %MouseWheelAccelerationSpeedTemp% line/cycle
Else
  ToolTip, Mouse wheel acceleration speed: %MouseWheelAccelerationSpeedTemp% lines/cycle
SetTimer, RemoveToolTip, 1000
Return

ButtonWheelMaxSpeedUp:
MouseWheelMaxSpeed:=MouseWheelMaxSpeed+2
ButtonWheelMaxSpeedDown:
MouseWheelMaxSpeed--
If (MouseWheelSpeed>MouseWheelMaxSpeed)
  MouseWheelSpeed:=MouseWheelMaxSpeed
If (MouseWheelMaxSpeed<=1)
  MouseWheelMaxSpeed:=1
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
MouseWheelMaxSpeedTemp:=MouseWheelMaxSpeed*MouseWheelSpeedMultiplier
If (MouseWheelMaxSpeedTemp=1)
  ToolTip, Mouse wheel max speed: %MouseWheelMaxSpeedTemp% line
Else
  ToolTip, Mouse wheel max speed: %MouseWheelMaxSpeedTemp% lines
SetTimer, RemoveToolTip, 1000
Return

ButtonWheelRotationAngleUp:
MouseWheelRotationAnglePart:=MouseWheelRotationAnglePart+2
ButtonWheelRotationAngleDown:
MouseWheelRotationAnglePart--
If(MouseWheelRotationAnglePart>=8)
  MouseWheelRotationAnglePart:=0
If(MouseWheelRotationAnglePart<0)
  MouseWheelRotationAnglePart:=7
MouseWheelRotationAngle = %MouseWheelRotationAnglePart%
MouseWheelRotationAngle *= 45
ToolTip, Mouse wheel rotation angle: %MouseWheelRotationAngle%°
SetTimer, RemoveToolTip, 1000
Return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
Return





DoubleClick:
MouseClick, left
MouseClick, left
Return

KeyUp:
GetKeyState, MouseButtonStateAlt, %tKSlow%, P
      If (MouseButtonStateAlt="D")
      Send, {LWin down}
GetKeyState, MouseButtonStateA, %tKCtrl%, P
If (MouseButtonStateA="D")
      Send, {Control down}
 GetKeyState, MovementButtonState, %tKSpeed%, P
if (MovementButtonState="D" )
    Send {Up}
Send {Up}
If (MouseButtonStateA="D")
      Send, {Control up}
If (MouseButtonStateAlt="D")
      Send, {LWin up}
Return

KeyDown:
GetKeyState, MouseButtonStateAlt, %tKSlow%, P
      If (MouseButtonStateAlt="D")
      Send, {LWin down}
GetKeyState, MouseButtonStateA, %tKCtrl%, P
If (MouseButtonStateA="D")
      Send, {Control down}
     GetKeyState, MovementButtonState, %tKSpeed%, P
if (MovementButtonState="D" )
    Send {Down}
Send {Down}
If (MouseButtonStateA="D")
      Send, {Control up}
If (MouseButtonStateAlt="D")
      Send, {LWin up}
Return

KeyLeft:
GetKeyState, MouseButtonStateAlt, %tKSlow%, P
      If (MouseButtonStateAlt="D")
      Send, {LWin down}
GetKeyState, MouseButtonStateA, %tKCtrl%, P
      If (MouseButtonStateA="D")
      Send, {Control down}
GetKeyState, MovementButtonState, %tKSpeed%, P
if (MovementButtonState="D" )
    Send {Left}
Send {Left}
If (MouseButtonStateA="D")
      Send, {Control up}
If (MouseButtonStateAlt="D")
      Send, {LWin up}
Return

KeyRight:
GetKeyState, MouseButtonStateAlt, %tKSlow%, P
      If (MouseButtonStateAlt="D")
      Send, {LWin down}
GetKeyState, MouseButtonStateA, %tKCtrl%, P
      If (MouseButtonStateA="D")
      Send, {Control down}
     GetKeyState, MovementButtonState, %tKSpeed%, P
if (MovementButtonState="D" )
    Send {Right}
    Send {Right}
    If (MouseButtonStateA="D")
      Send, {Control up}
If (MouseButtonStateAlt="D")
      Send, {LWin up}
Return


KeyUpShift:
GetKeyState, MouseButtonStateA, %tKCtrl%, P
If (MouseButtonStateA="D")
      Send, {Control down}
Send +{Up}
If (MouseButtonStateA="D")
      Send, {Control up}
Return

KeyDownShift:
GetKeyState, MouseButtonStateA, %tKCtrl%, P
If (MouseButtonStateA="D")
      Send, {Control down}
Send +{Down}
If (MouseButtonStateA="D")
      Send, {Control up}
Return

KeyLeftShift:
GetKeyState, MouseButtonStateA, %tKCtrl%, P
      If (MouseButtonStateA="D")
      Send, {Control down}
    Send +{Left}
    If (MouseButtonStateA="D")
      Send, {Control up}
Return

KeyRightShift:
GetKeyState, MouseButtonStateA, %tKCtrl%, P
      If (MouseButtonStateA="D")
      Send, {Control down}
    Send +{Right}
    If (MouseButtonStateA="D")
      Send, {Control up}
Return

KeyPgUp:
Send {PgUp}
Return

KeyPgDown:
Send {PgDn}
Return

KeyPgUpShift:
Send +{PgUp}
Return

KeyPgDownShift:
Send +{PgDn}
Return

KeyHome:
GetKeyState, MouseButtonStateShift, Shift
    GetKeyState, MouseButtonStateA, %tKCtrl%, P
    ;TrayTip,,% MouseButtonStateA
    If (MouseButtonStateShift="D")
      Send, {Shift down}
      If (MouseButtonStateA="D")
      Send, {Control down}
    Send {Home}
    If (MouseButtonStateShift="D")
      Send, {Shift up}
    If (MouseButtonStateA="D")
      Send, {Control up}
    Button%Buttons%Initialized:=1
Return

KeyEnd:
GetKeyState, MouseButtonStateShift, Shift
    GetKeyState, MouseButtonStateA, %tKCtrl%, P
    ;TrayTip,,% MouseButtonStateA
    If (MouseButtonStateShift="D")
      Send, {Shift down}
      If (MouseButtonStateA="D")
      Send, {Control down}
    Send {End}
    If (MouseButtonStateShift="D")
      Send, {Shift up}
    If (MouseButtonStateA="D")
      Send, {Control up}
    Button%Buttons%Initialized:=1
Return

KeyHomeShift:
    GetKeyState, MouseButtonStateA, %tKCtrl%, P
    ;TrayTip,,% MouseButtonStateA
      If (MouseButtonStateA="D")
      Send, {Control down}
    Send +{Home}
    If (MouseButtonStateA="D")
      Send, {Control up}
    Button%Buttons%Initialized:=1
Return

KeyEndShift:
    GetKeyState, MouseButtonStateA, %tKCtrl%, P
    ;TrayTip,,% MouseButtonStateA
      If (MouseButtonStateA="D")
      Send, {Control down}
    Send +{End}
    If (MouseButtonStateA="D")
      Send, {Control up}
    Button%Buttons%Initialized:=1
Return
