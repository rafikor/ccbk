dependencies: evdev
run: sudo python "./ccbk.py"

If there are several keyboards, then it will be proposed to press any key on a keyboard which you want  to use with the script.
Active ('ccbk') mode of script is indicated by light of Caps lock for used keyboard

Currently emulated keyboard keys and mouse buttons:

 Sometimes script starts generate mouse movements, and this key is only useful option to stop script (script runs under root).

up arrow
down arrow
lelt arrow
right arrow

mouse pointer up
mouse pointer down
mouse pointer left
mouse pointer right


ctrl+arows
ctrl+left mouse click)
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
tMWhlRight=e.KEY_P   #mouse wheel right (currently not i

правый alt - включение режима управления указателем мыши с клавиатуры
левый win (super) - выключение режима управления указателем мыши с клавиатуры и активация русской раскладки (ru)
    Длительное нажатие на левый win срабатывает как обычное (для возможности нажать win+w в Ubuntu)
caps lock - выключение режима управления указателем мыши с клавиатуры и активация английской раскладки (en)
Аварийный выход из программы - зажать клавишу ScrollLock на несколько секунд


В активном режиме (управления указателем мыши с клавиатуры и др.):
    указатель мыши:
        l - щелчок левой клавишей мыши
        w - двойной щелчок левой клавишей мыши
        m - щелчок правой клавишей мыши
        v+l - ctrl+щелчок мышью
        d/f - вправо/влево
        i/j - вверх/вниз
        влияние следущих клавиш на перемещение указателя мыши (в зажатом состоянии):
            ; - сильное ускорение
            a - среднее ускорение
            s - среднее замедление
            a+s - сильное замедление
        u/h - прокрутка колеса мыши вверх/вних
            при зажатых ; либо s - ускоренная прокрутка
        q - средняя кнопка мыши
    Иные клавиши клавиатуры:
        Клавиши, способные работать совместно с зажатыми shift и a (вместо ctrl):
            Стрелки:
                e,r - влево/вправо
                o,k - вверх/вниз
            c,x - pageUp/pageDown
            g,t - home/end
        b - клавиша меню
    
            