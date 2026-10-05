# custom kick

A lightweight custom kick module that displays a styled error prompt with optional buttons.

## Usage

```lua
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/XVCHub/librarys/main/customkick/source.lua"))()

Module.Kick("Title", "Message")
```

## Kick

```
Module.Kick(title, message, options?)
```

Kicks the local player and replaces the error prompt with a custom title, message, and optional buttons.

### Parameters

| Parameter | Type | Description |
|---|---|---|
| `title` | `string` | Title shown at the top of the prompt |
| `message` | `string` | Message shown in the body |
| `options` | `table?` | Optional configuration (see below) |

### Options

| Key | Type | Default | Description |
|---|---|---|---|
| `type` | `number` | `1` | `1` = Leave only, `2` = Leave + Reconnect |
| `leaveText` | `string` | `"Leave"` | Label for the Leave button |
| `reconnectText` | `string` | `"Reconnect"` | Label for the Reconnect button |

### Button Behavior

| Button | Action |
|---|---|
| Leave | Calls `game:Shutdown()` — returns to platform menu |
| Reconnect | Calls `TeleportToPlaceInstance` — rejoins the same server |

## Inline Tags

Tags wrap text using `tag(content)` syntax.

| Tag | Output |
|---|---|
| `blue(text)` | Blue text |
| `green(text)` | Green text |
| `red(text)` | Red text |
| `neon(text)` | Neon yellow-green text |
| `bold(text)` | Bold text |
| `italic(text)` | Italic text |

Tags are only active when used. If no tags are present, `RichText` stays disabled.

## Examples

```lua
-- Leave only
Module.Kick("Disconnected", "You have been kicked due to unexpected client behavior.\n(Error Code: 268)")

-- Leave only with tag
Module.Kick("Disconnected", "red(Reason:) neon(bypass the key system)")

-- Leave + Reconnect
Module.Kick("Disconnected","bold(Connection lost.) Try reconnecting.",{type = 2})

-- Custom button labels
Module.Kick("Kicked", "detected an admin in the server.",{
    type = 2,
    leaveText = "Leave",
    reconnectText = "Rejoin"
})
```

## Notes

- Nested tags are not supported — `bold(red(text))` will not work as expected.
- Unrecognized tags are left unchanged in the output.
- This module is client-side only. Must be run from a executor.
