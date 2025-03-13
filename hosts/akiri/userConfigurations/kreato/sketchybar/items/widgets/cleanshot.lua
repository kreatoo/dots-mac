local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local popup_width = 250

local cleanshot = sbar.add("item", {
  position = "right",
  label = { drawing = false },
  background = { color = colors.bg1 },
  popup = { align = "center", height = 30 },
  icon = { 
	string = icons.screenshare,
	padding_right = 3,
  },
  width = 35,
  align = "center",
})


sbar.add("item", "widgets.cleanshot.padding", {
  position = "right",
  label = { drawing = false },
  width = 5,
})


local function toggle_details()
	sbar.exec("osascript -e 'tell application \"System Events\" to tell process \"CleanShot X\" to perform action \"AXPress\" of menu bar item 1 of menu bar 2'")
end

cleanshot:subscribe("mouse.clicked", toggle_details)
