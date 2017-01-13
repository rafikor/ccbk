# -*- coding: utf-8 -*-
"""
Created on Tue Dec  6 00:14:00 2016

@author: baradaty-admin
"""

import evdev
import time
import threading
import multiprocessing

devind=-1
def waitInput(device,index,queue):
    print(device)
    for event in device.read_loop():
        queue.put(index)
        return
        
import os
baseDir='/dev/input/by-path'
files=os.listdir(baseDir)
keyboadsDevs=[]
keyboadsInputs=[]
keyboadsThreads=[]
queue=multiprocessing.Queue()

kbds=0
for file in range(len(files)):
    if files[file].find('kbd')>=0:
        kbds+=1
if kbds!=1:
    for file in range(len(files)):
        if files[file].find('kbd')>=0:
            keyboadsDevs.append(evdev.InputDevice(baseDir+'/'+files[file]))
            #keyboadsInputs.append(evdev.UInput.from_device(keyboadsDevs[-1]))
            keyboadsDevs[-1].grab()
            keyboadsThreads.append(multiprocessing.Process(target=waitInput,args=(keyboadsDevs[-1],len(keyboadsDevs)-1,queue) ))
            keyboadsThreads[-1].start()
    print('press key on a keyboard to grub it')
    devind=queue.get()
    for ind in range(len(keyboadsDevs)):
        keyboadsThreads[ind].terminate()
        keyboadsDevs[ind].ungrab()
        if devind==ind:
            device=keyboadsDevs[ind]
else:
    for file in range(len(files)):
        if files[file].find('kbd')>=0:
            device=evdev.InputDevice(baseDir+'/'+files[file])
            break

#device = evdev.InputDevice('/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd')
#/dev/input/by-path/platform-i8042-serio-0-event-kbd')
#
#'/dev/input/by-id/usb-Generic_USB_Keyboard-event-kbd')
#device = evdev.InputDevice('/dev/input/by-path/platform-i8042-serio-0-event-kbd')
print('Used keyboard:')
print(device)
device.capabilities()
device.leds(verbose=True)
#device.set_led(evdev.ecodes.LED_CAPSL, 1)  # enable numlock


mouse=None
for file in range(len(files)):
    if files[file].find('mouse')>=0:
        mouse = evdev.InputDevice(baseDir+'/'+files[file])
        break
#mouse = evdev.InputDevice('/dev/input/by-path/pci-0000:00:14.0-usb-0:6:1.0-event-mouse')
        
#'/dev/input/by-path/pci-0000:00:14.0-usb-0:6:1.0-event-mouse')
#mouse = evdev.InputDevice('/dev/input/event13')
#'/dev/input/by-path/pci-0000:00:14.0-usb-0:2:1.0-event-mouse')#'/dev/input/by-path/pci-0000:00:14.0-usb-0:6:1.0-event-mouse')
print('Used mouse:')
print(mouse )
#device=mouse

from evdev import InputDevice
from select import select
import evdev.ecodes as e

# A mapping of file descriptors (integers) to InputDevice instances.
devices = [mouse]#[device]#map(InputDevice, ('/dev/input/event1', '/dev/input/event2'))
devices = {dev.fd: dev for dev in devices}

#for dev in devices.values(): print(dev)

from evdev import UInput, AbsInfo

cap = {
    #e.EV_KEY : [e.KEY_A, e.KEY_B],
     e.EV_REL: [
       (e.REL_X, AbsInfo(value=0, min=-255, max=255,
                           fuzz=0, flat=0, resolution=0)),
         (e.REL_Y, AbsInfo(0, -255, 255, 0, 0, 0)),
         (e.ABS_MT_POSITION_X, (0, 255, 128, 0)) ]
}

cap2 = {
     e.EV_KEY : [e.KEY_A, e.KEY_B],
     e.EV_ABS : [
         (e.ABS_X, AbsInfo(value=0, min=0, max=255,
                           fuzz=0, flat=0, resolution=0)),
         (e.ABS_Y, AbsInfo(0, 0, 255, 0, 0, 0)),
         (e.ABS_MT_POSITION_X, (0, 255, 128, 0)) ]    
 }

