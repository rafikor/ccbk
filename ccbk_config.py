import evdev.ecodes as e

##config section
##################################################
#key settings
keyEmergencyExit=e.KEY_SCROLLLOCK   #key for emergency exit. Sometimes the script starts generate mouse movements, and this key is the only useful option to stop the script (the script uses threads, so ctrl+c is no option to terminate it). Remember this key:)

tKUp=e.KEY_O  #up arrow
tKDown=e.KEY_K  #down arrow
tKLeft=e.KEY_E   #lelt arrow
tKRight=e.KEY_R   #right arrow

tMUp=e.KEY_I    #moude pointer up
tMDown=e.KEY_J   #moude pointer down
tMLeft=e.KEY_D   #moude pointer left
tMRight=e.KEY_F   #moude pointer right

tKCtrl=e.KEY_A    #ctrl key for arrows (tKCtrl+tKLeft is like ctr+left)
tKSlow=e.KEY_S   #slower simulated mouse movements. Also tKSlow+tMWhlUp - is for scaling, like ctrl+mouse wheel up, same for mouse wheel down. For convenience (to offload fingers on right hand), this key also speeds up mouse wheel (like tKSpeed)
tKCtrlMouse=e.KEY_V   #ctrl key for mouse (tKCtrlMouse+tMLclk is like ctrl+left mouse click)
tKSpeed=39  # speeds up mouse moves when pressed  (39 is ';' key). Also speeds up arow presses and mouse wheel buttons

tMLclk=e.KEY_L   #left mouse click
tMRclk=e.KEY_M     #right mouse click
tMMclk=e.KEY_Q      #middle mouse click
tMDLclk=e.KEY_W      #double left mouse click

tMWhlUp=e.KEY_U   #mouse wheel up
tMWhlDown=e.KEY_H    #mouse wheel down

tKhome=e.KEY_T   #home
tKend=e.KEY_G    #end
tKpgUp=e.KEY_X    #page up
tKpgDown=e.KEY_C   #page down
tAppsKey=e.KEY_B   #context menu
tMWhlLeft=e.KEY_Y   #mouse wheel left (currently not implemented)
tMWhlRight=e.KEY_P   #mouse wheel right (currently not implemented)

keyEnableCCBKmode=e.KEY_RIGHTALT    #key to enter to emulate special keys and mouse from keyboard (aka 'ccbk mode')
keyDisableCCBKmodeFirstLayout=58 # Disables ccbk mode and sets first keyboard layout by firstLayoutString (58 is Caps Lock)
firstLayoutString='setxkbmap us' #english

keyDisableCCBKmodeSecondLayout=e.KEY_LEFTMETA # Disables ccbk mode and sets second keyboard layout by secondLayoutString. Set this variable to -1 if you do not need quick switch to second keyboard layout
#long presses of keyDisableCCBKmodeSecondLayout are transferred to the system (this is convinient when you use left meta key, your keyboard have no right meta key, and you want to use, e.g., ubuntu shortcuts)
secondLayoutString='setxkbmap ru+us:2' #russian layout
##################################################

#speed settings. Currently not used!
###############################
#timeToSpeedUp=0.
#MouseMaxSpeed=0
#MouseMaxSpeedFast=0
#MouseMaxSpeedSlow=0
#MouseMaxSpeedUsual=0

#MouseSpeed=0.1
#MouseSpeedFast=0.2
#MouseSpeedFastFast=0.03
#MouseAccelerationSpeed=200
#MouseAccelerationCycles=20
#MouseAccelerationCyclesOld=MouseAccelerationCycles
MouseAccelerationTimerInterval=15# ms
#MouseMaxSpeed=30
#MouseMaxSpeedUsual=20
#MouseMaxSpeedFast=20
#MouseMaxSpeedSlow=5

#MouseWheelSpeed=1
#MouseWheelSpeedFast=2
#MouseWheelAccelerationSpeed=1 #in pixels/MouseAccelerationCycles
#MouseWheelAccelerationCycles=50 #interval of timer executions to increase speed by the variable above
#MouseWheelAccelerationTimerInterval=35 #in milliseconds (this ends up to being approximate depending on computer performance)
#MouseWheelMaxSpeed=5
#MouseWheelRotationAngle=0
###############################