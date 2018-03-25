# -*- coding: utf-8 -*-
"""
Created on Tue Dec  6 00:14:00 2016

@author: raforl
"""

import evdev
import time
import threading
import multiprocessing

import evdev.ecodes as e

from ccbk_config import *

devind=-1
def waitInput(device,index,queue):
    print(device)
    for event in device.read_loop():
        queue.put(index)
        return
        
import os
baseDir='/dev/input/by-path'  #where to search devices
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
    print('press key on a keyboard to grab it')
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
    keyboadsDevs.append(device)

print('Used keyboard:')
print(device)
device.capabilities()
device.leds(verbose=True)

mouse=None
for file in range(len(files)):
    if files[file].find('mouse')>=0:
        try:
            mouse = evdev.InputDevice(baseDir+'/'+files[file])
        except IOError as e:
            pass
        else:
            break

print('Used mouse:')
print(mouse )

from evdev import InputDevice
from select import select


from evdev import UInput, AbsInfo

###############################
#capabilities to 'create virtual mouse'
#cap = {    
#     e.EV_REL: [
#       (e.REL_X, AbsInfo(value=0, min=-255, max=255,
#                           fuzz=0, flat=0, resolution=0)),
#         (e.REL_Y, AbsInfo(0, -255, 255, 0, 0, 0)),
#         (e.ABS_MT_POSITION_X, (0, 255, 128, 0)) ]
#}

#cap2 = {
#     e.EV_KEY : [e.KEY_A, e.KEY_B],
#     e.EV_ABS : [
#         (e.ABS_X, AbsInfo(value=0, min=0, max=255,
#                           fuzz=0, flat=0, resolution=0)),
#         (e.ABS_Y, AbsInfo(0, 0, 255, 0, 0, 0)),
#         (e.ABS_MT_POSITION_X, (0, 255, 128, 0)) ]    
# }

#uimouse = UInput(cap2, name='example-device', version=0x3)
# move mouse cursor
#ui.write(e.EV_ABS, e.ABS_X, 20)
#ui.write(e.EV_ABS, e.ABS_Y, 20)
#ui.syn()
###############################

#from http://stackoverflow.com/questions/3503879/assign-output-of-os-system-to-a-variable-and-prevent-it-from-being-displayed-on
import subprocess

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
dictThreadsArrowsMove={}
threadMouseWheel=None

currentMouseSpeed=0
currentMouseSpeed_X=0
currentMouseSpeed_Y=0

def threadMouseMove(xy=e.REL_X,sgn=1):
    global currentMouseSpeed_X
    global currentMouseSpeed_Y
    while True:
        if (isKeyInPressedKeys(tKCtrl)):
            if not isKeyInPressedKeys(tKSpeed):
                if isKeyInPressedKeys(tKSlow):
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
        
        elif not isKeyInPressedKeys(tKSpeed):
            if isKeyInPressedKeys(tKSlow):
                uimouse.write(e.EV_REL, xy, 1*sgn)
            else:
                uimouse.write(e.EV_REL, xy, 20*sgn)
        else:
            if not isKeyInPressedKeys(tKCtrl):
                uimouse.write(e.EV_REL, xy, 100*sgn)    
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
    if value==1:
        dictThreadsMouseMove[key]=[StoppableThread(threadMouseMove, (xy,sgn)),0,]
        dictThreadsMouseMove[key][0].start()
    elif value==0:
        dictThreadsMouseMove[key][0].stop()
    
def mouseWheelMoveThreadfunc(sgn,ui):
    while True:
        isCtrl=False    
        if isKeyInPressedKeys(tKSlow):
            isCtrl=True    
        if isCtrl:
            ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 1)
            ui.syn()
            time.sleep(0.02)
        if not (isKeyInPressedKeys(tKSpeed) or isKeyInPressedKeys(tKCtrl)):
            uimouse.write(e.EV_REL , 8, sgn)#e.BTN_WHEEL
        else:
            uimouse.write(e.EV_REL , 8, sgn*3)
        uimouse.syn()
        if isCtrl:
            ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 0)
            ui.syn()
        uimouse.write(e.EV_REL , 8, 0)
        uimouse.syn()
        time.sleep(0.08)
        if threadMouseWheel.stopped():        
            return
    
def mouseWheelMove(ui,sgn=1,value=1):
    global threadMouseWheel
    if value==1:       
        threadMouseWheel=StoppableThread(mouseWheelMoveThreadfunc, (sgn,ui))
        threadMouseWheel.start()
    elif value==0:
        threadMouseWheel.stop()  

def mouseArrowsMoveThreadfunc(key, ui):
    while True:        
        if (not isKeyInPressedKeys(tKSpeed)):
            return        
        ui.write(e.EV_KEY , key, 1)        
        ui.write(e.EV_KEY , key, 0)
        ui.syn()
        time.sleep(0.03)
        if dictThreadsArrowsMove[key][0].stopped():        
            return        
            