#uimouse = UInput(cap2, name='example-device', version=0x3)
# move mouse cursor
#ui.write(e.EV_ABS, e.ABS_X, 20)
#ui.write(e.EV_ABS, e.ABS_Y, 20)
#ui.syn()


#from http://stackoverflow.com/questions/3503879/assign-output-of-os-system-to-a-variable-and-prevent-it-from-being-displayed-on
import subprocess
#proc = subprocess.Popen(["cat", "/etc/services"], stdout=subprocess.PIPE, shell=True)
#(out, err) = proc.communicate()
#print "program output:", out


class StoppableThread(threading.Thread):
    """Thread class with a stop() method. The thread itself has to check
    regularly for the stopped() condition."""

    def __init__(self,func,args):
        super(StoppableThread, self).__init__(target=func,args=args)
        self._stop = threading.Event()

    def stop(self):
        self._stop.set()

    def stopped(self):
        return self._stop.isSet()
        

uimouse=evdev.UInput.from_device(mouse)

dictThreadsMouseMove={}
threadMouseWheel=None

timeToSpeedUp=0.
MouseMaxSpeed=0
MouseMaxSpeedFast=0
MouseMaxSpeedSlow=0
MouseMaxSpeedUsual=0

MouseSpeed=0.1
MouseSpeedFast=0.2
MouseSpeedFastFast=0.03
MouseAccelerationSpeed=200
MouseAccelerationCycles=20
MouseAccelerationCyclesOld=MouseAccelerationCycles
MouseAccelerationTimerInterval=15#10
MouseMaxSpeed=30
MouseMaxSpeedUsual=20
MouseMaxSpeedFast=20
MouseMaxSpeedSlow=5

MouseWheelSpeed=1
MouseWheelSpeedFast=2
MouseWheelAccelerationSpeed=1 #in pixels/MouseAccelerationCycles
MouseWheelAccelerationCycles=50 #interval of timer executions to increase speed by the variable above
MouseWheelAccelerationTimerInterval=35 #in milliseconds (this ends up to being approximate depending on computer performance)
MouseWheelMaxSpeed=5
MouseWheelRotationAngle=0


tKUp=e.KEY_O
tKDown=e.KEY_K
tKLeft=e.KEY_E
tKRight=e.KEY_R

tMUp=e.KEY_I
tMDown=e.KEY_J
tMLeft=e.KEY_D
tMRight=e.KEY_F

tKCtrl=e.KEY_A
tKSlow=e.KEY_S
tKCtrlMouse=e.KEY_V
tKSpeed=39

tMLclk=e.KEY_L
tMRclk=e.KEY_M
tMMclk=e.KEY_Q
tMDLclk=e.KEY_W

tMWhlUp=e.KEY_U
tMWhlDown=e.KEY_H

tKhome=e.KEY_T
tKend=e.KEY_G
tKpgUp=e.KEY_X
tKpgDown=e.KEY_C
tAppsKey=e.KEY_B
tMWhlLeft=e.KEY_Y
tMWhlRight=e.KEY_P

currentMouseSpeed=0
currentMouseSpeed_X=0
currentMouseSpeed_Y=0



def threadMouseMove(xy=e.REL_X,sgn=1):
    global currentMouseSpeed_X
    global currentMouseSpeed_Y
    while True:
        if (not e.KEY_A in pressedKeys):
            if not (39 in pressedKeys):
                if (e.KEY_S in pressedKeys):
                    uimouse.write(e.EV_REL, xy, 4*sgn)
                else:
                    if xy!=e.REL_X:
                        currentMouseSpeed_Y+=1
                        currentMouseSpeed=int(min(currentMouseSpeed_Y,10))
                    else:
                        currentMouseSpeed_X+=1
                        currentMouseSpeed=int(min(currentMouseSpeed_X,10))
                    uimouse.write(e.EV_REL, xy, currentMouseSpeed*sgn)            
            else:
                uimouse.write(e.EV_REL, xy, 50*sgn)
        
        elif not (39 in pressedKeys):
            if (e.KEY_S in pressedKeys):
                #print("f")
                uimouse.write(e.EV_REL, xy, 2*sgn)
            else:
                uimouse.write(e.EV_REL, xy, 20*sgn)
        else:
            uimouse.write(e.EV_REL, xy, 50*sgn)    
        uimouse.syn()
        time.sleep(MouseAccelerationTimerInterval*1e-3)
        if dictThreadsMouseMove[(xy,sgn)][0].stopped():
            if xy!=e.REL_X:
                currentMouseSpeed_Y=0
            else:
                currentMouseSpeed_X=0
            return
    

