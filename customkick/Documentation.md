# custom kick

A lightweight custom kick module that displays a styled error prompt instead of the default Roblox kick screen.

## Usage

```lua
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/XVCHub/librarys/main/customkick/source.lua"))()

Module.Kick("Title", "Message with blue(colored) and bold(formatted) text.")
```

## Kick

```
Module.Kick(title: string, message: string)
```

Kicks the local player and replaces the error prompt with a custom title and message. The message supports inline tags for rich text formatting.

## Inline Tags

Tags wrap a word or phrase using the syntax `tag(content)`.

| Tag | Output |
|---|---|
| `blue(text)` | Blue text |
| `green(text)` | Green text |
| `red(text)` | Red text |
| `neon(text)` | Neon yellow-green text |
| `bold(text)` | Bold text |
| `italic(text)` | Italic text |

## Examples

```lua
Module.Kick("Disconnected", "You have been kicked by this experience or its moderators.\n(Error Code: 267)")
```

```lua
Module.Kick("Disconnected", "red(Reason:) neon(bypass)")
```

```lua
Module.Kick("Disconnected", "You have been kicked due to unexpected client behavior.\n(Error Code: 268)")
```

## Notes

- Tags that are not recognized are left unchanged in the output.
- Nested tags are not supported (e.g. `bold(red(text))` will not work as expected).
- This module is client-side only. It must be run from a executor.