def mouseArrowsMoveThreadsControlfunc(key,value,event, ui):    
    if (not isKeyInPressedKeys(tKSpeed)):
        kbdArrows(key, value,event,ui)        
    else:        
        if value==1:
            dictThreadsArrowsMove[key]=[StoppableThread(mouseArrowsMoveThreadfunc, (key,ui)),0,]
            dictThreadsArrowsMove[key][0].start()            
        elif value==0:
            try:
                dictThreadsArrowsMove[key][0].stop()
            except Exception as e:
                pass
 
def kbdArrows(key, value,event, ui):#, isUseCtrlAsSpeed=False):
    isCtrl=False
    if isKeyInPressedKeys(tKCtrl):
        isCtrl=True
    if isCtrl:
        ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 1)
        ui.syn()    
    ui.write(e.EV_KEY, key, value)
    if isKeyInPressedKeys(tKSpeed) or isKeyInPressedKeys(tKSlow):
        ui.write(e.EV_KEY, key, 0)        
        ui.write(e.EV_KEY, key, value)            
    if isCtrl:        
        ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 0)
    ui.syn()    
    
import os
pressedKeys={}

def isKeyInPressedKeys(key):
    for dev in pressedKeys.keys():
        if key in pressedKeys[dev]:
            return True
    return False
    
isExit=False

