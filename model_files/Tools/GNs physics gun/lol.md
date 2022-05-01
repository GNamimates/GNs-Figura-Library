
**BUTTON LIBRARY(kinda.)**
this script does the hard parts of making a button for you, and makes it easier to make buttons, how easy it is?
really god damn easy:

```lua
function player_init()
    local myButton = button.new("MyEpicButton",model.HUD.button1)
    myButton.area = {-83,32,128,16,1,0}
    myButton.pressed_function = function ()
        log("ive been pressed")
    end
    myButton.released_function = function ()
        log("ive been released")
    end
end
```

even though its easily understandable, ill still explain on how this code works, how to make a button model and how to declare buttons in scripts yourself,

FIrst off, we need a button model, its really simple, just follow this layout:

```
:bb_group:buttonName1
├:bb_group:pressed1
│  └:bb_cube:cube
└:bb_group:idle1
    └:bb_cube:cube
```

**make sure to have the numbers at the end the same number and always have a number at the end**
make sure to put the group in a HUD group as well, so its gonna be on screen

now that we have ourselves a model, lets tell the script that its a button,

To declare the group into a button you call in `player_init()`
`button.new(<buton name>,<model path>)`
this returns the location of the button data in the `buttonElements` table, we can store this in a local variable so you dont have to find it after declaring:
`local myButton = button.new(<buton name>,<model path>)`

after we declare that its a button, we need to tell where the button is, since figura dosent have any functions for getting :(,
we store the value in a table like this: `{x,y,width,height,anchorX,anchorY}`

and heres what each value means
`x/y` = the origin point of the area, top left
`width/height` = the width of the button, negative dosent work
`anchorX/Y` = the anchor point on the screen 
example: `0,0` = top left of the screen, `1,1` = bottom right of the screen

we give it like so
`myButton.area = {-64,0,64,64,1,0}`
the 1st/2nd two values means the button is 64 UI pixels behind the x axis and at the top
the 3nd/4rd means the button is 64x64 big,
and the 5th/6th means they are anchored to the top right of the screen

after we declared they exist, we need to tell the script what its gonna do when its pressed or released, both of these are **optional** so you dont have to put a function, just when you need it

we add one like so
```lua
myButton.pressed_function = function ()
    log("ive been pressed")
end
```
and for the released trigger
```lua
myButton.released_function = function ()
    log("ive been released")
end
```

heres all the data you can get/set in a button:
```lua
model --model
area --table
wasPressed --boolean
isPressed --boolean
hovering --boolean
pressed_function --function
released_function --function
metadata={
    id --integer
}
```

congratulations, we've just made an awesome and functional beautiful button, and you know how this script works, you are a certified UI enjoyer now, now go make HUDs using this and Figura!