def mouseMove(xy=e.REL_X,sgn=1,value=1):#sgn=1 or -1    
    key=(xy,sgn)
    if value==1:# or value==2:        
                            #[thread,    current speed,  MouseSpeed,    maxSpeed,   acceleration interval, acceleration speed]
#==============================================================================
#         MouseMaxSpeed:=MouseMaxSpeedUsual ;MouseMaxSpeedSlow
#         
#         MovementButtonStateCtrl = True
#         GetKeyState, MovementButtonState, %tKSpeed%, P
#         if (MovementButtonStateCtrl="D" )
#         {
#             if (MovementButtonState="U" )
#             {
#             ;MouseMaxSpeed:=MouseMaxSpeedSlow*2
#             MouseAccelerationCycles:=MouseAccelerationCycles*1.15
#             }
#         }
#         GetKeyState, MovementButtonState, %tKSlow%, P
#         if (MovementButtonState="D" )
#             {
#             MouseMaxSpeed:=MouseMaxSpeedSlow
#             MouseAccelerationCycles:=MouseAccelerationCycles*1.5
#             ;;MouseAccelerationCycles:=MouseAccelerationCyclesOld
#             }
#==============================================================================

        #if (e.KEY_A in pressedKeys):
        #    uimouse.write(e.EV_REL, xy, 10*sgn)
        #elif not (39 in pressedKeys):
        #    uimouse.write(e.EV_REL, xy, 20*sgn)
        #else:
        #    uimouse.write(e.EV_REL, xy, 50*sgn)    
        dictThreadsMouseMove[key]=[StoppableThread(threadMouseMove, (xy,sgn)),0,]
        dictThreadsMouseMove[key][0].start()
    elif value==0:
        dictThreadsMouseMove[key][0].stop()
    
def mouseWheelMoveThreadfunc(sgn=1):
    while True:
        isCtrl=False    
        if (e.KEY_A in pressedKeys):
            isCtrl=True    
        if isCtrl:
            ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 1)
        if not (39 in pressedKeys or e.KEY_S in pressedKeys ):
            uimouse.write(e.EV_REL , 8, sgn)#e.BTN_WHEEL
        else:
            uimouse.write(e.EV_REL , 8, sgn*3)
        if isCtrl:
            ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 0)
            ui.syn()
        uimouse.write(e.EV_REL , 8, 0)
        uimouse.syn()
        time.sleep(0.08)
        if threadMouseWheel.stopped():        
            return
    
def mouseWheelMove(sgn=1,value=1):
    global threadMouseWheel
    if value==1:       
        threadMouseWheel=StoppableThread(mouseWheelMoveThreadfunc, (sgn,))
        threadMouseWheel.start()
    elif value==0:
        threadMouseWheel.stop()  
    
    
def kbdArrows(key, value,event):#, isUseCtrlAsSpeed=False):
    isCtrl=False
    if (e.KEY_A in pressedKeys):
        isCtrl=True
    if isCtrl:
        ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 1)
        ui.syn()    
    ui.write(e.EV_KEY, key, value)  # KEY_A down                
    #isDoublePress=False
    #if 39 in pressedKeys:
        #isDoublePress=True
    if 39 in pressedKeys or e.KEY_S in pressedKeys:
        #isDoublePress=True
    #if isDoublePress:
        ui.write(e.EV_KEY, key, 0)        
        ui.write(e.EV_KEY, key, value)            
    if isCtrl:        
        ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 0)
    ui.syn()    
    
import os
earlyPressedKeys={}
isMeta=0

