# Transparent theme for Helix
# Based on default theme with transparent backgrounds

"ui.background" = { }
"ui.statusline" = { fg = "white", bg = "black" }
"ui.statusline.inactive" = { fg = "gray", bg = "black" }
"ui.popup" = { bg = "black" }
"ui.window" = { bg = "black" }
"ui.help" = { bg = "black", fg = "white" }

"ui.text" = "white"
"ui.text.focus" = { fg = "cyan", modifiers = ["bold"] }
"ui.virtual" = "gray"
"ui.virtual.whitespace" = "gray"
"ui.virtual.ruler" = { bg = "#1c1c1c" }
"ui.virtual.inlay-hint" = { fg = "gray", modifiers = ["italic"] }

"ui.selection" = { bg = "#264f78" }
"ui.selection.primary" = { bg = "#264f78" }
"ui.cursorline.primary" = { bg = "#1c1c1c" }

"ui.linenr" = "gray"
"ui.linenr.selected" = { fg = "white", modifiers = ["bold"] }

"ui.cursor" = { fg = "black", bg = "white" }
"ui.cursor.primary" = { fg = "black", bg = "white" }
"ui.cursor.match" = { bg = "#3e3e3e", modifiers = ["underlined"] }

"ui.menu" = { fg = "white", bg = "black" }
"ui.menu.selected" = { fg = "black", bg = "cyan" }

"comment" = { fg = "green", modifiers = ["italic"] }
"string" = "yellow"
"constant" = "magenta"
"constant.numeric" = "magenta"
"constant.character.escape" = "cyan"

"type" = "cyan"
"function" = "blue"
"keyword" = "red"
"operator" = "white"
"variable" = "white"
"variable.parameter" = "white"

"markup.heading" = { fg = "blue", modifiers = ["bold"] }
"markup.list" = "cyan"
"markup.bold" = { modifiers = ["bold"] }
"markup.italic" = { modifiers = ["italic"] }
"markup.link.url" = { fg = "cyan", modifiers = ["underlined"] }
"markup.link.text" = "yellow"
"markup.quote" = "green"
"markup.raw" = "magenta"

"diff.plus" = "green"
"diff.minus" = "red"
"diff.delta" = "yellow"

"diagnostic.error" = { underline = { style = "curl", color = "red" } }
"diagnostic.warning" = { underline = { style = "curl", color = "yellow" } }
"diagnostic.info" = { underline = { style = "curl", color = "blue" } }
"diagnostic.hint" = { underline = { style = "curl", color = "gray" } }

"error" = "red"
"warning" = "yellow"
"info" = "blue"
"hint" = "gray"
