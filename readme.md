# Introduction
I don't like to use mouse, so here are results of my search and work in order to control mouse (and keyboard keys placed far away like arrows) by central part of keyboard in iseful and convenient way (if you use 10-finger touch typing, you will never move your arms). I have continuously used programs presented here for approximately two years both at work and home (except for games and 3D software, of course). It is useful when one has mouse and very useful when mouse can't be used (e.g. in waiting hall). I can't say anything about influence of this way to work to progress of Carpal tunnel syndrome.

There are two programs, one is for linux (python), the second is for windows (autohotkey script)
Both parts work almost in the same way from user point of view (I have windows at work and linux at home), but implementations are totally different.


The code is ugly, but working; refactor will be done in case of interest from other people.

Inspired by https://lexikos.github.io/v2/docs/scripts/NumpadMouse.htm

## User guide (for both linux and windows):
Right alt: activation of mouse pointer control by keyboard
Left win (super): deactivation of mouse pointer control by keyboard and activation of russian keyboard layout (ru)
caps lock: deactivation of mouse pointer control by keyboard and activation of english keyboard layout (en)
Emergency exit (could be required only at Linux part): press ScrollLock for several seconds

### When control of mouse is active:
-    mouse pointer:

--        l: left mouse button click

--        w: left mouse button click

--        m: right mouse button click

--        d/f: mouse pointer to right/left

--        i/j: mouse pointer to up/down

--       influence of the following buttons to mouse pointer movements (when hold):

---            ';' is for high acceleration

---            a is medium acceleration

---            s is medium slowdown

---            a+s is high slowdown

--        u/h: mouse wheel up/down

---            during ';' or s hold it will be accelerated

--        q: middle mouse button

### Other keys:
-        Keys working together with modifiers shift and a (instead of ctrl, only windows):

--            arrows:

---                e,r: left/right

---                o,k: up/down

--            c,x: pageUp/pageDown

--            g,t: home/end

-        b: menu button
    

# Windows part

See file mouse_windows.ahk. (autohotkey script).
This script is used as base (and the entire work is inspired by): "Using Keyboard NumPad as a Mouse -- by deguix" (https://lexikos.github.io/v2/docs/scripts/NumpadMouse.htm). Main differences are remapping of keys and addition of some other keys like arrows and PgDn/PgUp.

# Linux part


dependencies: evdev

run: sudo python "./ccbk.py"


Active ('ccbk') mode of script is indicated by light of Caps lock for used keyboard

Currently emulated keyboard keys and mouse buttons:

 Sometimes script starts generate mouse movements, so, press any keys moving mouse, and it will be ok.


            