with evdev.UInput.from_device(device) as ui:
    

    ifGrabbed=False
    device.grab()
    for event in device.read_loop():
        #print(event)        
        pressedKeys=device.active_keys()        
        #if ifGrabbed:
        if not ((e.KEY_LEFTCTRL in pressedKeys or e.KEY_RIGHTCTRL in pressedKeys) or (e.KEY_LEFTALT in pressedKeys ) or (e.KEY_RIGHTMETA in pressedKeys)) and not event.code in [e.KEY_LEFTCTRL,e.KEY_RIGHTCTRL,e.KEY_LEFTALT,e.KEY_RIGHTMETA]:#or e.KEY_RIGHTALT in pressedKeys
            if not ifGrabbed:
                if (event.code, event.value)==(evdev.ecodes.KEY_RIGHTALT,1):
                    ifGrabbed=True
                    device.set_led(evdev.ecodes.LED_CAPSL, 1)
                    continue
            if (event.code, event.value)==(e.KEY_SCROLLLOCK,2):                
                for thrd in dictThreadsMouseMove.values():
                    thrd[0].stop()
                break
            if (event.code, event.value)==(58,1):
                ifGrabbed=False                
                device.set_led(evdev.ecodes.LED_CAPSL, 0)
                #os.system('setxkbmap -layout us')            
                #os.system('setxkbmap -model evdev -layout us -option -option \'grp:switch\'')
                os.system('setxkbmap us')
                
                continue
            if (event.code, event.value)==(evdev.ecodes.KEY_LEFTMETA,1): #41 - `, 125 - LWin
                ifGrabbed=False
                device.set_led(evdev.ecodes.LED_CAPSL, 0)
                #os.system('setxkbmap -layout ru')
                #строка с больши числом опций взята отсюда: http://www.linux.org.ru/forum/desktop/6841687
                #os.system('setxkbmap -model evdev -layout ru -option -option \'grp:switch\'')
                #os.system('setxkbmap -layout ru -option \'grp:switch\'')
                
                #get by "setxkbmap -print"
                os.system('setxkbmap ru+us:2')
                #continue
                
            if ifGrabbed:                        
                #print(event.code==evdev.ecodes.KEY_LEFTMETA) 
                #print(pressedKeys)
                try:
                    if earlyPressedKeys[event.code]==1:
                        ui.write_event(event)
                        ui.syn()
                        earlyPressedKeys[event.code]=0                        
                except Exception as err:
                    pass                     
    
                if event.code==e.KEY_R:                
                    kbdArrows(e.KEY_RIGHT, event.value,event)                
                elif event.code==e.KEY_E:                
                    kbdArrows(e.KEY_LEFT, event.value,event)
                elif event.code==e.KEY_O:                
                    kbdArrows(e.KEY_UP, event.value,event)
                elif event.code==e.KEY_K:                
                    kbdArrows(e.KEY_DOWN, event.value,event)                                
                elif event.code==e.KEY_T:                
                    kbdArrows(e.KEY_HOME, event.value,event)
                elif event.code==e.KEY_G:                
                    kbdArrows(e.KEY_END, event.value,event)
                elif event.code==e.KEY_X:
                    kbdArrows(e.KEY_PAGEUP, event.value,event)
                elif event.code==e.KEY_C:
                    kbdArrows(e.KEY_PAGEDOWN, event.value,event)
                elif event.code==e.KEY_F:
                    mouseMove(e.REL_X,1,event.value)
                elif event.code==e.KEY_D:
                    mouseMove(e.REL_X,-1,event.value)                
                elif event.code==e.KEY_I:
                    mouseMove(e.REL_Y,-1,event.value)
                elif event.code==e.KEY_J:
                    mouseMove(e.REL_Y,1,event.value)
                elif event.code==e.KEY_H:
                    mouseWheelMove(-1,event.value)
                elif event.code==e.KEY_U:
                    mouseWheelMove(1,event.value)
                elif event.code==e.KEY_Z:    
                    #eviacam
                    if event.value==1 or event.value==0:
                        ui.write(e.EV_KEY, e.KEY_SCROLLLOCK,1)
                        ui.syn()                        
                        time.sleep(0.15)
                        ui.write(e.EV_KEY, e.KEY_SCROLLLOCK,0)
                        ui.syn()                        
                    #ui.write(e.EV_KEY, e.KEY_SCROLLLOCK,event.value)
                    ui.syn()
                #elif event.code == e.KEY_RIGHTMETA:
                 #   print('ololo')
                elif (event.code, event.value)==(e.KEY_L,1):
                    if e.KEY_V in pressedKeys:
                        ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 1)
                    uimouse.write(e.EV_KEY , e.BTN_LEFT, 1)
                    uimouse.syn()                
                elif (event.code, event.value)==(e.KEY_L,0):                    
                    uimouse.write(e.EV_KEY , e.BTN_LEFT, 0);
                    if e.KEY_V in pressedKeys:
                        ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 0)
                    uimouse.syn()
                elif (event.code, event.value)==(e.KEY_M,1):
                    uimouse.write(e.EV_KEY , e.BTN_RIGHT, 1)
                    uimouse.write(e.EV_KEY , e.BTN_RIGHT, 0)
                    uimouse.syn()
                elif event.code==e.KEY_Q:                    
                    uimouse.write(e.EV_KEY , e.BTN_MIDDLE, event.value)
                    uimouse.syn()
                elif (event.code, event.value)==(e.KEY_W,1):
                    uimouse.write(e.EV_KEY , e.BTN_LEFT, 1)
                    uimouse.write(e.EV_KEY , e.BTN_LEFT, 0);
                    uimouse.write(e.EV_KEY , e.BTN_LEFT, 1)
                    uimouse.write(e.EV_KEY , e.BTN_LEFT, 0)
                    uimouse.syn()
                elif event.code==e.KEY_B:
                    ui.write(e.EV_KEY , 127, event.value)
                    ui.syn()
                elif event.code==39:
                    #print('okl')
                    pass
                elif event.code==e.KEY_V:
                    #print('h')
                    #if event.value==0:
                        #ui.write_event(event)
                        #ui.syn()
                    pass
                elif event.code==e.KEY_S:
                    #print('okl')
                    pass
                elif e.KEY_RIGHTALT in pressedKeys:
                    pass
                elif event.code==e.KEY_A:
                    if (e.KEY_LEFTCTRL in pressedKeys or e.KEY_RIGHTCTRL in pressedKeys):
                        ui.write_event(event)
                        ui.syn()                
                else:
