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