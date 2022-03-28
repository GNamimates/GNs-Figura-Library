### preview
this script does the hard parts of making a button for you, and makes it easier to make buttons, how easy it is?
really god damn easy:

```lua
function player_init()
    local myButton = GNUI.UI.button.new("MyEpicButton",model.HUD.button1)
    myButton.area = {
                    -83,32,--offset
                    128,16,--size
                    1,0--screen position
                    }
    myButton.pressed_function = function ()
        log("ive been pressed")
    end
    myButton.released_function = function ()
        log("ive been released")
    end

    myButton.label.text = "Info Button"
end
```
***
### Requirements
before we start this amazing journey, we need to set up things before we can actually do the good stuff, follow these instrunctions shown bellow
* add a new group to the model called `"HUD_DEBUG"`, caps, on the very top of the hierarchy(not a children of anything)
***
### Breakdown
even though its easily understandable, ill still explain on how this code works, how to make a button model and how to declare buttons in scripts yourself,
***
### Button Model

FIrst off, we need a button model, its really simple, just follow this layout:

```
📁buttonName1
 ├📁pressed1
 │ └🧊cube
 └📁idle1
   └🧊cube
```

**make sure to have the numbers at the end the same number and always have a number at the end**  

make sure to put the group in a HUD group as well, so its gonna be on screen

now that we have ourselves a model, lets tell the script that its a button,
***
### Button Script
To declare the group into a button you call in `player_init()`
```lua
GNUI.UI.button.new(<buton_name>,<model_path>)
```
yeah its a mouthful to type and say, anyways 
this returns the location of the button data in the `buttonElements` table, we can store this in a local variable so you dont have to find it after declaring:
```lua
local myButton = button.new(<buton name>,<model path>)
```
***
### Area
after we declare that its a button, we need to tell where the button is, since figura dosent have any functions for getting model positions, only offsets :(,
we store the value in a table like this: 
```lua
{x,y,width,height,anchorX,anchorY}
```
and heres what each value means
`x/y` = the origin point of the area, top left
`width/height` = the width of the button, negative dosent work
`anchorX/Y` = the anchor point on the screen 
example: `0,0` = top left of the screen, `1,1` = bottom right of the screen
we give it like so
```lua
myButton.area = {-64,0,64,64,1,0}
```
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
***
### Labels
theres a build in label support for buttons (version 0.5+)
it can be accessed in `button.label`  
the text in the label can be changed in `button.label.text`  
the text in the label can only be `string`  
if you want to change the colors using `jsons` you can change them in  
`button.label.pressed.format` or `button.label.idle.format`  

example on changing the text
```lua
button.label.text = "Epic"
```
  check the [[Aditional Info]] for more info about the button metadata layout.
***
### Aditional Info
heres all the data you can get/set in a button:
```lua
model=model_path,
groupRoot=nil, --if this object is disabled, so will the button
area : Vector6
wasPressed : boolean -- the value of isPressed but delayed by a tick
isPressed : boolean
justPressed : boolean -- triggers once pressed
justReleased : boolean -- triggers once released
hovering : boolean
disabled : boolean
pressed_function : function
released_function : function
dynamicValues={ -- values that change by themselves
    id=0,
    lastArea=nil,
    lastText="",
    labelDeclared=false,
    groupRootDisabled=false
}

label = {
    text : string,-- the label written on the button
    pressed = {
        format = [[{"text":"LABEL","color":"white"}]],
        -- the word "LABEL" will be replaced with text  (variable)

        offset = {0,0},
        -- the offset of the text when pressed
    },
    idle = {
        format = [[{"text":"LABEL","color":"dark_gray"}]],
        -- the word "LABEL" will be replaced with text  (variable)

        offset = {0,0}
        -- the offset of the text when idle
    }
}
```
### Button Metadata Notes:  
* the button will automatically be disabled when `groupRoot` gets disabled via `setEnable()`
* the format can just be a `text` instead of a `json`
***
### Config
```lua
showButtonAreas : boolean
-- shows the area of the buttons,

buttonAreaBehind : boolean
-- the area would be behind the button instead of in front,
-- only works if "showButtonAreas" is enabled

layout = {
    button = {
        -- the layout of all buttons
        idle = "idle",
        -- name of the idle# children on allbuttons
        
        pressed = "pressed",
        -- name of the pressed# children on all buttons
    }
}
```

congratulations, we've just made an awesome and functional beautiful button, and you know how this script works, you are a certified UI enjoyer now, now go make HUDs using this and Figura!