#==============================================================================
#                     if event.value in (1,2):
#                         earlyPressedKeys[event.code]=1
#                         #print('fdof')
#                         ui.write_event(event)
#                     else:
#                         try:
#                             if earlyPressedKeys[event.code]==1:
#                                 ui.write_event(event)
#                                 earlyPressedKeys[event.code]=0
#                                 #print('hell')
#                         except Exception as err:
#                             pass                    
#==============================================================================
                    ui.write_event(event)
                    ui.syn()
            else:                
                #ui.write_event(event)                
                if event.code==evdev.ecodes.KEY_LEFTMETA:                    
                    if event.value in [0,2]:
                        if event.value==2:
                            if isMeta==0:
                                ui.write(e.EV_KEY, e.KEY_LEFTMETA, 1)
                                ui.syn()
                                isMeta=1
                        if event.value==0:
                            isMeta=0
                        #print('ofdof')
                        ui.write_event(event)
                        ui.syn()
                elif event.value in (1,2):
                    earlyPressedKeys[event.code]=1
                    #print('fdof')
                    ui.write_event(event)
                else:
                    try:
                        if earlyPressedKeys[event.code]==1:
                            ui.write_event(event)
                            earlyPressedKeys[event.code]=0
                            #print('hell')
                    except Exception as err:
                        pass            
                ui.syn()
        else:
            if event.code == 58:
                pass
                #print('ololo')
            else:
                if event.value in (1,2):
                    earlyPressedKeys[event.code]=1
                    #print('fdof')
                    ui.write_event(event)
                else:
                    try:
                        if earlyPressedKeys[event.code]==1:
                            ui.write_event(event)
                            earlyPressedKeys[event.code]=0
                            #print('hell')
                    except Exception as err:
                        pass                
                #ui.write_event(event)                
                ui.syn() 
    device.ungrab()
        
