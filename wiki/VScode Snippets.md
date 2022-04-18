## How To Use My VSCode Snippets
1. simply open file explorer
1. paste `%appdata%\Code\User` to the path
1. create a new file called `lua.json`  
1. and copy paste the my Snippets to `lua.json`
### Letting VSCode know the Snippets Exists
   after we add our snippets, we need to tell VSCode to read our Snippets, we can do this by following the instructions bellow:
1. open the command palette
   * windows & Linux: `Ctrl + Shift + P` by default
   * mac `Cmd + Shift + P` by default
2. look for `Preferences: Open Settings (JSON)`
3. and merge `"editor.quickSuggestions":true` to your `[lua]` dictionary, or if `[lua]` dosent exist, paste this inside the dictionary(`{}`):
```json
    "[lua]": {
        "editor.quickSuggestions":true
    },
```
4. and you are done! now the snippets that you added should appear now when you type the prefixes.

## tips on using VSCode Snippets
* you can scroll though tabstops when pressing tab, this is very helpful for selecting things inside the snippets, note that only some have this, ive listed the tabstops in the snippets bellow so you know where each one is or if a snippet has one 
# Current VSCode Snippets

## to Angle
* Converts Vectors/Tables to Angle

### Tabstops
1. none
```json
"To Angle": {
	"prefix": "toAngle",
	"body": [
		"function math.toAngle(pos)",
		"    local y = math.atan2(pos.x,pos.z)",
		"    local result = vectors.of({math.atan2((math.sin(y)*pos.x+(math.cos(y)*pos.z),pos.y),y})",
		"    return vectors.of({math.deg(result.x),math.deg(result.y)math.deg(result.z)})",
		"end"
	],
	"description": "Converts a position to an angle"
},
```

## Lerp Angle
* note that this is in degrees
### Tabstops
1. none
```json
"Lerp Angle" : {
		"prefix": "LerpAngle",
	"body": [
		"function lerp_angle(a, b, x)",
    	"    local diff = (b-a)",
    	"    local delta = diff-(math.floor(diff/360)*360)",
    	"    if delta > 180 then",
    	"        delta = delta - 360",
    	"    end",
    	"    return a + delta * x",
		"end"
	],
	"description": "Lerp Angle"
},
```

## Figura Skeleton
* creates a standard Figura skeleton
### Tabstops
1. inside `player_init()`
1. inside `tick()`
1. inside `world_render()`
1. entire `player_init()`
1. entire `tick()`
1. entire `world_render()`
```json
"Figura Skeleton": {
	"prefix": "Figura",
	"body": [
		"${4:function player_init()",
		"${1:--PLAYER INIT--}",
		"end}",
		"",
		"${5:function tick()",
		"${2:--TICK--}",
		"end}",
		"",
		"${6:function world_render()",
		"${3:--WORLD RENDER--}",
		"end}"
	]
},
```

## Figura Skeleton(No Comment)
* creates a standard Figura skeleton but without comment
### Tabstops
1. inside `player_init()`
1. inside `tick()`
1. inside `world_render()`
1. entire `player_init()`
1. entire `tick()`
1. entire `world_render()`
```json
"Figura Skeleton No Comment": {
	"prefix": "Figura:noComment",
	"body": [
		"${4:function player_init()",
		"$1",
		"end}",
		"",
		"${5:function tick()",
		"$2",
		"end}",
		"",
		"${6:function world_render(delta)",
		"$3",
		"end}"
	]
},
```

## Figura Skeleton(All)
* creates a standard Figura skeleton but without comment
### Tabstops
1. entire `player_init()`
1. entire `tick()`
1. entire `render()`
1. entire `world_render()`
1. entire `onDamage()`
1. entire `onCommand()`
1. command prefix
1. inside `player_init()`
1. inside `tick()`
1. inside `render()`
1. inside `world_render()`
1. inside `onDamage()`
1. inside `onCommand()`
```json
"Figura Skeleton All": {
	"prefix": "Figura:all",
	"body": [
		"${1:function player_init()",
		"    $8",
		"end}",
		"",
		"${2:function tick()",
		"    $9",
		"end}",
		"",
		"${3:function render(delta)",
		"    $10",
		"end}",
		"",
		"${4:function world_render(delta)",
		"    $11",
		"end}",
		"",
		"${5:function onDamage(damage,source)",
		"    $12",
		"end}",
		"",
		"${6:chat.setFiguraCommandPrefix(\"${7:/}\")",
		"function onCommand(text)",
		"    $13",
		"end}"
	]
}
```