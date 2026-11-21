# notify

A lightweight notification library.

## Usage

```lua
local notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/.../source.lua"))()

notify("Title", "Content")
```

## API

```
notify(title, content, icon, duration, position, button, close)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `string` | — | Bold title |
| `content` | `string` | — | Body text |
| `icon` | `number \| string \| nil` | `nil` | Asset ID or file path |
| `duration` | `number?` | auto | Seconds before dismiss (3–10s auto from content length) |
| `position` | `string?` | `"Bottom Right"` | Stack position |
| `button` | `table?` | `nil` | Action button |
| `close` | `boolean?` | `true` | Show × button |

### Positions

| Value | Description |
|---|---|
| `"Bottom Right"` | Stacks upward |
| `"Bottom Left"` | Stacks upward |
| `"Top Right"` | Stacks downward |
| `"Top Left"` | Stacks downward |

### Button

```lua
{ Text = "string", Callback = function() end }
```

## Examples

```lua
notify("Done", "Task completed.")

notify("Warning", "Something went wrong.", 10709799124)

notify("Info", "Stays 8 seconds.", nil, 8)

notify("Update", "New version.", nil, 5, "Top Left")

notify("Confirm", "Proceed?", nil, nil, "Bottom Right", {
    Text = "Copy Link",
    Callback = function()
        setclipboard("discord.gg/example")
    end,
})

notify("Silent", "No close button.", nil, 4, "Bottom Right", nil, false)
```

## Notes

- Shadow PNG is downloaded from GitHub and loaded via `getcustomasset` when available, falls back to `rbxassetid://3523728077`
- GUI is parented to `gethui()` or `get_hidden_gui()`, falls back to `CoreGui`
- Icons support asset IDs, `rbxassetid://` strings, or local file paths
- Each position has an independent notification stack