def serveKbd(device):
    global pressedKeys
    global ifGrabbed
    global isExit
    earlyPressedKeys={}
    isMeta=0
    #global ui
    with evdev.UInput.from_device(device) as ui:
    

        ifGrabbed=False
        device.grab()
        for event in device.read_loop():
            #print(event)        
            pressedKeys[device]=device.active_keys()
            #if ifGrabbed:
            if not ((isKeyInPressedKeys(e.KEY_LEFTCTRL) or isKeyInPressedKeys(e.KEY_RIGHTCTRL)) or (isKeyInPressedKeys(e.KEY_LEFTALT) ) or (isKeyInPressedKeys(e.KEY_RIGHTMETA))) and not event.code in [e.KEY_LEFTCTRL,e.KEY_RIGHTCTRL,e.KEY_LEFTALT,e.KEY_RIGHTMETA]:#or e.KEY_RIGHTALT in pressedKeys
                if not ifGrabbed:
                    if (event.code, event.value)==(evdev.ecodes.KEY_RIGHTALT,1):
                        ifGrabbed=True
                        for dev in keyboadsDevs:
                            dev.set_led(evdev.ecodes.LED_CAPSL, 1)
                        continue
                if (event.code, event.value)==(keyEmergencyExit,2) or isExit:     
                    isExit=True
                    for thrd in dictThreadsMouseMove.values():
                        thrd[0].stop()
                    for thrd in dictThreadsArrowsMove.values():
                        thrd[0].stop()
                    break
                if (event.code, event.value)==(keyDisableCCBKmodeFirstLayout,1):
                    ifGrabbed=False                
                    for dev in keyboadsDevs:
                        dev.set_led(evdev.ecodes.LED_CAPSL, 0) # disable caps led
                    #os.system('setxkbmap -layout us')            
                    #os.system('setxkbmap -model evdev -layout us -option -option \'grp:switch\'')
                    os.system(firstLayoutString)                
                    continue
                if (event.code, event.value)==(keyDisableCCBKmodeSecondLayout,1): #41 - `, 125 - LWin
                    ifGrabbed=False
                    for dev in keyboadsDevs:
                        dev.set_led(evdev.ecodes.LED_CAPSL, 0) # disable caps led
                    #os.system('setxkbmap -layout ru')
                    #string with long number of options is from here http://www.linux.org.ru/forum/desktop/6841687
                    #os.system('setxkbmap -model evdev -layout ru -option -option \'grp:switch\'')
                    #os.system('setxkbmap -layout ru -option \'grp:switch\'')
                    
                    #get by "setxkbmap -print"
                    os.system(secondLayoutString)
                    #continue
                    
                if ifGrabbed:
                    try:
                        if earlyPressedKeys[event.code]==1:
                            ui.write_event(event)
                            ui.syn()
                            earlyPressedKeys[event.code]=0                        
                    except Exception as err:
                        pass                     
        
                    if event.code==tKRight:
                        mouseArrowsMoveThreadsControlfunc(e.KEY_RIGHT,event.value,event,ui)
                    elif event.code==tKLeft:
                        mouseArrowsMoveThreadsControlfunc(e.KEY_LEFT,event.value,event,ui)
                    elif event.code==tKUp:
                        mouseArrowsMoveThreadsControlfunc(e.KEY_UP,event.value,event,ui)
                    elif event.code==tKDown:
                        mouseArrowsMoveThreadsControlfunc(e.KEY_DOWN,event.value,event,ui)
                    elif event.code==tKhome:                
                        kbdArrows(e.KEY_HOME, event.value,event,ui)
                    elif event.code==tKend:
                        kbdArrows(e.KEY_END, event.value,event,ui)
                    elif event.code==tKpgUp:
                        kbdArrows(e.KEY_PAGEUP, event.value,event,ui)
                    elif event.code==tKpgDown:
                        kbdArrows(e.KEY_PAGEDOWN, event.value,event,ui)
                    elif event.code==tMRight:
                        mouseMove(e.REL_X,1,event.value)
                    elif event.code==tMLeft:
                        mouseMove(e.REL_X,-1,event.value)                
                    elif event.code==tMUp:
                        mouseMove(e.REL_Y,-1,event.value)
                    elif event.code==tMDown:
                        mouseMove(e.REL_Y,1,event.value)
                    elif event.code==tMWhlDown:
                        mouseWheelMove(ui,-1,event.value)
                    elif event.code==tMWhlUp:
                        mouseWheelMove(ui,1,event.value)
                    elif event.code==e.KEY_Z:
                        #for eviacam (head tracking program)
                        #TODO: unstable code
                        if event.value==1 or event.value==0:
                            ui.write(e.EV_KEY, e.KEY_SCROLLLOCK,1)
                            ui.syn()                        
                            time.sleep(0.15)
                            ui.write(e.EV_KEY, e.KEY_SCROLLLOCK,0)
                            ui.syn()                        
                        #ui.write(e.EV_KEY, e.KEY_SCROLLLOCK,event.value)
                        ui.syn()                
                    elif (event.code, event.value)==(tMLclk,1):
                        if tKCtrlMouse in pressedKeys:
                            ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 1)
                        uimouse.write(e.EV_KEY , e.BTN_LEFT, 1)
                        uimouse.syn()                
                    elif (event.code, event.value)==(tMLclk,0):                    
                        uimouse.write(e.EV_KEY , e.BTN_LEFT, 0);
                        if tKCtrlMouse in pressedKeys:
                            ui.write(e.EV_KEY, e.KEY_LEFTCTRL, 0)
                        uimouse.syn()
                    elif (event.code, event.value)==(tMRclk,1):
                        uimouse.write(e.EV_KEY , e.BTN_RIGHT, 1)
                        uimouse.write(e.EV_KEY , e.BTN_RIGHT, 0)
                        uimouse.syn()
                    elif event.code==tMMclk:
                        uimouse.write(e.EV_KEY , e.BTN_MIDDLE, event.value)
                        uimouse.syn()
                    elif (event.code, event.value)==(tMDLclk,1):
                        uimouse.write(e.EV_KEY , e.BTN_LEFT, 1)
                        uimouse.write(e.EV_KEY , e.BTN_LEFT, 0);
                        uimouse.write(e.EV_KEY , e.BTN_LEFT, 1)
                        uimouse.write(e.EV_KEY , e.BTN_LEFT, 0)
                        uimouse.syn()
                    elif event.code==tAppsKey:
                        ui.write(e.EV_KEY , 127, event.value) #context menu
                        ui.syn()
                    elif event.code==tKSpeed:
                        #print('okl')
                        if event.value==1:
                            os.system('xinput set-prop 10 272 0.2');
                        elif event.value==0:
                            os.system('xinput set-prop 10 272 1');
                    elif event.code==tKCtrlMouse:              
                        pass
                    elif event.code==tKSlow:                    
                        pass
                    elif isKeyInPressedKeys(keyEnableCCBKmode):
                        pass
                    elif event.code==tKCtrl:
                        if (isKeyInPressedKeys(e.KEY_LEFTCTRL) or isKeyInPressedKeys(e.KEY_RIGHTCTRL)):
                            ui.write_event(event)
                            ui.syn()                
                    else:
                        ui.write_event(event)
                        ui.syn()
                else:                
                    if event.code==keyDisableCCBKmodeSecondLayout:
                        if event.value in [0,2]:
                            if event.value==2:
                                if isMeta==0:
                                    ui.write(e.EV_KEY, keyDisableCCBKmodeSecondLayout, 1)
                                    ui.syn()
                                    isMeta=1
                            if event.value==0:
                                isMeta=0                        
                            ui.write_event(event)
                            ui.syn()
                    elif event.value in (1,2):
                        earlyPressedKeys[event.code]=1                    
                        ui.write_event(event)
                    else:
                        try:
                            if earlyPressedKeys[event.code]==1:
                                ui.write_event(event)
                                earlyPressedKeys[event.code]=0                            
                        except Exception as err:
                            pass
                    ui.syn()
            else:
                if event.code == keyDisableCCBKmodeFirstLayout:
                    pass
                else:
                    if event.value in (1,2):
                        earlyPressedKeys[event.code]=1
                        ui.write_event(event)
                    else:
                        try:
                            if earlyPressedKeys[event.code]==1:
                                ui.write_event(event)
                                earlyPressedKeys[event.code]=0
                        except Exception as err:
                            pass
                    ui.syn() 
        device.ungrab()
 
threadsServeKbd={}
#with evdev.UInput.from_device(keyboadsDevs[0]) as ui:
for dev in keyboadsDevs:
    threadsServeKbd[dev]=StoppableThread(serveKbd, (dev,))  
    threadsServeKbd[dev].start()
