
# ShortcutsToolsSQLite

> [!IMPORTANT]  
> This package is undocumented. If you need help DM me (\@No\_Pen\_3825 on Discord; u\/No\_Pen\_3825 on Reddit).

```swift
// copy from resolved `~/Library/Shortcuts/ToolKit/Tools-active`
let sqliteURL = URL
    .desktopDirectory
    .appending(path: "SESCA/Tools-prod_1.sqlite")
    
let master = try Master(sqliteURL: sqliteURL)

// master.actions...
// master.valueTypes...
// master.containers...
```
