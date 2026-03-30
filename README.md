
# ShortcutsToolsSQLite

> [!IMPORTANT]  
> This package is undocumented. If you need help, DM me (`@no_pen_3825` on Discord; `u/No_Pen_3825` on Reddit).

```swift
// MARK: build Master
// use a copy from resolved `~/Library/Shortcuts/ToolKit/Tools-active`
let sqliteURL = URL
    .desktopDirectory
    .appending(path: "...")
    
let master = try Master(sqliteURL: sqliteURL)

// MARK: use in swift
print(master.actions.randomElement()!)
print(master.valueTypes.randomElement()!)
print(master.containers.randomElement()!)
//...

// MARK: export to json
let outputURL = URL
    .desktopDirectory
    .appending(path: "master.json")

try master.data().write(to: outputURL)
```
